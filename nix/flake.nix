{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		sushy-lib = {
			url = "github:sushydev/nix-lib";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, sushy-lib }: {
		packages = sushy-lib.forPlatforms sushy-lib.platforms.default (system: 
			let
				pkgs = import nixpkgs { inherit system; };
			in 
			{
				generate = pkgs.writeShellApplication {
					name = "sma-generate";
					runtimeInputs = [
						# Languages
						pkgs.go
						pkgs.beamMinimal28Packages.elixir_1_19
						
						# Protobuf tooling
						pkgs.protobuf                  # protoc compiler
						pkgs.protoc-gen-go             # Go protobuf plugin
						pkgs.protoc-gen-go-grpc        # Go gRPC plugin
						pkgs.protoc-gen-elixir         # Elixir protobuf plugin
					];
					text = builtins.readFile ../scripts/generate.sh;
				};
			}
		);

		devShells = sushy-lib.forPlatforms sushy-lib.platforms.default (system: 
			let
				pkgs = import nixpkgs { inherit system; };
				packages = self.packages.${system};
			in 
			{
				default = pkgs.mkShell {
					buildInputs = [
						# Languages
						pkgs.go
						pkgs.beamMinimal28Packages.elixir_1_19
						
						# Protobuf tooling
						pkgs.protobuf                  # protoc compiler
						pkgs.protoc-gen-go             # Go protobuf plugin
						pkgs.protoc-gen-go-grpc        # Go gRPC plugin
						pkgs.protoc-gen-elixir         # Elixir protobuf plugin
						
						# Development tools
						pkgs.gnumake                   # For Makefile commands

						# Scripts
						packages.generate
					];

					shellHook = ''
						echo "Stream Mount API Development Environment"
						echo ""
						echo "Elixir version: $(elixir --version | head -1)"
						echo "Go version:     $(go version)"
						echo "Protoc version: $(protoc --version)"
						echo ""
						echo "Run 'make help' or 'sma-generate' to get started"
					'';
				};
			}
		);
	};
}

