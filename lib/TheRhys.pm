package TheRhys;

use Mojo::Base 'Mojolicious', -signatures;
use TheRhys::Model::Blog;

sub startup {
	my ($self) = @_;

	my $config = $self->plugin ('NotYAMLConfig');
	
	$self->{blog} = TheRhys::Model::Blog->new($self->home.'/posts');

	my $r = $self->routes;

	$r->get('/')->to ('Index#index');
	
	$r->get('/about')->to ('About#about');
	
        $r->get('/projects')->to ('Projects#projects');
        
        $r->get('/contact')->to ('Contact#contact');
        
        $r->get('/blog')->to ('Blog#posts');
        $r->get('/blog.rss')->to ('Blog#rss');
        $r->get('/post')->to ('Blog#post');
}

1;
