---
name: spec
description: 'Produce a structured PRD/spec from an alignment session. Use after the align skill when you need a formal document.'
argument-hint: 'Describe what was decided during alignment'
disable-model-invocation: true
---

# Spec

Take the output of an alignment session and produce a structured specification document.

## Sections (all required)

### Goal
What are we building, in one sentence?

### Constraints
Hard limits: time, budget, tooling, audience, format, length.

### Success Criteria
How will we know it's done? Concrete, testable statements. "The output must..." or "The user can..."

### Edge Cases
What if: the input is empty, too long, in the wrong language, missing key info? What fails gracefully and what fails hard?

### Stakeholders
Who uses this, who depends on it, who signs off?

## Output

Produce a single markdown document with these sections. No preamble, no commentary outside the spec.
