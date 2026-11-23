#!/bin/bash
# Opens Daily Breakdown in a small app-style window (Chrome, else Edge/Brave/Chromium).
# Tip: run install-mac.sh once to get a proper "Daily Breakdown" app instead.
DIR="$(cd "$(dirname "$0")" && pwd)"
URL="file://$(printf '%s' "$DIR/daily-breakdown.html" | sed 's/%/%25/g; s/ /%20/g')"
for APP in "Google Chrome" "Microsoft Edge" "Brave Browser" "Chromium"; do
  if open -Ra "$APP" 2>/dev/null; then
    open -na "$APP" --args --app="$URL" --window-size=460,820
    exit 0
  fi
done
echo "Chrome (or Edge/Brave/Chromium) isn't installed; opening in your default browser instead."
open "$DIR/daily-breakdown.html"
