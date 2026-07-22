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
# Open VS Code, open Copilot Chat, select "Brain Dump Assistant" agent
# Type a stream of thoughts — anything on your mind.
# (It won't do much yet — that's what you'll build in the tasks below.)
```

If you get stuck, skip to the [Reference](#reference) section — filled-in examples are there.

---

## Anatomy of an Agent File

Every agent, prompt, and skill file follows the same structure: a **header block** between `---` lines, followed by the actual content.

### The header block (between the `---` lines)

| Field | What it does | Applies to |
|---|---|---|
| `name` | Display name shown in Copilot Chat's menus and agent picker | Agent, Prompt, Skill |
| `description` | Shown when you hover or browse. Keep it one sentence. | Agent, Prompt, Skill |
| `model` | Which LLM to use. `openrouter/deepseek/deepseek-v4-pro` = DeepSeek V4 Pro via your OpenRouter key. Other values: `GPT-5 (copilot)`, `claude-sonnet-4-20250514 (copilot)`, etc. Check the Copilot Chat model picker for available options. | Agent only |
| `tools` | What the agent can do. Common values: `[read, search]` for read-only, add `bash` for running commands, add `web` for browsing. See full list in Copilot Chat's agent settings. | Agent only |
| `argument-hint` | Hint shown to the user about what to provide when invoking this agent or prompt | Agent, Prompt, Skill |
| `user-invocable` | `true` = user can manually select this agent from the picker. `false` = only callable by other agents. | Agent only |
| `disable-model-invocation` | `true` = the model cannot auto-invoke this. `false` = the model can decide to use it on its own. | Agent, Skill |
| `agent` | For prompts: `ask` = the prompt runs when the user types `/prompt-name`. Other values depend on the harness. | Prompt only |

### The content (below the second `---`)

For **agents**: the system prompt — the agent's default behaviour and instructions.

For **prompts**: the actual prompt text — what the agent should do when this prompt is invoked.

For **skills**: the skill instructions — rules the agent follows automatically whenever the skill is active.

### Where to find the full docs

APM documentation: https://microsoft.github.io/apm/

Copilot Chat agent/prompt/skill docs: look in the Copilot Chat extension settings in VS Code, or search "GitHub Copilot agent configuration" on docs.github.com.

### Example: a filled-in agent

Open `meeting-assistant.agent.md` in the workshop repo. It's a complete, working example. Compare it against the table above to see how each field is used.

---

## Basic Block — Prompts, Skills, Agents (20 min)

Three tasks. Each builds on the previous one. The goal: fill in two **template files**, then create a **new agent** that combines everything.

The templates you'll work with: take messy, unfiltered thoughts and turn them into organised themes and priorities.

**Pro tip throughout the tasks:** look at the meeting-assistant files when you're stuck. `meeting-assistant.agent.md` is a filled-in agent. `meeting-summary.prompt.md` is a filled-in prompt. Compare yours against them.

### Task 1: Fill in a Prompt Template

The file `brain-dump.prompt.md` is a template — the header has `[fill in...]` placeholders and the content is empty. Your job: fill it in.

**Step 1:** Open `brain-dump.prompt.md` in VS Code. Read the placeholder text so you know what needs filling.

**Step 2:** Open `meeting-summary.prompt.md` — this is a finished example. Compare the two. Notice how the finished one has a real description, a real argument-hint, and the content section tells the agent exactly what to output and in what format.

**Step 3:** Fill in the `description` field. One sentence — what does this prompt do?

**Step 4:** Fill in the `argument-hint` field. What should the user paste in?

**Step 5:** Below the second `---`, write the actual prompt. Tell the agent: what to do with the brain dump, what sections the output should have, what format. Look at `meeting-summary.prompt.md` for the pattern.

**Step 6:** Test — in Copilot Chat, select "Brain Dump Assistant", then invoke your prompt. Type a stream of thoughts and see if the output is structured the way you intended.

### Task 2: Fill in an Agent

The file `brain-dump.agent.md` is a template. Fill it in.

**Step 1:** Open `brain-dump.agent.md`. Read the placeholders.

**Step 2:** Open `meeting-assistant.agent.md` — the finished example. Compare.

**Step 3:** Fill in the `description` and `argument-hint` fields.

**Step 4:** Below the second `---`, write the system prompt. Describe in clear steps what the agent does with a brain dump. Look at the meeting-assistant's system prompt — it lists steps 1-3, very direct.

**Step 5:** Test — in Copilot Chat, select your Brain Dump Assistant, give it a brain dump, and see if it works.

### Task 3: Add a Skill

Skills change how an agent behaves by default — the agent follows the skill's instructions automatically. Unlike a prompt (which you invoke on demand), a skill is always active.

**Step 1:** Look at an existing skill. Open `.apm/skills/align/SKILL.md`. Notice the header (name, description) followed by the skill's rules.

**Step 2:** Inside `.apm/skills/`, create a new folder called `tone`. Inside it, create a file called `SKILL.md`.

**Step 3:** Copy the header structure from `align/SKILL.md`. Change the name to "tone", write a short description. Below the header, write one line: "Always respond in a formal, professional tone."

**Step 4:** In Copilot Chat, open the Brain Dump Assistant agent's settings. Add `tone` to the list of skills the agent uses. (Look at how the existing agent has skills listed — add yours the same way.)

**Step 5:** Test — give the Brain Dump Assistant a brain dump. Output should be formal. Try changing "professional tone" to "Respond like a pirate" and test again.

### Task 4: Create a New Agent From Scratch

**Step 1:** In `.github/agents/`, create a new file called `my-agent.agent.md`.

**Step 2:** Copy the full structure from `brain-dump.agent.md` (which you filled in during Task 2). Change the name to something new, write a fresh description and system prompt. Keep the model as `openrouter/deepseek/deepseek-v4-pro`.

**Step 3:** In the agent's settings, add your skill from Task 3 (`tone`) and wire in your prompt from Task 1 (`brain-dump`).

**Step 4:** Test — select your new agent, give it a brain dump. It should use your skill (tone) and your prompt (structured output). All three components — **agent + skill + prompt** — now work together.

---

## Advanced Block — Align → Spec → Decompose → Execute (15 min)

The same task — **structuring a brain dump** — but run through a structured pipeline. Compare the output against what you built in the basics block.

Four skills are pre-installed: `align`, `spec`, `tasks`, `execute`. Each builds on the previous.

### Step 1: Align

Activate the **align** skill on the brain-dump task. It will ask you clarifying questions before producing anything.

```
You: "Build a tool that structures brain dumps"
Agent (with align skill): "What kind of brain dumps — work tasks, creative ideas, personal journaling, or all of the above?"
You: "Work tasks mostly."
Agent: "What output format — grouped by project, by urgency, or by type of task?"
You: "By project, then by urgency within each project."
Agent: "How long are the brain dumps typically — a few sentences or multiple paragraphs?"
You: "Usually a paragraph or two."
Agent: "What would make this output unusable?"
You: "If it mis-categorises tasks into the wrong project."
Agent: [Now produces the structured output]
```

### Step 2: Spec

Feed the alignment session output into the **spec** skill. It produces a structured PRD:

- **Goal**: A brain-dump structurer that groups work tasks by project, then by urgency
- **Constraints**: Input is 1-2 paragraphs, output is grouped by project, no external data sources
- **Success Criteria**: Tasks correctly assigned to projects, urgency ordering is sensible, no tasks dropped
- **Edge Cases**: Empty input → "nothing to structure"; single task → still group it; ambiguous project names → ask for clarification
- **Stakeholders**: Individual knowledge worker using it for personal task management

### Step 3: Tasks

Feed the spec into the **tasks** skill. It decomposes the PRD into an ordered task list:

```
1. Create the output structure: projects as top-level groups, tasks nested under each
2. Write logic to identify project names from the brain dump
3. Write logic to assign each task to the most likely project
4. Write logic to rank tasks within each project by urgency (keywords: "urgent", "deadline", "ASAP")
5. Handle edge cases: empty input, single task, ambiguous project names
6. Format output as markdown with project headers and numbered task lists
7. Test with a sample brain dump containing tasks across multiple projects
```

### Step 4: Execute

Feed the task list into the **execute** skill. It runs each task sequentially and produces the final deliverable — a working brain-dump structurer.

### Compare

Put the basics-block output next to the advanced-block output. What changed?

- The spec forced you to think about edge cases you'd skip otherwise
- The task decomposition caught steps you'd forget (like handling ambiguous project names)
- The alignment questions surfaced hidden assumptions about grouping and urgency
- **This is the core insight: prompts work for one-offs. Pipelines work for systems.**

---

## Reference

### Filled-in examples (look at these when stuck)

- **Agent:** `.github/agents/meeting-assistant.agent.md` — complete working agent for meeting summarisation
- **Prompt:** `.github/prompts/meeting-summary.prompt.md` — complete working prompt template
- **Skills:** `.apm/skills/align/SKILL.md` — a complete skill with instructions

### Templates (fill these in during the workshop)

- `.github/agents/brain-dump.agent.md` — agent template for structuring brain dumps
- `.github/prompts/brain-dump.prompt.md` — prompt template for structuring brain dumps

### Pre-built Pipeline (advanced block)

All four pipeline skills are installed:
- `.agents/skills/align/SKILL.md` — clarifying questions before building
- `.agents/skills/spec/SKILL.md` — structured PRD from alignment
- `.agents/skills/tasks/SKILL.md` — decompose spec into ordered tasks
- `.agents/skills/execute/SKILL.md` — execute tasks sequentially

---

## Troubleshooting

**"apm: command not found"** — Run `export PATH="$HOME/.local/bin:$PATH"` and try again.

**"No agents found"** — Make sure `apm install -g` completed without errors. Check `apm list`.

**Agent doesn't use my skill** — Check that the skill is listed in the agent's settings in Copilot Chat. Check the skill file exists in `.apm/skills/`.

**OpenRouter key not working** — Verify the key in `.env`. Check it has credits remaining.