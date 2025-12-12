#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
readonly PROJECT_ROOT

if [[ -z "$PROJECT_ROOT" ]] && [[ ! -d "$PROJECT_ROOT" ]]; then
	echo "Error: Could not find git root. Are you inside a git repository?" >&2
	exit 1
fi

SCRIPT_DIR="$PROJECT_ROOT/scripts"
readonly SCRIPT_DIR

if [[ -z "$SCRIPT_DIR" ]] && [[ ! -d "$SCRIPT_DIR" ]]; then
	echo "Error: Script directory not found: $SCRIPT_DIR" >&2
	exit 1
fi

cd "$SCRIPT_DIR/.."

PROTO_DIR="$PROJECT_ROOT/proto"
readonly PROTO_DIR
GO_OUT_DIR="$PROJECT_ROOT/gen/go"
readonly GO_OUT_DIR
ELIXIR_OUT_DIR="$PROJECT_ROOT/gen/elixir/lib/generated"
readonly ELIXIR_OUT_DIR

echo "Stream Mount API - Code Generator"
echo ""

# Check for protoc
if ! command -v protoc &> /dev/null; then
    echo "ERROR: protoc not found!"
    echo "Run 'nix develop' to enter the development environment."
    exit 1
fi

# Generate Go code
if ! command -v protoc-gen-go &> /dev/null || ! command -v protoc-gen-go-grpc &> /dev/null; then
    echo "WARNING: Go protoc plugins not found. Skipping Go generation."
else
    echo "Generating Go code..."
    mkdir -p "$GO_OUT_DIR"

    protoc \
        --go_out="$GO_OUT_DIR" \
        --go_opt=paths=source_relative \
        --go-grpc_out="$GO_OUT_DIR" \
        --go-grpc_opt=paths=source_relative \
        --proto_path="$PROTO_DIR" \
        "$PROTO_DIR"/*.proto
    echo "✓ Go code generated"
fi

# Generate Elixir code
if ! command -v protoc-gen-elixir &> /dev/null; then
    echo "WARNING: Elixir protoc plugin not found. Skipping Elixir generation."
else
    echo ""
    echo "Generating Elixir code..."
    mkdir -p "$ELIXIR_OUT_DIR"

    protoc \
        --elixir_out=plugins=grpc:"$ELIXIR_OUT_DIR" \
        --proto_path="$PROTO_DIR" \
        "$PROTO_DIR"/*.proto
    echo "✓ Elixir code generated"
fi

echo ""
echo "✓ Code generation complete!"
