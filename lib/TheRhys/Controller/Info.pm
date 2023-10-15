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

sub init {
    my $class = shift;
    my ($base) = @_;

    $base->get('/')->to(action => 'index');
    $base->get('/about')->to(action => 'about');
    $base->get('/projects')->to(action => 'projects');
    $base->get('/contact')->to(action => 'contact');
    $base->get('/links')->to(action => 'links');

    my $project = $base->any('/project');
    $project->get('/rhysos')->to(action => 'rhysos');
    $project->get('/rhyslang')->to(action => 'rhyslang');
}

sub rhyslang { $_[0]->render; }
sub rhysos   { $_[0]->render; }

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

