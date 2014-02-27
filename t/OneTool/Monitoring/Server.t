#!/usr/bin/perl

=head1 NAME

t/OneTool/Monitoring/Server.t

=head1 DESCRIPTION

Tests for OneTool::Monitoring::Server module

=cut

use strict;
use warnings;

use FindBin;
use Test::More;

use lib "$FindBin::Bin/../../../lib/";

my $FILE_CONF = "$FindBin::Bin/../../conf/test_onetool_monitoring_server.conf";

require_ok('OneTool::Monitoring::Server');

my $response = OneTool::Monitoring::Server::Version();
my $version = $response->{data}->{Version};
like($version, qr/\d+\.\d+/, 'OneTool::Monitoring::Server::Version()');

my $os = OneTool::Monitoring::Server::Operating_System();
like($os, qr/^(Linux|Mac OS X|Windows)$/, 'OneTool::Monitoring::Server::Operating_System()');
    
#my $server = OneTool::Monitoring::Server->new({ file => $FILE_CONF });
#my @devices = $server->Devices_List();
#printf "%s\n", join(',', @devices);
#cmp_ok($value, 'eq', $version, "\$agent->Check('$CHECK') => $version");

done_testing(4);

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut