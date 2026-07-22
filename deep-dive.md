# Deep Dive: AI Harnesses & Standardized Agent Frameworks

## 1. AI Harnesses — What Are They?

An **AI harness** is the shell, runtime, and interface where an LLM "lives." It's the layer between raw model inference and the user — providing tool access, context management, agent orchestration, and the interaction surface.

Think of it as the browser for the web. The browser doesn't own the content, but it defines how you experience it. Similarly, the harness doesn't own the model, but it defines how you interact with it and what it can do.

### Examples

| Harness | Type | Link |
|---|---|---|
| **VS Code Copilot Chat** | IDE-embedded agent chat | github.com/features/copilot |
| **OpenCode** | Terminal-native agent framework | opencode.ai |
| **Claude Code** | Terminal-based agentic coding tool | docs.anthropic.com |
| **Cursor** | AI-first code editor | cursor.com |
| **Aider** | Terminal pair-programming agent | aider.chat |
| **LangChain Deep Agents** | Programmatic agent harness | docs.langchain.com |
| **GitHub Copilot Agent Mode** | Autonomous IDE agent | github.com/features/copilot |

### The Harness Layer

Every harness provides three things:
1. **Tool access** — read files, run commands, search, browse the web, call APIs
2. **Context assembly** — what goes into the model's prompt window, in what order, with what priority
3. **Interaction surface** — chat, inline edits, voice, terminal, IDE

The harness is the new OS. Just as an OS mediates between applications and hardware, a harness mediates between agents and the world.

---

## 2. The Evolution — LLMs → Agents → Agent Networks → Harnesses → Standardization → Future

### LLMs (2020–2022)
Large language models as completion engines. Prompt in, text out. No tool access, no memory, no autonomy. The model is a function: `f(prompt) → response`.

### Agents (2023)
LLMs with agency. Tool use, multi-turn reasoning, memory. The model can plan and execute — but each agent is a one-off, handcrafted system. Frameworks like LangChain and AutoGen emerge, but they're bespoke and fragile.

Key insight: **giving a model tools changes its nature.** A model that can search, read files, and run code behaves fundamentally differently from one that can only generate text.

### Agent Networks (2024)
Multiple agents working together. Orchestration patterns emerge: chains, routers, orchestrator-workers, evaluator-optimizer. Agents delegate to sub-agents. Frameworks like CrewAI, LangGraph, and AutoGen formalize multi-agent patterns.

Key insight: **agents don't scale individually. Networks scale compositionally.**

### Harnesses (2024–2025)
The realization that the environment matters more than the agent. The harness provides the shell — context management, tool registry, memory, voice I/O, model switching. OpenCode, Claude Code, Cursor, and Copilot Chat are not just tools; they're platforms.

Key insight: **the OS is more durable than the apps. The harness is more durable than the agents.**

### Standardization (2025–2026)
As harnesses proliferate, the need for interoperability becomes obvious. Standards emerge:
- **MCP (Model Context Protocol):** USB-C for AI tools — standardised tool interfaces across harnesses
- **APM (Agent Package Manager):** npm/pip for agent artifacts — skills, prompts, agents as installable packages
- **A2A (Agent-to-Agent Protocol):** Google's standard for cross-agent communication

Key insight: **standardization enables ecosystems. Ecosystems enable adoption.**

### Future (2026+)
- Harnesses become commodity infrastructure (like browsers)
- Agents become transactional — paid per task, not per month
- Multi-agent networks become the default architecture for complex work
- Voice I/O becomes primary, text becomes archival
- The distinction between "developer tool" and "professional tool" dissolves

---

## 3. Marketplace — Sharing Skills, Agents, and Prompts

AI organizations face the same problem software orgs faced before package managers: **every team independently builds the same things.** A prompt for code review, a skill for GDPR compliance, an agent for meeting summaries — reinvented in every team, every week.

### The Package Manager Model

APM applies the npm/pip model to AI artifacts:

