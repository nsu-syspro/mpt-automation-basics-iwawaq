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
TEST_TARGETS := $(TEST_FILES:$(TEST_DIR)/%.txt=check-%)

.PHONY: all clean check $(TEST_TARGETS) force-rebuild

all: $(TARGET)

$(TARGET): $(OBJ_FILES) | $(BUILD_DIR)
	$(CC) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

check: $(TEST_TARGETS)
	@

check-%: $(TARGET)
	@test_file="$(TEST_DIR)/$*.txt"; \
	expected_file="$(TEST_DIR)/$*.expected"; \
	if ! ./$(TARGET) < "$$test_file" | diff -q "$$expected_file" - > /dev/null; then \
		echo "Test failed: $$test_file"; \
		./$(TARGET) < "$$test_file" | diff -u "$$expected_file" -; \
		exit 1; \
	fi

clean:
	rm -rf $(BUILD_DIR)
