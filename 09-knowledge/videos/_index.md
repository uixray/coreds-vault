---
title: "Video Transcripts"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "source/video"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Transcripts and notes from design talks, conference presentations, and lectures."
---

# Video Transcripts

Расшифровки и конспекты докладов, конференций и видео-лекций.

## Как пополняется

- **AI-транскрипция**: YouTube URL → Whisper / Gemini → структурированный конспект
- **Ручная обработка**: смотришь доклад → заполняешь шаблон `video.md`
- **Экспорт субтитров**: YouTube → скачать `.srt` → AI форматирует по шаблону

## Основные источники

- YouTube: Google I/O, Apple WWDC, Figma Config, Material Design talks
- Confs: SmashingConf, UX Matters, Awwwards
- Courses: Figma Academy, Reforge, NNGroup

## Шаблон

→ [[04-automation/templates/video|video.md]]

## Доклады

```dataview
TABLE speaker, event, source_date, description
FROM "09-knowledge/videos"
WHERE type = "video"
SORT source_date DESC
```
