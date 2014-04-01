#!/usr/bin/env perl

use 5.010;
use strict;

use lib '/opt/BK/lib/common';
use lib '/opt/BK/lib/frontend';

use Constants;
use MessagesTextConstants;
use BKFileHandler;
use CommonMessages;
use DatabaseAccess;
use ActionHandler;

use Mojolicious::Lite;
use Mojo::IOLoop;
use FileHandle;
use DBI;
use JSON;

our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');

websocket '/ws' => sub {
    my $self = shift;

    Mojo::IOLoop->stream($self->tx->connection)->timeout(800);

    $self->on(message => sub {
        my ($self, $msg_data) = @_;
        my $recv_action = ActionHandler->new(undef, $msg_data);
        $recv_action->FromJSON();
        $recv_action->PrepareWebScoketData();
        $recv_action->ProcessAction();
        $self->send($recv_action->PrepareWebScoketData());
        $recv_action->DESTROY();
    });
};

app->start;
