#!/usr/bin/env perl

use 5.010;
use strict;

use lib 'lib/';

use Constants;
use DatabaseAccess;
use Doors;

use DBI;

my $database_connection = DatabaseAccess->new('SQLite', '../Database/BKDatabase.db');
my $doors = Doors->new(Constants::DOORS);

while(2) {
    my $input_barc = chomp(<STDIN>);

    my $database_entries = $database_connection->ReadEntryDatabase('users', {'username' => $input_barc});

    while(my $database_entries_row = $database_entries->fetchrow_hashref) {
        $doors->OpenDoor($database_entries_row->{doornumber});
        $database_connection->DeleteEntryDatabase('users', {'username' => $input_barc});

        ##  Send E-Mail
        ##  To Correspondant Person
    }
}
