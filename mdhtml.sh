#!/bin/sh
set -e 

# Accept filename or pipe
[ $# -ge 1 -a -f "$1" ] && file="$1" || input="-"

RESULT=$(cat $file \
  `#-----------------------------` 				\
  `# Inline Command Processing:` 				\
  `#-----------------------------` 				\
  | sed -e "s/^#\(\s\)\(.*\)/<h1>\2<\/h1>/" `# Header 1`	\
  | sed -e "s/^##\(\s\)\(.*\)/<h2>\2<\/h2>/" `# Header 2`  	\
  | sed -e "s/^###\(\s\)\(.*\)/<h3>\2<\/h3>/" `# Header 3` 	\
  | sed -e "s/^-\(\s\)\(.*\)/<li>\2<\/li>/" `# Bullet Point` 	\
  | sed -e "s/^---/<hr\/>/" `# Horizontal Rule`		 	\
  | sed -e "s/\*\*\(.*\)\*\*/<b>\1<\/b>/" `# Bold`	 	\
  | sed -e "s/\*\(.*\)\*/<i>\1<\/i>/" `# Italics`	 	\
  | sed -e "s/^>\(\s\)\(.*\)/<q>\2<\/q>/" `# Quote`	 	\
  | sed -e 's/!\[\(.*\)\](\(.*\))/<img src="\2" alt="\1">/' `#Img`\
  | sed -e 's/\[\(.*\)\](\(.*\))/<a href="\2">\1<\/a>/' `#Link`	\
  `#-----------------------------` 				\
  `# Multiline Command Processing:` 				\
  `#-----------------------------` 				\
  | awk 1 ORS='<br/>' `# Merge into a single line` 		\
  `# Wrap paragraphs` \
  | sed -e 's/<br\/><br\/>\(\w.*\)<br\/><br\/>/<br\/><br\/><p>\1<\/p><br\/><br\/>/g' \
  `# Code Blocks` \
  | sed -e "s/\`\`\`<br\/>\(.*\)\`\`\`/<pre><code>\1<\/code><\/pre>/g" \
  | sed -e "s/\`\([^\`]*\)\`/<pre><code>\1<\/code><\/pre>/g" \
  `# Remove double newlines` \
  | sed -e "s/<br\/><br\/>//g" \
)

printf '<html><head><link rel="stylesheet" type="text/css" href="styles.css"/><body></head>'
printf "$RESULT"
printf '</body></html>'
