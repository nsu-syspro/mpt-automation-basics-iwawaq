FROM ubuntu:latest
RUN apt-get update && apt-get install -y gcc jq make
WORKDIR /app
COPY . .
RUN set -e && make all && make check
ENTRYPOINT ["./build/wordcount"]
