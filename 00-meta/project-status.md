---
title: "Project Status & Next Steps"
type: meta
status: seed
version: "0.1.0"
created: 2026-03-02
updated: 2026-03-02
freshness: current
freshness_checked: 2026-03-02
tags: ["type/meta", "status/active"]
platforms: [web, iOS, Android]
description: "Current state of the CoreDS Vault after inbox cleanup, outstanding decisions, and instructions for future Claude sessions."
---

# CoreDS Vault — Project Status

> **Дата последнего обновления:** 2026-03-02
> **Версия:** v0.1.0 (post-inbox-cleanup)
> **Автор:** Ray (@uixray)

---

## Текущее состояние

### Что сделано (2026-03-02)

Выполнена полная систематизация `00-meta/Inbox/` — ~150 файлов разобраны, переименованы, размечены frontmatter и перемещены по разделам vault.

| Раздел | Файлов перемещено | Примечание |
|--------|------------------|-----------|
| `03-research/articles/` | ~20 | Исследования рынка, аналитика |
| `03-research/deep-research/` | 4 | DR-001, DR-004, DR-005, DR-008 |
| `04-automation/prompts/` | ~15 | Системные промпты, AI-инструкции |
| `04-automation/prompts/fabric/` | 238 | AI Pattern Fabric (Fabric project) |
| `07-figma/` | ~18 | API docs, плагины, ссылки |
| `01-design-system/` | ~8 | Spec, guides, патч |
| `02-patterns/platform/` | ~5 | Android/iOS/Web guidelines |
| `00-meta/` | ~10 | Карьера, гайды, персональное |
| `00-meta/archive/` | ~35 | Дубли + off-topic |
| `06-platforms/flutter/` | 1 | Flutter Profile screen docs |

**Что также сделано:**
- Все файлы переименованы в English kebab-case
- Все `.md` файлы получили YAML frontmatter (`status: seed`)
- Созданы `_index.md` (MOC) для 7 разделов
- Русские папки переименованы: `Гайды/` → `guides/`, `Гайд по карьере/` → `career-designops/`
- Очищены пустые папки

---

## Пункт 1: Ревизия архива

Папка `00-meta/archive/` содержит **35 файлов** двух типов:

### Дубли (`_dup` суффикс) — безопасно игнорировать

Это вторые копии файлов, которые существуют в правильных разделах vault. Оригиналы находятся по указанным путям:

| Файл в archive | Оригинал |
|---------------|---------|
| `android-design-guidelines_dup.md` | `02-patterns/platform/android-design-guidelines.md` |
| `ios-human-interface-guidelines_dup.md` | `02-patterns/platform/ios-human-interface-guidelines.md` |
| `web-design-guidelines_dup.md` | `02-patterns/platform/web-design-guidelines.md` |
| `cross-platform-design-evaluation-system_dup.md` | `02-patterns/platform/cross-platform-design-evaluation-system.md` |
| `figma-plugin-api-reference_dup.md` | `07-figma/figma-plugin-api-reference.md` |
| `figma-variables-api-reference_dup.md` | `07-figma/figma-variables-api-reference.md` |
| `eagle-plugin-api-docs_dup.md` | `07-figma/eagle-plugin-api-docs.md` |
| `uvectorfinder-tz_dup.md` | `07-figma/uvectorfinder-spec.md` |
| `unified-design-system-master_dup.md` | `01-design-system/unified-design-system-master.md` |
| `cross-platform-design-system_dup.md` | `01-design-system/cross-platform-design-system.md` |
| `design-system-foundation_dup.md` | `01-design-system/design-system-foundation.md` |
| `ecosystem-plan_pe_dup.md` | `04-automation/ecosystem-plan.md` |
| `rays-ecosystem-plan_dup.md` | `04-automation/ecosystem-plan.md` (то же) |
| `designops-guide_dup.md` | `00-meta/designops-guide.md` |
| `uiux-designer-guide_dup.md` | `00-meta/ui-ux-designer-guide.md` |
| `gemini-deep-research-prompts_ds_dup.md` | `04-automation/prompts/gemini-deep-research-prompts.md` |
| `optimal-ux-reference-library-eagle_dup.md` | `03-research/articles/optimal-ux-reference-library-eagle.md` |
| `a1-basic-utilities-specs_dup.md` | `04-automation/a1-basic-utilities-specs.md` |
| `a2-advanced-utilities-specs_dup.md` | `04-automation/a2-advanced-utilities-specs.md` |
| `e1-figma-plugin-boilerplate_dup.md` | `04-automation/e1-figma-plugin-boilerplate.md` |
| `android-design-guide_dup.md` | `02-patterns/platform/android-design-guidelines.md` |
| `android-design-guidelines_guides_dup.md` | то же |
| `ios-human-interface-guidelines_guides_dup.md` | то же |
| `cross-platform-design-evaluation-system_guides_dup.md` | то же |
| `CLAUDE_design_system_dup.md` | `00-meta/Inbox/CLAUDE.md` |

