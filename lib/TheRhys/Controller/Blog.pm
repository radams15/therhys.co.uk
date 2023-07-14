package TheRhys::Controller::Blog;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub posts {
        my ($c) = @_;
        
        $c->stash(posts => [$c->{app}->{blog}->posts(split /,\s*/, $c->param('tags'))]);
        
        return $c->render;
}

sub post {
        my ($c) = @_;
        
        my $post = $c->{app}->{blog}->post($c->param('name'));
        
        $c->stash(post => $post);
        
        return $c->render();
}

1;

