FROM node:22-alpine AS builder

WORKDIR /build

COPY ./package*.json .
RUN npm i

COPY . .
RUN npm run build

FROM nginx:1-alpine-slim

COPY --from=builder /build/build /usr/share/nginx/html
