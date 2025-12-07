# Stream Mount API - Polyglot Proto Repository Makefile
# Supports generation for Go and Elixir

# Directories
PROTO_DIR := proto
GO_OUT_DIR := gen/go
ELIXIR_OUT_DIR := gen/elixir/lib/generated

# Proto files
PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)

# Tools
PROTOC := protoc
GO := go

# Default target
.PHONY: all
all: help

# Help target
.PHONY: help
help:
	@echo "Stream Mount API - Makefile Commands"
	@echo ""
	@echo "  make generate      Generate code for all languages (Go + Elixir)"
	@echo "  make generate-go   Generate only Go code"
	@echo "  make generate-ex   Generate only Elixir code"
	@echo "  make clean         Remove all generated code"
	@echo "  make test-go       Run Go tests"
	@echo "  make install-hooks Install git pre-commit hooks"
	@echo "  make verify        Generate and verify code compiles"
	@echo ""
	@echo "Using Nix? Run 'nix develop' or 'direnv allow' first."
	@echo ""

# Generate all
.PHONY: generate
generate: generate-go generate-ex
	@echo "✓ Generated code for all languages"

# Generate Go code
.PHONY: generate-go
generate-go:
	@echo "Generating Go code..."
	@mkdir -p $(GO_OUT_DIR)
	@$(PROTOC) \
		--go_out=$(GO_OUT_DIR) \
		--go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT_DIR) \
		--go-grpc_opt=paths=source_relative \
		--proto_path=$(PROTO_DIR) \
		$(PROTO_FILES)
	@echo "✓ Go code generated"

# Generate Elixir code
.PHONY: generate-ex
generate-ex:
	@echo "Generating Elixir code..."
	@mkdir -p $(ELIXIR_OUT_DIR)
	@$(PROTOC) \
		--elixir_out=plugins=grpc:$(ELIXIR_OUT_DIR) \
		--proto_path=$(PROTO_DIR) \
		$(PROTO_FILES)
	@echo "✓ Elixir code generated"

# Clean generated code
.PHONY: clean
clean:
	@echo "Cleaning generated code..."
	@rm -rf $(GO_OUT_DIR)/stream_mount_api
	@rm -rf $(ELIXIR_OUT_DIR)/*.pb.ex
	@echo "✓ Cleaned"

# Test Go code
.PHONY: test-go
test-go:
	@echo "Running Go tests..."
	@$(GO) test ./...

# Install git hooks
.PHONY: install-hooks
install-hooks:
	@echo "Installing git pre-commit hook..."
	@mkdir -p .git/hooks
	@cp scripts/pre-commit .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "✓ Git hooks installed"

# Verify generated code compiles
.PHONY: verify
verify: generate
	@echo "Verifying generated code..."
	@$(GO) build ./...
	@echo "✓ Verification complete"
