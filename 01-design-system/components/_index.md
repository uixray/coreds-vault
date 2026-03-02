---
title: "Компоненты"
type: moc
created: 2026-02-27
updated: 2026-02-27
---

# 🧩 Компоненты CoreDS

## Tier 1 — Primitives

```dataview
TABLE status, platforms
FROM "01-design-system/components"
WHERE type = "component" AND contains(tags, "tier/1")
SORT file.name ASC
```

## Tier 2 — Composites

```dataview
TABLE status, platforms
FROM "01-design-system/components"
WHERE type = "component" AND contains(tags, "tier/2")
SORT file.name ASC
```

## Tier 3 — Patterns

```dataview
TABLE status, platforms
FROM "01-design-system/components"
WHERE type = "component" AND contains(tags, "tier/3")
SORT file.name ASC
```

## AI Components (from Pattern Library)

```dataview
TABLE status, related_patterns
FROM "01-design-system/components"
WHERE type = "component" AND contains(tags, "ai")
SORT file.name ASC
```

## Backlog (все компоненты)

| Tier | Компонент | Статус |
|------|-----------|--------|
| 1 | Button | 🌱 seed |
| 1 | Input | 🌱 seed |
| 1 | Checkbox | 🌱 seed |
| 1 | Radio | 🌱 seed |
| 1 | Toggle | 🌱 seed |
| 1 | Select | 🌱 seed |
| 1 | Link | 🌱 seed |
| 1 | Badge | 🌱 seed |
| 1 | Tag | 🌱 seed |
| 1 | Icon | 🌱 seed |
| 1 | Avatar | 🌱 seed |
| 1 | Divider | 🌱 seed |
| 1 | ThinkingIndicator | 🌱 seed |
| 1 | SourceCitation | 🌱 seed |
| 1 | ConfidenceBadge | 🌱 seed |
| 1 | AIBadge | 🌱 seed |
