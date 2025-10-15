NAME := $(jq -r .name config.json)
VERSION := $(jq -r .version config.json)

BUILD_DIR := build

EXECUTABLE := $(BUILD_DIR)/$(NAME)

SOURCE := src/wordcount.c

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE) config.json | $(BUILD_DIR)

$(BUILD_DIR):
 mkdir -p $@

clean:
 rm -rf $(BUILD_DIR)

$(EXECUTABLE): $(SOURCE) config.json
