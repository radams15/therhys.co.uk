FROM docker.io/tekki/mojolicious

RUN cpan -T Text::Markdown Mojolicious::Plugin::AssetPack Mojolicious::Plugin::AssetPack::Pipe::Sass

# RUN apt-get update && apt-get install -y ruby-sass 
RUN curl -L --output dartsass.tar.gz https://github.com/sass/dart-sass/releases/download/1.69.5/dart-sass-1.69.5-linux-x64.tar.gz \
    && tar -C /opt -xzf dartsass.tar.gz

ENV PATH="${PATH}:/opt/dart-sass"

ENTRYPOINT ["script/site", "prefork", "-m", "production"]
