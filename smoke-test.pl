#!/usr/bin/perl
use strict;
use warnings;

use Socket;
use threads;

use Config;
$Config{useithreads} or
    die('Recompile Perl with threads to run this program.');
    
my $port = 5000;
my $proto = getprotobyname('tcp');
my $server = 'localhost';

# Create a socket, make it reusable.
socket(my $socket, PF_INET, SOCK_STREAM, $proto)
    or die "Can't open socket: $!\n";
setsockopt($socket, SOL_SOCKET, SO_REUSEADDR, 1)
    or die "Can't set socket option SO_REUSEADDR: $!\n";

# Bind to port.
bind($socket, pack_sockaddr_in($port, inet_aton($server)))
    or die "Can't bind to port $port: $!\n";;

# Start listening.
listen($socket, 5)
    or die "Failed to start listening: $!\n";

my $client_addr;
while ($client_addr = accept(my $client_socket, $socket)) {
    print "Accepted client: ", (unpack "H*", $client_addr), "\n";
    close $client_socket;
}

# my $socket = new IO::Socket::INET (
#     LocalHost => "localhost",
#     LocalPort => "5000",
#     Proto => "tcp",
#     Listen => 1,
#     Reuse => 1
# );

# die "Could not create socket: $!n" unless $socket;

# print "Waiting for data from the client\n";
# my $new_socket = $socket->accept();
# while (<$new_socket>) {
#     print $new_socket $_;
# }

# close($socket);
