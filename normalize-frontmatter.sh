#!/bin/bash

# Normalize all markdown files under the site directory
echo "🔧 Normalizing front matter in Markdown files under ./site"

find ./site \( -name ".git" -o -name "Assets" \) -prune -false -o -name "*.md" | while read -r file; do
  echo "🔍 Processing: $file"

  awk '
  BEGIN { inYaml=0 }
  /^---/ {
    if (!inYaml) {
      print "---"
      inYaml=1
      next
    } else {
      print "---"
      inYaml=0
      next
    }
  }
  inYaml {
    gsub(/^[[:space:]]*L?Title:[[:space:]]*/, "title: ")
    gsub(/^[[:space:]]*L?Date:[[:space:]]*/, "date: ")
    gsub(/^[[:space:]]*L?Tags:[[:space:]]*/, "tags: ")
    gsub(/^[[:space:]]*L?Status:[[:space:]]*/, "status: ")
    gsub(/^[[:space:]]*L?Source:[[:space:]]*/, "source: ")
    gsub(/^[[:space:]]*Loop[[:space:]]+Number:[[:space:]]*/, "loop_number: ")
    gsub(/^[[:space:]]*RCE[[:space:]]+Tier:[[:space:]]*/, "rce_tier: ")
    gsub(/^[[:space:]]*Connected[[:space:]]+Loops:[[:space:]]*/, "connected_loops:")
    gsub(/^[[:space:]]*Companion[[:space:]]+To:[[:space:]]*/, "companion_to:")
    gsub(/^[[:space:]]*Emotional[[:space:]]+Weight:[[:space:]]*/, "emotional_weight: ")
    print
    next
  }
  {
    print
  }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

done

echo "✅ Normalization complete."
