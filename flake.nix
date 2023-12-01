{
  description = "Nix flake for Clide";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };
      erlang = pkgs.beam.packages.erlang_26;
      elixir = erlang.elixir_1_15;
    in {
      # packages exported by the flake
      packages = {};

      # nix run
      apps = {};

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells.default = pkgs.mkShell {
        name = "default dev shell";
        packages = [
            elixir
            pkgs.elixir-ls
            pkgs.p7zip
            pkgs.xz
            pkgs.zig
          ]
          ++ pkgs.lib.optionals (!pkgs.stdenv.isDarwin) [
            pkgs.wine64
          ];
      };
    });
  in
    outputs;
}
