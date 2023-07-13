#!/usr/bin/perl

use CGI ':standard';

use Text::Markdown qw/ markdown /;

use lib '.';
use shared ();

print &http_header;

my $POST_DIR = "posts";

sub linkify_imgs {
    my ($data) = @_;

    $data =~ s:<img .*?src="(.*?)".*?alt="(.*?)".*?>:
        <figure>
            <a href="$1">
                <img src="$1" alt="$2">
            </a>
            <figcaption>$2</figcaption>
        </figure>
        :mg;

    $data;
}

sub md2html {
    my $out = markdown(
        $_[0],
        {
            empty_element_suffix => '>',
            tab_width            => 2
        }
    );

    $out =~ s/<code>/<code class="prettyprint">/g;
    $out = &linkify_imgs($out);

    $out,
      script({
            src => '/static/run_prettify.js'
        }, ''
      );
}

sub load_post {
    my ($fname) = @_;

    $fname =~ s:/::g;    # Be safe and remove any slashes whatsoever.

    $fname = "$POST_DIR/$fname";

    open FH, '<', $fname or return h1("Unknown post!");

    my %conf;
    until ((my $line = <FH>) =~ /^----*/) {    # Read until the first --- marker
        next unless $line =~ /.*:.*/g;         # Skip unless there is key: value

        my ($k, $v) = split /:\s*/, $line;
        $conf{$k} = $v;
    }
    $conf{Tags} = [split ',\s*', $conf{Tags}];
    my $data = join '', <FH>;                  # Read the rest of the data
    close FH;

    my $infobar = div({    # Make info bar with publish date, topics
            class => 'post_infobar'
        },
        p("Published: $conf{Published}"),
        "Tags: ",
        (
            map { a({ class => 'topic_round', href => "/blog?tags=$_", }, $_) }
              @{ $conf{Tags} } # Add a topic filter link for every listed topic.
        ),
    );

    if ($fname =~ /\.md$/) {
        return div({    # Convert markdown to html before displaying.
                class => 'post_body centre_page',
            },
            $infobar,
            &md2html($data),
        );
    } elsif ($fname =~ /\.html/) {
        return $infobar, div({    # Display html directly if is an html file.
                class => 'post_body centre_page',
            },
            $data,
        );
    }

    return h1("Unknown post type!");    # Not html or markdown, show an error.
}

sub post_body {
    my ($post_name) = @_;

    &page(content => div(&load_post($post_name)));
}

my $post_name = param('post');

print html (
    CGI::head(&page_head('Rhys Adams - ' . param('post'))),
    CGI::body(&post_body($post_name))
);
