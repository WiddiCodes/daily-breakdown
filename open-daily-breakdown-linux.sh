#!/bin/bash
# Opens Daily Breakdown in a small app-style Chrome/Chromium window.
# Tip: run install-linux.sh once to add it to your app menu and open it at login.
DIR="$(cd "$(dirname "$0")" && pwd)"
URL="file://$(printf '%s' "$DIR/daily-breakdown.html" | sed 's/%/%25/g; s/ /%20/g')"
for B in google-chrome google-chrome-stable chromium chromium-browser brave-browser microsoft-edge microsoft-edge-stable; do
  if command -v "$B" >/dev/null 2>&1; then
    exec "$B" --app="$URL" --window-size=460,820
  fi
done
echo "Chrome/Chromium not found; opening in your default browser instead."
xdg-open "$DIR/daily-breakdown.html"
