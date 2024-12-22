# Build Stage
FROM golang:1.23.4-alpine3.20 AS builder
WORKDIR /app
COPY . .

RUN go build -o main main.go

RUN chmod +x start.sh 
RUN chmod +x wait-for.sh 


# Run Stage
FROM alpine:3.20
WORKDIR /app
COPY --from=builder /app/main .

COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./db/migration


EXPOSE 8080 
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]

