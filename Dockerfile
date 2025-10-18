RUN apt-get update && apt-get install -y build-essential jq make
WORKDIR /app
COPY . .
RUN set -e && make all && make check
CMD ["./build/wordcount"]
