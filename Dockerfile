FROM alpine:latest

WORKDIR /app

COPY server /app

CMD [ "/app/server" ]