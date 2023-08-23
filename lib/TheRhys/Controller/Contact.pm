package TheRhys::Controller::Contact;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub contact {
    my ($c) = @_;

    $c->render;
}

1;

