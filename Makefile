NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC_DIR := src
BUILD_DIR := build
TEST_DIR := test

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRC_FILES))

TARGET := $(BUILD_DIR)/$(NAME)

CPPFLAGS := -DNAME="\"$(NAME)\"" -DVERSION="\"$(VERSION)\""

TEST_INPUT_FILES := $(wildcard $(TEST_DIR)/*.txt)
TEST_PASSED_FLAGS := $(patsubst $(TEST_DIR)/%.txt,$(BUILD_DIR)/%.passed,$(TEST_INPUT_FILES))

.PHONY: all clean check force-check

all: $(TARGET)

$(TARGET): $(OBJ_FILES) | $(BUILD_DIR)
	$(CC) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c config.json | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

check: force-check
	@

force-check: $(TEST_PASSED_FLAGS)
	@rm -f $(TEST_PASSED_FLAGS)

$(BUILD_DIR)/%.passed: $(TARGET) $(TEST_DIR)/%.txt $(TEST_DIR)/%.expected | $(BUILD_DIR)
	@./$(TARGET) < $(filter %.txt,$^) | diff -q $(filter %.expected,$^) - > /dev/null || \
	{ ./$(TARGET) < $(filter %.txt,$^) | diff -u $(filter %.expected,$^) -; exit 1; }
	@touch $@

clean:
	rm -rf $(BUILD_DIR)
