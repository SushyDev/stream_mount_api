# Quick Start

Get started with Stream Mount API in under 2 minutes.

## Setup

```bash
# Clone the repo
git clone git@github.com:SushyDev/stream_mount_api.git
cd stream_mount_api

# Enter development environment
nix develop
# or with direnv
direnv allow
```

## Generate Code

```bash
make generate
```

## Use in Your Project

### Go

```bash
go get github.com/sushydev/stream_mount_api
```

```go
import pb "github.com/sushydev/stream_mount_api/gen/go/stream_mount_api"

client := pb.NewFileSystemServiceClient(conn)
```

### Elixir

In `mix.exs`:
```elixir
{:stream_mount_api, git: "https://github.com/sushydev/stream_mount_api", subdir: "gen/elixir"}
```

```elixir
alias StreamMountApi.FileSystemService.Stub
Stub.root(channel, %StreamMountApi.RootRequest{})
```

## Development

```bash
# Edit proto
vim proto/api.proto

# Generate
make generate

# Commit
git commit -am "Update API"
```

## Install Pre-commit Hook (Optional)

```bash
make install-hooks
```

Now proto changes auto-generate on commit.

## Commands

```bash
make help       # List all commands
make generate   # Generate all
./scripts/generate.sh   # Alternative to make
```

Done! Check [README.md](README.md) for full docs.
