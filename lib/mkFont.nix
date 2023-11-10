# Based on https://github.com/NixOS/nixpkgs/pull/91518 by @Valodim
{
  lib,
  stdenvNoCC,
}: args: let
  noUnpackFonts = lib.hasAttr "noUnpackFonts" args && args.noUnpackFonts;
  hasMultipleSources = lib.hasAttr "srcs" args;
in
  stdenvNoCC.mkDerivation ({
      dontPatch = true;
      dontConfigure = true;
      dontBuild = true;
      doCheck = false;
      dontFixup = true;

      sourceRoot =
        if noUnpackFonts || hasMultipleSources
        then "."
        else null;
      unpackCmd =
        if noUnpackFonts
        then ''
          filename="$(basename "$(stripHash "$curSrc")")"
          cp $curSrc "./$filename"
        ''
        else null;

      installPhase = ''
        runHook preInstall
        # these come up in some source trees, but are never useful to us
        find -iname __MACOSX -type d -print0 | xargs -0 rm -rf
        find -type f,l
        find -iname '*.ttc' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/truetype/ -D
        find -iname '*.ttf' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/truetype/ -D
        find -iname '*.otf' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/opentype/ -D
        find -iname '*.bdf' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/misc/ -D
        find -iname '*.otb' -print0 | xargs -0 -r install -v -m644 --target $out/share/fonts/misc/ -D
        find -iname '*.psf' -print0 | xargs -0 -r install -v -m644 --target $out/share/consolefonts/ -D
      '';
    }
    // args)
