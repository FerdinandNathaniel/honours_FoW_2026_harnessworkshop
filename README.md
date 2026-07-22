# AI Harnesses and Standardized Agent Frameworks

In this workshop you will build a small system that turns a brain dump into structured thoughts. You will use three reusable AI primitives:

- A **prompt**: a workflow you invoke explicitly.
- A **skill**: a capability the harness can discover when relevant.
- An **agent**: a named role with its own behavior and boundaries.

You will first build these directly. Then you will improve the same package through an **Align -> Spec -> Tasks -> Execute** workflow with human review between every stage.

## 1. Setup

### Prerequisites

- VS Code with GitHub Copilot Chat installed
- Git
- The OpenRouter key provided during the workshop

### Clone and bootstrap

```bash
git clone https://github.com/FerdinandNathaniel/honours_FoW_2026_harnessworkshop.git
cd honours_FoW_2026_harnessworkshop
export PATH="$HOME/.local/bin:$PATH"
./scripts/bootstrap-clean-vm.sh
```

The script installs APM 0.26.0 and deploys the workshop package to the Copilot file structure in this workspace.

### Add your OpenRouter key to VS Code

Do not put the key in this repository. VS Code can store it in its Secret Storage and reference it from your user-level `chatLanguageModels.json`.

1. Open the Command Palette: `Cmd+Shift+P` on macOS or `Ctrl+Shift+P` on Windows/Linux.
2. Run **Chat: Manage Language Models**.
3. Select **Add Models**, then **OpenRouter**.
4. Paste the OpenRouter key supplied during the workshop.
5. If VS Code opens `chatLanguageModels.json`, save it. VS Code creates an entry similar to:

```json
[
  {
    "name": "OpenRouter",
    "vendor": "openrouter",
    "apiKey": "${input:chat.lm.secret.<generated-id>}"
  }
]
```

The generated secret reference is different on every machine. Do not replace it with another student's value and do not commit this user-level file.

6. Return to **Manage Language Models** and filter for `@provider:"OpenRouter"`.
7. Make **DeepSeek V4 Pro** visible in the model picker.
8. In Copilot Chat, select DeepSeek V4 Pro from the model picker.

If OpenRouter is not offered, update VS Code and GitHub Copilot Chat. On managed Copilot Business or Enterprise accounts, the administrator must allow **Bring Your Own Language Model Key in VS Code**.

Official VS Code documentation: https://code.visualstudio.com/docs/copilot/customization/language-models#_bring-your-own-language-model-key

### Verify the setup

Use the completed meeting example before editing anything:

1. Open Copilot Chat.
2. Select **Meeting Assistant** from the agent picker.
3. Invoke `/meeting-summary` with:

```text
The team selected Friday for the demo. Fabian will prepare the slides by Thursday. Lisa will test the setup on Wednesday. The budget question is unresolved.
```

You should receive a summary with decisions, action items, and follow-up points. If the agent or prompt does not appear, reload the VS Code window.

## 2. The APM Authoring Loop

The `.apm/` directory is the source of truth. Do not edit generated files under `.github/` or `.agents/`.

```text
Edit .apm/
    |
    v
apm install --target copilot
    |
    +--> .github/prompts/   prompts for Copilot
    +--> .github/agents/    custom agents for Copilot
    +--> .agents/skills/    portable Agent Skills
    |
    v
Test in Copilot Chat
```

For prompts, skills, and agents, APM's deployment command is `apm install`. `apm compile` is a separate command used to aggregate **instruction** primitives into files such as `AGENTS.md`; it does not deploy the primitives used in this exercise.

You will repeat this loop after every change:

```bash
apm install --target copilot
```

## 3. Basic Block: Prompt -> Skill -> Agent

Use this brain dump throughout the basic block:

```text
I need to prepare the workshop but I also promised to review Sam's proposal. The workshop slides still need examples. I have an idea for a voice interface that I do not want to forget. The student keys need testing today. Sam can probably wait until tomorrow, but I should message them. I also need to decide whether the final exercise should produce code or a document.
```

### Task 1: Complete a prompt

Open these two files side by side:

- Template: `.apm/prompts/brain-dump.prompt.md`
- Completed example: `.apm/prompts/meeting-summary.prompt.md`

Complete the brain-dump prompt:

1. Replace the placeholder `description` with one sentence explaining its purpose.
2. Replace `argument-hint` with a short hint about what the user should provide.
3. Replace the body with precise instructions. Define the output sections and state what the model should not invent.
4. Deploy it:

```bash
apm install --target copilot
```

