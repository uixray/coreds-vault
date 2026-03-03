---
title: "URenaming — AI Layer Renaming Tool"
type: guide
status: seed
version: "1.0.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "platform/figma"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Figma plugin for AI-powered mass layer renaming with BEM, camelCase, snake_case, kebab-case presets and free-form AI instructions."
github: "TODO"
---

# URenaming — AI Layer Renaming Tool

> Массовое переименование слоёв Figma: стилевые пресеты и AI-режим.

**Версия:** 1.0.0 · **GitHub:** TODO

---

## Зачем этот плагин

Хаотичные имена слоёв — `Rectangle 47`, `Group 3`, `Frame Copy 12` — создают проблемы при передаче в разработку и при работе с компонентами. Вручную переименовать 200 слоёв занимает час. URenaming делает это за секунды, понимая контекст и структуру.

---

## Два режима

### Style Mode — детерминированное переименование
Выбери конвенцию и применяй к выделению:

| Пресет | Пример |
|--------|--------|
| BEM | `card__title`, `button--primary` |
| camelCase | `cardTitle`, `buttonPrimary` |
| snake_case | `card_title`, `button_primary` |
| kebab-case | `card-title`, `button-primary` |

### AI Mode — переименование по смыслу
Опиши задачу в свободной форме:
> *"Используй семантические имена на основе содержимого, следуй BEM-конвенции, компоненты — UpperCamelCase"*

AI анализирует структуру и контент слоёв, предлагает имена, ты принимаешь или редактируешь.

---

## Workflow

1. Выдели фреймы / группы в Figma
2. Открой URenaming
3. Выбери Style или AI режим
4. **Preview Changes** — посмотри что изменится
5. **Apply** — применить

---

## Поддерживаемые AI-провайдеры

OpenAI, Anthropic, Google, Mistral, Groq, Cohere, Yandex Cloud

---

## Стек

TypeScript 5.3, tsup 8.0, Figma Plugin API 1.95

---

## Место в стеке

Специализированная альтернатива функции переименования в [[utext|UText]]. Рекомендуется когда задача — именно привести имена в порядок, а не генерировать текстовый контент.

**Связанные инструменты:**
- [[utext|UText]] — также умеет переименовывать слои
- [[../services/figma-ai-proxy|figma-ai-proxy]] — прокси для AI-запросов
