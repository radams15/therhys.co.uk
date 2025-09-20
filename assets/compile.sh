#!/bin/sh

podman run -v .:/sass:z -it --rm -w /sass --entrypoint './compile.pl' docker.io/michalklempa/dart-sass:latest
