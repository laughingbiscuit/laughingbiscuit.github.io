#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

# run all of the src files through mdhtml.sh
## output the result in the public dir 

for PAGE in $SCRIPT_DIR/content/* ; do
  cat $PAGE | $SCRIPT_DIR/src/mdhtml.sh > $SCRIPT_DIR/public/$(basename $PAGE | sed 's/\.md$//').html
done
