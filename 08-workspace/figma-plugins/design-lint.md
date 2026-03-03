---
title: "Design Lint — Figma Design File Auditor"
type: guide
status: seed
version: "1.0.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "platform/figma"]
related_components: []
related_tokens: ["color-variables", "text-styles", "effect-styles"]
related_patterns: []
platforms: [web]
description: "Figma plugin for auditing design files: finds unlinked colors, typography inconsistencies, detached effects, and component override drift."
github: "https://github.com/UIXRay/design-lint"
---

# Design Lint

> Модульный аудитор дизайн-файлов для Figma.

**Версия:** 1.0.0 · **Лицензия:** MIT · [GitHub](https://github.com/UIXRay/design-lint)

---

## Зачем этот плагин

Дизайн-файл со временем засоряется: появляются жёсткие HEX-цвета вместо переменных, шрифты без привязки к стилям, тени без effect styles. Найти всё это вручную в большом файле — часы работы. Design Lint делает это за секунды.

---

## Что проверяет

### Typography Audit
- Находит все текстовые слои, группирует по семейству/стилю/размеру/интерлиньяжу
- Выявляет слои без привязки к text styles
- Массовая замена шрифтов по выборке

### Color Audit
- Обнаруживает захардкоженные fill/stroke цвета без привязки к переменным или стилям
- Группировка по HEX-значению
- Привязка к color variables или paint styles через поиск

### Effect Audit
- Находит тени (drop/inner) и блюры без effect styles
- Привязка к стилям одним кликом

### Override Detection
- Сканирует инстансы компонентов, сравнивает с мастер-компонентами
- Находит fill/stroke/effect/text style/image overrides
- Выборочный сброс нежелательных overrides

### Общие возможности
- **Scope control** — сканировать selection / страницу / весь документ
- **Non-blocking** — chunked DFS-обход с прогрессбаром, можно отменить
- **Bulk actions** — чекбоксы на каждый элемент + select-all
- **Export** — результат в Markdown или JSON в буфер обмена
- **Quick-launch** — команды меню для каждого режима сканирования

---

## Стек

| Слой | Технология |
|------|-----------|
| UI framework | Preact 10 |
| Язык | TypeScript 5.5 |
| Бандлер | esbuild 0.21 |
| Figma API | @figma/plugin-typings 1.100 |

Размер сборки: `code.js` ~22 KB, `ui.html` ~41 KB.

---

## Установка и разработка

```bash
git clone https://github.com/UIXRay/design-lint.git
cd design-lint
npm install
npm run build
```

В Figma: **Plugins → Development → Import plugin from manifest...** → выбрать `manifest.json`.

Режим наблюдения:
```bash
npm run watch
```

---

## Место в стеке

Design Lint — инструмент **качества**, не скорости. Используется перед хендовером разработчику или при аудите чужого файла. Работает независимо от других плагинов.

**Связанные инструменты:**
- [[utext|UText]] — после аудита шрифтов можно массово перегенерировать тексты
- [[uvectorfinder|UVectorFinder]] — аудит иконок на дубли
- [[../services/figma-ai-proxy|figma-ai-proxy]] — не используется (плагин без AI)
