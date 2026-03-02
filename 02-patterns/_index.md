---
title: "Pattern Library — Map of Content"
type: moc
created: 2026-02-27
updated: 2026-02-27
---

# 📚 Pattern Library

## Разделы

| Раздел | Описание | Кол-во |
|--------|----------|--------|
| [[02-patterns/foundations/_index\|🧠 Foundations]] | Эвристики, законы UX, психология, accessibility | — |
| [[02-patterns/platform/_index\|📱 Platform]] | Кроссплатформенные паттерны (Web/iOS/Android) | — |
| [[02-patterns/interaction/_index\|🖱️ Interaction]] | Формы, поиск, загрузка, ошибки, уведомления | — |
| [[02-patterns/ai/_index\|🤖 AI Patterns]] | Промпты, вывод, доверие, agentic UX | — |
| [[02-patterns/domain/_index\|🏢 Domain]] | SaaS, e-commerce, контент, социальные | — |

## Все паттерны по статусу

### ⚠️ Требуют обновления
```dataview
TABLE category, freshness_checked
FROM "02-patterns"
WHERE (freshness = "stale" OR freshness = "outdated") AND type = "pattern"
SORT freshness_checked ASC
```

### ✅ Stable
```dataview
TABLE category, version
FROM "02-patterns"
WHERE status = "stable" AND type = "pattern"
SORT file.name ASC
```

### 📝 Draft
```dataview
TABLE category
FROM "02-patterns"
WHERE status = "draft" AND type = "pattern"
SORT file.name ASC
```

### 🌱 Seed
```dataview
TABLE category
FROM "02-patterns"
WHERE status = "seed" AND type = "pattern"
SORT file.name ASC
```
