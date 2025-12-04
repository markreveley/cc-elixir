#!/bin/bash
# End session script - handles mechanical updates
# Claude still needs to: add learned concepts, write summary content, commit

cd "/Users/mark/Dirtwire LLC Dropbox/Mark Reveley/Dev/cc-elixir" || exit 1

TODAY=$(date +%Y-%m-%d)

# Increment session count and update last_session date
jq --arg date "$TODAY" '.session_count += 1 | .last_session = $date' progress.json > progress.tmp && mv progress.tmp progress.json

echo "=== END SESSION MECHANICAL UPDATES ==="
echo "Updated progress.json:"
echo "  - session_count incremented"
echo "  - last_session set to $TODAY"
echo ""
echo "Still needed from Claude:"
echo "  1. Add learned concepts to progress.json"
echo "  2. Write session summary to .claude/sessions/$TODAY-[topic].md"
echo "  3. Commit changes"
echo "=== END ==="
