FROM ubuntu:22.04
RUN apt-get update && apt-get install -y build-essential jq make
WORKDIR /app
COPY . .
RUN make all
RUN make test
RUN test $? -eq 0 || exit 1
CMD ["./build/wordcount"]
