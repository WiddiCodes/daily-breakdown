#!/bin/bash
# Adds "Daily Breakdown" to your app menu and opens it when you log in.
#   bash install-linux.sh            install (menu + open at login)
#   bash install-linux.sh --no-autostart   menu entry only
#   bash install-linux.sh remove     undo
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/daily-breakdown.html"
APPS="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
AUTO="${XDG_CONFIG_HOME:-$HOME/.config}/autostart"
NAME="daily-breakdown.desktop"

if [ "$1" = "remove" ]; then
  rm -f "$APPS/$NAME" "$AUTO/$NAME"
  echo "Removed the menu entry and login item."
  exit 0
fi

[ -f "$HTML" ] || { echo "Can't find daily-breakdown.html next to this script."; exit 1; }

BROWSER=""
for B in google-chrome google-chrome-stable chromium chromium-browser brave-browser microsoft-edge microsoft-edge-stable; do
  if command -v "$B" >/dev/null 2>&1; then BROWSER="$(command -v "$B")"; break; fi
done
[ -n "$BROWSER" ] || { echo "Please install Google Chrome or Chromium first (saving to history.json needs a Chromium-based browser)."; exit 1; }

URL="file://$(printf '%s' "$HTML" | sed 's/%/%25/g; s/ /%20/g')"
# In .desktop files a literal % must be written as %%
EXEC_URL="$(printf '%s' "$URL" | sed 's/%/%%/g')"

mkdir -p "$APPS"
cat > "$APPS/$NAME" <<EOF
[Desktop Entry]
Type=Application
Name=Daily Breakdown
Comment=Daily study schedule, timer and problem log
Exec=$BROWSER --app=$EXEC_URL --window-size=460,820
Icon=x-office-calendar
Terminal=false
Categories=Office;Education;
EOF
chmod +x "$APPS/$NAME"
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APPS" >/dev/null 2>&1 || true

if [ "$1" != "--no-autostart" ]; then
  mkdir -p "$AUTO"
  cp "$APPS/$NAME" "$AUTO/$NAME"
  echo "X-GNOME-Autostart-enabled=true" >> "$AUTO/$NAME"
fi

echo "Done. Using: $BROWSER"
echo "  • 'Daily Breakdown' is in your app menu."
[ "$1" != "--no-autostart" ] && echo "  • It will open automatically when you log in."
case "$BROWSER" in /snap/*) echo "  Note: Snap browsers can only open files in your home folder (not hidden folders), so keep this folder there.";; esac