5. Inspect the generated `.github/prompts/brain-dump.prompt.md`.
6. In Copilot Chat, type `/brain-dump`, add the sample brain dump, and run it.

Record what worked and one thing you would improve.

### Task 2: Create a skill

A skill is not always loaded. Copilot first reads its `name` and `description`, then loads the full skill when that description matches the task. You can also invoke it explicitly with `/skill-name`.

1. Inspect `.apm/skills/align/SKILL.md` for the folder and file structure.
2. Create `.apm/skills/challenge-assumptions/SKILL.md`.
3. Give it this required structure:

```markdown
---
name: challenge-assumptions
description: FILL IN what this skill does and when Copilot should use it.
---

# Challenge Assumptions

FILL IN a short procedure that:

1. Identifies assumptions or contradictions in a brain dump.
2. Separates stated priorities from priorities inferred by the model.
3. Asks a question instead of silently resolving genuine ambiguity.
```

The `name` must match the parent directory exactly. The `description` is important: it is how Copilot discovers the skill.

4. Deploy it:

```bash
apm install --target copilot
```

5. Confirm `.agents/skills/challenge-assumptions/SKILL.md` exists.
6. First test it explicitly with `/challenge-assumptions` and the sample brain dump.
7. Then ask Copilot naturally to organise the brain dump while challenging unclear assumptions. Check the response references to see whether the skill was loaded automatically.

### Task 3: Complete the agent

Open these two files side by side:

- Template: `.apm/agents/brain-dump.agent.md`
- Completed example: `.apm/agents/meeting-assistant.agent.md`

Complete the Brain Dump Assistant:

1. Replace the placeholder `description` and `argument-hint`.
2. Replace the body with three to five clear steps describing its behavior.
3. Include boundaries: what should it preserve, what may it infer, and when should it ask a question?
4. Do not add a `model` field. The agent will use DeepSeek V4 Pro selected in the VS Code model picker.
5. Deploy it:

```bash
apm install --target copilot
```

6. Inspect the generated `.github/agents/brain-dump.agent.md`.
7. Select **Brain Dump Assistant**, invoke `/brain-dump`, and use the sample brain dump.

This combines the selected agent, the explicitly invoked prompt, and any relevant skill Copilot discovers. There is no skills or prompts list to wire into the agent.

## 4. Advanced Block: Align -> Spec -> Tasks -> Execute

Now improve the package through a controlled process. Start a new Copilot Chat session, select **Agent** mode, select DeepSeek V4 Pro, and enable editing and terminal tools. Do not use the Brain Dump Assistant for this block: the executing agent needs to change files and run APM.

The four pipeline skills are manual: invoke them as slash commands.

### Step 1: Align

Run:

```text
/align Improve the brain-dump prompt, skill, and agent we created. The result should help a student turn mixed tasks and ideas into a useful structure without inventing priorities.
```

Answer the questions one at a time. At the end, ask the agent to write the approved Alignment Summary to `workshop-output/alignment.md`.

**Human checkpoint:** read the alignment summary. Correct unclear assumptions before continuing. Continue only when you would be willing to judge the final result against it.

### Step 2: Spec

Run:

```text
/spec Read workshop-output/alignment.md and write the specification to workshop-output/spec.md. Do not edit the APM package yet.
```

The spec must cover goal, constraints, success criteria, edge cases, and stakeholders.

**Human checkpoint:** review the success criteria and edge cases. Edit the file if needed, then explicitly approve it.

### Step 3: Tasks

Run:

```text
/tasks Read workshop-output/spec.md and write an ordered implementation plan to workshop-output/tasks.md. The deliverable is the APM package under .apm/, not a separate Python application.
```

**Human checkpoint:** confirm every task is small, ordered, and tied to the spec. Remove anything outside the agreed scope, then approve the list.

### Step 4: Execute

Run:

```text
/execute Read the approved workshop-output/tasks.md and execute it. Work only in .apm/ and workshop-output/. Build the deliverable rather than describing it. Deploy with apm install --target copilot and report what you verified.
```

The executor should change the package, deploy it, and inspect the generated Copilot artifacts.

**Human checkpoint:** inspect the changed `.apm/` files and the deployment output before testing the result.

### Validate with unseen input

Create a new brain dump that was not used in the basic block.

1. Run it once in plain Ask mode without a custom prompt.
2. Run it again with the improved Brain Dump Assistant and `/brain-dump` prompt.
3. Evaluate the second result against the success criteria in `workshop-output/spec.md`.

Discuss:

- Which assumptions became visible during alignment?
- What did the spec prevent the executor from inventing?
- Which tasks made the implementation easier to review?
- Where did human judgment materially change the result?

The point is not that every task needs four stages. The point is knowing when a one-off prompt is enough and when a reviewed process produces a more reliable artifact.

## 5. Reference

### Repository structure

```text
.apm/
  agents/       authored custom agents
  prompts/      authored reusable prompts
  skills/       authored portable skills
.github/
  agents/       generated Copilot agents
  prompts/      generated Copilot prompts
.agents/
  skills/       generated cross-harness skills
```

Completed examples:

- `.apm/agents/meeting-assistant.agent.md`
- `.apm/prompts/meeting-summary.prompt.md`
- `.apm/skills/align/SKILL.md`

Templates:

- `.apm/agents/brain-dump.agent.md`
- `.apm/prompts/brain-dump.prompt.md`

### YAML frontmatter

Frontmatter is the YAML block between the two `---` lines. It is metadata for the harness; the Markdown below it contains the instructions sent to the model.

#### Agent fields (`.agent.md`)

| Field | Purpose | Typical values |
|---|---|---|
| `name` | Display name; defaults to the filename | `Brain Dump Assistant` |
| `description` | Explains what the agent does and helps Copilot surface it | One concise sentence |
| `argument-hint` | Hint shown in the chat input | `Paste your unstructured thoughts` |
| `model` | Optionally pins a model | Exact model name from the VS Code picker; omit to use the selected model |
| `tools` | Restricts tools available to the agent | Target-specific tool names; omit unless restriction is needed |
| `agents` | Restricts which subagents it may call | A list of agent names, `*`, or `[]` |
| `user-invocable` | Controls visibility in the agent picker | `true` or `false`; default `true` |
| `disable-model-invocation` | Prevents other agents from invoking it as a subagent | `true` or `false`; default `false` |
| `handoffs` | Defines buttons for moving to another agent | Structured list of agent, label, prompt, and optional model |

VS Code agent reference: https://code.visualstudio.com/docs/copilot/customization/custom-agents#_custom-agent-file-structure

#### Prompt fields (`.prompt.md`)

| Field | Purpose | Typical values |
|---|---|---|
| `name` | Slash-command name; defaults to filename | `Brain Dump` |
| `description` | Description shown in the prompt picker | One concise sentence |
| `argument-hint` | Hint about additional input | `Paste your brain dump` |
| `agent` | Optionally chooses the agent used to run the prompt | `ask`, `agent`, `plan`, or a custom-agent name; omit to use the current agent |
| `model` | Optionally pins a model | Exact model name from the VS Code picker |
| `tools` | Restricts tools available to this prompt | Target-specific tool names |

VS Code prompt reference: https://code.visualstudio.com/docs/copilot/customization/prompt-files#_prompt-file-format

#### Skill fields (`SKILL.md`)

| Field | Purpose | Typical values |
|---|---|---|
| `name` | Skill identifier; must match the parent directory | Lowercase letters, numbers, and hyphens; maximum 64 characters |
| `description` | Says what the skill does **and when to use it**; drives discovery | Specific sentence; maximum 1024 characters |
| `argument-hint` | Hint shown when manually invoked | Optional short input hint |
| `user-invocable` | Shows or hides it from the slash-command menu | `true` or `false`; default `true` |
| `disable-model-invocation` | Enables or disables automatic discovery | `true` means manual invocation only; default `false` |
| `context` | Optionally runs the skill in a separate context | `fork` is experimental; omit for normal inline use |

VS Code skill reference: https://code.visualstudio.com/docs/copilot/customization/agent-skills#_skillmd-file-format

APM authoring references:

- Skills: https://microsoft.github.io/apm/producer/author-primitives/skills/
- Prompts: https://microsoft.github.io/apm/producer/author-primitives/prompts/
- Agents: https://microsoft.github.io/apm/producer/author-primitives/instructions-and-agents/#agents

APM translates primitives between harnesses, but not every field is portable. Target-specific fields may be transformed, ignored, or reported as lossy during installation. Start with the minimal fields used in this workshop, then consult the target matrix before adding complexity.

## Troubleshooting

**`apm: command not found`**

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then rerun the bootstrap script.

**A prompt, skill, or agent does not appear**

Run `apm install --target copilot`, inspect its output, then reload the VS Code window. Use **Chat: Open Customizations** or the Chat diagnostics view to see what VS Code loaded.

**The skill is not automatically used**

Invoke it explicitly with `/skill-name`. Then improve its `description` so it states both what the skill does and when it is relevant.

**OpenRouter or DeepSeek does not appear**

Return to **Chat: Manage Language Models**, confirm the OpenRouter provider exists, and make the model visible. Check whether BYOK is disabled by an organization policy.
