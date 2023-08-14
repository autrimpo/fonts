{
  description = "Open source fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake.lib.mkFont = ./lib/mkFont.nix;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
      perSystem = {
        self',
        pkgs,
        ...
      }: let
        mkFont = pkgs.callPackage self.lib.mkFont {};
      in {
        formatter = pkgs.alejandra;
        packages = import ./pkgs/omnibusType {
          inherit mkFont;
          inherit (pkgs) lib fetchzip;
        };
      };
    };
}
