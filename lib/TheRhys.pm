package TheRhys;

use Mojo::Base 'Mojolicious', -signatures;
use TheRhys::Model::Blog;

sub startup {
	my ($self) = @_;

	my $config = $self->plugin ('NotYAMLConfig');

    $self->log->level('error');
	
	$self->{blog} = TheRhys::Model::Blog->new($self->home.'/posts');

	my $r = $self->routes;

	$r->get('/')->to ('Info#index');
	$r->get('/about')->to ('Info#about');
    $r->get('/projects')->to ('Info#projects');
    $r->get('/contact')->to ('Info#contact');
    $r->get('/links')->to ('Info#links');
    
    $r->get('/blog')->to ('Blog#posts');
    $r->get('/blog.rss')->to ('Blog#rss');
    $r->get('/post')->to ('Blog#post');
}

1;
