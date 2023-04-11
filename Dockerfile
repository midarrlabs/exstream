FROM elixir:1.14.3-otp-24-alpine

ARG MIX_ENV="dev"
ARG SECRET_KEY_BASE=""

ENV MIX_ENV="${MIX_ENV}"
ENV SECRET_KEY_BASE="${SECRET_KEY_BASE}"

RUN MIX_ENV=$MIX_ENV
RUN SECRET_KEY_BASE=$SECRET_KEY_BASE

WORKDIR /app

COPY . ./

RUN \
    apk add --no-cache --virtual=.build-deps \
        build-base \
    && \
    apk add --no-cache \
        inotify-tools \
        curl \
        make \
        g++ \
        ca-certificates \
        ffmpeg \
    && \
    mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && mix assets.deploy \
    && mix compile \
    && apk del --purge .build-deps \
    && rm -rf /tmp/*

EXPOSE 4000

CMD [ "mix", "phx.server" ]