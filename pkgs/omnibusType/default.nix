{
  mkFont,
  lib,
  fetchzip,
}: let
  version = import ./_version.nix;
  fetchOmnibus = {
    pname,
    sha256,
  }:
    fetchzip {
      url = "https://www.omnibus-type.com/wp-content/uploads/${pname}.zip";
      inherit sha256;
    };
  mkOmnibus = {
    pname,
    sha256,
  }:
    mkFont {
      inherit pname version;
      src = fetchOmnibus {inherit pname sha256;};
    };
in
  lib.mapAttrs
  (name: value:
    mkOmnibus {
      pname = name;
      sha256 = value;
    })
  (import ./_sources.nix)
