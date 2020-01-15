FROM debian:buster-slim
MAINTAINER Freddie Leeman <freddie@freddieleeman.nl>

RUN buildDeps='make gcc wget libc6-dev ca-certificates cpanminus' \
    && apt update \
    && apt install -y --no-install-recommends \
       $buildDeps \
       libssl-dev \
       zlib1g-dev \
       perl \
       sqlite3 \
    && cpanm --notest Mail::Milter::Authentication Net::SMTPS \
    && apt purge -y --auto-remove $buildDeps \
    && apt clean \
    && rm -rf /var/cache/apt/archives \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cpan \
    && rm -rf /root/.cpanm

COPY start.sh /start.sh

RUN chmod +x /start.sh

CMD ["./start.sh"]

EXPOSE 12345
