---
description: Create an in-depth spike summary capturing mental model evolution
---

Reread the entire conversation for this spike. Create a comprehensive summary document at `.claude/sessions/YYYY-MM-DD-spike-NN-topic.md` that includes:

## Required Sections

### 1. Mental Model Evolution
- Trace how the user's understanding evolved through the conversation
- Identify the starting assumptions (often incorrect or incomplete)
- Show the progression of questions that revealed deeper understanding
- Quote the user's own words where they reveal their mental model

### 2. Incorrect Models / Misconceptions
- Explicitly document what the user initially believed that was wrong
- Explain WHY it seemed reasonable (often from other language experience)
- This helps future review by highlighting what NOT to think

### 3. The Correct Model
- Detailed explanation of how things actually work
- Use diagrams (ASCII), tables, and code examples
- Go deep - this is NOT a summary for context conservation
- Include the level of detail from the back-and-forth discussion

### 4. Key Concepts Explained In Depth
- Each major concept gets its own section
- Include: what it does, what it does NOT do, when you'll use it
- Code examples showing correct usage
- Common patterns from real codebases

### 5. Syntax/Code Covered
- Quick reference of actual Elixir syntax learned
- Runnable examples

### 6. Key Takeaways
- Numbered list of the most important insights
- Phrased as memorable principles

### 7. CC Patterns (if any)
- Any Claude Code context management techniques discussed

### 8. Next Spike Preview
- What's coming next and how it connects

## Guidelines

- **Do NOT conserve space** - the goal is full recollection in a fresh context
- **Quote the user's questions** - they reveal the learning journey
- **Explain the "why"** - not just what, but why it works this way
- **Include failed mental models** - knowing what's wrong is as valuable as knowing what's right

After writing the summary, report: "Deep summary written to [filepath]"
