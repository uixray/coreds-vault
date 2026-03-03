---
title: "Workspace — Designer Tooling & Philosophy"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "category/tools", "category/automation"]
platforms: [web, iOS, Android]
description: "Map of Content for the personal designer tooling stack: philosophy, Figma plugins, services, and system tools."
---

# 08-workspace — Инструментальный стек дизайнера

> Дизайнер максимально отвязан от рутины и занимается верхнеуровневым проектированием.

Этот раздел документирует персональный инструментальный стек Ray (@uixray) — плагины, сервисы и скрипты, которые реализуют философию автоматизации дизайна.

**Начни отсюда:** [[08-workspace/philosophy/designer-as-creative-director|Designer as Creative Director]] — манифест, объясняющий зачем всё это.

---

## Каталог инструментов

### Figma плагины

| Инструмент | Назначение | GitHub | Статус |
|-----------|-----------|--------|--------|
| [[08-workspace/figma-plugins/utext\|UText]] | AI генерация текста, переименование слоёв | [figma-llm-plugin](https://github.com/uixray/figma-llm-plugin) | Опубликован |
| [[08-workspace/figma-plugins/urenaing\|URenaming]] | Массовое переименование (BEM, AI-режим) | TODO | В разработке |
| [[08-workspace/figma-plugins/udata\|UData]] | Пресеты реалистичных данных | TODO | В разработке |
| [[08-workspace/figma-plugins/design-lint\|Design Lint]] | Аудит: цвета, шрифты, overrides | [design-lint](https://github.com/UIXRay/design-lint) | v1.0.0 |
| [[08-workspace/figma-plugins/uvectorfinder\|UVectorFinder]] | Поиск дублей векторов | [UVectorFinder](https://github.com/uixray/UVectorFinder) | v1.0.0 |

### Сервисы и бэкенд

| Инструмент | Назначение | GitHub | Статус |
|-----------|-----------|--------|--------|
| [[08-workspace/services/figma-ai-proxy\|figma-ai-proxy]] | CORS прокси для AI API (production) | [figma-ai-proxy](https://github.com/uixray/figma-ai-proxy) | v2.0.0 |
| [[08-workspace/services/tg-digest-bot\|tg-digest-bot]] | Telegram дайджест каналов с AI | TODO | v1.0.0 |
| [[08-workspace/services/ai-design-ops\|AI Design Ops]] | Мульти-агентный Python оркестратор | TODO | Experimental |

### Системный уровень

| Инструмент | Назначение | GitHub | Статус |
|-----------|-----------|--------|--------|
| [[08-workspace/system/designops-assistant\|DesignOps Assistant]] | AI + типографика через хоткеи (Windows) | TODO | Stable |

---

## Архитектура стека

```
OS → DesignOps Assistant (AHK)    AI везде в любом приложении
   ↓
Figma → Плагины                   Автоматизация внутри дизайн-инструмента
   ↓
Infrastructure → figma-ai-proxy    Единый прокси для всех AI-провайдеров
   ↓
Data → tg-digest-bot               Информация сама приходит из каналов
     → AI Design Ops               Мульти-агентные исследовательские задачи
```

---

## Связанные разделы vault

- [[08-workspace/philosophy/designer-as-creative-director|Философия]] — зачем всё это
- [[04-automation/prompts/_index|Промпты]] — AI-промпты для автоматизации
- [[01-design-system/_index|Design System]] — компоненты и токены
- [[02-patterns/_index|Pattern Library]] — UX паттерны
