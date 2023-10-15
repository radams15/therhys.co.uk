package TheRhys;

use Mojo::Base 'Mojolicious', -signatures;

use TheRhys::Model::Blog;

use TheRhys::Controller::Blog;
use TheRhys::Controller::Info;

sub startup {
    my ($self) = @_;

    my $config = $self->plugin('NotYAMLConfig');

    $self->log->level('error');

    $self->{blog} = TheRhys::Model::Blog->new($self->home . '/posts');

    my $r = $self->routes;

    TheRhys::Controller::Blog->init($r->any('/')->to(controller => 'blog'));
    TheRhys::Controller::Info->init($r->any('/')->to(controller => 'info'));

}

1;
