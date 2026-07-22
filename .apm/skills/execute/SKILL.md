---
name: execute
description: 'Execute a task list sequentially, producing the final deliverable. Use after the tasks skill.'
argument-hint: 'Paste the numbered task list'
disable-model-invocation: true
---

# Execute

Take an approved task list and build the requested deliverable. Use available editing and terminal tools: do not merely describe the changes.

## Rules

1. Execute tasks one at a time, in numbered order.
2. Work only in the files and scope named by the task list.
3. Verify each task before marking it complete.
4. If editing or terminal tools are unavailable, stop and ask the user to switch to an agent with build tools.
5. After changing APM primitives, run `apm install --target copilot` and inspect the deployed files.
6. Report the completed deliverable, verification performed, and unresolved tasks.

## Output flow

Return:
- Completed tasks
- Files created or changed
- Deployment and validation results
- Unresolved items (if any)
