#!/bin/bash

DOT_GIT_DIR="../prophecy-template_gh-pages-dot-git"

if [ ! -d "$DOT_GIT_DIR" -o ! -f "$DOT_GIT_DIR/config" ]; then
    echo "Create the HTML repo .git folder as $DOT_GIT_DIR."
    exit 2
fi

if [ -d gh-pages ]; then
    mdbook clean
fi

mdbook build

touch gh-pages/.nojekyll

# Relative path is interpreted from symlink target location, i.e. in ./gh-pages
ln -s "../$DOT_GIT_DIR" ./gh-pages/.git
