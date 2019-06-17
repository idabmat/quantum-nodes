FROM bitwalker/alpine-elixir as builder

RUN apk --no-cache --update upgrade

WORKDIR /app

ENV MIX_ENV prod

ADD mix.exs mix.lock ./

RUN mix do hex.info, deps.get, deps.compile

ADD lib ./lib
ADD config ./config
ADD rel ./rel
RUN mix release --env prod \
 && mkdir /app/dist \
 && cp _build/prod/rel/sample_app/releases/$(ls -t _build/prod/rel/sample_app/releases/ | head -1)/sample_app.tar.gz /app/dist

FROM bitwalker/alpine-elixir

WORKDIR /app

RUN apk --no-cache --update upgrade \
 && apk --no-cache add bash

COPY --from=builder /app/dist/sample_app.tar.gz .
ADD rel/bin /app/bin

RUN cd /app \
 && tar zxf sample_app.tar.gz \
 && rm sample_app.tar.gz

ENV REPLACE_OS_VARS true
EXPOSE 45892
ENTRYPOINT ["/app/bin/entrypoint.sh"]
CMD ["/app/bin/sample_app", "foreground", "&", "wait"]
