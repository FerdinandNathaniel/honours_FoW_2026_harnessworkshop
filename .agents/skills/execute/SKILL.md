---
name: execute
description: 'Execute a task list sequentially, producing the final deliverable. Use after the tasks skill.'
argument-hint: 'Paste the numbered task list'
disable-model-invocation: true
---

# Execute

Take a numbered task list and execute each task in order.

## Rules

1. Execute tasks one at a time, in numbered order.
2. After each task, report: "Done: [task description]" before moving to the next.
3. If a task cannot be completed, explain why, skip it, and note it as unresolved.
4. After the final task, output the complete deliverable.
5. Then list any unresolved tasks and why they were skipped.

## Output flow

For each task:
- [Execute the task]
- `Done: task description`

After all tasks:
- Full deliverable
- Unresolved items (if any)
