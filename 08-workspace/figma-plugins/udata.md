---
title: "UData — Design Data Filler"
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
description: "Figma plugin for managing reusable data presets and applying them to text layers, with AI-powered data generation."
github: "TODO"
---

# UData — Design Data Filler

> Управление пресетами данных и автозаполнение текстовых слоёв в Figma.

**Версия:** 1.0.0 · **GitHub:** TODO

---

## Зачем этот плагин

Реалистичные данные делают макет убедительным: имена пользователей, email-адреса, описания товаров, адреса. Заполнять это вручную — скучно и медленно. UData позволяет создавать пресеты данных и применять их к слоям одним действием, а AI может генерировать данные под конкретный контекст.

---

## Возможности

- **Data Presets** — сохраняемые наборы данных: имена, email, телефоны, товары и т.д.
- **Smart Apply** — слой `user_name` → имя, `email` → email. Маппинг по имени слоя.
- **AI Generation** — сгенерировать данные под контекст через любой LLM-провайдер
- **Multi-provider** — OpenAI, Anthropic, Google, Mistral, Groq, Cohere, Yandex Cloud, LM Studio
- **Bulk apply** — применить пресет ко всем подходящим слоям сразу

---

## Поддерживаемые провайдеры

OpenAI, Anthropic, Google, Mistral, Groq, Cohere, Yandex Cloud, LM Studio

---

## Стек

TypeScript 5.3, tsup 8.0, Figma Plugin API 1.95

---

## Место в стеке

**Связанные инструменты:**
- [[utext|UText]] — включает похожую функциональность data presets
- [[../services/figma-ai-proxy|figma-ai-proxy]] — используется для AI-генерации данных
