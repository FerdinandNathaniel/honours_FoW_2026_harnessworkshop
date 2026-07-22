# AI Harnesses & Standardized Agent Frameworks — FoW 2026

## Quick Start (5 min)

```bash
# 1. Clone the workshop repo
git clone https://github.com/FerdinandNathaniel/honours_FoW_2026_harnessworkshop.git
cd honours_FoW_2026_harnessworkshop

# 2. Run bootstrap — installs APM and all workshop skills/agents/prompts
./scripts/bootstrap-clean-vm.sh

# 3. Copy your OpenRouter key
cp .env.example .env
# Edit .env and paste your key from the workshop chat

# 4. Verify
# Open VS Code, open Copilot Chat, select "Meeting Assistant" agent
# Type: "summarise: The team discussed the Q3 roadmap. Decided to prioritize auth module. Action: Fabian to draft spec by Friday."
```

If you get stuck, skip to the [Reference](#reference) section — pre-built examples are there.

---

## Workshop Structure (100 min)

| Time | Block |
|---|---|
| 0:00–0:05 | Evolution arc |
| 0:05–0:10 | What is a harness? |
| 0:10–0:20 | Two harnesses side by side |
| 0:20–0:30 | **Bootstrap sprint** — get everyone installed |
| 0:30–0:50 | **Basics** — add skill, add prompt, create agent |
| 0:50–1:05 | **Advanced** — pipeline: align → spec → tasks → execute |
| 1:05–1:15 | Human-in-the-loop & process flows |
| 1:15–1:25 | Wrap — where is this going? |
| 1:25–1:30 | Handout deep-dive doc |

---

## Basic Block — Skills, Prompts, Agents (20 min)

Three tasks. Each builds on the previous one. The goal: add a **skill** and a **prompt template** to the default agent, then create a **new agent** that wires everything together.

### Task 1: Add a Skill

Skills are instructions that change how an agent behaves. They're markdown files with YAML frontmatter, placed in `.apm/skills/`.

**Step 1:** Create a new file `tone.prompt.md` in the Copilot prompts directory (find it via the Copilot Chat interface or the APM docs).

**Step 2:** Write a prompt that sets the agent's tone — e.g. "Always respond in a professional, formal tone" or "Respond like a pirate."

**Step 3:** Wire it to the Meeting Assistant agent (agent settings in Copilot Chat).

**Step 4:** Test — run the meeting summarisation again. Tone should change.

### Task 2: Add a Prompt Template

Prompt templates are reusable prompts agents can invoke on demand. They're markdown files with YAML frontmatter, placed in `.apm/prompts/`.

**Step 1:** Create a new prompt file `action-items.prompt.md`.

**Step 2:** Write a prompt that extracts ONLY action items from meeting notes, with due dates and owners.

**Step 3:** Wire it to the Meeting Assistant agent.

**Step 4:** Test — ask the agent to use the action-items prompt on some sample notes.

### Task 3: Create a New Agent

**Step 1:** Create a new agent file `my-agent.agent.md` in `.apm/agents/`.

**Step 2:** Set the frontmatter — name, description, model (`openrouter/deepseek/deepseek-v4-pro`), tools.

**Step 3:** Write a short system prompt describing what the agent does.

**Step 4:** Wire in your skill from Task 1 and your prompt from Task 2.

**Step 5:** Run the new agent on a test meeting — all three components (agent + skill + prompt) should work together.

---

## Advanced Block — Align → Spec → Decompose → Execute (15 min)

The same task — meeting note summarisation — but run through a structured pipeline. Compare the output against what you built in the basics block.

Four skills are pre-installed: `align`, `spec`, `tasks`, `execute`. Each builds on the previous.

### Step 1: Align

Activate the **align** skill on the same meeting task. It will ask you clarifying questions before producing anything.

```
You: "Build a meeting note summariser"
Agent (with align skill): "What format — bullet points, paragraphs, or a table with decisions and action items?"
You: "Table."
Agent: "Who is the audience?"
You: "My team."
Agent: "What length?"
You: "One screen."
Agent: "What would make this output unusable?"
You: "If it misses action items."
Agent: [Now produces the summary]
```

### Step 2: Spec

Feed the alignment session output into the **spec** skill. It produces a structured PRD:

- **Goal**: A one-screen meeting summary table with decisions and action items
- **Constraints**: One screen, table format, team audience
- **Success Criteria**: Must capture all action items, no missed owners
- **Edge Cases**: Empty input → "no content to summarise"; too long → truncate with warning
- **Stakeholders**: Team members

### Step 3: Tasks

Feed the spec into the **tasks** skill. It decomposes the PRD into an ordered task list:

```
1. Create the output structure with Summary, Decisions, Action Items sections
2. Write logic to extract decisions from meeting text (lines with "Decided:" or "Decision:")
3. Write logic to extract action items (lines with "Action:" or "TODO:")
4. Format as a table with columns: Item, Owner, Status
5. Add edge case handling for empty input
6. Test with sample meeting notes
```

### Step 4: Execute

Feed the task list into the **execute** skill. It runs each task sequentially and produces the final deliverable — a working meeting summariser.

### Compare

Put the basics-block output next to the advanced-block output. What changed?

- The spec forced you to think about edge cases you'd skip otherwise
- The task decomposition caught steps you'd forget
- The alignment questions surfaced hidden assumptions about audience and format
- **This is the core insight: prompts work for one-offs. Pipelines work for systems.**

---

## Reference

### Pre-built Meeting Assistant (basic block)

The default agent installed by bootstrap. Check `.github/agents/meeting-assistant.agent.md` in the workshop repo.

### Pre-built Pipeline (advanced block)

All four pipeline skills are installed:
- `.agents/skills/align/SKILL.md` — clarifying questions before building
- `.agents/skills/spec/SKILL.md` — structured PRD from alignment
- `.agents/skills/tasks/SKILL.md` — decompose spec into ordered tasks
- `.agents/skills/execute/SKILL.md` — execute tasks sequentially

### Templates

#### Skill

```yaml
---
name: my-skill
description: 'What this skill does, in one sentence'
argument-hint: 'What the user should provide'
---
# My Skill

Instructions for the agent when this skill is active.
```

#### Agent

```yaml
---
name: My Agent
description: 'What this agent does'
tools: [read, search]
model: 'openrouter/deepseek/deepseek-v4-pro'
user-invocable: true
---
System prompt — the agent's default behaviour.
```

#### Prompt

```yaml
---
name: My Prompt
description: 'What this prompt does'
argument-hint: 'What to provide'
agent: ask
---
The prompt content — what the agent should do when this is invoked.
```

---

## Troubleshooting

**"apm: command not found"** — Run `export PATH="$HOME/.local/bin:$PATH"` and try again.

**"No agents found"** — Make sure `apm install -g` completed without errors. Check `apm list`.

**Agent doesn't use my skill** — Verify the skill is wired in the agent settings. Check the skill file is in `.apm/skills/`.

**OpenRouter key not working** — Verify the key in `.env`. Check it has credits remaining.