| Concept | Software Package | APM Package |
|---|---|---|
| Artifact | Library, module | Skill, prompt template, agent definition |
| Registry | npmjs.com, PyPI | GitHub repo as marketplace |
| Install | `npm install react` | `apm install -g org/repo` |
| Version lock | `package-lock.json` | `apm.lock.yaml` |
| Dependency graph | package.json deps | apm.yml deps |

### Why It Matters

1. **Reuse reduces cost.** A well-crafted GDPR compliance skill costs real engineering time. Every reuse saves that cost.
2. **Standardization increases quality.** Org-reviewed skills are battle-tested. Ad-hoc prompts are not.
3. **Discoverability enables learning.** A marketplace makes the org's AI knowledge visible and searchable.

### The HU Agent Standards Model

The `hu-agent-standards` repository (link shared during workshop) serves as the marketplace for university teams. It contains:
- Standardised skills (surf-a10-inference, new-project-bootstrap)
- Team instructions (house-style, GDPR compliance, onboarding)
- Agent templates (code-reviewer)
- Prompt templates (design-review)

Teams install via `apm install -g uashogeschoolutrecht/hu-agent-standards --target copilot`.

---

## 4. Context Management — The Smart Zone, Dumb Zone, and Middle Blindness

### The Problem

LLMs have limited context windows — or, more precisely, limited *effective* context windows. Research shows a U-shaped performance curve: models pay most attention to information at the **beginning** and **end** of the context window, with a sharp drop in the middle.

### Lost in the Middle

**Paper:** Liu et al., "Lost in the Middle: How Language Models Use Long Contexts" (2023)
**Link:** https://arxiv.org/abs/2307.03172

Key finding: When relevant information sits in the middle of a long context, retrieval accuracy drops by 20–50% compared to when it's at the beginning or end. This holds across model families (GPT-4, Claude, Gemini).

### Smart Zone / Dumb Zone

