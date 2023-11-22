package TheRhys;

use File::Basename;
use Data::Dumper;

use Mojo::Base 'Mojolicious', -signatures;

use TheRhys::Model::Blog;

use TheRhys::Controller::Blog;
use TheRhys::Controller::Info;

sub startup {
    my ($self) = @_;

    my $config = $self->plugin('NotYAMLConfig');
    my $assets = $self->plugin('AssetPack', {pipes => [qw(Sass Css Combine)]});

    for(glob("@{[$self->home]}/assets/*")) {
        my $src = basename($_);
        $self->asset->store->extra($src => "assets/$src");
    }

    for(glob("@{[$self->home]}/assets/*.scss")) {
        next if (/_.*$/);
        my $src = basename($_);
        (my $product = $src) =~ s/\.scss$/.css/;
        # say "$src => $product"; 
        # $assets{$src} = $_; 
        say "Register $product";
        $self->asset->process($product => $src);
    }

    $self->log->level('error');

    $self->{blog} = TheRhys::Model::Blog->new($self->home . '/posts');

    my $r = $self->routes;

    TheRhys::Controller::Blog->init($r->any('/')->to(controller => 'blog'));
    TheRhys::Controller::Info->init($r->any('/')->to(controller => 'info'));

}

1;
