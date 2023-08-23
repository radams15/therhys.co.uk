package TheRhys::Controller::Projects;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub projects {
    my ($c) = @_;

    $c->render;
}

1;

