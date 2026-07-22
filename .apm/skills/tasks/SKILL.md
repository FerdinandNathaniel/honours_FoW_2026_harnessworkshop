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

## Example output

1. Create an empty Python file `meeting_summary.py`
2. Write a function `parse_notes(text)` that splits input by double-newline into sections
3. Write a function `extract_decisions(sections)` that pulls lines starting with "Decided:" or "Decision:"
4. Write a function `extract_actions(sections)` that pulls lines starting with "Action:" or "TODO:"
5. Write a function `format_output(decisions, actions)` that outputs the structured format from the spec
6. Write a `main()` function that reads stdin, calls all functions in order, prints result
7. Test with the sample meeting notes from the spec's success criteria
