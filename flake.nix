{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-analyzer"
            "rust-src"
          ];
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = lib.optionals stdenv.isDarwin [
              darwin.apple_sdk.frameworks.AppKit
            ];
            packages = [ rust-toolchain ];
          };

        packages = rec {
          klip =
            with pkgs;

            rustPlatform.buildRustPackage {
              name = "klip";
              src = ./.;
              cargoLock = {
                lockFile = ./Cargo.lock;
              };

              meta = {
                description = "A dead simple cross-platform tool to interact with the clipboard";
                homepage = "https://github.com/iniw/klip";
                license = [
                  lib.licenses.bsd2
                ];
              };

              buildInputs = lib.optionals stdenv.isDarwin [
                darwin.apple_sdk.frameworks.AppKit
              ];
            };

          default = klip;
        };
      }
    );
}
