# ELIXIR DEPENDENCIES
FROM hexpm/elixir:1.10.2-erlang-22.3.2-alpine-3.11.3 as dependencies-builder

RUN apk add --no-cache build-base git

ENV MIX_ENV=prod

WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force

# dependencies
COPY mix.exs mix.lock ./
COPY config ./config
COPY apps/notris/mix.exs ./apps/notris/
COPY apps/notris_web/mix.exs ./apps/notris_web/
RUN mix do deps.get --only ${MIX_ENV}, deps.compile

COPY apps apps

# ******
# ASSETS
# ******
FROM node:14.1.0 as assets-builder

WORKDIR /app
COPY --from=dependencies-builder /app/deps ./deps

WORKDIR /app/apps/notris_web
COPY apps/notris_web ./
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
RUN npm run --prefix ./assets deploy

# RELEASE
FROM dependencies-builder as release-builder

WORKDIR /app

COPY --from=assets-builder /app/apps/notris_web/priv/static ./apps/notris_web/priv/static
RUN mix cmd --app notris_web mix phx.digest
RUN mix compile
RUN mix release

# IMAGE
FROM alpine:3.11.3 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app
USER nobody:nobody

COPY --from=release-builder --chown=nobody:nobody /app/_build/prod/rel/notris ./

ENV HOME=/app
CMD ["bin/notris", "start"]
