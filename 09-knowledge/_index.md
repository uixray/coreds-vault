---
title: "Knowledge Base"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "section/knowledge"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Curated information inputs: digests, web clippings, books, and video transcripts for analysis and study."
---

# Knowledge Base

Информационная база знаний — раздел для хранения и анализа потребляемого контента.

В отличие от [[03-research/_index|Research]] (результаты исследований), здесь хранятся **входящие материалы**: то, что Ray читает, смотрит и изучает.

## Структура

| Раздел | Источник | Наполнение |
|---|---|---|
| [[digests/_index\|Digests]] | tg-digest-bot | Автоматические дайджесты Telegram-каналов |
| [[clippings/_index\|Clippings]] | Web Clipper | Сохранённые статьи и публикации |
| [[books/_index\|Books]] | Ручной ввод / AI | Конспекты и заметки по книгам |
| [[videos/_index\|Videos]] | AI транскрипция | Расшифровки докладов и конференций |

## Типы контента

```
digest   → Telegram digest (auto, tg-digest-bot)
clipping → Сохранённая статья (web clipper)
book     → Конспект книги
video    → Расшифровка видео / доклада
```

## Связанные разделы

- [[03-research/_index|Research]] — результаты ресёрчей и анализа
- [[02-patterns/_index|Patterns]] — UX паттерны, выведенные из изученных материалов
- [[04-automation/templates|Templates]] — шаблоны для добавления нового контента

## Датавью

```dataview
TABLE type, created, description
FROM "09-knowledge"
WHERE type != "moc"
SORT created DESC
LIMIT 20
```
