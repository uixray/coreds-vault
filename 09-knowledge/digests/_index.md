---
title: "Telegram Digests"
type: moc
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/moc", "source/telegram"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Auto-generated Telegram channel digests from tg-digest-bot."
---

# Telegram Digests

Автоматические дайджесты из Telegram-каналов, сгенерированные [tg-digest-bot](https://github.com/uixray/tg-digest-bot).

## Как пополняется

Команда `/export` в tg-digest-bot → GitHub API → этот раздел → `ds.uixray.tech` обновляется.

## Шаблон

→ [[04-automation/templates/digest|digest.md]]

## Дайджесты

```dataview
TABLE created, description
FROM "09-knowledge/digests"
WHERE type = "digest"
SORT created DESC
```