> **Решение Ray:** Дубли можно удалить вручную из Obsidian в любое время. Claude их не трогает (правило "не удалять").

### Off-topic файлы — на усмотрение Ray

| Файл | Содержание | Рекомендация |
|------|-----------|-------------|
| `harry-potter-slytherin-17th-century.md` | Личная заметка | Удалить |
| `fast-food-prices-russia-analysis.md` | Анализ цен на фастфуд | Удалить |
| `sochi-cost-of-living-analysis-2025.md` | Анализ стоимости жизни | Удалить |
| `internet-blocking-bypass-whitelist.md` | VPN/прокси | Удалить |
| `jazz-intro-blender.md` | Blender-туториал | Удалить |
| `concert-video-editing-davinci-resolve-20.md` | DaVinci Resolve | Удалить |
| `spatial-audio-game-service-spec.md` | ТЗ для игрового сервиса | Удалить или сохранить как идею |
| `youtube-shorts-autoscroller-results.md` | Итоги пет-проекта | Переместить в личный vault |
| `client-negotiations-book-notes.txt` | Конспект книги | Переместить в личный vault |

---

## Пункт 2: `coreds-spec-patch-v0.2.md` — статус и рекомендации

**Файл:** `01-design-system/_spec/coreds-spec-patch-v0.2.md`
**Дата патча:** 2026-02-26
**Статус:** Полностью актуален и критически важен.

### Что описывает патч

Патч описывает **миграцию из отдельного репозитория `uixray/coreds` в единый Obsidian vault** — именно то, что сейчас реализовано. Это не устаревший документ, а **руководство по развитию**.

### Ключевые решения из патча (требуют реализации)

| Решение | Статус | Приоритет |
|---------|--------|-----------|
| `related_patterns` в frontmatter компонентов | Поле добавлено в стандарт | ✅ Готово |
| DR-012..018 в research backlog | Не созданы | P0 |
| AI-компоненты: `PromptInput`, `StreamingText` и др. | Не созданы | P1 |
| `freshness-rules.json` + токены/компоненты/архитектура | Не создан | P1 |
| `link-integrity.ts` скрипт | Не создан | P2 |
| Dataview dashboards в `_index.md` | Не добавлены | P2 |
| Двойная лицензия: MIT + CC BY-SA 4.0 | Не создана | P1 |
| Obsidian шаблоны Templater | Не созданы | P1 |

### Рекомендация

**Не удалять патч.** Объединить содержимое патча с основным spec в ходе работы над v0.2.0:

```
01-design-system/_spec/
├── design-system-spec.md        ← основной spec (v0.1.0)
├── coreds-spec-patch-v0.2.md    ← патч → будет слит в spec при v0.2.0
└── changelog.md                 ← создать при v0.2.0
```

**Следующий шаг:** При старте работы над v0.2.0 создать `design-system-spec-v0.2.md`, слив spec + патч в единый документ.

---

## Пункт 3: Flutter — платформенная стратегия

**Контекст:** В `06-platforms/flutter/` находится `profile-screen-flutter-docs-example.md` — сгенерированный через Claude + Figma MCP пример документации для Flutter.

### Текущее состояние

Текущий spec (v0.1.0) определяет три платформы:
- `06-platforms/web/css/` — CSS Custom Properties
- `06-platforms/ios/swift/` — Swift/SwiftUI
- `06-platforms/android/kotlin/` — Kotlin/Jetpack Compose

Flutter **не упоминается** в spec, но папка создана де-факто.

### Варианты решений

| Вариант | Плюсы | Минусы |
|---------|-------|--------|
| **A. Добавить Flutter как 4-ю платформу** | Dart-токены автоматически генерируются Style Dictionary; охватывает Flutter-команды | Увеличивает объём работы; Flutter использует Material Design |
| **B. Flutter как отдельный community layer** | Не ломает основной CoreDS; можно добавить позже | Нет официальной поддержки в v1.0 |
| **C. Исключить Flutter, удалить папку** | Уменьшает сложность; фокус на трёх платформах | Теряем уже имеющийся материал |

### Рекомендация

