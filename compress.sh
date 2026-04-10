#!/usr/bin/env bash
# Compress and resize raw images dropped into _staging/ and move them to images/
#
# Usage:
#   ./compress.sh                # process all 3 staging folders
#   ./compress.sh cross-sell     # only cross-sell
#   ./compress.sh tiles          # only tiles
#   ./compress.sh hero           # only hero
#
# Requires: sips (built into macOS), no installs needed
#
# Output targets:
#   cross-sell/ -> 400x400 square crop, JPEG quality 75
#   tiles/      -> 500x400 crop, JPEG quality 78
#   hero/       -> 1200 max width, JPEG quality 80

set -euo pipefail

cd "$(dirname "$0")"

# ANSI colours for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

process_folder() {
  local folder="$1"
  local max_w="$2"
  local max_h="$3"
  local quality="$4"
  local crop="$5"  # "square" or "rect" or "none"

  local src="_staging/$folder"
  local dst="images/$folder"

  if [[ ! -d "$src" ]]; then
    echo -e "${YELLOW}⚠ $src does not exist, skipping${NC}"
    return
  fi

  mkdir -p "$dst"

  local count=0
  for f in "$src"/*.{jpg,jpeg,png,JPG,JPEG,PNG}; do
    [[ -e "$f" ]] || continue
    local name
    name="$(basename "$f")"
    # Normalise extension to lowercase .jpg
    local stem="${name%.*}"
    local out="$dst/${stem}.jpg"

    local before_size
    before_size=$(stat -f%z "$f")

    # Copy to output first, then process in place
    cp "$f" "$out"

    # Resize
    if [[ "$crop" == "square" ]]; then
      # Square crop: resize shorter side to target, then crop centre
      sips --resampleHeightWidthMax "$max_w" "$out" >/dev/null
      sips --cropToHeightWidth "$max_h" "$max_w" "$out" >/dev/null
    elif [[ "$crop" == "rect" ]]; then
      sips --resampleHeightWidthMax "$max_w" "$out" >/dev/null
      sips --cropToHeightWidth "$max_h" "$max_w" "$out" >/dev/null
    else
      sips --resampleWidth "$max_w" "$out" >/dev/null
    fi

    # Convert to JPEG and set quality
    sips -s format jpeg -s formatOptions "$quality" "$out" >/dev/null

    local after_size
    after_size=$(stat -f%z "$out")

    local ratio=$(( (after_size * 100) / before_size ))
    local before_kb=$(( before_size / 1024 ))
    local after_kb=$(( after_size / 1024 ))

    echo -e "  ${GREEN}✓${NC} $name  ${before_kb}KB → ${after_kb}KB (${ratio}%)"
    count=$((count + 1))
  done

  if [[ $count -eq 0 ]]; then
    echo -e "${YELLOW}  (no images found in $src)${NC}"
  else
    echo -e "${GREEN}$count files processed → $dst${NC}"
  fi
  echo ""
}

FOLDER="${1:-all}"

case "$FOLDER" in
  cross-sell)
    echo "📦 Processing cross-sell (400×400 square, Q75)"
    process_folder "cross-sell" 400 400 75 "square"
    ;;
  tiles)
    echo "📦 Processing tiles (500×400, Q78)"
    process_folder "tiles" 500 400 78 "rect"
    ;;
  hero)
    echo "📦 Processing hero (1200 wide, Q80)"
    process_folder "hero" 1200 800 80 "none"
    ;;
  all)
    echo "📦 Processing cross-sell (400×400 square, Q75)"
    process_folder "cross-sell" 400 400 75 "square"
    echo "📦 Processing tiles (500×400, Q78)"
    process_folder "tiles" 500 400 78 "rect"
    echo "📦 Processing hero (1200 wide, Q80)"
    process_folder "hero" 1200 800 80 "none"
    ;;
  *)
    echo -e "${RED}Unknown folder: $FOLDER${NC}"
    echo "Usage: ./compress.sh [cross-sell|tiles|hero|all]"
    exit 1
    ;;
esac

echo -e "${GREEN}Done. Review images in images/ and commit when ready:${NC}"
echo "  git add images/ && git commit -m 'add: compressed images' && git push"
