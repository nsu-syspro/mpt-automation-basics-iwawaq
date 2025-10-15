FROM alpine:latest
RUN apk add --no-cache build-base jq make
WORKDIR /app
COPY . .
RUN make all check
CMD ["./build/wordcount"]
