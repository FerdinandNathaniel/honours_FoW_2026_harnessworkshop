---
name: tasks
description: 'Decompose a spec/PRD into an ordered, actionable task list. Use after the spec skill.'
argument-hint: 'Paste the spec document'
disable-model-invocation: true
---

# Tasks

Read the provided specification and decompose it into a numbered, ordered list of tasks.

## Rules

1. Each task must be small enough to execute in a single step by an LLM.
2. Tasks must be ordered — each task should logically follow the previous.
3. Each task starts with a verb: "Write", "Create", "Check", "Generate", "Review".
4. Include the relevant constraint or criterion from the spec that the task addresses.
5. Output ONLY the numbered task list. No preamble.

## Example output for an APM agent package

1. Update `.apm/prompts/brain-dump.prompt.md` to implement the output structure in the approved spec
2. Update `.apm/agents/brain-dump.agent.md` to implement the agent behaviour and boundaries in the approved spec
3. Create or update the relevant skill under `.apm/skills/` with a specific discovery description
4. Run `apm install --target copilot` to deploy the package to VS Code
5. Inspect the generated Copilot files and check that all three primitives were deployed
6. Test the result with a previously unseen brain dump and evaluate it against the success criteria
