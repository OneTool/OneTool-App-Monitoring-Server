package OneTool::Monitoring::Server::App;

=head1 NAME

OneTool::Monitoring::Server::App - Module handling everything for onetool_monitoring_server.pl

=head1 DESCRIPTION

Module handling everything for onetool_monitoring_server.pl

=head1 SYNOPSIS

onetool_monitoring_server.pl [options]

=head1 OPTIONS

=over 8

=item B<-c,--config>     

Prints Monitoring Server configuration

=item B<-D,--debug>

Sets Debug mode

=item B<-h,--help>

Prints this Help

=item B<--start>  

Starts Monitoring Server daemon

=item B<--stop>  

Stops Monitoring Server daemon

=item B<-v,--version>

Prints version

=back

=cut

use strict;
use warnings;

use FindBin;
use Getopt::Long qw(:config no_ignore_case);
use Pod::Find qw(pod_where);
use Pod::Usage;

use lib "$FindBin::Bin/../lib/";

use OneTool::App;
use OneTool::Monitoring::Server;

__PACKAGE__->run(@ARGV) unless caller;

my $PROGRAM = 'onetool_monitoring_server.pl';
my $OS      = OneTool::Monitoring::Server::Operating_System();
my $TITLE   = "OneTool Monitoring Server (for $OS)";

my $server = undef;

=head1 SUBROUTINES/METHODS

=head2 Daemon()

Launches OneTool Monitoring Server as Daemon

=cut

sub Daemon_Start
{
    my $server = OneTool::Monitoring::Server->new();

    if (fork())
    { #father -> API Listener
        $server->Listener();
    }
    else
    { #child -> monitoring loop
        $server->Log('info', 'Monitoring Server Loop Started !');
        while (1)
        {
            foreach my $device (@{$server->{devices}})
            {
                my $time = time();
                $device->{last_check} = 0    if (!defined $device->{last_check});
                if (($time - $device->{last_check}) >= $device->{interval})
                {
                    $server->Log('debug', "Device '$device->{name}'");
                    #my $result = $agent->Check($check->{name});
                    #$check->Data_Write($result) if (defined $result);
                    $device->{last_check} = $time;
                }
            }
            sleep(1);
        }
    }

    return (undef);
}

=head2 Print_Config()

Prints Server Configuration

=cut

sub Print_Config
{
    printf "OneTool Monitoring Server Configuration:\n";
    printf "Devices:\n";
    my @devices = $server->Devices_List();
    foreach my $c (@devices)
    {
        printf "\t%s (%s:%s) ==> %s seconds\n", 
            $c->{name}, $c->{ip}, $c->{port}, $c->{interval};
    }

    return (scalar(@devices));
}



=head2 run(@ARGV)

=cut

sub run
{
    my $self = shift;
    my %opt  = ();

    local @ARGV = @_;
    my @options = @OneTool::App::DEFAULT_OPTIONS;
    push @options, 
        'config|c', 
        'start', 
        'stop';
    my $status = GetOptions(\%opt, @options);

    pod2usage(
        -exitval => 'NOEXIT', 
        -input => pod_where({-inc => 1}, __PACKAGE__)) 
        if ((!$status) || ($opt{help}));
        
    if ($opt{version})
    {
        printf "%s v%s\n", $PROGRAM, $OneTool::Monitoring::Agent::VERSION;
    }

    $server = OneTool::Monitoring::Server->new();
    Print_Config()          if ($opt{config});
    
    Daemon_Start() if ($opt{start});

    return ($status);
}

1;

=head1 AUTHOR

Sebastien Thebert <contact@onetool.pm>

=cut