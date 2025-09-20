#!/usr/bin/env perl

my $SASS = '/opt/dart-sass/sass';

for(<*.scss>) {
	next if /_.*\.scss/;

	print "Compile: $_\n";
	(my $new = $_) =~ s/\.scss$/.css/g;

	system("$SASS $_  $new");
}
