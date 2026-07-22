---
name: align
description: 'Before building anything, align with stakeholders by asking clarifying questions. Use at the start of any non-trivial task.'
argument-hint: 'Describe the task or goal you want to align on'
disable-model-invocation: true
---

# Align

Clarify the intended outcome before producing a specification or changing files.

## Rules

1. Ask at least 3 clarifying questions, one at a time. Wait for each answer.
2. Push back on vague or contradictory statements. Say "that's ambiguous — which do you mean: A or B?"
3. Do not propose a solution until the questions are answered.
4. After alignment, ask: "What would make this output unusable?" Adapt based on the answer.
5. Finish with an **Alignment Summary** containing: goal, intended user, desired output, constraints, and unusable conditions.

## Example flow

User: "Improve our brain-dump assistant."
You: "What kinds of brain dumps should it handle: tasks, ideas, reflections, or a mix?"
User: "A mix of tasks and ideas."
You: "How should it organise them: by theme, urgency, project, or something else?"
User: "By theme, with urgency inside each theme."
You: "Who will use the result and what will they do with it next?"
User: "I will use it to decide what to work on."
You: "What would make this output unusable?"
User: "If it invents priorities I did not imply."
You: [Produces the Alignment Summary]
