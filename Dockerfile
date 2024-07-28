# Build Stage
FROM golang:1.21.4-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN apk add --no-cache curl netcat-openbsd \
    && go build -o main main.go \
    && curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

RUN chmod +x start.sh 
RUN chmod +x wait-for.sh 


# Run Stage
FROM alpine:3.18
WORKDIR /app
RUN apk add --no-cache libbsd
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY --from=builder /usr/bin/nc /usr/bin/nc

COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration


EXPOSE 8080 
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
