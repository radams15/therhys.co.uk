package TheRhys::Controller::Blog;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub posts {
        my ($c) = @_;

        my @posts = $c->{app}->{blog}->posts(split /,\s*/, $c->param('tags') // '');
        
        $c->stash(posts => \@posts);
        
        return $c->render;
}

sub post {
        my ($c) = @_;
        
        my $post = $c->{app}->{blog}->post($c->param('name'));
        
        $c->stash(post => $post);
        
        return $c->render();
}

sub mkrss {
    my %args = @_;
    
    my $out = '<?xml version="1.0" encoding="utf-8"?>
               <rss version="2.0"  xmlns:atom="http://www.w3.org/2005/Atom">
               <channel>';
    $out .=    "<title>$args{title}</title>
                <link>$args{url}</link>
                <description>$args{description}</description>
                <atom:link href=\"http://therhys.co.uk/blog.rss\" rel=\"self\" type=\"application/rss+xml\" />
    ";
    
    for my $item (@{$args{items}}) {
        $out .= '<item>';
        
        $out .= sprintf("
                <title>%s</title>
                <link>http://therhys.co.uk%s</link>
                <pubDate>%s</pubDate>\n",
            $item->{title},
            $item->{url},
            $item->{published}
        );
        
        $out .= "</item>\n";
    }
    
    $out .=   '</channel>';
    
    $out;
}

sub rss {
        my ($c) = @_;

        my $tags = $c->param('tags') // '';
        
        my @posts = $c->{app}->{blog}->posts(
                split /,\s*/, $tags
        );
        
        my $out = &mkrss(
            title => "Rhys' Blog",
            url => 'http://therhys.co.uk/blog',
            description => 'Vintage computing, cyber security and other interesting stuff.',
            items => [map {
                {
                    title => $$_{conf}{Title},
                    url => $c->url_for("/post")->query(name=>$$_{name}),
                    published => $$_{conf}{Published}->strftime('%a, %d %b %Y %H:%M:%S %z')
                }
            } @posts]
        );

        
        $c->res->headers->content_type('application/rss+xml');
        $c->render(text => $out);
}

1;

