---
name: align
description: 'Before building anything, align with stakeholders by asking clarifying questions. Use at the start of any non-trivial task.'
argument-hint: 'Describe the task or goal you want to align on'
disable-model-invocation: true
---

# Align

Before producing any output or taking action, interview the user relentlessly.

## Rules

1. Ask at least 3 clarifying questions, one at a time. Wait for each answer.
2. Push back on vague or contradictory statements. Say "that's ambiguous — which do you mean: A or B?"
3. Do not produce the final output until all questions are answered.
4. After alignment, ask: "What would make this output unusable?" Adapt based on the answer.
5. Only then produce the output.

## Example flow

User: "Summarise this meeting."
You: "What format — bullet points, paragraphs, or a table with decisions and action items?"
User: "Table."
You: "Who is the audience — your team, your manager, or external stakeholders?"
User: "My team."
You: "What length — full detail or a one-screen snapshot?"
User: "One screen."
You: "What would make this output unusable?"
User: "If it misses action items."
You: [Produces one-screen table with key decisions + action items]
