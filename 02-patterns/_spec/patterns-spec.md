---
title: "Pattern Library Specification"
type: "adr"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/adr"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Technical specification for the CoreDS pattern library"
---

# Техническое задание: UX Pattern Library «CoreDS Patterns»

> **Версия документа:** 0.1.0-draft
> **Автор:** Ray (@uixray)
> **Дата:** 2026-02-26
> **Назначение:** ТЗ для Claude Code — создание обновляемой Obsidian-библиотеки UX-паттернов
> **Связанный проект:** CoreDS (design-system-spec.md)
> **Лицензия:** CC BY-SA 4.0 (контент) + MIT (скрипты автоматизации)

---

## Содержание

1. [Обзор проекта](#1-обзор-проекта)
2. [Единая Obsidian Vault архитектура](#2-единая-obsidian-vault-архитектура)
3. [Фаза 0 — Инициализация vault](#3-фаза-0--инициализация-vault)
4. [Фаза 1 — Foundations: эвристики и принципы](#4-фаза-1--foundations)
5. [Фаза 2 — Platform Patterns: кроссплатформенные паттерны](#5-фаза-2--platform-patterns)
6. [Фаза 3 — Interaction Patterns: паттерны взаимодействия](#6-фаза-3--interaction-patterns)
7. [Фаза 4 — AI Patterns: паттерны человек-ИИ](#7-фаза-4--ai-patterns)
8. [Фаза 5 — Domain Patterns: доменные паттерны](#8-фаза-5--domain-patterns)
9. [Фаза 6 — Автоматизация обновлений](#9-фаза-6--автоматизация-обновлений)
10. [Связь с CoreDS](#10-связь-с-coreds)
11. [Приложения](#11-приложения)

---

## 1. Обзор проекта

### 1.1. Что это

Обновляемая open-source Obsidian-библиотека UX-паттернов, эвристик и принципов проектирования кроссплатформенных цифровых продуктов. Включает классическое человеко-компьютерное взаимодействие (HCI) и новые паттерны взаимодействия с ИИ.

### 1.2. Ключевые отличия от обычной документации

- **Живая (living)** — периодически сканируется ИИ, сравнивается с новыми исследованиями, обновляется
- **Связанная (connected)** — каждый паттерн ссылается на конкретные компоненты и токены CoreDS
- **Двунаправленная (bidirectional)** — паттерны информируют компоненты, компоненты реализуют паттерны
- **Sharable** — публикуется на GitHub как Obsidian vault, доступна community

### 1.3. Целевая аудитория

| Аудитория | Что получает |
|-----------|-------------|
| **Дизайнеры** | Справочник паттернов с платформенными адаптациями и Figma-примерами |
| **Разработчики** | Спецификации поведения, accessibility requirements, связь с токенами |
| **Продукт-менеджеры** | Обоснования решений через эвристики и исследования |
| **Сам автор (Ray)** | Накопительная база знаний, ускоряющая работу над клиентскими проектами |

### 1.4. Принципы библиотеки

- **Practice over theory** — каждый паттерн привязан к конкретному UI-решению
- **Platform-aware** — паттерны учитывают различия web / iOS / Android
- **Evidence-based** — ссылки на исследования, не мнения
- **AI-updatable** — структура позволяет ИИ находить, оценивать и обновлять контент
- **Human-curated** — ИИ предлагает обновления, человек подтверждает

---

## 2. Единая Obsidian Vault архитектура

### 2.1. Монорепозиторий

Оба проекта (CoreDS + Patterns) живут в **одном** Obsidian vault и одном Git-репозитории:

```
coreds-vault/                          # Obsidian vault = Git repo
├── .obsidian/                         # Настройки Obsidian
│   ├── plugins/                       # Community plugins
│   ├── themes/                        # Тема оформления
│   ├── templates/                     # Шаблоны Obsidian Templater
│   └── workspace.json
│
├── README.md                          # GitHub README
├── LICENSE-CODE.md                    # MIT для кода
├── LICENSE-CONTENT.md                 # CC BY-SA 4.0 для контента
├── CHANGELOG.md
├── CONTRIBUTING.md
│
├── 00-meta/                           # Мета-информация vault
│   ├── about.md                       # О проекте
│   ├── roadmap.md                     # Дорожная карта
│   ├── glossary.md                    # Глоссарий терминов
│   ├── conventions.md                 # Соглашения по оформлению заметок
│   └── how-to-contribute.md
│
├── 01-design-system/                  # === CoreDS (ТЗ #1) ===
│   ├── _spec/                         # Техническое задание
│   │   └── design-system-spec.md
│   ├── architecture/                  # ADR и архитектурные решения
│   │   ├── ADR-001-reference-audit.md
│   │   ├── ADR-003-naming-convention.md
│   │   └── ...
│   ├── tokens/                        # Документация токенов
│   │   ├── color.md
│   │   ├── typography.md
│   │   ├── spacing.md
│   │   ├── elevation.md
│   │   ├── motion.md
│   │   └── platform-mapping.md
│   ├── components/                    # Спецификации компонентов
│   │   ├── _index.md                  # MOC (Map of Content)
│   │   ├── button.md
│   │   ├── input.md
│   │   └── ...
│   ├── themes/                        # Документация тематизации
│   │   ├── theme-contract.md
│   │   └── creating-a-theme.md
│   └── guides/                        # Практические гайды
│       ├── for-designers.md
│       ├── for-developers.md
│       └── accessibility-checklist.md
│
├── 02-patterns/                       # === Pattern Library (ТЗ #2) ===
│   ├── _index.md                      # MOC всех паттернов
│   ├── _spec/
│   │   └── patterns-spec.md           # Это ТЗ
│   │
│   ├── foundations/                    # Фундаментальные принципы
│   │   ├── _index.md
│   │   ├── heuristics/
│   │   │   ├── nielsen-10.md
│   │   │   ├── tognazzini-principles.md
│   │   │   └── shneiderman-rules.md
│   │   ├── laws/
│   │   │   ├── fitts-law.md
│   │   │   ├── hicks-law.md
│   │   │   ├── millers-law.md
│   │   │   └── ...
│   │   ├── psychology/
│   │   │   ├── cognitive-load.md
│   │   │   ├── gestalt-principles.md
│   │   │   └── mental-models.md
│   │   └── accessibility/
│   │       ├── wcag-overview.md
│   │       ├── cognitive-accessibility.md
│   │       └── motor-accessibility.md
│   │
│   ├── platform/                      # Кроссплатформенные паттерны
│   │   ├── _index.md
│   │   ├── navigation/
│   │   │   ├── tab-bar.md
│   │   │   ├── sidebar-navigation.md
│   │   │   ├── bottom-navigation.md
│   │   │   ├── breadcrumbs.md
│   │   │   └── back-navigation.md
│   │   ├── input/
│   │   │   ├── touch-targets.md
│   │   │   ├── gesture-vocabulary.md
│   │   │   ├── keyboard-types.md
│   │   │   └── text-selection.md
│   │   ├── layout/
│   │   │   ├── responsive-vs-adaptive.md
│   │   │   ├── safe-areas.md
│   │   │   ├── grid-systems.md
│   │   │   └── breakpoints.md
│   │   ├── feedback/
│   │   │   ├── haptic-feedback.md
│   │   │   ├── visual-feedback.md
│   │   │   └── audio-feedback.md
│   │   └── platform-divergence/
│   │       ├── convergence-framework.md
│   │       ├── ios-vs-android-matrix.md
│   │       └── web-vs-native-matrix.md
│   │
│   ├── interaction/                   # Паттерны взаимодействия
│   │   ├── _index.md
│   │   ├── forms/
│   │   ├── search/
│   │   ├── data-display/
│   │   ├── onboarding/
│   │   ├── empty-states/
│   │   ├── error-handling/
│   │   ├── loading/
│   │   └── notifications/
│   │
│   ├── ai/                            # AI Interaction Patterns
│   │   ├── _index.md
│   │   ├── input/
│   │   │   ├── blank-prompt.md
│   │   │   ├── prompt-suggestions.md
│   │   │   ├── contextual-ai.md
│   │   │   ├── scoping.md
│   │   │   └── prompt-templates.md
│   │   ├── output/
│   │   │   ├── streaming-text.md
│   │   │   ├── progressive-disclosure.md
│   │   │   ├── confidence-indicators.md
│   │   │   ├── source-attribution.md
│   │   │   └── regenerate-edit.md
│   │   ├── trust/
│   │   │   ├── ai-vs-human-badge.md
│   │   │   ├── explainability.md
│   │   │   └── transparency-framework.md
│   │   ├── control/
│   │   │   ├── human-in-the-loop.md
│   │   │   ├── undo-rollback.md
│   │   │   └── approval-workflows.md
│   │   ├── agentic/
│   │   │   ├── delegation-patterns.md
│   │   │   ├── multi-step-tasks.md
│   │   │   ├── agent-handoff.md
│   │   │   └── autonomy-levels.md
│   │   └── hybrid/
│   │       ├── ai-copilot-sidebar.md
│   │       ├── ai-inline-enhancement.md
│   │       └── ai-first-interface.md
│   │
│   └── domain/                        # Доменные паттерны
│       ├── _index.md
│       ├── ecommerce/
│       ├── saas-dashboard/
│       ├── content-platform/
│       └── social/
│
├── 03-research/                       # Исследования и источники
│   ├── _index.md
│   ├── deep-research/                 # Результаты deep research (Gemini, etc.)
│   │   ├── DR-001-naming-conventions.md
│   │   ├── DR-004-dtcg-spec.md
│   │   └── ...
│   ├── papers/                        # Академические статьи
│   ├── articles/                      # Статьи из индустрии
│   └── benchmarks/                    # Бенчмарки и аудиты DS
│
├── 04-automation/                     # Скрипты и конфигурации
│   ├── scripts/
│   │   ├── build-tokens.ts
│   │   ├── validate-tokens.ts
│   │   ├── validate-theme.ts
│   │   ├── generate-token-docs.ts
│   │   ├── scan-freshness.ts          # Проверка актуальности паттернов
│   │   ├── generate-changelog.ts
│   │   └── link-integrity.ts          # Проверка внутренних ссылок
│   ├── config/
│   │   ├── style-dictionary/
│   │   │   └── config.ts
│   │   └── freshness-rules.json       # Правила проверки актуальности
│   └── templates/                     # Obsidian Templater шаблоны
│       ├── pattern.md
│       ├── component.md
│       ├── adr.md
│       ├── research.md
│       └── law.md
│
├── 05-tokens/                         # Исходные файлы токенов (DTCG JSON)
│   ├── core/
│   ├── semantic/
│   ├── component/
│   └── themes/
│
├── 06-platforms/                      # Сгенерированные платформенные файлы
│   ├── web/css/
│   ├── ios/swift/
│   └── android/kotlin/
│
└── 07-figma/                          # Figma-связанные материалы
    ├── README.md
    └── scripts/
```

### 2.2. Соглашения Obsidian (Obsidian Conventions)

#### Frontmatter стандарт

Каждый `.md` файл начинается с YAML frontmatter:

```yaml
---
title: "Название заметки"
type: pattern | component | token | adr | law | heuristic | research | guide
category: foundations | platform | interaction | ai | domain
status: seed | draft | review | stable | deprecated
version: "1.0.0"
created: 2026-02-26
updated: 2026-02-26
freshness: current | stale | outdated     # Для автоматической проверки
freshness_checked: 2026-02-26             # Дата последней проверки
tags:
  - navigation
  - cross-platform
  - iOS
  - Android
related_components:                        # Связь с CoreDS
  - "[[button]]"
  - "[[tab-bar]]"
related_tokens:
  - "[[spacing]]"
  - "[[color]]"
related_patterns:
  - "[[back-navigation]]"
related_heuristics:
  - "[[nielsen-10#consistency]]"
platforms:
  - web
  - iOS
  - Android
---
```

#### Статусы (Status lifecycle)

```
seed → draft → review → stable → deprecated
  │                        │
  └── Создана заметка      └── Проверена, актуальна
       с минимальным            полное содержание
       содержанием              + ревью
```

#### Внутренние ссылки (Wikilinks)

- Между паттернами: `[[tab-bar]]`
- На компоненты DS: `[[01-design-system/components/button|Button]]`
- На токены: `[[01-design-system/tokens/spacing|Spacing tokens]]`
- На исследования: `[[03-research/deep-research/DR-001-naming-conventions|DR-001]]`

#### Теги (Tags)

Иерархические теги через `/`:

```
#type/pattern
#type/component
#type/heuristic
#type/law
#category/ai
#category/platform
#category/interaction
#platform/web
#platform/ios
#platform/android
#status/seed
#status/stable
#freshness/current
#freshness/stale
```

### 2.3. Обязательные Obsidian плагины

| Плагин | Назначение |
|--------|-----------|
| **Dataview** | Динамические списки, MOC генерация, статистика vault |
| **Templater** | Шаблоны для создания новых заметок |
| **Obsidian Git** | Автоматический push в GitHub |
| **Tag Wrangler** | Управление тегами |
| **Linter** | Форматирование markdown, frontmatter validation |
| **Kanban** | Визуальное управление research backlog |
| **Graph Analysis** | Анализ связей между заметками |

---

## 3. Фаза 0 — Инициализация vault

### 3.1. Задачи

- [ ] Создать Git-репозиторий `uixray/coreds-vault`
- [ ] Инициализировать структуру директорий по схеме из раздела 2.1
- [ ] Создать `.obsidian/` конфигурацию с настройками и плагинами
- [ ] Создать все шаблоны в `04-automation/templates/`
- [ ] Перенести первое ТЗ в `01-design-system/_spec/`
- [ ] Перенести это ТЗ в `02-patterns/_spec/`
- [ ] Создать MOC (Map of Content) файлы для каждой директории
- [ ] Написать `README.md` для GitHub
- [ ] Написать `CONTRIBUTING.md` с гайдом для community
- [ ] Написать `00-meta/conventions.md` — правила ведения vault
- [ ] Настроить `.gitignore` (исключить `.obsidian/workspace.json`, `.trash/`)

### 3.2. Шаблоны

#### Pattern Template (`04-automation/templates/pattern.md`)

```markdown
---
title: "{{title}}"
type: pattern
category: {{category}}
status: seed
version: "0.1.0"
created: {{date}}
updated: {{date}}
freshness: current
freshness_checked: {{date}}
tags: []
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms: [web, iOS, Android]
---

# {{title}}

## Проблема (Problem)

Какую пользовательскую задачу решает этот паттерн.

## Контекст (Context)

### Когда использовать
- ...

### Когда НЕ использовать
- ...

## Решение (Solution)

Описание паттерна.

## Платформенные адаптации (Platform Adaptations)

| Аспект | Web | iOS | Android |
|--------|-----|-----|---------|
| Компонент | — | — | — |
| Поведение | — | — | — |
| Жесты | — | — | — |
| Расположение | — | — | — |

### Web
<!-- Детали для web -->

### iOS
<!-- Детали для iOS (HIG reference) -->

### Android
<!-- Детали для Android (Material Design reference) -->

## Связанные компоненты CoreDS

```dataview
LIST
FROM [[]]
WHERE type = "component"
```

## Связанные токены

- ...

## Эвристики и принципы (Heuristics)

| Эвристика | Как этот паттерн её поддерживает |
|-----------|--------------------------------|
| — | — |

## Accessibility

- **WCAG критерий:** ...
- **Keyboard:** ...
- **Screen reader:** ...
- **Motor:** ...

## Примеры из реальных продуктов

| Продукт | Платформа | Как реализовано | Скриншот |
|---------|----------|----------------|----------|
| — | — | — | — |

## Источники (References)

- ...

## Changelog

| Дата | Версия | Изменение |
|------|--------|-----------|
| {{date}} | 0.1.0 | Создание |
```

#### Research Template (`04-automation/templates/research.md`)

```markdown
---
title: "{{title}}"
type: research
research_id: "DR-{{id}}"
status: draft
created: {{date}}
updated: {{date}}
source_tool: gemini | claude | perplexity | manual
freshness: current
freshness_checked: {{date}}
tags: []
feeds_into: []  # Какие паттерны / компоненты это информирует
---

# {{title}}

## Запрос (Query)

> Точный текст запроса к AI / поисковый запрос

## Ключевые находки (Key Findings)

### Находка 1
...

### Находка 2
...

## Применение к CoreDS (Application)

| Находка | Влияет на | Действие |
|---------|----------|----------|
| — | Паттерн / Компонент / Токен | Создать / Обновить / Пересмотреть |

## Первоисточники (Primary Sources)

- [ ] Источник 1 — проверен / не проверен
- [ ] Источник 2 — проверен / не проверен

## Дата актуальности

Информация актуальна на: {{date}}
Рекомендуемая дата перепроверки: ...
```

### 3.3. MOC шаблон с Dataview

```markdown
---
title: "Patterns Index"
type: moc
---

# Паттерны — Map of Content

## По статусу

### 🌱 Seed
```dataview
TABLE category, platforms
FROM "02-patterns"
WHERE status = "seed" AND type = "pattern"
SORT file.name ASC
```

### 📝 Draft
```dataview
TABLE category, platforms
FROM "02-patterns"
WHERE status = "draft" AND type = "pattern"
SORT file.name ASC
```

### ✅ Stable
```dataview
TABLE category, platforms, freshness
FROM "02-patterns"
WHERE status = "stable" AND type = "pattern"
SORT file.name ASC
```

### ⚠️ Требуют обновления (Stale)
```dataview
TABLE category, freshness_checked
FROM "02-patterns"
WHERE freshness = "stale" OR freshness = "outdated"
SORT freshness_checked ASC
```

## По категории

### Foundations
```dataview
LIST
FROM "02-patterns/foundations"
WHERE type = "pattern" OR type = "heuristic" OR type = "law"
SORT file.name ASC
```

### Platform
```dataview
LIST
FROM "02-patterns/platform"
WHERE type = "pattern"
SORT file.name ASC
```

### AI Patterns
```dataview
LIST
FROM "02-patterns/ai"
WHERE type = "pattern"
SORT file.name ASC
```
```

### 3.4. Критерий завершения

- Vault открывается в Obsidian без ошибок
- Все плагины установлены и работают
- Шаблоны создают корректные заметки
- Dataview запросы отображают данные
- Git push на GitHub работает
- README на GitHub отображает описание проекта

---

## 4. Фаза 1 — Foundations

**Цель:** Создать справочник фундаментальных UX-принципов, связанный с компонентами DS.

### 4.1. Эвристики (Heuristics)

| Файл | Содержание | Приоритет |
|------|-----------|-----------|
| `nielsen-10.md` | 10 эвристик Нильсена с маппингом на компоненты CoreDS | P0 |
| `tognazzini-principles.md` | 19 принципов Тогнаццини | P1 |
| `shneiderman-rules.md` | 8 золотых правил Шнейдермана | P1 |
| `norman-design-principles.md` | Принципы Дона Нормана (affordance, signifiers, mapping, feedback, constraints) | P0 |
| `dieter-rams-10.md` | 10 принципов хорошего дизайна Рамса | P2 |

**Для каждой эвристики создать маппинг:**

```markdown
## Маппинг на CoreDS

| Эвристика | Компоненты | Токены | Паттерны |
|-----------|-----------|--------|----------|
| #1 Visibility of system status | [[loading]], [[toast]], [[progress-bar]] | [[motion#duration]] | [[loading-states]], [[feedback]] |
| #2 Match between system and real world | [[icon]], [[button]] | [[typography]] | [[naming-conventions]] |
| ... | ... | ... | ... |
```

### 4.2. Законы UX (Laws of UX)

| Файл | Закон | Маппинг на DS |
|------|-------|--------------|
| `fitts-law.md` | Время нажатия зависит от размера и расстояния до цели | Touch targets, button sizing tokens |
| `hicks-law.md` | Время решения растёт с количеством вариантов | Select, navigation, menu patterns |
| `millers-law.md` | 7±2 элементов в рабочей памяти | Navigation grouping, tab limits |
| `jakobs-law.md` | Пользователи ожидают что ваш продукт работает как другие | Platform conventions |
| `aesthetic-usability.md` | Красивые интерфейсы воспринимаются как более удобные | Visual design tokens |
| `doherty-threshold.md` | <400ms — продуктивность | Loading tokens, animation duration |
| `von-restorff-effect.md` | Отличающийся элемент запоминается | Accent colors, badges |
| `serial-position.md` | Первый и последний элементы запоминаются лучше | Navigation order |
| `peak-end-rule.md` | Опыт оценивается по пику и финалу | Onboarding, success states |
| `zeigarnik-effect.md` | Незавершённые задачи запоминаются лучше | Progress indicators |
| `teslers-law.md` | Сложность нельзя убрать, можно только перенести | Form design, defaults |
| `postel-law.md` | Будь либерален к вводу, строг к выводу | Input validation |

### 4.3. Когнитивная психология (Cognitive Psychology)

| Файл | Тема |
|------|------|
| `cognitive-load.md` | Intrinsic, extraneous, germane load; guidelines для UI |
| `gestalt-principles.md` | Proximity, similarity, closure, continuity, figure-ground |
| `mental-models.md` | Ментальные модели пользователей и conceptual models продукта |
| `attention-perception.md` | Selective attention, change blindness, inattentional blindness |
| `decision-making.md` | Choice architecture, defaults, nudging |

### 4.4. Accessibility

| Файл | Тема |
|------|------|
| `wcag-overview.md` | WCAG 2.2 AA/AAA — чеклист привязанный к компонентам |
| `cognitive-accessibility.md` | Когнитивная доступность (простой язык, предсказуемость, undo) |
| `motor-accessibility.md` | Моторная доступность (touch targets, alternative input methods) |
| `visual-accessibility.md` | Зрительная доступность (контрасты, увеличение, цветовая слепота) |
| `assistive-tech.md` | Screen readers, switch control, voice control — как тестировать |

### 4.5. Задачи

- [ ] Создать все файлы из таблиц выше используя шаблоны
- [ ] Заполнить P0 файлы (nielsen-10, norman-design-principles, fitts-law, hicks-law, millers-law, cognitive-load, gestalt-principles, wcag-overview) до статуса `stable`
- [ ] Создать маппинг эвристик → компоненты CoreDS → токены
- [ ] Заполнить P1 файлы до статуса `draft`
- [ ] Создать MOC для foundations/

### 4.6. Критерий завершения

- Все P0 файлы в статусе `stable`
- Маппинг эвристик → компоненты CoreDS создан
- MOC foundations/ работает с Dataview

---

## 5. Фаза 2 — Platform Patterns

**Цель:** Задокументировать кроссплатформенные различия и решения.

### 5.1. Navigation Patterns

| Паттерн | Web | iOS | Android |
|---------|-----|-----|---------|
| **Tab Bar** | Не используется / опционально | Основная навигация внизу (UITabBarController) | Bottom navigation (NavigationBar) |
| **Sidebar** | Основная навигация (desktop) | Настройки / secondary content | Navigation drawer |
| **Bottom Navigation** | Появляется на mobile web | Tab bar (≤5 items) | Bottom navigation (3-5 items) |
| **Back Navigation** | Browser back / breadcrumbs | Back button top-left + swipe right | System back button / gesture |
| **Breadcrumbs** | Стандарт для deep hierarchy | Не используется (редко) | Не используется |
| **Search** | Search bar в header | Prominent / hidden search | Search bar in top app bar |

### 5.2. Input Patterns

| Паттерн | Покрытие |
|---------|----------|
| `touch-targets.md` | Минимальные размеры: 44pt (iOS), 48dp (Android), 44px (web WCAG) |
| `gesture-vocabulary.md` | Tap, double tap, long press, swipe, pinch, rotate — по платформам |
| `keyboard-types.md` | Клавиатуры: text, email, phone, URL, numeric — поведение по платформам |
| `text-selection.md` | Выделение текста, context menu, clipboard — различия |
| `pickers.md` | Date/time picker, selection wheels — платформенные реализации |

### 5.3. Layout Patterns

| Паттерн | Покрытие |
|---------|----------|
| `responsive-vs-adaptive.md` | Fluid web vs fixed native layouts, когда что использовать |
| `safe-areas.md` | Notch, Dynamic Island, navigation bar — безопасные зоны |
| `grid-systems.md` | Сетки: 12-col web, layout grid iOS, responsive grid Android |
| `breakpoints.md` | Breakpoints web, size classes iOS, window size classes Android |
| `scroll-behavior.md` | Elastic scroll, pull-to-refresh, infinite scroll — по платформам |
| `keyboard-avoidance.md` | Поведение UI при появлении клавиатуры |

### 5.4. Platform Divergence Framework

Ключевой документ: `convergence-framework.md` — фреймворк принятия решений:

```markdown
## Когда делать ОДИНАКОВО (converge)

- Brand identity: логотип, цвета, tone of voice
- Information architecture: одинаковая структура
- Core user flows: ключевые сценарии
- Data models: одинаковая бизнес-логика
- Design tokens: единый источник истины (DTCG)
- Content: одинаковый контент на всех платформах

## Когда АДАПТИРОВАТЬ (diverge)

- Navigation pattern: tab bar vs sidebar vs drawer
- System controls: date pickers, alerts, action sheets
- Gestures: platform-specific (iOS swipe back, Android back button)
- Typography: system fonts, Dynamic Type, accessibility scaling
- Haptic feedback: iOS Taptic Engine, Android haptics
- Notification patterns: platform conventions
- Settings/preferences: platform-standard locations
- Permissions: platform-specific flows
```

### 5.5. Задачи

- [ ] Создать все файлы navigation patterns
- [ ] Создать все файлы input patterns
- [ ] Создать все файлы layout patterns
- [ ] Написать convergence-framework.md
- [ ] Создать ios-vs-android-matrix.md — полная матрица различий
- [ ] Создать web-vs-native-matrix.md
- [ ] Привязать каждый паттерн к компонентам CoreDS

### 5.6. Критерий завершения

- Navigation и Input паттерны в статусе `stable`
- Convergence framework написан
- Матрицы различий заполнены

---

## 6. Фаза 3 — Interaction Patterns

**Цель:** Библиотека паттернов взаимодействия для типовых UI-задач.

### 6.1. Приоритизированный список

**P0 — Необходимы для любого продукта:**

| Категория | Паттерны |
|-----------|---------|
| Forms | Form layout, inline validation, multi-step form, error summary, autosave |
| Search | Search bar, filters, sort, search results, no results, recent searches |
| Loading | Skeleton screens, spinner, progress bar, optimistic UI, lazy loading |
| Error handling | Error message, error page (404/500), retry, offline fallback |
| Empty states | First-use empty, no results, no data, cleared state |
| Notifications | Toast, snackbar, banner, badge, push notification |

**P1 — Важны для большинства продуктов:**

| Категория | Паттерны |
|-----------|---------|
| Data display | Table, list, card grid, detail view, master-detail |
| Onboarding | Welcome screen, feature tour, permission request, progressive disclosure |
| Selection | Single select, multi select, bulk actions, drag-and-drop |
| Content | Pagination, infinite scroll, pull-to-refresh, content preview |

**P2 — Доменно-специфичные:**

| Категория | Паттерны |
|-----------|---------|
| Settings | Settings page, toggles, preferences sync |
| Collaboration | Presence, comments, sharing, permissions |
| Real-time | Live updates, real-time indicators, conflict resolution |

### 6.2. Задачи

- [ ] Создать все P0 паттерны до статуса `draft`
- [ ] Привязать каждый к компонентам CoreDS и платформенным адаптациям
- [ ] Создать P1 паттерны до статуса `seed`
- [ ] MOC interaction patterns

### 6.3. Критерий завершения

- P0 паттерны в статусе `stable`
- Каждый паттерн имеет платформенные адаптации

---

## 7. Фаза 4 — AI Patterns

**Цель:** Каталог паттернов проектирования AI-powered интерфейсов.

### 7.1. AI Interaction Flow

Паттерны организованы по этапам взаимодействия пользователя с AI:

```
Initiate → Compose → Process → Receive → Refine → Trust
```

### 7.2. Input Patterns (Initiate + Compose)

| Паттерн | Описание | Примеры продуктов |
|---------|----------|------------------|
| `blank-prompt.md` | Пустое поле ввода для свободного промпта | ChatGPT, Claude |
| `prompt-suggestions.md` | Стартовые подсказки для преодоления «blank canvas» | Claude, Perplexity |
| `contextual-ai.md` | AI привязан к контексту текущей страницы/выделения | Notion AI, Figma AI |
| `scoping.md` | Ограничение контекста AI (файлы, домен, время) | Perplexity, Claude Projects |
| `prompt-templates.md` | Структурированные шаблоны для типовых задач | Midjourney /imagine, GPT Actions |
| `multimodal-input.md` | Ввод через текст + изображение + файлы + голос | GPT-4o, Claude |
| `refinement-controls.md` | Tone, length, format — контроль стиля генерации | Claude style, Jasper |

### 7.3. Output Patterns (Process + Receive)

| Паттерн | Описание | Примеры |
|---------|----------|---------|
| `streaming-text.md` | Посимвольный/пословный вывод текста | ChatGPT, Claude |
| `progressive-disclosure.md` | Сначала summary, потом details по запросу | Perplexity, Google AI Overview |
| `thinking-indicators.md` | Визуализация «размышлений» AI | Claude thinking, ChatGPT o1 |
| `structured-output.md` | Таблицы, списки, код-блоки, диаграммы | Claude artifacts, ChatGPT canvas |
| `multi-artifact.md` | Несколько генераций в одном ответе | Claude artifacts, Cursor |
| `source-attribution.md` | Цитирование источников, ссылки | Perplexity, Claude web search |
| `confidence-indicators.md` | Степень уверенности AI в ответе | Google AI, medical AI |

### 7.4. Control Patterns (Refine + Trust)

| Паттерн | Описание | Примеры |
|---------|----------|---------|
| `regenerate-edit.md` | Перегенерация полностью или частично | ChatGPT edit, Claude retry |
| `branch-compare.md` | Несколько вариантов ответа для сравнения | ChatGPT GPT-4 vs GPT-4o |
| `human-in-the-loop.md` | Одобрение перед выполнением действия | GitHub Copilot, Cursor |
| `undo-rollback.md` | Отмена AI-действий, возврат к предыдущему | Claude artifacts versions |
| `approval-workflows.md` | Многоступенчатое одобрение AI-решений | Enterprise AI tools |
| `ai-vs-human-badge.md` | Визуальное различие AI-контента от человеческого | Google, EU AI Act |
| `explainability.md` | Объяснение почему AI принял такое решение | Medical AI, financial AI |
| `transparency-framework.md` | Общий фреймворк прозрачности AI | Microsoft HAX Toolkit |

### 7.5. Agentic Patterns

| Паттерн | Описание | Примеры |
|---------|----------|---------|
| `delegation-patterns.md` | Что пользователь делегирует агенту, что оставляет себе | Copilot Workspace, Devin |
| `multi-step-tasks.md` | Визуализация многошаговых AI-задач | Claude Code, Cursor Composer |
| `agent-handoff.md` | Передача контроля между AI и человеком | Copilot, customer service AI |
| `autonomy-levels.md` | Уровни автономии: suggest → do with approval → autonomous | Tesla FSD levels analogy |
| `multi-agent.md` | Несколько AI-агентов работают совместно | CrewAI, AutoGen |

### 7.6. Hybrid Patterns (AI + Traditional UI)

| Паттерн | Описание | Когда использовать |
|---------|----------|--------------------|
| `ai-copilot-sidebar.md` | AI в боковой панели, не мешает основному UI | VS Code Copilot, Notion AI |
| `ai-inline-enhancement.md` | AI улучшает существующие функции inline | Gmail Smart Reply, Figma AI |
| `ai-first-interface.md` | Chat / prompt как основной способ взаимодействия | ChatGPT, Claude |
| `ai-progressive-enhancement.md` | UI работает без AI, AI добавляет сверху | Search → AI Search |
| `mode-switching.md` | Переключение между manual и AI режимами | Cursor AI mode, Photoshop AI |

### 7.7. Компоненты CoreDS для AI паттернов

AI-паттерны требуют компоненты, которые нужно добавить в CoreDS:

| Компонент | Описание | Tier |
|----------|----------|------|
| `PromptInput` | Textarea с автоподсказками, attachment support | 2 |
| `StreamingText` | Компонент для потокового вывода текста | 2 |
| `ThinkingIndicator` | Визуализация размышлений AI | 1 |
| `SourceCitation` | Блок цитирования с ссылкой на источник | 1 |
| `ConfidenceBadge` | Индикатор уверенности AI | 1 |
| `AIBadge` | Маркер «AI-generated» контента | 1 |
| `ApprovalCard` | Карточка для approve/reject AI-действия | 2 |
| `StepProgress` | Визуализация многошагового AI-процесса | 2 |
| `DiffView` | Сравнение до/после AI-изменений | 2 |
| `BranchSelector` | Переключение между вариантами генерации | 2 |

### 7.8. Задачи

- [ ] Создать все AI Input паттерны
- [ ] Создать все AI Output паттерны
- [ ] Создать все Control паттерны
- [ ] Создать все Agentic паттерны
- [ ] Создать все Hybrid паттерны
- [ ] Добавить AI-компоненты в CoreDS component backlog
- [ ] Создать MOC для ai/

### 7.9. Критерий завершения

- Все AI паттерны минимум в статусе `draft`
- Каждый паттерн имеет связь с CoreDS компонентами
- Список AI-компонентов добавлен в CoreDS backlog

---

## 8. Фаза 5 — Domain Patterns

**Цель:** Типовые решения для конкретных доменов, переиспользуемые между проектами.

### 8.1. Приоритет доменов

| Домен | Приоритет | Типовые задачи |
|-------|-----------|---------------|
| **SaaS Dashboard** | P0 | Settings, billing, team management, data visualization |
| **E-commerce** | P1 | Product card, cart, checkout, order tracking |
| **Content Platform** | P1 | Feed, content creation, comments, sharing |
| **Social** | P2 | Profiles, messaging, reactions, notifications |

### 8.2. Задачи

- [ ] Создать seed-заметки для P0 домена (SaaS Dashboard)
- [ ] Постепенно наполнять по мере работы с клиентскими проектами

---

## 9. Фаза 6 — Автоматизация обновлений

**Цель:** Создать систему проверки актуальности и обновления контента.

### 9.1. Freshness System (Система актуальности)

#### Правила актуальности (`04-automation/config/freshness-rules.json`)

```json
{
  "rules": {
    "foundations": {
      "freshness_period_days": 365,
      "note": "Фундаментальные принципы меняются редко"
    },
    "platform": {
      "freshness_period_days": 180,
      "note": "Платформенные гайдлайны обновляются 1-2 раза в год (WWDC, Google I/O)"
    },
    "interaction": {
      "freshness_period_days": 270,
      "note": "Паттерны взаимодействия относительно стабильны"
    },
    "ai": {
      "freshness_period_days": 90,
      "note": "AI паттерны меняются быстро"
    },
    "domain": {
      "freshness_period_days": 180,
      "note": "Доменные паттерны средне стабильны"
    },
    "tokens": {
      "freshness_period_days": 365,
      "note": "Токены обновляются по semver"
    }
  }
}
```

#### Скрипт проверки (`04-automation/scripts/scan-freshness.ts`)

Функционал:
1. Сканирует все `.md` файлы с frontmatter
2. Сравнивает `freshness_checked` с текущей датой по правилам
3. Если просрочено — ставит `freshness: stale`
4. Генерирует отчёт: список stale-заметок с приоритетами
5. Может запускаться вручную или через GitHub Action

```
npm run scan:freshness
```

Выход:
```
📊 Freshness Report — 2026-02-26
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 Outdated (>2x period): 3 files
  - 02-patterns/ai/input/blank-prompt.md (checked 180 days ago, limit 90)
  - ...

🟡 Stale (>1x period): 7 files
  - 02-patterns/platform/navigation/tab-bar.md (checked 200 days ago, limit 180)
  - ...

🟢 Current: 42 files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Action items generated: 04-automation/freshness-report.md
```

### 9.2. AI-Assisted Update Workflow

#### Шаг 1: Сканирование (автоматическое)
```
npm run scan:freshness → freshness-report.md
```

#### Шаг 2: Исследование (ИИ + человек)

Для каждой stale-заметки:
1. Claude / Perplexity ищет обновления по теме
2. Сравнивает с текущим содержанием
3. Генерирует `update-proposal.md`:

```markdown
---
type: update-proposal
target: "02-patterns/ai/input/blank-prompt.md"
generated: 2026-02-26
---

# Update Proposal: Blank Prompt Pattern

## Что изменилось с момента последней проверки

1. **GPT-5 ввёл adaptive prompt UI** — промпт адаптируется к контексту
2. **Claude добавил project-level context** — промпт учитывает project files
3. **Новое исследование NNg** — лучшие практики prompt UX обновлены

## Предлагаемые изменения

### Добавить:
- Новый подпаттерн: Adaptive Prompt
- Обновить примеры продуктов

### Обновить:
- Секцию Platform Adaptations (новые iOS/Android AI APIs)

### Удалить:
- Устаревший пример (продукт X закрылся)

## Статус: ⏳ Ожидает ревью автора
```

#### Шаг 3: Ревью (человек)
- Ray читает proposal
- Подтверждает / отклоняет / модифицирует
- Обновляет заметку
- Ставит `freshness: current` + новую `freshness_checked`

#### Шаг 4: Commit
```
git commit -m "update(patterns): refresh blank-prompt pattern — Feb 2026"
```

### 9.3. Периодические события (Calendar Triggers)

| Событие | Когда | Действие |
|---------|-------|----------|
| WWDC (Apple) | Июнь | Пересканировать все `platform/` паттерны для iOS |
| Google I/O | Май | Пересканировать все `platform/` паттерны для Android |
| W3C DTCG обновления | По мере выхода | Пересканировать `tokens/` |
| AI landscape check | Каждые 3 месяца | Пересканировать все `ai/` паттерны |
| Full vault audit | Каждые 6 месяцев | `npm run scan:freshness` на весь vault |

### 9.4. GitHub Actions для автоматизации

```yaml
# .github/workflows/freshness-check.yml
name: Freshness Check
on:
  schedule:
    - cron: '0 9 1 * *'  # Первый день каждого месяца
  workflow_dispatch:       # Ручной запуск

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci
      - run: npm run scan:freshness
      - name: Create issue if stale found
        # Создать GitHub Issue со списком stale-заметок
```

### 9.5. Задачи

- [ ] Реализовать `scan-freshness.ts`
- [ ] Создать `freshness-rules.json`
- [ ] Реализовать `link-integrity.ts` (проверка битых ссылок)
- [ ] Настроить GitHub Action для ежемесячной проверки
- [ ] Написать `00-meta/update-workflow.md` — инструкция по обновлению
- [ ] Создать шаблон `update-proposal.md`

### 9.6. Критерий завершения

- `npm run scan:freshness` работает и генерирует отчёт
- GitHub Action запускается по расписанию
- Инструкция по обновлению написана

---

## 10. Связь с CoreDS

### 10.1. Двунаправленные связи

```
┌─────────────────────┐         ┌──────────────────────┐
│  02-patterns/        │ ←────→ │  01-design-system/    │
│                      │         │                       │
│  Паттерн:           │ ──refs→ │  Компонент:           │
│  [[tab-bar]]        │         │  [[bottom-navigation]]│
│                      │         │                       │
│  Эвристика:         │ ──refs→ │  Токен:               │
│  [[fitts-law]]      │         │  [[touch-targets]]    │
│                      │         │                       │
│  AI Pattern:        │ ──refs→ │  Новый компонент:     │
│  [[streaming-text]] │         │  [[StreamingText]]    │
└─────────────────────┘         └──────────────────────┘
         │                               │
         └───── оба ←── ────────────────┘
                    │
            ┌───────────────┐
            │  03-research/  │
            │  Исследования  │
            │  подпитывают   │
            │  оба слоя      │
            └───────────────┘
```

### 10.2. Как паттерны влияют на CoreDS

| Паттерн | Влияние на CoreDS |
|---------|-------------------|
| Touch targets | → Токен `space.target.min` с платформенными значениями |
| Loading states | → Компоненты Skeleton, Spinner, ProgressBar |
| AI streaming | → Новый компонент StreamingText |
| Back navigation | → Platform-adaptive breadcrumb / back button |
| Form validation | → Состояния компонента Input (error, success, helper) |

### 10.3. Dataview запрос: компоненты без паттернов

```dataview
TABLE related_patterns
FROM "01-design-system/components"
WHERE length(related_patterns) = 0
```

### 10.4. Dataview запрос: паттерны без компонентов

```dataview
TABLE related_components
FROM "02-patterns"
WHERE type = "pattern" AND length(related_components) = 0
```

---

## 11. Приложения

### Приложение A: Research Backlog

| ID | Тема | Приоритет | Для фазы | Статус |
|----|------|-----------|----------|--------|
| DR-001 | Naming conventions audit | P0 | Tokens | Pending |
| DR-002 | Platform token mapping | P0 | Tokens | Pending |
| DR-003 | Accessibility token patterns | P0 | Tokens | Pending |
| DR-004 | DTCG 2025.10 deep dive | P0 | Tokens | Pending |
| DR-005 | Style Dictionary v4 config | P0 | Tokens | Pending |
| DR-006 | Color system engineering | P1 | Foundation | Pending |
| DR-007 | Typography scale systems | P1 | Foundation | Pending |
| DR-008 | Figma Variables architecture | P0 | Figma | Pending |
| DR-009 | Tokens Studio workflow | P1 | Figma | Pending |
| DR-010 | Multi-brand theming | P1 | Theming | Pending |
| DR-011 | Framework decision matrix | P2 | Code | Pending |
| DR-012 | UX heuristics → DS mapping | P0 | Patterns | Pending |
| DR-013 | Cognitive psychology for UI | P1 | Patterns | Pending |
| DR-014 | Platform divergence matrix | P0 | Patterns | Pending |
| DR-015 | Responsive spatial system | P1 | Patterns | Pending |
| DR-016 | AI UX patterns catalog 2025 | P0 | Patterns | Pending |
| DR-017 | Agentic UX framework | P1 | Patterns | Pending |
| DR-018 | AI + Traditional UI integration | P1 | Patterns | Pending |

### Приложение B: Рекомендуемые источники

| Категория | Источники |
|-----------|----------|
| **Эвристики** | nngroup.com, lawsofux.com, interaction-design.org |
| **Платформы** | developer.apple.com/design, m3.material.io, w3.org |
| **AI UX** | shapeof.ai, aiuxpatterns.com, Microsoft HAX Toolkit |
| **Design Systems** | designsystemscollective.com, designsystems.wtf |
| **Accessibility** | w3.org/WAI, dequeuniversity.com, a11yproject.com |
| **Research** | CHI Conference proceedings, ACM Digital Library |

### Приложение C: Roadmap

```
v0.1.0  — Фаза 0: Vault инициализирован, структура, шаблоны
v0.2.0  — Фаза 1: Foundations (P0: Nielsen, Norman, Laws of UX)
v0.3.0  — Фаза 2: Platform Patterns (navigation, input, layout)
v0.4.0  — Фаза 3: Interaction Patterns (P0: forms, loading, errors)
v0.5.0  — Фаза 4: AI Patterns (input, output, trust, agentic)
v0.6.0  — Фаза 5: Domain Patterns (SaaS dashboard)
v0.7.0  — Фаза 6: Freshness system + automation
v1.0.0  — Public release: все P0 в stable, freshness system работает
```

---

> **Примечание для Claude Code:**
> Этот проект — часть единого Obsidian vault с CoreDS.
> 1. Всегда проверяй связи между паттернами и компонентами CoreDS
> 2. Используй wikilinks `[[]]` для всех внутренних ссылок
> 3. Каждый файл должен иметь корректный frontmatter по шаблону
> 4. Комментируй код на русском
> 5. При создании AI-паттернов — добавляй соответствующие компоненты в backlog CoreDS
> 6. Status lifecycle: seed → draft → review → stable → deprecated
