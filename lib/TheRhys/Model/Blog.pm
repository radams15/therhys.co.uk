package TheRhys::Model::Blog;

use utf8;

use Time::Piece;
use Text::Markdown qw/ markdown /;

my $POST_DIR = '../../../posts';

sub new {
        my $class = shift;
        my ($post_dir) = @_;
        
        bless {
                post_dir => $post_dir
        }, $class;
}


sub posts {
        my $class = shift;
        my @tags = @_;
        
        my @out;
        
        my $base = $class->{post_dir};
        
        for(<$base/*.{md,html}>) {
                (my $fname = $_) =~ s:$base/::g;

                open FH, '<', $_;
                my %conf;
                until ((my $line = <FH>) =~ /^----*/) {
                    next unless $line =~ /.*:.*/g;    # Skip unless there is key: value
                    chomp $line;

                    my ($k, $v) = split /:\s*/, $line;
                    $conf{$k} = $v;
                }
                close FH;

                $conf{Published} = Time::Piece->strptime($conf{Published}, '%d/%m/%Y'); # Convert from dd/mm/YYYY to perl Time::Piece format.
                $conf{Tags} = [split ',\s*', $conf{Tags}]
                  ;    # Split the tags string by comma into a list.

                if (@tags) {
                    for my $tag (@{ $conf{Tags} }) {    # Show only relevant tags if specified.
                        chomp $tag;
                        if (grep { $_ eq $tag } @tags) {
                            push @out, {
                                name => $fname, 
                                conf => \%conf
                            };
                            last;
                        }
                    }
                } else {
                    push @out, {
                        name => $fname, 
                        conf => \%conf
                    };
                }
        }
        
        grep {not $$_{conf}{Disabled}} sort { $$b{conf}{Published}->epoch <=> $$a{conf}{Published}->epoch } # Compare the epochs of the dates.
      @out;    # Return sorted by publish date.
}

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

    $out =~ s:<pre>\s*<code>\s*([\s\S]*?)\s*</code>\s*</pre>:
        <figure>
            <code class="prettyprint">\1</code>
        </figure>
        :mg;
    $out = &linkify_imgs($out);

    "$out<script src='/run_prettify.js'></script>";
}

sub md2plain {
    my ($in) = @_;

    $in =~ s/^#+(.*)$/$1\n------------/gm;
    $in =~ s/`(.*?)`/$1/gm;
    $in =~ s/!\[(.*?)\]\((.*?)\)/[$1]/gm;
    $in =~ s/\<video.*\>[\s\S]*?\<\/video\>/[Video]/gm;

    $in;
}

sub post {
        my $class = shift;
        my ($fname, $format) = @_;
        
        $fname =~ s:/::g;    # Be safe and remove any slashes whatsoever.

        $fname = "$class->{post_dir}/$fname";

        open FH, '<:encoding(utf-8)', $fname or return;

        my %conf;
        until ((my $line = <FH>) =~ /^----*/) {    # Read until the first --- marker
                next unless $line =~ /.*:.*/g;         # Skip unless there is key: value
                chomp $line;

                my ($k, $v) = split /:\s*/, $line;
                $conf{$k} = $v;
        }
        my $data = join '', <FH>;                  # Read the rest of the data
        $conf{Published} = Time::Piece->strptime($conf{Published}, '%d/%m/%Y'); # Convert from dd/mm/YYYY to perl Time::Piece format.
        $conf{Tags} = [split ',\s*', $conf{Tags}];    # Split the tags string by comma into a list.
        
        close FH;

        my $body;
        if($fname =~ /\.md$/) {
                 $body = (uc $format eq 'PLAIN') ?
                    &md2plain($data)
                    : &md2html($data);
        } elsif($fname =~ /\.html$/) {
                 $body = $data;
        } else {
                $body = "ERROR";
        }
        
        {
                conf => \%conf,
                body => $body
        }
}

1;

