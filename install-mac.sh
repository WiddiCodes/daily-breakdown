#!/bin/bash
# Creates ~/Applications/Daily Breakdown.app and makes it open when you log in.
#   bash install-mac.sh           install
#   bash install-mac.sh remove    undo
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/daily-breakdown.html"
APP="$HOME/Applications/Daily Breakdown.app"
PLIST="$HOME/Library/LaunchAgents/com.dailybreakdown.open.plist"

if [ "$1" = "remove" ]; then
  launchctl bootout "gui/$(id -u)" "$PLIST" 2>/dev/null || true
  rm -rf "$APP" "$PLIST"
  echo "Removed Daily Breakdown.app and the login item."
  exit 0
fi

[ -f "$HTML" ] || { echo "Can't find daily-breakdown.html next to this script."; exit 1; }

BROWSER=""
for B in "Google Chrome" "Microsoft Edge" "Brave Browser" "Chromium"; do
  if open -Ra "$B" 2>/dev/null; then BROWSER="$B"; break; fi
done
[ -n "$BROWSER" ] || { echo "Please install Google Chrome first (saving to history.json needs Chrome or Edge)."; exit 1; }

URL="file://$(printf '%s' "$HTML" | sed 's/%/%25/g; s/ /%20/g')"

# 1) A small app you can open from Spotlight, Launchpad or the Dock
mkdir -p "$HOME/Applications"
rm -rf "$APP"
SCRIPT="$(mktemp -d)/app.applescript"
cat > "$SCRIPT" <<EOF
do shell script "open -na " & quoted form of "$BROWSER" & " --args --app=" & quoted form of "$URL" & " --window-size=460,820"
EOF
osacompile -o "$APP" "$SCRIPT"
rm -f "$SCRIPT"

# 2) Open it automatically at login
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.dailybreakdown.open</string>
  <key>ProgramArguments</key>
  <array><string>/usr/bin/open</string><string>$APP</string></array>
  <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

echo "Done."
echo "  • App: ~/Applications/Daily Breakdown.app (find it with Spotlight; drag it to the Dock if you like)"
echo "  • It will open automatically when you log in (macOS may show a 'Background item added' note)."
echo "Opening it now…"
open "$APP"
