NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC_DIR := src
BUILD_DIR := build
TEST_DIR := test
SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES := $(SRC_FILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

TARGET := $(BUILD_DIR)/$(NAME)

CPPFLAGS := -DNAME="\"$(NAME)\"" -DVERSION="\"$(VERSION)\""

TEST_FILES := $(wildcard $(TEST_DIR)/*.txt)

all: $(TARGET)

$(TARGET): $(OBJ_FILES) | $(BUILD_DIR)
	$(CC) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

check: $(TARGET)
	@for test_file in $(TEST_FILES); do \
		expected_file="$${test_file%.txt}.expected"; \
		./$(TARGET) < "$${test_file}" | diff -q "$${expected_file}" - > /dev/null || \
		{ ./$(TARGET) < "$${test_file}" | diff -u "$${expected_file}" -; exit 1; }; \
	done

clean:
	rm -rf $(BUILD_DIR)
