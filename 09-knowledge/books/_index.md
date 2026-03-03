---
title: "Book Notes"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "source/book"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Book notes and summaries — design, UX, psychology, and systems thinking."
---

# Book Notes

Конспекты и заметки по книгам о дизайне, UX, психологии и системном мышлении.

## Как пополняется

- **AI-генерация**: загрузить PDF/epub → AI создаёт структурированный конспект по шаблону
- **Ручной ввод**: читаешь книгу → заполняешь шаблон `book.md`
- **Экспорт из Readwise** (если используется)

## Шаблон

→ [[04-automation/templates/book|book.md]]

## Рейтинги

```dataview
TABLE author, year, rating, description
FROM "09-knowledge/books"
WHERE type = "book"
SORT rating DESC
```
