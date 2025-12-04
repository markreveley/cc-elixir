End the current learning session. Execute these steps in order:

1. Summarize what was learned this session:
   - Elixir concepts covered
   - CC patterns demonstrated
   - Git skills practiced

2. Update `progress.json`:
   - Add learned concepts to appropriate arrays
   - Increment session_count
   - Set last_session to today's date
   - Update current_spike and next_suggested

3. Create session summary at `.claude/sessions/YYYY-MM-DD-topic.md` containing:
   - What was accomplished
   - Key insights
   - Questions or gaps remaining
   - What comes next

4. Stage and commit all changes with descriptive message

5. Report: "Session complete. Next: [next_suggested]"
