#!/bin/bash
# App status - visible observability for the user

cd "/Users/mark/Dirtwire LLC Dropbox/Mark Reveley/Dev/cc-elixir" || exit 1

# Read progress.json values
CURRENT_SPIKE=$(jq -r '.current_spike // "none"' progress.json)
NEXT_SUGGESTED=$(jq -r '.next_suggested' progress.json)
SESSION_COUNT=$(jq -r '.session_count' progress.json)
LAST_SESSION=$(jq -r '.last_session // "never"' progress.json)

# Count learned items
ELIXIR_COUNT=$(jq '.learning.elixir_concepts | length' progress.json)
CC_COUNT=$(jq '.learning.cc_patterns | length' progress.json)
GIT_COUNT=$(jq '.learning.git_skills | length' progress.json)

# Count spikes
TOTAL_SPIKES=$(jq '.tracks.elixir | length' .claude/learning-path.json)
COMPLETED_SPIKES=$(jq '.completed_spikes | length' progress.json)

# Git info
BRANCH=$(git branch --show-current)
UNCOMMITTED=$(git status --short | wc -l | tr -d ' ')
RECENT_COMMITS=$(git log --oneline -3)

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                     CC-ELIXIR STATUS                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "── Learning Progress ──"
echo "  Spikes:      $COMPLETED_SPIKES / $TOTAL_SPIKES complete"
echo "  Elixir:      $ELIXIR_COUNT concepts"
echo "  CC Patterns: $CC_COUNT learned"
echo "  Git Skills:  $GIT_COUNT practiced"
echo ""
echo "── Current State ──"
echo "  Spike:       $CURRENT_SPIKE"
echo "  Branch:      $BRANCH"
echo "  Uncommitted: $UNCOMMITTED files"
echo "  Sessions:    $SESSION_COUNT (last: $LAST_SESSION)"
echo ""
echo "── Recent Commits ──"
echo "$RECENT_COMMITS" | sed 's/^/  /'
echo ""
echo "── Next ──"
echo "  Suggested:   $NEXT_SUGGESTED"
echo ""
echo "════════════════════════════════════════════════════════════════"
