package TheRhys::Controller::Info;

use Mojo::Base 'Mojolicious::Controller', -signatures;

my %linked_pages = (
    'Cloud'               => '/cloud/',
    'Jellyfin'            => '/jellyfin/',
    'Transmission'        => '/transmission',
    'Sonarr'              => '/sonarr/',
    'Radarr'              => '/radarr/',
    'Jackett'             => '/jackett/',
    'Jenkins'             => '/jenkins/',
    'Github'              => 'https://github.com/radams15',
    'Github (University)' => 'https://github.com/rhys-cyber',
);

sub index {
    my ($c) = @_;

    $c->render;
}

sub about {
    my ($c) = @_;

    $c->render;
}

sub contact {
    my ($c) = @_;

    $c->render;
}

sub links {
    my ($c) = @_;

    $c->stash(links => \%linked_pages); 

    $c->render;
}

sub projects {
    my ($c) = @_;
    
    $c->render;
}


1;

