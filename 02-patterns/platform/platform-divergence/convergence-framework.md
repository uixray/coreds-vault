---
title: "Convergence / Divergence Framework"
type: pattern
category: platform
status: seed
version: "0.1.0"
created: 2026-02-27
updated: 2026-02-27
freshness: current
freshness_checked: 2026-02-27
tags: [type/pattern, category/platform, framework]
platforms: [web, iOS, Android]
---

# Convergence / Divergence Framework

Фреймворк принятия решений: когда делать одинаково (converge), когда адаптировать (diverge).

## Converge (одинаково на всех платформах)

- Brand identity: логотип, цвета, tone of voice
- Information architecture: структура навигации
- Core user flows: ключевые сценарии
- Data models: бизнес-логика
- Design tokens: единый DTCG source of truth
- Content: одинаковый контент

## Diverge (адаптировать под платформу)

- Navigation pattern: tab bar vs sidebar vs drawer
- System controls: date pickers, alerts, action sheets
- Gestures: platform-specific
- Typography: system fonts, Dynamic Type
- Haptic feedback: platform APIs
- Notification patterns: platform conventions
- Settings / preferences: platform-standard locations
- Permissions: platform-specific flows

## Decision Matrix

| Решение | Вопрос | Converge | Diverge |
|---------|--------|----------|---------|
| Navigation | Пользователь ожидает платформенный паттерн? | Нет → converge | Да → diverge |
| Controls | Есть нативный эквивалент? | Нет → converge | Да → diverge |
| Визуал | Бренд важнее платформы? | Да → converge | Нет → diverge |
| Жесты | Платформа имеет уникальный жест? | Нет → converge | Да → diverge |

> **TODO:** Добавить примеры из реальных продуктов (Instagram, Telegram, Spotify)
