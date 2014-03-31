#!/usr/bin/env perl

use 5.010;
use strict;

use Cwd qw(abs_path);
use File::Basename qw(dirname);

use lib dirname(abs_path($0)) . '/lib/common';
use lib dirname(abs_path($0)) . '/lib/frontent';

use Constants;
use MessagesTextConstants;
use BKFileHandler;
use CommonMessages;
use DatabaseAccess;
use ActionHandler;

use Mojolicious::Lite;
use FileHandle;
use DBI;
use JSON;

our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');

websocket '/echo' => sub {
    my $self = shift;

    $self->on(message => sub {
        my ($self, $msg_data) = @_;
        my $recv_action = ActionHandler->new(undef, $msg_data);
        $recv_action->FromJSON();
        $recv_action->PrepareWebScoketData();
        $recv_action->ProcessAction();
##          my $data_to_send = $recv_action->PrepareDataToSend();
##          $topic->publish($data_to_send);
        $self->send($recv_action->PrepareWebScoketData());
        $recv_action->DESTROY();
    });
};

app->start;
