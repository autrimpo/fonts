#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq
set -euxo pipefail

OUT="_sources.nix"
URL="https://www.omnibus-type.com/wp-content/uploads/"
FONTS=("Archivo"
       "Archivo-Narrow"
       "Asap"
       "Asap-Condensed"
       "Asap-Symbol"
       "Bahiana"
       "Bahianita"
       "Barriecito"
       "Barrio"
       "Chivo"
       "Faustina"
       "Grenze"
       "Grenze-Gotisch"
       "Jaldi"
       "Leluja-Original"
       "Manuale"
       "MuseoModerno"
       "Pragati-Narrow"
       "Rosario"
       "Saira"
       "Saira-Semi-Condensed"
       "Saira-Condensed"
       "Saira-Extra-Condensed"
       "Saira-Stencil-One"
       "Sansita"
       "Sansita-Swashed"
       "Truculenta-Original"
       "Unna")

printf "{\n" > $OUT

for FONT in "${FONTS[@]}"
do
    HASH="$(nix store prefetch-file --json --unpack "${URL}/${FONT}.zip" | jq -r .hash)"
    printf "  %s = "%s";\n" "$FONT" "\"$HASH\"" >> $OUT
done

printf "}\n" >> $OUT

printf "\"%s\"\n" "$(date -I)" > _version.nix
