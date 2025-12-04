!bash .claude/scripts/end-session.sh

The script above has incremented session_count and set last_session. Now complete these steps:

1. Summarize what was learned this session:
   - Elixir concepts covered
   - CC patterns demonstrated
   - Git skills practiced

2. Update `progress.json`:
   - Add learned concepts to the appropriate arrays in `learning`
   - Update current_spike and next_suggested if needed

3. Create session summary at `.claude/sessions/YYYY-MM-DD-topic.md` containing:
   - What was accomplished
   - Key insights
   - Questions or gaps remaining
   - What comes next

4. Stage and commit all changes with descriptive message

5. Push to remote

6. Report: "Session complete. Next: [next_suggested]"
