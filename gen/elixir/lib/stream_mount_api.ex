defmodule StreamMountApi do
  @moduledoc """
  Stream Mount API - gRPC client/server for filesystem operations.

  This module provides the generated protobuf messages and gRPC service
  definitions for the Stream Mount API.

  ## Generated Modules

  - `StreamMountApi.FileSystemService.Service` - gRPC service definition
  - `StreamMountApi.FileSystemService.Stub` - gRPC client stub
  - All protobuf message types (e.g., `StreamMountApi.Node`, `StreamMountApi.RootRequest`, etc.)
  """

  @doc """
  Returns the version of the Stream Mount API package.
  """
  def version, do: "0.1.0"
end
