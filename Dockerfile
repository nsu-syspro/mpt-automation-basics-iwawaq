FROM alpine:latest AS builder
RUN apk add --no-cache build-base jq make
WORKDIR /app
COPY . .
RUN make check
FROM alpine:latest
RUN apk add --no-cache jq
COPY --from=builder /app /app
WORKDIR /app
CMD ["./build/wordcount"]
