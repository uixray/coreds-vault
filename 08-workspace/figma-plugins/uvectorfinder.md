---
title: "UVectorFinder — Duplicate Vector Detection"
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
description: "Figma plugin for finding and managing geometrically identical vector nodes regardless of position, scale, name, or layer structure."
github: "https://github.com/uixray/UVectorFinder"
---

# UVectorFinder

> Поиск и управление геометрически идентичными векторами в Figma.

**Версия:** 1.0.0 · **Лицензия:** MIT · [GitHub](https://github.com/uixray/UVectorFinder)

---

## Зачем этот плагин

В больших дизайн-файлах одна иконка может существовать в десятках копий — немного растянутая, перевёрнутая, переименованная, без связи с компонентом. Это засоряет файл и создаёт проблемы при обновлении. UVectorFinder находит такие копии через анализ геометрии SVG-путей — независимо от позиции, масштаба, имени слоя или структуры.

---

## Возможности

- **Full scan** — весь файл / страница / фрейм / секция
- **Selection mode** — найти дубли только среди выбранных элементов
- **Tolerance control** — exact / pixel / relaxed / loose (насколько похожи пути)
- **Cross-page navigation** — переход к найденным элементам на других страницах
- **Persistent settings** — настройки сохраняются между сессиями

---

## Алгоритм (6 стадий)

```
Collect → Extract → Parse → Normalize → Fingerprint → Cluster
```

1. **Collect** — обход дерева нод, сбор vector-нод
2. **Extract** — извлечение SVG path geometry
3. **Parse** — разбор path commands (M, L, C, Q, A, Z)
4. **Normalize** — нормализация к единичному bounding box (position/scale инвариантность)
5. **Fingerprint** — создание строкового хеша нормализованного пути
6. **Cluster** — группировка по совпадающим fingerprint'ам

23 unit-теста покрывают parsing, normalization и fingerprinting.

---

## Режимы поиска

| Режим | Область |
|-------|---------|
| Selection | Только выделенные элементы |
| Frame/Section | Текущий выбранный фрейм |
| Current Page | Текущая страница |
| Entire File | Весь документ (может быть медленным на больших файлах) |

---

## Стек

| Слой | Технология |
|------|-----------|
| Язык | TypeScript 5.3 |
| Бандлер | tsup |
| Тесты | Jest 29.7 (23 unit tests) |
| Figma API | @figma/plugin-typings |

---

## Место в стеке

Используется при:
- Чистке старых файлов от накопленных копий иконок
- Аудите перед хендовером разработчику
- Объединении нескольких файлов в один

**Связанные инструменты:**
- [[design-lint|Design Lint]] — другой аудитор, проверяет стили и overrides
