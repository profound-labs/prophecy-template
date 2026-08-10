#!/bin/bash

# Call this from project root:
#
# ./helpers/tex_to_markdown.sh ./manuscript/tex/chapter-01.tex ./manuscript/markdown/

TEX_SRC="$1"

# Strip trailing slashes from output folder argument.
OUT_DIR=$(echo "$2" | sed 's:/*$::')

# https://stackoverflow.com/a/2352397/195141
file_ext=$(echo "$TEX_SRC" |awk -F . '{if (NF>1) {print $NF}}')

if [ "$TEX_SRC" == "" -o ! -f "$TEX_SRC" -o "$file_ext" != "tex" ]; then
   echo "First argument must be a .tex file."
   exit 2
fi

if [ "$OUT_DIR" == "" ]; then
    echo "Second argument must be an output folder."
    exit 2
fi

if [ ! -d "$OUT_DIR" ]; then
    echo "Folder doesn't exist: $OUT_DIR"
    exit 2
fi

echo -n "--- "$(basename $TEX_SRC)" to Markdown ... "

# Check for unknown LaTeX.

./helpers/check_unknown_latex.sh "$TEX_SRC"

if [ "$?" != "0" ]; then
    echo "Exiting."
    exit 2
fi

name=$(basename -s .tex $TEX_SRC)
OUT_FILE="$OUT_DIR/$name.md"

# Replace or remove LaTeX which pandoc doesn't know, then convert with pandoc.

./helpers/canonicalize_latex.sh "$TEX_SRC" | \
    # convert latex quotes
    sed -e "s/\`\`\([[:alnum:][:punct:]]\)/“\1/g; s/\([[:alnum:][:punct:]]\)''/\1”/g;" | \
    sed -e   "s/\`\([[:alnum:][:punct:]]\)/‘\1/g; s/\([[:alnum:][:punct:]]\)'/\1’/g;" | \
    pandoc -f latex -t markdown-smart --wrap=none | \
    cat -s > "$OUT_FILE"

# Check the output file.

RES=""
RES="$RES"$(grep -E "\`|'|’'" "$OUT_FILE")
RES="$RES"$(grep -E '"' "$OUT_FILE")

if [ "$RES" != "" ]; then
    echo "WARNING! These lines don't look good:"
    echo "$RES"
fi

if [ "$?" == "0" ]; then
    echo "OK"
else
    echo "ERROR, Exiting."
    exit 2
fi

