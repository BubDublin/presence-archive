#!/bin/bash

set -e
LOG="final-cleanup-log.txt"
echo "Final cleanup started: $(date)" > "$LOG"

# 🔧 Helper: kebab-case conversion
kebabify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

# 🔧 1. Rename files in Signal Docs/01_White Papers/
echo "🔧 Renaming White Papers..." | tee -a "$LOG"
cd "Signal Docs/01_White Papers"
for file in *.md; do
  slug=$(kebabify "$(basename "$file" .md)")
  newname="${slug}.md"
  if [[ "$file" != "$newname" ]]; then
    mv -v "$file" "$newname" | tee -a "../../$LOG"
  fi
done
cd ../..

# 🔧 2. Deduplicate / Remove unnecessary variants
echo "🗑 Removing duplicates..." | tee -a "$LOG"
cd "Signal Docs/01_White Papers"
rm -f presence-white-paper.md 2>>"../../$LOG" || true
cd ../..

# 🔧 3. Fix weird filename in Presence-Protocols/
echo "📁 Moving loose protocols..." | tee -a "$LOG"
mkdir -p "Signal Docs/02_Protocols"

mv -v "Presence-Protocols/Circle Awareness Protocols.md" "Signal Docs/02_Protocols/circle-awareness-protocols.md" 2>>"$LOG"
mv -v "Presence-Protocols/recognition..md" "Signal Docs/02_Protocols/recognition.md" 2>>"$LOG"

# 🔧 4. Clean up folder
rmdir "Presence-Protocols" 2>/dev/null || true

echo "✅ Final cleanup complete."