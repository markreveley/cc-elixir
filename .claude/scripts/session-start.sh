#!/bin/bash
# Session start hook - injects context into Claude silently
# User runs /app-status for visible output

cd "/Users/mark/Dirtwire LLC Dropbox/Mark Reveley/Dev/cc-elixir" || exit 1

echo "=== SESSION CONTEXT (injected) ==="
echo ""
echo "Progress State:"
cat progress.json
echo ""
echo "Git Branch: $(git branch --show-current)"
echo "Git Status: $(git status --short | wc -l | tr -d ' ') uncommitted files"
echo ""
echo "Recent Commits:"
git log --oneline -3
echo ""
echo "Next Suggested: $(jq -r '.next_suggested' progress.json)"
echo "=== END SESSION CONTEXT ==="
