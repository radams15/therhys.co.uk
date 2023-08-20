package TheRhys::Controller::Blog;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub posts {
        my ($c) = @_;
        
        my @posts = $c->{app}->{blog}->posts(
            split /,\s*/, ($c->param('tags') // '')
        );
        
        $c->stash(
            posts => \@posts
        );
        
        return $c->render;
}

sub post {
        my ($c) = @_;
        
        my $post = $c->{app}->{blog}->post($c->param('name'));
        
        $c->stash(post => $post);
        
        return $c->render();
}

sub rss {
        my ($c) = @_;
        
        my @posts = $c->{app}->{blog}->posts(
                split /,\s*/, $c->param('tags')
        );
        
        my $out = sprintf(
                '<?xml version="1.0" encoding="utf-8"?>
                        <rss version="2.0"  xmlns:atom="http://www.w3.org/2005/Atom">
                        <channel>
                                <title>Rhys\' Blog</title>
                                <link>http://therhys.co.uk/blog</link>
                                <description>Vintage computing, cyber security and other interesting stuff.</description>
                                <atom:link href="http://therhys.co.uk/blog.rss" rel="self" type="application/rss+xml" />
                                %s
                        </channel>
                </rss>',
                join("\n", map {
                        sprintf("<item>
                                        <title>%s</title>
                                        <link>http://therhys.co.uk%s</link>
                                        <pubDate>%s</pubDate>
                                </item>",
                                $$_{conf}{Title},
                                $c->url_for("/post")->query(name=>$$_{name}),
                                $$_{conf}{Published}->strftime('%a, %d %b %Y %H:%M:%S %z')
                        );
                } @posts)
        );
        
        $c->res->headers->content_type('application/rss+xml');
        $c->render(text => $out);
}

1;

