{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    perl
    perlPackages.Mojolicious
    perlPackages.TextMarkdown
  ];
}

