package OneTool::Monitoring::Server;

=head1 NAME

OneTool::Monitoring::Server - OneTool Monitoring Server module

=cut

use strict;
use warnings;

use FindBin;
use Log::Log4perl;
use Moose;

use lib "$FindBin::Bin/../lib/";

use OneTool::Configuration;
use OneTool::Monitoring::Server::API qw( %server_api );

my $DIR_DATA = "$FindBin::Bin/../data/monitoring_server/";
my $FILE_CONF = "$FindBin::Bin/../conf/itt_monitoring_server.conf";

our $VERSION = 0.1;

my %check = (
    'OneTool.Monitoring.Server.Version' => {
        fct  => \&Version,
        args => [],
        type => 'version'
    },
);

=head1 MOOSE OBJECT

=cut

extends 'OneTool::Daemon';

has 'devices' => (
    is => 'rw',
    isa => 'ArrayRef[HashRef]',
    );
    
around BUILDARGS => sub 
{
    my $orig  = shift;
    my $class = shift;

    Log::Log4perl::init_and_watch("$FindBin::Bin/../conf/onetool_monitoring_server.log.conf", 10);
    my $logger = Log::Log4perl->get_logger('OneTool_monitoring_server');
    
    if (@_ == 0)
    {
        # OneTool::Monitoring::Server->new();
        my $conf = OneTool::Configuration::Get({ module => 'onetool_monitoring_server' });
        my @devices = @{$conf->{devices}};

        $conf->{devices} = \@devices;
        $conf->{api} = \%server_api;
        $conf->{logger} = $logger;
        
        return $class->$orig($conf);
    }
    elsif ( @_ == 1 && defined $_[0]->{file} )
    {
        # OneTool::Monitoring::Server->new($fileconf);
        my $conf = OneTool::Configuration::Get({ file => $_[0]->{file} });
        my @devices = @{$conf->{devices}};

        $conf->{devices} = \@devices;
        
        return $class->$orig($conf);
    }
    else 
    {
        return $class->$orig(@_);
    }
};

=head1 SUBROUTINES/METHODS

=head2 Devices_List()

Returns list of Devices

=cut

sub Devices_List
{
    my $self = shift;

    return (@{$self->{devices}});
}

=head2 Operating_System()

Returns Agent Operating System

=cut

sub Operating_System
{
    if    ($^O eq 'linux')   { return ('Linux'); }
    elsif ($^O eq 'darwin')  { return ('Mac OS X'); }
    elsif ($^O eq 'MSWin32') { return ('Windows'); }

    return (undef);
}

=head2 Version()

Returns Server version

=cut

sub Version
{
    return ({ status => 'ok', data => { Version => $VERSION } });
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut