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

## Basic Block — Prompts, Skills, Agents (20 min)

Three tasks. Each builds on the previous one. The goal: add a **prompt template** and a **skill** to the default agent, then create a **new agent** that uses both.

### Task 1: Add a Prompt Template

Prompt templates are reusable instructions you ask the agent to follow on demand. They're simple markdown files.

**Step 1:** Look at the existing `meeting-summary.prompt.md` file that came with the bootstrap — open it in VS Code to see the structure. It's a header section followed by "The prompt content — what the agent should do when this is invoked."

**Step 2:** Create a new file. Inside the workshop repo, navigate to `.github/prompts/` and create `action-items.prompt.md`.

**Step 3:** Copy the header structure from `meeting-summary.prompt.md`. Change the name to "Action Items" and the description to "Extract action items from meeting notes." Below the header, write: "Read the meeting notes below. Extract ONLY action items. For each, include who it's assigned to and the deadline if mentioned. Output as a bullet list."

**Step 4:** Test — in Copilot Chat, select the Meeting Assistant agent. Type: "Use the action-items prompt on this meeting: The team discussed Q3 roadmap. Decided to prioritize auth module. Action: Fabian to draft spec by Friday. Action: Lisa to review by Monday."

### Task 2: Add a Skill

Skills change how an agent behaves by default — the agent follows the skill's instructions automatically, without you asking. Unlike a prompt template (which you invoke on demand), a skill is always active.

**Step 1:** Look at an existing skill to see the structure. Open `.apm/skills/align/SKILL.md` from the workshop repo. Notice it has a header section (name, description) followed by instructions.

**Step 2:** Inside `.apm/skills/`, create a new folder called `tone`. Inside it, create a file called `SKILL.md`.

**Step 3:** Copy the header structure from `align/SKILL.md`. Change the name to "tone" and write a short description. Below the header, write one line: "Always respond in a formal, professional tone."

**Step 4:** In Copilot Chat, open the Meeting Assistant agent. In its settings, add `tone` to the list of skills the agent uses. (If you're unsure how, look at the skills the agent already has — add yours the same way.)

**Step 5:** Test — ask the Meeting Assistant to summarise a meeting. The output should sound formal and professional. Try changing the instruction to "Respond like a pirate" and test again.

### Task 3: Create a New Agent

**Step 1:** Look at the existing `meeting-assistant.agent.md` in the workshop repo — open it and read the structure. The top section defines the agent's name, description, and model. The bottom section is the system prompt — what the agent always knows.

**Step 2:** In `.github/agents/`, create a new file called `my-agent.agent.md`.

**Step 3:** Copy the structure from `meeting-assistant.agent.md`. Change the name, description, and system prompt to describe your new agent. Keep the model as `openrouter/deepseek/deepseek-v4-pro`.

**Step 4:** In the agent's settings, add your skill from Task 2 (`tone`) and your prompt from Task 1 (`action-items`).

**Step 5:** Select your new agent in Copilot Chat. Give it a test meeting to summarise — it should use your skill (formal tone) and your prompt (action items). All three components — **agent + skill + prompt** — now work together.

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

Every file you worked with today follows the same pattern: a header block (between `---` lines) followed by the actual content.

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

#### Structure explained

- **`name`**: How this file appears in Copilot Chat's menus
- **`description`**: Shown when you hover over it or browse the list
- **`model`** (agents only): Which LLM to use. `openrouter/deepseek/deepseek-v4-pro` points to DeepSeek V4 Pro via your OpenRouter key
- Everything below the second `---`: the actual content — what the agent reads and follows

---

## Troubleshooting

**"apm: command not found"** — Run `export PATH="$HOME/.local/bin:$PATH"` and try again.

**"No agents found"** — Make sure `apm install -g` completed without errors. Check `apm list`.

**Agent doesn't use my skill** — Check that the skill is listed in the agent's settings in Copilot Chat. Check the skill file exists in `.apm/skills/`.

**OpenRouter key not working** — Verify the key in `.env`. Check it has credits remaining.
