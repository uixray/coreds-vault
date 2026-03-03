# CLAUDE.md — CoreDS Vault

> Инструкция для Claude Code при работе с этим Obsidian vault.

## О проекте

CoreDS Vault — open-source Obsidian vault с двумя слоями:
- **01-design-system/** — токены (DTCG), компоненты, темы (Web/iOS/Android)
- **02-patterns/** — UX-паттерны, эвристики, AI patterns

Автор: Ray (@uixray), UI/UX дизайнер, 10+ лет опыта.

## Структура

```
00-meta/              Конвенции, глоссарий, inbox
00-meta/Inbox/        ← ВХОДЯЩИЕ: сюда Ray кидает сырые файлы для обработки
00-meta/archive/      Дубли и off-topic файлы (не удалять)
01-design-system/     Токены, компоненты, темы, ADR
  _spec/              ТЗ design system + патчи
  architecture/       ADR документы
  components/         Спецификации компонентов
  guides/             Гайды по цвету, токенам и т.д.
02-patterns/          UX-паттерны по категориям
  foundations/        Эвристики, законы UX, психология
  platform/           Android, iOS, Web guidelines
  interaction/        Формы, поиск, загрузка, ошибки
  ai/                 AI UX patterns
  domain/             SaaS, e-commerce
03-research/          Исследования
  deep-research/      DR-001..018 (deep research)
  articles/           Статьи, аналитика, бенчмарки
04-automation/        Скрипты, шаблоны, промпты
  prompts/            Системные промпты для AI
  prompts/fabric/     AI Pattern Fabric (238 промптов)
  scripts/            Автоматизация
  templates/          Шаблоны Obsidian Templater
  config/             freshness-rules.json и др.
05-tokens/            DTCG JSON (source of truth)
06-platforms/         Сгенерированные файлы платформ
  web/css/            CSS Custom Properties
  ios/swift/          Swift/SwiftUI
  android/kotlin/     Kotlin/Jetpack Compose
  flutter/            Experimental (не в основном roadmap)
07-figma/             Figma API docs, плагины, скрипты
  reference-docs/     Eagle API, Figma API документация
08-workspace/         Инструментальный стек дизайнера
  philosophy/         Манифест "Designer as Creative Director"
  figma-plugins/      Документация Figma-плагинов (UText, Design Lint и др.)
  services/           Бэкенд-сервисы (figma-ai-proxy, tg-digest-bot)
  system/             Системный уровень (DesignOps Assistant / AutoHotkey)
```

**Важно:** `00-meta/Inbox/CLAUDE.md` — этот файл. Не перемещать, не удалять.

## Команды

### Разобрать inbox

Когда Ray пишет "разбери inbox" или "обработай входящие":

1. Сканируй `00-meta/inbox/`
2. Для каждого файла:
   - Прочитай содержимое
   - Определи тип по содержанию (см. таблицу ниже)
   - Добавь YAML frontmatter в начало файла
   - Добавь wikilinks на связанные заметки в vault
   - Переименуй файл в kebab-case если нужно
   - Перенеси в целевую директорию
3. Выведи отчёт: что → куда, какие связи создал

### Таблица маршрутизации

| Содержание файла | type | Целевая директория |
|---|---|---|
| Результат Gemini/Claude research | research | `03-research/deep-research/` |
| Статья из интернета | research | `03-research/articles/` |
| Описание UX-паттерна | pattern | `02-patterns/{category}/{subcategory}/` |
| Описание компонента UI | component | `01-design-system/components/` |
| Архитектурное решение | adr | `01-design-system/architecture/` |
| Закон UX / психологии | law | `02-patterns/foundations/laws/` |
| Эвристика / набор принципов | heuristic | `02-patterns/foundations/heuristics/` |
| Accessibility-тема | pattern | `02-patterns/foundations/accessibility/` |
| Идея / заметка / TODO | meta | `00-meta/` (оставить, не перемещать) |
| Непонятно что | — | Спросить Ray |

### Определение category для паттернов

| Ключевые слова в тексте | category | subcategory |
|---|---|---|
| Nielsen, Norman, Tognazzini, heuristic, principle | foundations | heuristics/ |
| Fitts, Hick, Miller, закон, law, cognitive | foundations | laws/ или psychology/ |
| WCAG, accessibility, screen reader, contrast | foundations | accessibility/ |
| navigation, tab bar, sidebar, breadcrumb, back | platform | navigation/ |
| touch target, gesture, keyboard, input, picker | platform | input/ |
| grid, breakpoint, responsive, safe area, layout | platform | layout/ |
| iOS vs Android, divergence, convergence, platform | platform | platform-divergence/ |
| form, validation, multi-step, autosave | interaction | forms/ |
| search, filter, sort, results | interaction | search/ |
| loading, skeleton, spinner, progress, optimistic | interaction | loading/ |
| error, 404, 500, retry, fallback | interaction | error-handling/ |
| empty state, no results, first use | interaction | empty-states/ |
| toast, notification, snackbar, banner, alert | interaction | notifications/ |
| onboarding, welcome, tutorial, permission | interaction | onboarding/ |
| prompt, AI input, suggestion, template | ai | input/ |
| streaming, thinking, output, artifact, citation | ai | output/ |
| trust, badge, AI vs human, explainability | ai | trust/ |
| approval, undo, rollback, human-in-the-loop | ai | control/ |
| agent, delegation, multi-step, handoff, autonomy | ai | agentic/ |
| copilot, inline AI, AI-first, hybrid, mode switch | ai | hybrid/ |
| SaaS, dashboard, settings, billing | domain | saas-dashboard/ |
| e-commerce, product, cart, checkout | domain | ecommerce/ |

## Frontmatter стандарт

Добавляй в начало КАЖДОГО файла:

```yaml
---
title: "Название на английском"
type: pattern | component | token | adr | law | heuristic | research | guide | meta
category: foundations | platform | interaction | ai | domain
status: seed
version: "0.1.0"
created: YYYY-MM-DD
updated: YYYY-MM-DD
freshness: current
freshness_checked: YYYY-MM-DD
tags: []
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms: [web, iOS, Android]
---
```

### Правила заполнения

- **title** — осмысленное название на английском
- **status** — всегда `seed` для inbox файлов (Ray повысит позже)
- **tags** — иерархические: `#type/pattern`, `#category/ai`, `#platform/ios`
- **related_*** — wikilinks на СУЩЕСТВУЮЩИЕ файлы в vault. Проверяй что файл существует перед добавлением ссылки!
- **created** — дата из файла или сегодня
- **platforms** — определяй по содержанию, по умолчанию `[web, iOS, Android]`

## Поиск связей

При обработке файла ищи связи с существующими заметками:

1. Прочитай frontmatter всех `.md` файлов в `01-design-system/components/` и `02-patterns/`
2. Если inbox-файл упоминает существующий компонент/паттерн → добавь в `related_*`
3. Если inbox-файл требует нового компонента → добавь TODO в конец файла и упомяни в отчёте

## Другие команды

### "Проверь freshness" / "scan freshness"
Прочитай `04-automation/config/freshness-rules.json`, пройди по всем файлам, сравни `freshness_checked` с текущей датой. Выведи отчёт: stale / outdated файлы.

### "Проверь связи" / "check links"
Найди все `[[wikilinks]]` в vault, проверь что целевые файлы существуют. Найди файлы без входящих/исходящих связей.

### "Проверь библиотеку" / "audit library" / "health check"

Комплексная проверка состояния vault. Выполни поочерёдно:

**1. Freshness audit**
- Прочитай `04-automation/config/freshness-rules.json`
- Для каждого `.md` файла в vault: проверь `freshness_checked` vs сегодняшняя дата
- Правила по умолчанию (если файл не создан): AI-паттерны — 90 дней, платформы — 180, фундамент — 365
- Выведи список: stale (скоро устареет) / outdated (уже устарело)

**2. Link integrity**
- Найди все `[[wikilinks]]` во всех `.md` файлах
- Проверь что целевой файл существует в vault
- Выведи список битых ссылок с указанием файла-источника

**3. Orphan check**
- Найди все `.md` файлы без входящих ссылок (на них никто не ссылается)
- Исключить `_index.md`, `CLAUDE.md`, `conventions.md`, `about.md`, `roadmap.md`
- Выведи список "сиротских" файлов — кандидатов на удаление или интеграцию

**4. Missing frontmatter**
- Найди все `.md` файлы без YAML frontmatter (не начинаются с `---`)
- Выведи список: файл → предложенный тип

**5. Status distribution**
- Посчитай количество файлов по статусам: seed / draft / review / stable / deprecated
- Выведи как таблицу по разделам vault

**6. Missing _index.md**
- Проверь что каждая директория с `.md` файлами имеет `_index.md`
- Выведи список директорий без индекса

**Формат отчёта:**

```
## Library Health Report — YYYY-MM-DD

### Freshness Issues (N files)
🔴 outdated: [file] — последняя проверка: YYYY-MM-DD (N дней назад)
🟡 stale: [file] — последняя проверка: YYYY-MM-DD

### Broken Links (N links)
[source-file] → [[broken-target]]

### Orphan Files (N files)
[file] — нет входящих ссылок

### Missing Frontmatter (N files)
[file] → предложенный тип: research

### Status Distribution
| Раздел | seed | draft | review | stable | total |
|--------|------|-------|--------|--------|-------|

### Missing _index.md
[directory/]

## Рекомендации
1. Обновить freshness в N файлах
2. Исправить N битых ссылок
3. ...
```

### "Создай паттерн X" / "новый паттерн X"
Используй шаблон из `04-automation/templates/pattern.md`. Заполни по образцу `02-patterns/platform/navigation/tab-bar.md`.

### "Создай компонент X"
Используй шаблон из `04-automation/templates/component.md`.

### "Обработай research DR-XXX"
Прочитай файл из `03-research/deep-research/`, извлеки ключевые находки, предложи какие паттерны/компоненты/токены нужно создать или обновить.

## Формат ответов

- Язык: русский, термины дублировать на английском
- Комментарии в коде: на русском
- Код: TypeScript, полные рабочие блоки
- После каждого действия: краткий отчёт + предложения что дальше

## Что НЕ делать

- Не менять файлы в `05-tokens/` без явной команды Ray
- Не удалять файлы (только перемещать)
- Не менять `status` выше `seed` — это делает Ray
- Не трогать `.obsidian/` конфигурацию
- Не создавать файлы без frontmatter
