---
title: "Токены"
type: moc
created: 2026-02-27
updated: 2026-02-27
---

# 🎯 Design Tokens

## Категории

| Категория | Описание | Статус |
|-----------|----------|--------|
| [[color|Color]] | Цветовая система (primitives + semantic) | 🌱 seed |
| [[typography|Typography]] | Типографическая шкала | 🌱 seed |
| [[spacing|Spacing]] | Отступы и промежутки | 🌱 seed |
| [[elevation|Elevation]] | Тени и глубина | 🌱 seed |
| [[motion|Motion]] | Анимация (duration + easing) | 🌱 seed |
| [[platform-mapping|Platform Mapping]] | Маппинг на CSS / Swift / Kotlin | 🌱 seed |

## Архитектура

```
Component Tokens → button.bg.default    → {color.action.primary}
Semantic Tokens  → color.action.primary → {color.blue.600}
Primitive Tokens → color.blue.600       → #2563EB
```
