---
title: "Figma Plugins — Design Automation"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "category/tools", "platform/figma"]
platforms: [web]
description: "Map of Content for UIXRay Figma plugins — tools for automating repetitive design tasks."
---

# Figma Плагины

Пять плагинов, закрывающих самые болезненные точки рутины в Figma:
работа с текстом, данными, именованием слоёв, проверкой качества и поиском дублей.

## Плагины

| Плагин | Проблема | Решение | GitHub |
|--------|---------|---------|--------|
| [[utext\|UText]] | Ручной ввод и редактура текстов | AI генерирует и применяет текст к слоям | [figma-llm-plugin](https://github.com/uixray/figma-llm-plugin) |
| [[urenaing\|URenaming]] | Хаос в именах слоёв | Массовое переименование + AI-режим | TODO |
| [[udata\|UData]] | Lorem Ipsum везде | Реалистичные данные из пресетов | TODO |
| [[design-lint\|Design Lint]] | Непривязанные стили и цвета | Аудит всего файла за секунды | [design-lint](https://github.com/UIXRay/design-lint) |
| [[uvectorfinder\|UVectorFinder]] | Дублирующиеся иконки и пути | Геометрический поиск по fingerprint | [UVectorFinder](https://github.com/uixray/UVectorFinder) |

## AI-инфраструктура плагинов

Плагины UText, URenaming и UData используют [[../services/figma-ai-proxy|figma-ai-proxy]] как единый CORS-прокси для обращения к AI API. Все поддерживают следующих провайдеров: OpenAI, Claude, Gemini, Mistral, Groq, Yandex Cloud, LM Studio.