**Вариант B.** Оставить `06-platforms/flutter/` как **experimental / community** раздел. Не включать в основной roadmap до v1.0. При желании добавить ADR:

```
01-design-system/architecture/ADR-flutter-platform.md
```

**Для Ray:** Если планируется активная работа с Flutter-приложениями, стоит добавить Flutter в официальный список платформ в _spec при v0.2.0.

---

## Пункт 4: Команда "разбери inbox" — статус

### Где находится CLAUDE.md

```
00-meta/Inbox/CLAUDE.md     ← ОСНОВНОЙ файл инструкций
```

Файл **загружается автоматически** Claude Code при работе в этом vault (если Claude Code запущен из директории vault или путь указан в проекте).

### Как убедиться что команда работает

В будущих сессиях напиши:

> "разбери inbox" или "обработай входящие"

Claude должен:
1. Сканировать `00-meta/Inbox/` на новые файлы
2. Для каждого файла: определить тип → добавить frontmatter → переименовать → переместить
3. Вывести отчёт

### Важные правила (напоминание)

- `status` всегда `seed` — Ray повышает вручную
- Не удалять файлы — только перемещать
- Не трогать `05-tokens/` без явной команды
- Не трогать `.obsidian/`
- Добавлять `related_*` только на СУЩЕСТВУЮЩИЕ файлы

---

## Пункт 5: Новая команда "проверь библиотеку"

Описание команды добавлено в `CLAUDE.md` (см. раздел "Другие команды").

**Что делает команда:**

1. **Freshness audit** — сравнивает `freshness_checked` с текущей датой по правилам `04-automation/config/freshness-rules.json`
2. **Link integrity** — проверяет все `[[wikilinks]]` на существование целевых файлов
3. **Orphan check** — находит файлы без входящих ссылок
4. **Missing frontmatter** — находит `.md` файлы без YAML frontmatter
5. **Status distribution** — считает сколько файлов в каждом статусе (seed/draft/review/stable)
6. **Empty sections** — проверяет что все директории имеют `_index.md`

**Вывод:** Отчёт в консоль + предложения что обновить.

---

## Backlog — что делать дальше

### Приоритет P0 (следующий спринт — v0.2.0)

- [ ] Создать DR-012..018 в `03-research/deep-research/` (по шаблону DR-001)
- [ ] Создать `04-automation/config/freshness-rules.json` с правилами для всех типов
- [ ] Создать шаблоны Templater: `04-automation/templates/pattern.md`, `component.md`, `adr.md`
- [ ] Написать первые ADR: token architecture, theming strategy, naming conventions

### Приоритет P1 (v0.2.0 — v0.3.0)

- [ ] Создать `LICENSE-CODE.md` (MIT) и `LICENSE-CONTENT.md` (CC BY-SA 4.0)
- [ ] Создать `README.md` в корне vault для GitHub
- [ ] Добавить Dataview dashboards в `01-design-system/components/_index.md`
- [ ] Создать первые паттерны в `02-patterns/foundations/` (из DR-001: naming conventions)
- [ ] Добавить freshness rules для tokens + components в `freshness-rules.json`
- [ ] Начать работу с `05-tokens/` — базовая структура DTCG JSON

### Приоритет P2 (v0.3.0+)

- [ ] Слить `design-system-spec.md` + `coreds-spec-patch-v0.2.md` → `design-system-spec-v0.2.md`
- [ ] Создать `04-automation/scripts/link-integrity.ts`
- [ ] AI-компоненты backlog: `PromptInput`, `StreamingText`, `ThinkingIndicator` и др.
- [ ] Принять решение по Flutter как официальной платформе

### Чего не хватает (gaps)

| Что | Где должно быть |
|-----|----------------|
| Шаблоны Templater | `04-automation/templates/` — пусто |
| freshness-rules.json | `04-automation/config/` — не создан |
| Первые ADR | `01-design-system/architecture/` — пусто |
| Первые токены DTCG | `05-tokens/` — пусто |
| Паттерны foundations | `02-patterns/foundations/` — пусто |
| CHANGELOG.md | Корень vault — не создан |
| README.md (GitHub) | Корень vault — не создан |

---

## Ссылки

- [[00-meta/conventions|Конвенции оформления]]
- [[00-meta/roadmap|Дорожная карта]]
- [[01-design-system/_spec/design-system-spec|ТЗ Design System v0.1.0]]
- [[01-design-system/_spec/coreds-spec-patch-v0.2|Патч v0.2.0]]
- [[00-meta/Inbox/CLAUDE|Инструкции для Claude Code]]
