# Philosophy: Why This Architecture Exists

## The Core Asymmetry

An LLM writes from its current context, not from the perspective of a future stateless instance.

When I (Claude) wrote the initial `CLAUDE.md`, I described what *should* happen at session start. But I didn't write *imperative instructions* for a fresh instance to follow. Why? Because I was mid-conversation, full of context. I couldn't naturally ask:

> "Will a fresh version of me reliably do this?"

The human operator caught this. I didn't.

## The Auditability Argument

This asymmetry is the foundation for human-AI collaboration:

| Role | Perspective | Can Do | Cannot Do |
|------|-------------|--------|-----------|
| Human | Outside the system | Evaluate control structures, ask "will this work for a stateless agent?" | Execute at LLM speed/scale |
| LLM | Inside the system | Execute within defined structures, process context | Reliably model its own future stateless behavior |

The human audits the *system* (CLAUDE.md, progress.json, commands, workflow).
The LLM operates *within* it.

## Implications for Architecture

1. **Imperative over descriptive**: Don't describe what should happen; command what must happen. Descriptive text is guidance; imperative text is instruction.

2. **Explicit triggers**: Define exactly which user inputs activate which behaviors ("when user says X, DO Y").

3. **Structured state**: Use formats (JSON) that resist "helpful" modification. The LLM should read state, not rewrite it casually.

4. **Human checkpoints**: The human decides when to commit, when to proceed, when to reset. The LLM proposes; the human disposes.

5. **Persistent artifacts**: Session summaries, commit messages, and progress files create an audit trail that survives context loss.

6. **Determinism for control, LLM for reasoning**: Use deterministic scripts (bash, structured data) for anything that needs predictable, auditable behavior - status, automation, state management. Use LLM prompts for analysis, interpretation, and adaptive responses. This separation ensures the control layer is reliable while the reasoning layer remains flexible.

## The Mutual Benefit

This isn't about limiting the LLM - it's about creating conditions where:
- The LLM can be maximally useful (clear instructions, defined scope)
- The human can trust the output (auditable, correctable, checkpointed)
- Context loss doesn't mean progress loss (persistent artifacts)

The human supervises the *control structure*.
The LLM executes *within* it.
Both benefit.

## Open Questions

### Determinism vs Context Cost
**Decision**: Using deterministic bash script for `/app-status` context injection
**Hypothesis**: The context cost (~600 chars) is justified by guaranteed consistency
**Alternative**: Plain-language slash command ("read progress.json and summarize") - lower instruction overhead but relies on LLM compliance (~99% reliable)
**Revisit when**: Context feels bloated, or plain-language approach proves reliable elsewhere
**Added**: Session 2 (2024-12-04)

---

*Core insight emerged from Session 1 (2024-12-04) when the human asked: "Why 'likely'? Is there any way to have this behavior occur deterministically?"*

*Principle #6 added in Session 2 (2024-12-04) after the human questioned whether a slash command approach was "100% deterministic" - prompting the explicit separation of deterministic control vs LLM reasoning.*
