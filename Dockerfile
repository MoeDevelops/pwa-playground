FROM node:22-alpine AS builder

WORKDIR /build

COPY ./package*.json .
RUN npm i

COPY . .
RUN npm run build && cp -r drizzle/ build/drizzle/

FROM node:22-alpine

WORKDIR /app

COPY --from=builder /build/build .

RUN npm i && mkdir data/
VOLUME [ "/app/data" ]

ENTRYPOINT [ "node", "index.js" ]
