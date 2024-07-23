#Build Satge
FROM golang:1.21 AS buildstage
WORKDIR /app
COPY . .
RUN go build -o main main.go


# Run Stage
FROM alpine
WORKDIR /app
COPY --from=buildstage /app/main .
EXPOSE 8080 
CMD [ "/app/main" ]