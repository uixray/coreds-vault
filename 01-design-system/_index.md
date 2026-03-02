---
title: "Design System — Map of Content"
type: moc
created: 2026-02-27
updated: 2026-02-27
---

# 🎨 CoreDS — Design System

## Навигация

- [[01-design-system/_spec/design-system-spec|📋 Техническое задание]]
- [[01-design-system/architecture/_index|🏗️ Архитектурные решения (ADR)]]
- [[01-design-system/tokens/_index|🎯 Токены]]
- [[01-design-system/components/_index|🧩 Компоненты]]
- [[01-design-system/themes/theme-contract|🎭 Тематизация]]
- [[01-design-system/guides/_index|📖 Гайды]]

## Статистика

### Компоненты по статусу
```dataview
TABLE WITHOUT ID
  status AS "Статус",
  length(rows) AS "Кол-во"
FROM "01-design-system/components"
WHERE type = "component"
GROUP BY status
```

### Компоненты без паттернов
```dataview
LIST
FROM "01-design-system/components"
WHERE type = "component" AND (length(related_patterns) = 0 OR !related_patterns)
```
