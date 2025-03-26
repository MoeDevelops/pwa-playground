FROM node:22-alpine AS builder

WORKDIR /build

COPY ./package*.json .
RUN npm i

COPY . .
RUN npm run build

FROM node:22-alpine

WORKDIR /app

COPY --from=builder /build/build .

ENTRYPOINT [ "node", "index.js" ]
