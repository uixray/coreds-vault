---
title: "UText — AI Text Generator for Figma"
type: guide
status: seed
version: "2.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "platform/figma"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Figma plugin for AI-powered text generation, mass layer renaming, and design data automation with 30+ LLM models."
github: "https://github.com/uixray/figma-llm-plugin"
---

# UText — AI Text Generator

> AI-генерация текста, массовое переименование слоёв и автоматизация дизайн-данных. 30+ LLM моделей.

**Версия:** 2.1.0 · **Лицензия:** MIT · [GitHub](https://github.com/uixray/figma-llm-plugin) · **Статус:** Опубликован в Figma Community

---

## Зачем этот плагин

Дизайнеры тратят огромное время на вставку текстов в макеты: придумать заголовки, описания, имена пользователей, тексты кнопок. UText делегирует это AI — выделяешь слои, пишешь промпт, нажимаешь Generate, AI сам заполняет всё.

---

## Возможности

### Generate & Apply
Выдели текстовые слои → напиши промпт → AI заполняет каждый слой. Работает на один слой или на сотни одновременно.

### Mass Layer Renaming
- **Style Mode:** BEM, camelCase, snake_case, kebab-case
- **AI Mode:** опиши конвенцию в свободной форме, AI переименовывает по смыслу содержимого

### Prompt Library
Сохраняй, организовывай и переиспользуй промпты с категориями и тегами.

### Data Presets
Пресеты реалистичных данных: Users, Products, Places, Colors. Применяются по клику или через контекстное меню. Слой `user_name` получит имя, `email` — email, `avatar` — фото.

---

## Поддерживаемые AI-провайдеры

| Провайдер | Модели | Ключ |
|----------|--------|------|
| OpenAI | GPT-4o, GPT-4 Turbo, GPT-4o Mini | Обязателен |
| Claude (Anthropic) | Claude 3.5 Sonnet/Haiku, Claude 3 Opus | Обязателен |
| Google Gemini | Gemini 2.5 Flash, 1.5 Pro/Flash | Обязателен |
| Mistral | Large, Small, Nemo, Codestral | Обязателен |
| Groq | Llama 3.3/3.1/3, Mixtral, Gemma 2 | Обязателен |
| Cohere | Command R+, Command R | Обязателен |
| Yandex Cloud | YandexGPT Pro/Lite + 6 моделей | Обязателен |
| LM Studio | Любая локальная модель | Не нужен |

---

## Прокси

По умолчанию запросы идут через `proxy.uixray.tech` для обхода CORS-ограничений браузера.
В настройках можно указать собственный прокси или отключить. Подробнее: [[../services/figma-ai-proxy|figma-ai-proxy]].

---

## Стек

| Слой | Технология |
|------|-----------|
| Язык | TypeScript 5.3 |
| Бандлер | tsup 8.0 |
| Figma API | 1.95 |
| i18n | 5 языков (EN, RU, JA, ZH, FR) |
| Тема | Dark / Light / Auto |

---

## Установка

**Из Figma Community:**
1. Plugins → Browse plugins in Community → поиск **UText** → Install

**Для разработки:**
```bash
git clone https://github.com/uixray/figma-llm-plugin.git
cd figma-llm-plugin
npm install
npm run build
```

---

## Место в стеке

UText — основной инструмент работы с текстом в Figma. Закрывает потребность в:
- Реалистичных плейсхолдерах (вместо Lorem Ipsum)
- Генерации UX-копи прямо в макете
- Массовом переименовании слоёв по смыслу

**Связанные инструменты:**
- [[urenaing|URenaming]] — специализированный инструмент только для переименования
- [[udata|UData]] — альтернатива пресетам данных с большими возможностями
- [[../services/figma-ai-proxy|figma-ai-proxy]] — прокси, через который ходят все AI-запросы
