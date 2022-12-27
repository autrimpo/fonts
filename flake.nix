{
  description = "Open source fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        mkFont = pkgs.callPackage ./lib/mkFont.nix {};
      in {
        packages = import ./pkgs/omnibusType {
          inherit mkFont;
          inherit (pkgs) lib fetchzip;
        };
      }
    );
}
