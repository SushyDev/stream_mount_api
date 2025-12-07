# Stream Mount API

A polyglot protobuf/gRPC repository providing filesystem service definitions for both **Go** and **Elixir**.

## Overview

This repository contains:
- Protocol Buffer definitions for a filesystem gRPC service
- Generated Go packages (idiomatic Go module)
- Generated Elixir packages (idiomatic Mix project)
- Automated code generation on git commits via pre-commit hooks
- Nix flake for reproducible development environment

## Project Structure

```
.
├── proto/                  # Protocol Buffer definitions
│   └── api.proto          # Main API definition
├── gen/                   # Generated code (committed to repo)
│   ├── go/                # Generated Go code
│   └── elixir/            # Generated Elixir code
├── nix/                   # Nix development environment
├── docs/                  # Documentation
│   ├── README.md          # Main documentation
│   └── QUICKSTART.md      # Quick start guide
├── scripts/
│   ├── pre-commit         # Git pre-commit hook
│   └── generate.sh        # Generation script
├── Makefile               # Build commands
├── .envrc                 # direnv configuration
└── .gitignore             # Git ignore patterns
```

**For Go users**: Import `sushydev.github.io/stream_mount_api/go/api`  
**For Elixir users**: Add as dependency pointing to `gen/elixir` subdirectory

## Quick Start

### 1. Enter Development Environment

```bash
# Using direnv (recommended)
direnv allow

# Or manually
nix develop
```

All dependencies are automatically available: Go, Elixir, protoc, and all required plugins.

### 2. Generate Code

```bash
make generate
```

### 3. Install Git Hooks (Optional)

```bash
make install-hooks
```

This auto-generates code when you commit proto file changes.

## Using as a Go Package

```go
import api "sushydev.github.io/stream_mount_api/go/api"

// Use the client
client := api.NewFileSystemServiceClient(conn)
resp, _ := client.Root(context.Background(), &api.RootRequest{})
```

Get the package:
```bash
go get sushydev.github.io/stream_mount_api/go
```

## Using as an Elixir Package

In your `mix.exs`:
```elixir
{:stream_mount_api, git: "https://github.com/sushydev/stream_mount_api", subdir: "gen/elixir"}
```

In your code:
```elixir
alias StreamMountApi.FileSystemService.Stub

{:ok, channel} = GRPC.Stub.connect("localhost:50051")
{:ok, response} = Stub.root(channel, %StreamMountApi.RootRequest{})
```

## Development Workflow

### Edit Proto Files

```bash
# Edit proto
vim proto/api.proto

# Generate code
make generate

# Commit (or let pre-commit hook do it)
git add proto/api.proto gen/
git commit -m "Add new RPC method"
```

### With Pre-commit Hook

```bash
vim proto/api.proto
git add proto/api.proto
git commit -m "Add new RPC method"
# Hook auto-generates and includes generated code
```

## Available Commands

```bash
make help           # Show all commands
make generate       # Generate code for all languages
make generate-go    # Generate only Go code
make generate-ex    # Generate only Elixir code
make clean          # Remove generated code
make install-hooks  # Install git hooks
make verify         # Generate and verify compilation
make test-go        # Run Go tests
```

Or use the shell script:
```bash
./scripts/generate.sh       # Generate all
```

## API Reference

### Service: FileSystemService

- `Root()` - Get the root node
- `ReadDirAll()` - List directory contents
- `Lookup()` - Look up a file/directory by name
- `Create()` - Create a new file
- `Mkdir()` - Create a new directory
- `Remove()` - Remove a file/directory
- `Rename()` - Rename/move a file/directory
- `Link()` - Create a hard link
- `ReadFile()` - Read file contents
- `WriteFile()` - Write file contents
- `GetFileInfo()` - Get file metadata
- `GetStreamUrl()` - Get streaming URL for a file

See `proto/api.proto` for full message definitions.

## Contributing

1. Fork the repository
2. `nix develop` to enter dev environment
3. Edit proto files
4. `make generate` to generate code
5. Test your changes
6. Submit a pull request

## License

MIT