The "smart zone" is roughly the first 10–20% and last 10–20% of context. The "dumb zone" is the middle 60–80%. This concept emerged from the Needle in a Haystack benchmark (https://github.com/gkamradt/needle-in-a-haystack), which systematically tests retrieval at every position in varying context lengths.

### Implications for Agent Harnesses

1. **Placement > capacity.** A well-structured 10K-token context outperforms a poorly-structured 100K-token context.
2. **Structure context programmatically.** Use XML tags, clear headers, and explicit section demarcation (Anthropic's guidance: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/long-context-tips).
3. **Curate, don't dump.** Aider's repository map pattern (https://aider.chat/docs/repomap.html) sends a relevance-ranked subset of the codebase, not the whole thing.
4. **Rotate context.** Move stale information to a retrieval store. Keep active information at the edges of the context window.

### The Agent-Specific Challenge

Agents accumulate context — conversation history, tool outputs, retrieved documents, sub-agent results. After 20 tool calls, critical instructions from the system prompt may have been pushed deep into the dumb zone. Harnesses must actively manage this: summarise old turns, re-insert key instructions, compress verbose tool outputs.

---

## 5. Spec-Driven Development — Align → Spec → Decompose → Execute

### Why Prompts Aren't Enough

A single prompt ("summarise this meeting") gets you one output. But it doesn't get you:
- Alignment on what "summarise" means for your audience
- Edge case handling for empty or malformed input
- Decomposition into testable, reviewable steps
- A reproducible process that works across different meetings

Spec-driven development (SDD) solves this by inserting a **planning phase** between the request and the execution.

### The Pipeline

```
Align → Spec → Decompose → Execute
```

**Align:** Clarify the actual requirement. Who is this for? What format? What's the constraint? What would make the output unusable? Ask before building.

**Spec:** Produce a structured specification — goal, constraints, success criteria, edge cases, stakeholders. The spec is a contract: "if the output meets these criteria, it's done."

**Decompose:** Break the spec into ordered, actionable tasks. Each task small enough to execute in one step. Each task verifiable against a spec criterion.

**Execute:** Run each task sequentially. Produce the deliverable. Flag unresolved items.

### Frameworks Implementing This Pattern

| Framework | Pipeline | Link |
|---|---|---|
| **GitHub Spec Kit** | constitution → specify → clarify → plan → tasks → implement | github.com/github/spec-kit |
| **OpenSpec (Fission-AI)** | explore → propose → apply → archive | github.com/Fission-AI/OpenSpec |
| **Claude Code** | explore → plan → implement → commit | code.claude.com/docs/en/best-practices |
| **Anthropic Agents** | workflow chains → routing → orchestrator-workers → evaluator-optimizer | anthropic.com/engineering/building-effective-agents |

### Adapting to Your Organization

The pipeline is a pattern, not a religion. Adapt it:
- **Small tasks:** skip spec, just align → execute
- **Solo work:** skip stakeholder section, but keep edge cases
- **Internal tools:** lighter spec format, focus on constraints and success criteria
- **Client work:** full pipeline, every section mandatory

The point is not bureaucracy. The point is **not skipping the thinking step.**

---

## 6. Transcription Tools — The Interface Shift

### From Typing to Speaking

The bandwidth difference is significant: average typing speed is ~40 WPM; average speaking speed is ~150 WPM. But the quality difference matters more: spoken instructions tend to be higher-level and more conversational. You describe what you want, not how to format it.

### Key Tools

| Tool | Type | Link |
|---|---|---|
| **MacWhisper** | Local macOS transcription (whisper.cpp) | goodsnooze.gumroad.com |
| **whisper.cpp** | Cross-platform local Whisper inference | github.com/ggml-org/whisper.cpp |
| **OpenAI Whisper** | Open-source speech recognition (foundation) | github.com/openai/whisper |
| **Aider Voice Mode** | Voice-to-code for pair-programming | aider.chat/docs/usage/voice.html |
| **macOS Dictation** | Built-in OS dictation | apple.com |
| **HearIt** | Local transcription with UI | Various |

### Why Local Transcription Matters for Agents

1. **Privacy:** Meeting notes, code discussions, and design conversations stay on-device.
2. **Latency:** No API round-trip. Real-time transcription feels like dictation, not a network call.
3. **Cost:** Zero per-minute cost. Unlimited usage.
4. **Reliability:** Works offline. No API outages to worry about.

### The Shift

Voice changes the nature of agent interaction. When you speak to an agent:
- Instructions become more natural-language, less "prompt-engineered"
- Interaction becomes more conversational, more iterative
- The agent moves from a tool you operate to a collaborator you talk to

This is the direction harnesses are heading: voice-first, keyboard-optional.

---

## 7. Composability — Agents, Sub-Agents, and Skill Chaining

### The Sub-Agent Pattern

A main agent spawns specialised sub-agents for specific subtasks. Each sub-agent:
- Gets a fresh, isolated context window
- Has access to the tools it needs (and only those tools)
- Returns a single structured result to the parent
- Is disposable — creates no permanent state

This is the key insight from LangChain's Deep Agents (docs.langchain.com/oss/python/deepagents/overview) and Google's ADK 2.0 (github.com/google/adk-python): **sub-agents are cheaper and more reliable than one big agent trying to do everything in a single context window.**

### Skill Chaining

Skills are composable instructions. An agent with multiple skills active chains them:
1. The `align` skill intercepts the request, asks clarifying questions
2. The `spec` skill takes the aligned output, produces a structured document
3. The `tasks` skill decomposes the spec into steps
4. The `execute` skill runs each step

This is not a framework feature — it's a design pattern. Any harness that supports multiple skills can chain them.

### Framework Patterns

| Pattern | Example Framework | How It Works |
|---|---|---|
| **Workflow graphs** | LangGraph, ADK 2.0 | Agents are nodes in a directed graph. Edges define execution order and routing. |
| **Role-based crews** | CrewAI | Agents are assigned roles. Crews execute tasks collaboratively. |
| **Conversation-based** | AutoGen (AG2) | Agents communicate through a standardised message protocol. |
| **Package-based** | APM | Agents, skills, and prompts are versioned packages. Harnesses resolve and compose them. |

### Why Composability Matters

Composability is the difference between **building agents** and **building agent systems.** A single agent is a tool. A composed system is infrastructure. The harness enables the composition.

---

## 8. Process Flows — Visualizing Agent Workflows

### Why Visualize?

Agent workflows are invisible by default. You type, the agent does things, output appears. For anyone who isn't the person typing — managers, stakeholders, teammates, future you — the process is a black box.

Process flows make the invisible visible. They serve three purposes:
1. **Design:** Map out the flow before building it
2. **Communication:** Explain to non-technical stakeholders what the agent does and where humans fit in
3. **Debugging:** Trace what happened when something went wrong

### The Visual Language

A simple, universal visual language for agent workflows (from Anthropic's workflow patterns):
- **Boxes** = LLM calls / agent actions
- **Diamonds** = decision / routing gates
- **Arrows** = execution flow
- **Dashed lines** = data dependencies
- **Human icon** = human-in-the-loop checkpoint

### Reference Patterns

Anthropic's five foundational patterns (anthropic.com/engineering/building-effective-agents):
1. **Prompt chaining:** Sequential — each step feeds the next
2. **Routing:** Input classified → sent to specialised handler
3. **Parallelization:** Multiple agents work simultaneously on sub-tasks
4. **Orchestrator-Workers:** Central agent delegates to specialised workers
5. **Evaluator-Optimizer:** Iterative loop — produce → evaluate → refine

### Tools for Visualization

| Tool | Approach | Link |
|---|---|---|
| **CrewAI `flow.plot()`** | Generate HTML flow diagrams from code | docs.crewai.com/concepts/flows |
| **LangSmith** | Agent execution trace visualization | langchain.com/langsmith |
| **Mermaid** | Text-to-diagram for process flows | mermaid.js.org |
| **Excalidraw** | Manual whiteboarding for design sessions | excalidraw.com |

### Cross-Discipline Communication

A process flow diagram is the universal language between:
- **Developers:** "This is what the agent does."
- **Managers:** "This is where we review output."
- **Compliance:** "This is where data is processed."
- **Users:** "This is what happens when you submit a request."

The diagram bridges the technical/non-technical gap without dumbing down the content.

---

## 9. Further Reading

### Papers
- **Lost in the Middle** — Liu et al. (2023): LLM context retrieval follows a U-curve. https://arxiv.org/abs/2307.03172
- **Needle in a Haystack** — Kamradt (2023): Systematic long-context retrieval benchmark. https://github.com/gkamradt/needle-in-a-haystack

### Blog Posts & Guides
- **Building Effective Agents** — Anthropic (2024): The canonical reference on agent architecture. https://www.anthropic.com/engineering/building-effective-agents
- **Best Practices for Claude Code** — Anthropic (2025): The explore→plan→implement→commit workflow. https://code.claude.com/docs/en/best-practices
- **Long-Context Prompt Engineering** — Anthropic: Structured context strategies. https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/long-context-tips

### Tools & Repos
- **OpenCode** — Terminal-native agent harness. https://opencode.ai
- **Aider** — AI pair programming in the terminal. https://aider.chat
- **Spec Kit** — GitHub's spec-driven development toolkit. https://github.com/github/spec-kit
- **OpenSpec** — Lightweight spec-driven development. https://github.com/Fission-AI/OpenSpec
- **whisper.cpp** — On-device speech recognition. https://github.com/ggml-org/whisper.cpp
- **LangGraph** — Graph-based agent orchestration. https://github.com/langchain-ai/langgraph
- **CrewAI** — Multi-agent automation framework. https://github.com/crewAIInc/crewAI
- **Google ADK** — Agent Development Kit with workflow runtime. https://github.com/google/adk-python

### Standards
- **MCP (Model Context Protocol)** — Standardized tool interfaces for AI. https://modelcontextprotocol.io
- **A2A (Agent-to-Agent Protocol)** — Google's agent communication standard. https://developers.google.com
- **APM (Agent Package Manager)** — Package management for AI artifacts. (link shared during workshop)

### Concepts
- **Aider Repository Map** — Context optimization via relevance ranking. https://aider.chat/docs/repomap.html
- **ChatGPT Multimodal Launch** — Voice and vision as standard interfaces. https://openai.com/index/chatgpt-can-now-see-hear-and-speak/
