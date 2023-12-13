FROM debian:stable

RUN apt-get update && apt-get install -y libmojolicious-perl libtext-markdown-perl

WORKDIR /usr/src/app

ENTRYPOINT ["script/site", "prefork", "-m", "production"]
