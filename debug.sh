#!/bin/sh

podman run -p 3000:3000 -v .:/usr/src/app:z -it --rm mojo script/site prefork
