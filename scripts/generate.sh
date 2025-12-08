#!/usr/bin/env bash

set -e

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

readonly PROTO_DIR="proto"
readonly GO_OUT_DIR="gen/go"
readonly ELIXIR_OUT_DIR="gen/elixir/lib/generated"

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
