#!/usr/bin/env perl
use IO::Socket;
my $name = "PerlGopher v0.1"; #servername
my $port = 7070;               #Gopher default port 70
my $dir = "./*";               #default Gopher directory
my $lineend = "\r\n";

use lib './lib';

use TheRhys::Model::Blog;

my $blog = TheRhys::Model::Blog->new('./posts');

my $server = IO::Socket::INET->new(LocalPort => $port,
				   Type => SOCK_STREAM,
				   Reuse => 1,
				   Listen => 10 )
   or die "Can't open server on port $port : $1 \n";

while ($client = $server->accept()) {
  $remote_addr = $client->peerhost();
  print "New Connction from: $remote_addr\n";
  $request = <$client>;  
  &handle_request($client, $request, $dir);
}

sub dir_list {
    my ($client) = @_;

    my $host = $client->sockhost;

    for($blog->posts) {
        my $fname = $$_{name};
        my %conf = %{$$_{conf}};
        print $client "0$conf{Title}\t$fname\t$host\t$port$lineend";
    }
}

sub read_file {
    my ($client, $file) = @_;

    my $post = $blog->post($file, 'PLAIN');

    print $client $post->{body};
}

sub handle_request { 
    my ($client, $request, $dir) = @_;

    chomp $request;
    $request =~ s/\s//g;

    if($request eq '') {
        &dir_list($client);
    } else {
        &read_file($client, $request);
    }

    $client->close();
}
