#!/bin/bash
# scripts/agents/oc-rpi-update.sh
#
# Scheduled agent that syncs this project with the latest oc-rpi blueprint.
# Designed to run nightly via launchd (macOS) or cron (Linux).
#
# The key trick: this script reads the update instructions from oc-rpi itself
# at runtime. When oc-rpi improves the /update command, all projects
# automatically get the new logic on the next scheduled run.
#
# ── Setup ──
#
# 1. Copy this script to your project: scripts/agents/oc-rpi-update.sh
# 2. Set OC_RPI_PATH below to your oc-rpi clone location
# 3. Make executable: chmod +x scripts/agents/oc-rpi-update.sh
# 4. Create required directories: mkdir -p docs/agents logs
# 5. Ensure OpenCode CLI is authenticated
# 6. Schedule with launchd or cron (see examples below)
#
# ── macOS launchd ──
#
#   Create ~/Library/LaunchAgents/com.<project>.agent.oc-rpi-update.plist:
#   (Replace YOUR_USERNAME with your macOS username)
#
#   <?xml version="1.0" encoding="UTF-8"?>
#   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
#     "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#   <plist version="1.0">
#   <dict>
#     <key>Label</key>
#     <string>com.<project>.agent.oc-rpi-update</string>
#     <key>ProgramArguments</key>
#     <array>
#       <string>/bin/bash</string>
#       <string>-c</string>
#       <string>exec /bin/bash /absolute/path/to/project/scripts/agents/oc-rpi-update.sh</string>
#     </array>
#     <key>StartCalendarInterval</key>
#     <dict>
#       <key>Hour</key>
#       <integer>3</integer>
#       <key>Minute</key>
#       <integer>0</integer>
#     </dict>
#     <key>HardResourceLimits</key>
#     <dict>
#       <key>NumberOfFiles</key>
#       <integer>122880</integer>
#     </dict>
#     <key>SoftResourceLimits</key>
#     <dict>
#       <key>NumberOfFiles</key>
#       <integer>122880</integer>
#     </dict>
#     <key>EnvironmentVariables</key>
#     <dict>
#       <key>HOME</key>
#       <string>/Users/YOUR_USERNAME</string>
#       <key>TERM</key>
#       <string>xterm-256color</string>
#       <key>PATH</key>
#       <string>/usr/local/bin:/opt/homebrew/bin:/Users/YOUR_USERNAME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
#     </dict>
#     <key>StandardOutPath</key>
#     <string>/absolute/path/to/project/logs/oc-rpi-update.log</string>
#     <key>StandardErrorPath</key>
#     <string>/absolute/path/to/project/logs/oc-rpi-update.error.log</string>
#   </dict>
#   </plist>
#
#   Install: launchctl load ~/Library/LaunchAgents/com.<project>.agent.oc-rpi-update.plist
#   Test:    launchctl start com.<project>.agent.oc-rpi-update
#   Remove:  launchctl unload ~/Library/LaunchAgents/com.<project>.agent.oc-rpi-update.plist
#
# ── Linux cron ──
#
#   # Run nightly at 3:00 AM:
#   0 3 * * * /absolute/path/to/project/scripts/agents/oc-rpi-update.sh \
#     >> /absolute/path/to/project/logs/oc-rpi-update.log 2>&1
#

set -euo pipefail

# ── Configuration ──
# Change these for your project:
OC_RPI_PATH="<path-to-your-oc-rpi-clone>"
OPENCODE_BIN="${OPENCODE_BIN:-$HOME/.local/bin/opencode}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

AGENT_NAME="oc-rpi-update"
REPORT_FILE="docs/agents/${AGENT_NAME}-report.md"
UPDATE_INSTRUCTIONS="$OC_RPI_PATH/oc-rpi/templates/commands/update.md"

# ── Preflight checks ──

if [ ! -d "$OC_RPI_PATH" ]; then
  echo "[$(date)] ERROR: oc-rpi not found at $OC_RPI_PATH"
  exit 1
fi

if [ ! -f "$UPDATE_INSTRUCTIONS" ]; then
  echo "[$(date)] ERROR: Update command not found at $UPDATE_INSTRUCTIONS"
  exit 1
fi

if [ ! -x "$OPENCODE_BIN" ]; then
  echo "[$(date)] ERROR: opencode binary not found at $OPENCODE_BIN"
  echo "[$(date)] Set OPENCODE_BIN in this script or export it as an env var."
  exit 1
fi

# ── Build the prompt ──
# The agent reads the update instructions from oc-rpi at runtime.
# This means when oc-rpi updates the /update command, this script
# automatically uses the new logic without any changes needed here.

PROMPT="You are the oc-rpi-update scheduled agent for this project.

Your job: sync this project with the latest oc-rpi blueprint.

Read and follow the instructions in: $UPDATE_INSTRUCTIONS

Important context:
- The oc-rpi blueprint is at: $OC_RPI_PATH
- This project is at: $PROJECT_ROOT
- Apply all updates non-interactively. Do not ask for confirmation.
- Commit changes when done.
- Write your final summary as your text output (it becomes the report).

If there are no changes needed, just output: 'oc-rpi sync: already up to date as of <version>.'"

# ── Run with retry ──

MAX_RETRIES=2
RETRY_COUNT=0

cd "$PROJECT_ROOT"
echo "[$(date)] Starting $AGENT_NAME agent..."
echo "[$(date)] Project: $PROJECT_ROOT"
echo "[$(date)] Blueprint: $OC_RPI_PATH"

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  if "$OPENCODE_BIN" run "$PROMPT" \
    > "$REPORT_FILE" 2>&1; then
    echo "[$(date)] $AGENT_NAME complete. Report: $REPORT_FILE"
    exit 0
  fi
  RETRY_COUNT=$((RETRY_COUNT + 1))
  echo "[$(date)] Attempt $RETRY_COUNT failed. Retrying in 10s..."
  sleep 10
done

echo "[$(date)] $AGENT_NAME FAILED after $MAX_RETRIES attempts" | tee -a "$REPORT_FILE"
exit 1
