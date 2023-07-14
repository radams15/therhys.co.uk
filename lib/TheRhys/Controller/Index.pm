package TheRhys::Controller::Index;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub index {
    my ($c) = @_;

    $c->render;
}

1;

