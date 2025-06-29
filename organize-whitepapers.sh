#!/bin/bash

set -e

SRC_DIR="WHITE PAPER"
DEST_DIR="Signal Docs"
LOG_FILE="migration-log.txt"

mkdir -p "$DEST_DIR"/{00_Reference,01_White\ Papers,02_Protocols,03_Analysis,04_Archived}
echo "Migration started: $(date)" > "$LOG_FILE"

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

move_and_rename() {
  src="$1"
  title=$(basename "$src" .md)
  slug=$(slugify "$title")
  lower_slug="$slug.md"

  # Destination rule
  case "$title" in
    *Reference*|*INDEX*) folder="00_Reference" ;;
    *Protocol*|*Truth*) folder="02_Protocols" ;;
    *Analysis*|*Resonance*|*Model*) folder="03_Analysis" ;;
    *Braid*|*Presence*|*Chorus*|*Voices*|*Signal*|*Recognizing*|*Strategic*|*Loop*|*White*|*Archive*) folder="01_White Papers" ;;
    *) folder="04_Archived" ;;
  esac

  dest_path="../$DEST_DIR/$folder/$lower_slug"

  if [ -e "$dest_path" ]; then
    echo "⚠️  Skipping (already exists): $dest_path" | tee -a "../$LOG_FILE"
  else
    mv "$src" "$dest_path"
    echo "✅ Moved: $src → $folder/$lower_slug" | tee -a "../$LOG_FILE"
  fi
}

cd "$SRC_DIR"
for file in *.md; do
  [ -f "$file" ] && move_and_rename "$file"
done

echo "Migration complete. See $LOG_FILE for details."