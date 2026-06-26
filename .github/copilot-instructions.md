# STC Brainstorming Workspace — Copilot Instructions

This workspace is exclusively dedicated to the **System-Topology Compiler (STC)** concept.
All chat sessions in this workspace are STC brainstorming or STC infrastructure sessions.

---

## Mandatory session start

At the beginning of **every** chat session, before responding to the user, read these four files:

1. `ai/INSTRUCTIONS.md` — full session protocol, Topic Registry, end-of-session rules
2. `ai/context_map.md` — compressed STC concept map (~150 lines)
3. `ai/log_summary.md` — cross-session decisions and open threads
4. `ai/roadmap.md` — section priority list with known gaps

Then follow the **Session Start Protocol** defined in `ai/INSTRUCTIONS.md`.

Do **not** ask the user to re-explain STC — the concept is in `context_map.md`.  
Do **not** load `docs/STC Co-Pilot & Systems Architect Reference Manual/v2026.1.0.md` — it is 2000+ lines. Use the individual section files in `sections/` instead.

---

## What kind of session this might be

- **Brainstorming a section** — consult roadmap, load Tier 2/3 files via Topic Registry in `INSTRUCTIONS.md`
- **Infrastructure/meta work** — editing AI files, scripts, or documentation structure; follow user instructions directly
- **Session wrap-up** — follow the Session End Protocol in `INSTRUCTIONS.md`; apply file updates and commit

---

## After a productive exchange

Apply the Session End Protocol from `ai/INSTRUCTIONS.md` proactively — do not wait to be asked.
