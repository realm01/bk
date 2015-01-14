#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package Doors;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;
use BK::Common::DatabaseAccess;

sub new {
    $class = shift;
    $self = {
        _owner_desc => Constants::DOORS,
        _doors      => shift
    };
    bless $self, $class;
    return $self;
}

sub SetDoors {
    my ($self, $doors) = @_;
    $self->{_doors} = $doors if defined($doors);
    return $self->{_doors};
}

sub GetDoors {
    my $self = shift;
    return $self->{_doors};
}

sub OpenDoor {
    my ($self, $door, $username) = @_;

    print "Sending Signal to Door:\n\n";
    print "Number $door\n\n";


    my $doors_opened_err = &main::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::DOORSOUTPUT->[$door], Constants::HEXNULL);

    if($doors_opened_err > 0) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONOPENEND, MessagesTextConstants::DOORSERRORCODE . $doors_opened_err);
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOOROPENED, MessagesTextConstants::DOORSNUMBER . $door . MessagesTextConstants::DOORSUSERNAME . $username);
        sleep(Constants::DOORSSENDSIGNALTIME);
    }

    my $doors_closed_err = &main::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::HEXNULL, Constants::HEXNULL);

    if($doors_closed_err > 0) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONCLOSED, MessagesTextConstants::DOORSERRORCODE . $doors_closed_err);
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOORCLOSED, MessagesTextConstants::DOORSNUMBER . $door . MessagesTextConstants::DOORSUSERNAME . $username);
    }

    print "Stop Sending Signal to Door:\n\n";
    print "Number $door\n\n";


    return $doors_opened_err > 0 || $doors_closed_err > 0 ? undef : 2;
}

sub CheckDoors {
    my $self = shift;

    my $db_entries = $CommonVariables::database_connection->ReadEntryDatabase('Users', {});
    if($db_entries eq Constants::INTERNALERROR) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONCHECKDOORS, MessagesTextConstants::DOORSERRCHECKDOORS);
    }
    while (my $db_entries_row = $db_entries->fetchrow_hashref) {
        if($db_entries_row->{opendoor} == 1) {
            $self->OpenDoor($db_entries_row->{doornumber}, Constants::DOOROPENBYFRONTEND);
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::OPENDOOR, MessagesTextConstants::NOTOPENDOOR);
            if($CommonVariables::database_connection->UpdateEntryDatabase('Users', {'opendoor' => Constants::NOTOPENDOORNUM}, {'doornumber' => $db_entries_row->{doornumber}}) eq Constants::INTERNALERROR) {
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONCHECKDOORS, MessagesTextConstants::DOORSERRCHECKDOORS);
            }
        }
    }
}

1;

__END__

=head1 BK::Backend::Doors

Doors.pm

=head2 Description

Modul for controling the Pins on the LabJack basically open the Doors on the BuecherkastenBibliothek

=head2 Constuctor

_owner_desc - STRING owner for logging
_doors - ARRAY with all doors

=head2 Setter

SetDoors( [doors - ARRAY] ) - Set Doors

=head2 Getter

GetDoors() - Get Doors return Doors ARRAY

=head2 Methods

OpenDoor( [door - INT], [username - STRING] ) - Sends signal to a specific pin on the LabJack defined as [door - INT], [username - STRING] is required only for logging purposes
CheckDoors() - Checks if a or some Doors are marked to be openend in the Database, opens those Doors and mark Doors as closed in the Database

=head2 Synopsis

my $doors = Doors->new( [doors - ARRAY] );
$doors->SetDoors( [doors - ARRAY] );
my $doors_array = $doors->GetDoors();
$doors->OpenDoors( [door - INT], [username - STRING] );
