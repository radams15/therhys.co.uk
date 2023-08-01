package TheRhys::Controller::Info;

use Mojo::Base 'Mojolicious::Controller', -signatures;

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

sub projects {
    my ($c) = @_;

    $c->render;
}

1;

