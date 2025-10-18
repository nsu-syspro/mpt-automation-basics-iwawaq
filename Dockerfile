FROM ubuntu:22.04
RUN apt-get update && apt-get install -y build-essential jq make
WORKDIR /app
COPY . .
RUN make all || exit 1
RUN make test || exit 1
CMD ["./build/wordcount"]
