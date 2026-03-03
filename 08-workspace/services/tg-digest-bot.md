---
title: "tg-digest-bot — Telegram Channel Digest Bot"
type: guide
status: seed
version: "1.0.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "category/services"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Personal Telegram bot that aggregates posts from channels and delivers AI-summarized digests on schedule."
github: "TODO"
---

# tg-digest-bot

> Персональный Telegram-бот для сбора и AI-суммаризации постов из каналов.

**Версия:** 1.0.0 · **GitHub:** TODO

---

## Зачем этот бот

Профессиональные Telegram-каналы генерируют 50-100 постов в день. Читать всё — невозможно, пропускать — нельзя. tg-digest-bot сам собирает посты из выбранных каналов, суммаризирует через AI и доставляет дайджест по расписанию.

Информация сама приходит к дизайнеру — не надо листать ленту.

---

## Возможности

- **Multi-channel collection** — подписка на произвольное количество каналов
- **AI summarization** — суммаризация через LM Studio (локально) или YandexGPT
- **Cron scheduling** — доставка дайджеста в заданное время (daily, weekly)
- **Channel filtering** — включить/выключить каналы по тегам или вручную
- **Telegram commands** — управление ботом через стандартные команды
- **Media indicators** — отметки о картинках/видео/документах в суммари
- **Context-aware onboarding** — умная настройка для новых пользователей

---

## Команды бота

| Команда | Действие |
|---------|---------|
| `/digest` | Получить дайджест прямо сейчас |
| `/channels` | Список отслеживаемых каналов |
| `/add @channel` | Добавить канал |
| `/remove @channel` | Убрать канал |
| `/schedule` | Настроить расписание |
| `/status` | Статус бота |

---

## Стек

| Компонент | Технология |
|----------|-----------|
| Runtime | Node.js / TypeScript 5.9 |
| Bot API | Telegraf 4.16 |
| Userbot (чтение каналов) | GramJS / MTProto |
| ORM | Prisma 6.19 |
| База данных | PostgreSQL 14+ |
| AI (локально) | LM Studio |
| AI (облако) | YandexGPT |
| Scheduler | node-cron 4.2 |

---

## Архитектура

```
Telegram каналы
    ↓ GramJS (MTProto / userbot)
Сборщик постов
    ↓
Prisma → PostgreSQL
    ↓
AI суммаризатор (LM Studio / YandexGPT)
    ↓
Telegraf (Bot API)
    ↓
Личные сообщения пользователю
```

---

## Roadmap

| Версия | Фича |
|--------|------|
| v1.0 | ✅ Multi-channel, AI summary, cron |
| v1.1 | RAG-поиск по истории постов |
| **v1.2** | **Интеграция с Obsidian vault** — автоматическое создание заметок из дайджестов |
| v2.0 | Multi-user поддержка |

**Obsidian-интеграция (v1.2):** посты из каналов автоматически попадут в `03-research/articles/` vault с правильным frontmatter — полностью закрывая цикл от информации к знаниям.

---

## Место в стеке

tg-digest-bot реализует принцип **"информация сама приходит"** из [[../philosophy/designer-as-creative-director|манифеста]]. Дизайнер не тратит время на чтение ленты — получает структурированный дайджест.

**Будущая связь с vault:**
- Дайджест → `03-research/articles/` через v1.2 интеграцию
- Связь с [[../../03-research/_index|Research section]]
