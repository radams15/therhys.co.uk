FROM docker.io/tekki/mojolicious

RUN cpan -T Text::Markdown

ENTRYPOINT ["script/site", "prefork", "-m", "production"]
