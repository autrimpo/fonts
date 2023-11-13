{
  mkFont,
  lib,
  fetchzip,
}: let
  version = import ./_version.nix;
  fetchFontshare = {
    pname,
    sha256,
  }:
    fetchzip {
      url = "https://api.fontshare.com/v2/fonts/download/${pname}";
      inherit sha256;
      extension = "zip";
    };
  mkFontshare = {
    pname,
    sha256,
  }:
    mkFont {
      inherit pname version;
      src = fetchFontshare {inherit pname sha256;};
      preInstall = ''
        find -iname 'web' -type d -print0 | xargs -0 -r rm -rf
      '';
    };
in
  lib.mapAttrs
  (name: value:
    mkFontshare {
      pname = name;
      sha256 = value;
    })
  (import ./_sources.nix)
