---
title: "Конвенции оформления"
type: meta
created: 2026-02-27
updated: 2026-02-27
---

# Конвенции оформления vault

## Frontmatter

Каждый файл начинается с YAML frontmatter:

```yaml
---
title: "Название"
type: pattern | component | token | adr | law | heuristic | research | guide | meta | moc
category: foundations | platform | interaction | ai | domain   # для паттернов
status: seed | draft | review | stable | deprecated
version: "1.0.0"
created: YYYY-MM-DD
updated: YYYY-MM-DD
freshness: current | stale | outdated
freshness_checked: YYYY-MM-DD
tags: []
related_components: []     # wikilinks на компоненты
related_tokens: []         # wikilinks на токены
related_patterns: []       # wikilinks на паттерны
related_heuristics: []     # wikilinks на эвристики/законы
platforms: [web, iOS, Android]
---
```

## Status lifecycle

| Статус | Описание |
|--------|----------|
| 🌱 `seed` | Заметка создана, минимальное содержание |
| 📝 `draft` | Основное содержание написано, не проверено |
| 🔍 `review` | На проверке (self-review или community) |
| ✅ `stable` | Проверено, актуально, полное содержание |
| ⛔ `deprecated` | Устарело, сохранено для истории |

## Freshness

| Статус | Описание |
|--------|----------|
| 🟢 `current` | Проверено недавно, актуально |
| 🟡 `stale` | Прошёл период проверки, возможно устарело |
| 🔴 `outdated` | Подтверждённо устарело, нужно обновить |

Периоды проверки: AI паттерны — 90 дней, платформы — 180, фундамент — 365.

## Ссылки

- Внутренние: `[[название-файла]]` или `[[путь/к/файлу|Отображаемый текст]]`
- Внешние: `[текст](https://url)`
- Якоря: `[[файл#заголовок]]`

## Теги

Иерархические через `/`:
- `#type/pattern`, `#type/component`, `#type/law`
- `#category/ai`, `#category/platform`
- `#platform/web`, `#platform/ios`, `#platform/android`
- `#status/seed`, `#status/stable`
- `#tier/1`, `#tier/2`, `#tier/3` (для компонентов)

## Именование файлов

- Kebab-case: `tab-bar.md`, `cognitive-load.md`
- Без пробелов и спецсимволов
- Осмысленные имена на английском
