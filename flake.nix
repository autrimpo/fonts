{
  description = "Open source fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        lib,
        ...
      }: let
        h = inputs.haumea.lib;
        mkFont = pkgs.callPackage self.lib.mkFont {};
      in {
        formatter = pkgs.alejandra;
        packages =
          lib.attrsets.concatMapAttrs
          (_: x: x)
          (h.load {
            src = ./pkgs;
            inputs = {
              inherit mkFont;
              inherit (pkgs) lib fetchzip;
            };
            transformer = h.transformers.liftDefault;
          });
      };
    };
}
