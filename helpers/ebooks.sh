#!/usr/bin/env bash

set -e

EBOOK_NAME="The-Book"
EPUB_FILE="$EBOOK_NAME.epub"
MOBI_FILE="$EBOOK_NAME.mobi"

# Use book-epub.toml to provide options
mv book.toml book-html.toml
cp book-epub.toml book.toml

# Update the date
cd manuscript/markdown
TODAY=$(date --iso-8601)
sed -i 's/\(Last updated on:\) *[0-9-]\{10\}/\1 '"$TODAY"'/' titlepage.md
sed -i 's/\(Last updated on:\) *[0-9-]\{10\}/\1 '"$TODAY"'/' titlepage-ebook.md
cd ../..

# Use titlepage-ebook.md for a simple title page
cd manuscript/markdown
mv titlepage.md titlepage-html.md
cp titlepage-ebook.md titlepage.md
cd ../..

mdbook-epub --standalone

# Restore
mv book-html.toml book.toml
cd manuscript/markdown
mv titlepage-html.md titlepage.md
cd ../..

mv ./book/*.epub ./

# The epub is generated with the title as file name, but use a non-accented file name for storage.
mv "The Book.epub" "$EPUB_FILE"

~/bin/epubcheck "./$EPUB_FILE"

mv "./$EPUB_FILE" "./manuscript/markdown/assets/docs"

echo "OK"
