Start a new learning session. Execute these steps in order:

1. Read `progress.json` and report:
   - current_spike (what's in progress, if any)
   - next_suggested (what comes next)
   - session_count (how many sessions so far)
   - last_session date

2. Run `git log --oneline -5` and report recent commits

3. Run `git status` to check for uncommitted work

4. Summarize the current state in 2-3 sentences

5. Ask: "Ready to continue with [next_suggested]?" and wait for confirmation

Do not proceed to any work until the user confirms.
