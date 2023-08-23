package TheRhys::Controller::About;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub about {
    my ($c) = @_;

    $c->render;
}

1;

