---
title: "AI Interaction Patterns"
type: moc
created: 2026-02-27
updated: 2026-02-27
---

# 🤖 AI Interaction Patterns

Паттерны проектирования интерфейсов с искусственным интеллектом.

## Interaction Flow

```
Initiate → Compose → Process → Receive → Refine → Trust
```

## Разделы

### Input (Initiate + Compose)
```dataview
LIST
FROM "02-patterns/ai/input"
WHERE type = "pattern"
SORT file.name ASC
```

### Output (Process + Receive)
```dataview
LIST
FROM "02-patterns/ai/output"
WHERE type = "pattern"
SORT file.name ASC
```

### Trust & Transparency
```dataview
LIST
FROM "02-patterns/ai/trust"
WHERE type = "pattern"
SORT file.name ASC
```

### Control (Refine)
```dataview
LIST
FROM "02-patterns/ai/control"
WHERE type = "pattern"
SORT file.name ASC
```

### Agentic UX
```dataview
LIST
FROM "02-patterns/ai/agentic"
WHERE type = "pattern"
SORT file.name ASC
```

### Hybrid (AI + Traditional UI)
```dataview
LIST
FROM "02-patterns/ai/hybrid"
WHERE type = "pattern"
SORT file.name ASC
```

## Связанные AI-компоненты CoreDS

| Компонент | Паттерн-источник |
|----------|-----------------|
| [[PromptInput]] | [[blank-prompt]], [[prompt-templates]] |
| [[StreamingText]] | [[streaming-text]] |
| [[ThinkingIndicator]] | [[thinking-indicators]] |
| [[SourceCitation]] | [[source-attribution]] |
| [[AIBadge]] | [[ai-vs-human-badge]] |
