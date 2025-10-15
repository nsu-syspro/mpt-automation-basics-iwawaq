FROM alpine/git AS builder
RUN apk add --no-cache build-base jq
WORKDIR /app
COPY . .
RUN make all check || exit 1
FROM alpine
RUN apk add --no-cache jq
WORKDIR /app
COPY --from=builder /app/build /app/build
CMD ["/app/build/$(shell jq -r .name config.json)"]
