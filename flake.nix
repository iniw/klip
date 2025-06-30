{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      overlays.default = final: prev: {
        inherit (self.packages."${final.system}") klip;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = rec {
          klip = pkgs.rustPlatform.buildRustPackage {
            name = "klip";
            src = ./.;
            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            meta = {
              description = "A dead simple cross-platform tool to interact with the clipboard";
              homepage = "https://github.com/iniw/klip";
              license = [
                pkgs.lib.licenses.bsd2
              ];
            };
          };

          default = klip;
        };
      }
    );
}
