#!/bin/bash

echo "Fixing YAML colons in frontmatter..."

find site/Signal/protocols -type f -name "*.md" | while read -r file; do
  awk '
    BEGIN { in_frontmatter = 0 }
    /^---$/ {
      if (++in_frontmatter == 2) in_frontmatter = 0
      print $0
      next
    }
    in_frontmatter == 1 {
      sub(/^([^:]+):([^[:space:]])/, "\\1: \\2")
    }
    { print $0 }
  ' "$file" > "$file.fixed" && mv "$file.fixed" "$file"
done

echo "All frontmatter colons corrected. Try running Eleventy again:"
echo "npx eleventy --serve"