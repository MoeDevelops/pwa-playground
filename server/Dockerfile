FROM ghcr.io/gleam-lang/gleam:v1.10.0-erlang-alpine AS builder

RUN apk add make gcc musl-dev

WORKDIR /build

COPY *.toml .
RUN gleam deps download

COPY . .
RUN gleam export erlang-shipment

RUN cp -r db build/erlang-shipment

FROM erlang:alpine

WORKDIR /app
COPY --from=amacneil/dbmate:latest /usr/local/bin/dbmate /usr/bin/dbmate
COPY --from=builder /build/build/erlang-shipment .

ENV DATABASE_URL=postgres://postgres:postgres@postgres:5432/pwaplayground?sslmode=disable

ENTRYPOINT [ "./entrypoint.sh", "run" ]
