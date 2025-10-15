NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

BUILD_DIR := build
EXECUTABLE := $(BUILD_DIR)/$(NAME)
SOURCE := src/wordcount.c
TEST_DIR := test
TESTS := $(wildcard $(TEST_DIR)/*.txt)
EXPECTED := $(patsubst $(TEST_DIR)/%.txt,$(TEST_DIR)/%.expected,$(TESTS))

CC := gcc
CFLAGS := -g -Wall -Wextra -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE) config.json | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $<
$(BUILD_DIR):
	@$(foreach TEST,$(TESTS),\
		./$(EXECUTABLE) < $(TEST) > tmp.out; \
		diff -q tmp.out $(patsubst $(TEST_DIR)/%.txt,$(TEST_DIR)/%.expected,$(TEST)) > /dev/null || \
		(diff -u $(patsubst $(TEST_DIR)/%.txt,$(TEST_DIR)/%.expected,$(TEST)) tmp.out; \
		rm -f tmp.out; \
		exit 0);\
		rm -f tmp.out; \
	)
clean:
	rm -rf $(BUILD_DIR)
	rm -f tmp.out
