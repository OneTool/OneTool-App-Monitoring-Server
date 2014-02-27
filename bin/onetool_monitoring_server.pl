#!/usr/bin/perl

=head1 NAME

onetool_monitoring_server.pl - Monitoring Server Program from the OneTool Suite

=cut

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib/";

use OneTool::Monitoring::Server::App;

OneTool::Monitoring::Server::App->run(@ARGV);

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut