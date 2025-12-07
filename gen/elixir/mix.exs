defmodule StreamMountApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :stream_mount_api,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Stream Mount API - gRPC client/server for filesystem operations",
      package: package(),
      source_url: "https://github.com/sushydev/stream_mount_api"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:grpc, "~> 0.8"},
      {:protobuf, "~> 0.12"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sushydev/stream_mount_api"}
    ]
  end
end
