package OneTool::Monitoring::Server::API;

=head1 NAME

OneTool::Monitoring::Server::API - OneTool Monitoring Server API module

=cut

use strict;
use warnings;

use Exporter 'import';
use FindBin;
use JSON;

use lib "$FindBin::Bin/../lib/";

use OneTool::Monitoring::Server;

our @EXPORT_OK = qw(%server_api);

my $API_ROOT = '/api/monitoring_server';

our %server_api = (
    "$API_ROOT/version" => {
        method => 'GET',
        action => sub {
            my ($self) = @_;
            return (to_json($self->Version())); 
            } 
        },
    "$API_ROOT/get_config" => {
        method => 'GET',
        action => sub {
            my ($self) = @_;           
            return (to_json([$self->Devices_List()])); 
            } 
        },
#    "$API_ROOT/get_data" => { 
#        method => 'GET', 
#        action => sub {
#            my ($self, $check) = @_;
#            return (to_json($self->Check($check)));         
#            } 
#        },
#    "$API_ROOT/set_config" =>
#        { method => 'POST', action => \&Set_Config },
#    "$API_ROOT/upload_app_module" =>
#        { method => 'POST', action => \&Upload_App_Module },
    );


1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut