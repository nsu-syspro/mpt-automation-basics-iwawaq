FROM ubuntu:22.04
RUN apt-get update && apt-get install -y build-essential jq make
WORKDIR /app
COPY . .
RUN set -e && make all && make check
ENTRYPOINT ["./build/wordcount"]
