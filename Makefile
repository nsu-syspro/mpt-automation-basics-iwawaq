NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

BUILD_DIR := build

EXECUTABLE := $(BUILD_DIR)/$(NAME)

SOURCE := src/wordcount.c

CC := gcc

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE) config.json | $(BUILD_DIR)
	$(CC) -o $@ $<
$(BUILD_DIR):
	mkdir -p $@
clean:
	rm -rf $(BUILD_DIR)
