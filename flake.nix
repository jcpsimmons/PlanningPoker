{
  description = "Twi's blog, version 2";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.deno2nix = {
    url = "github:Xe/deno2nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, deno2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ deno2nix.overlays.default ];
        };

      in
      rec {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            deno
            flyctl
          ];
        };

        packages = rec {
          poker = pkgs.deno2nix.mkExecutable {
            pname = "planning-poker";
            version = "0.2.0";

            src = ./.;
            lockfile = ./deno.lock;

            output = "poker";
            entrypoint = "./main.ts";
            additionalDenoFlags = "--allow-all";
            # importMap = "./import_map.json";
          };
        };
      }
    );
}
