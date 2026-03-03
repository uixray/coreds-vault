---
title: "Web Clippings"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "source/web"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Saved web articles and publications clipped for study and reference."
---

# Web Clippings

Сохранённые статьи и публикации из интернета.

## Как пополняется

- **Obsidian Web Clipper** (браузерное расширение) — сохраняет страницу в Markdown
- **Ручной ввод** — по шаблону `clipping.md`

## Рекомендации по тегам

```
tags: ["type/clipping", "category/design-system"]
tags: ["type/clipping", "category/ux-patterns"]
tags: ["type/clipping", "category/ai-tools"]
tags: ["type/clipping", "category/typography"]
tags: ["type/clipping", "category/accessibility"]
```

## Шаблон

→ [[04-automation/templates/clipping|clipping.md]]

## Статьи

```dataview
TABLE source_author, source_publication, created, description
FROM "09-knowledge/clippings"
WHERE type = "clipping"
SORT created DESC
```
