#!/bin/sh

podman run -e MOJO_LOG_LEVEL=trace -p 3000:3000 -v .:/usr/src/app:z -it --rm mojo morbo script/site debug
