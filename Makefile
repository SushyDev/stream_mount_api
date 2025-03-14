# Makefile for building a Go gRPC project

# Directories
PROTO_DIR := .

# Find all proto files in the proto directory
PROTO_FILES := $(wildcard $(PROTO_DIR)/*.proto)

# Go settings
GOCMD := go

# Default target
all: proto

# Generate Go code from proto files
proto:
	protoc --go_out=. --go-grpc_out=. $(PROTO_FILES)

.PHONY: all proto build run clean
