# Патч к ТЗ CoreDS v0.1.0 → v0.2.0

> **Дата:** 2026-02-26
> **Причина:** Интеграция с Pattern Library в единый Obsidian vault

---

## 1. Изменение структуры репозитория

**Было:** Отдельный репозиторий `uixray/coreds` со структурой `tokens/`, `platforms/`, `config/`, `docs/`, `scripts/`

**Стало:** Единый Obsidian vault `uixray/coreds-vault`, где CoreDS и Pattern Library — параллельные разделы одного хранилища.

### Новая структура

Вся документация CoreDS переезжает в `01-design-system/`:

```
coreds-vault/                        # Единый Obsidian vault = Git repo
├── .obsidian/                       # Настройки Obsidian (plugins, themes)
├── README.md
├── LICENSE-CODE.md                  # MIT — для кода и токенов
├── LICENSE-CONTENT.md               # CC BY-SA 4.0 — для документации и паттернов
├── CHANGELOG.md
├── CONTRIBUTING.md
│
├── 00-meta/                         # О проекте, conventions, glossary
├── 01-design-system/                # ← CoreDS (ТЗ #1)
│   ├── _spec/design-system-spec.md
│   ├── architecture/                # ADR документы
│   ├── tokens/                      # Документация токенов
│   ├── components/                  # Спецификации компонентов
│   ├── themes/                      # Документация тематизации
│   └── guides/                      # Гайды (for designers, developers)
│
├── 02-patterns/                     # ← Pattern Library (ТЗ #2)
│   ├── foundations/
│   ├── platform/
│   ├── interaction/
│   ├── ai/
│   └── domain/
│
├── 03-research/                     # Deep research, статьи, бенчмарки
├── 04-automation/                   # Скрипты, конфиги, шаблоны Templater
│   ├── scripts/
│   ├── config/style-dictionary/
│   ├── config/freshness-rules.json
│   └── templates/                   # Obsidian Templater шаблоны
│
├── 05-tokens/                       # Source of truth — DTCG JSON файлы
│   ├── core/
│   ├── semantic/
│   ├── component/
│   └── themes/
│
├── 06-platforms/                    # Сгенерированные файлы (CSS, Swift, Kotlin)
│   ├── web/css/
│   ├── ios/swift/
│   └── android/kotlin/
│
└── 07-figma/                        # Figma scripts, ссылки
```

### Миграция из старой структуры

| Было (coreds/) | Стало (coreds-vault/) |
|----------------|-----------------------|
| `tokens/` | `05-tokens/` |
| `platforms/` | `06-platforms/` |
| `config/` | `04-automation/config/` |
| `scripts/` | `04-automation/scripts/` |
| `docs/architecture/` | `01-design-system/architecture/` |
| `docs/tokens/` | `01-design-system/tokens/` |
| `docs/components/` | `01-design-system/components/` |
| `docs/guides/` | `01-design-system/guides/` |
| `figma/` | `07-figma/` |
| `themes/` | `05-tokens/themes/` |
| `README.md` | `README.md` (обновить) |

---

## 2. Изменения в Фазе 0 (Инициализация)

### Добавить задачи:

- [ ] Создать единый vault вместо отдельного репозитория
- [ ] Настроить `.obsidian/` с плагинами: Dataview, Templater, Obsidian Git, Tag Wrangler, Linter
- [ ] Создать шаблоны в `04-automation/templates/`: pattern.md, component.md, adr.md, research.md, law.md
- [ ] Создать `00-meta/conventions.md` — единые правила оформления заметок
- [ ] Настроить двойную лицензию: MIT (код) + CC BY-SA 4.0 (контент)

### Frontmatter стандарт

Все `.md` файлы CoreDS теперь следуют единому стандарту frontmatter:

```yaml
---
title: "Button"
type: component               # component | token | adr | guide
status: draft                  # seed | draft | review | stable | deprecated
version: "1.0.0"
created: 2026-02-26
updated: 2026-02-26
freshness: current             # current | stale | outdated
freshness_checked: 2026-02-26
tags:
  - tier-1
  - interactive
related_patterns:              # ← НОВОЕ: связь с паттернами
  - "[[tab-bar]]"
  - "[[touch-targets]]"
platforms: [web, iOS, Android]
---
```

Ключевое добавление — поле `related_patterns` в каждом компоненте и токене, обеспечивающее двунаправленную связь с Pattern Library.

---

## 3. Изменения в Фазе 1 (Исследование)

### Расширение research backlog

Добавить 7 research-задач для Pattern Library:

| ID | Тема | Приоритет | Категория |
|----|------|-----------|-----------|
| DR-012 | UX heuristics → DS mapping | P0 | Patterns |
| DR-013 | Cognitive psychology for UI | P1 | Patterns |
| DR-014 | Platform divergence matrix | P0 | Patterns |
| DR-015 | Responsive spatial system | P1 | Patterns |
| DR-016 | AI UX patterns catalog 2025 | P0 | Patterns |
| DR-017 | Agentic UX framework | P1 | Patterns |
| DR-018 | AI + Traditional UI integration | P1 | Patterns |

Результаты сохраняются в `03-research/deep-research/DR-XXX-*.md`.

---

## 4. Изменения в Фазе 4 (Компонентная библиотека)

### Добавить AI-компоненты

На основе AI-паттернов из ТЗ #2, добавить в backlog компонентов:

| Компонент | Tier | Пришёл из паттерна |
|----------|------|--------------------|
| `PromptInput` | 2 | [[blank-prompt]], [[prompt-templates]] |
| `StreamingText` | 2 | [[streaming-text]] |
| `ThinkingIndicator` | 1 | [[thinking-indicators]] |
| `SourceCitation` | 1 | [[source-attribution]] |
| `ConfidenceBadge` | 1 | [[confidence-indicators]] |
| `AIBadge` | 1 | [[ai-vs-human-badge]] |
| `ApprovalCard` | 2 | [[human-in-the-loop]] |
| `StepProgress` | 2 | [[multi-step-tasks]] |
| `DiffView` | 2 | [[regenerate-edit]] |
| `BranchSelector` | 2 | [[branch-compare]] |

### Обновить Component Spec Template

Добавить секцию `Related Patterns`:

```markdown
## Связанные паттерны (Related Patterns)

| Паттерн | Как компонент его реализует |
|---------|---------------------------|
| [[touch-targets]] | Минимальный размер кнопки = токен space.target.min |
| [[loading-states]] | Компонент поддерживает loading state |
```

---

## 5. Изменения в Фазе 7 (Документация)

### Вся документация теперь в Obsidian формате

- Wikilinks `[[page]]` вместо относительных markdown-ссылок
- Frontmatter на каждой странице
- Dataview запросы для динамических списков
- Теги для категоризации

### Добавить Dataview dashboards

В `01-design-system/components/_index.md`:

```markdown
## Компоненты без привязанных паттернов

\```dataview
TABLE related_patterns
FROM "01-design-system/components"
WHERE length(related_patterns) = 0 AND type = "component"
\```

## Покрытие по Tier

\```dataview
TABLE length(filter(rows, (r) => r.status = "stable")) AS "Stable",
      length(rows) AS "Total"
FROM "01-design-system/components"
WHERE type = "component"
GROUP BY tier
\```
```

---

## 6. Изменения в Фазе 8 (Автоматизация)

### Добавить freshness-систему для CoreDS

Не только паттерны, но и компоненты/токены теперь поддерживают freshness check:

```json
// В freshness-rules.json добавить:
{
  "tokens": {
    "freshness_period_days": 365,
    "note": "Токены обновляются по semver"
  },
  "components": {
    "freshness_period_days": 270,
    "note": "Компоненты относительно стабильны после v1"
  },
  "architecture": {
    "freshness_period_days": 365,
    "note": "ADR пересматриваются раз в год"
  }
}
```

### Добавить скрипт проверки связей

`04-automation/scripts/link-integrity.ts`:
- Проверяет что все wikilinks ведут на существующие файлы
- Проверяет что `related_patterns` и `related_components` двунаправлены
- Генерирует отчёт о «сиротских» заметках без связей

---

## 7. Обновлённый Roadmap (объединённый)

```
v0.1.0  — Vault инициализирован, структура, шаблоны, оба ТЗ внутри
v0.2.0  — CoreDS: ADR, исследование | Patterns: Foundations (P0)
v0.3.0  — CoreDS: Token architecture + Style Dictionary | Patterns: Platform patterns
v0.4.0  — CoreDS: Foundation layer | Patterns: Interaction patterns (P0)
v0.5.0  — CoreDS: Figma components Tier 1 | Patterns: AI patterns
v0.6.0  — CoreDS: Figma Tier 2+3 + Theming | Patterns: Domain patterns
v0.7.0  — CoreDS: Code implementation (CSS) | Patterns: Freshness system
v0.8.0  — Full documentation pass, cross-links audit
v0.9.0  — CI/CD, automation, GitHub Actions
v1.0.0  — Public release: stable tokens, Tier 1 components, P0 patterns
```

---

## 8. Обновлённое примечание для Claude Code

> При работе с CoreDS vault:
> 1. Это **единый Obsidian vault** — CoreDS и Patterns связаны через wikilinks
> 2. Каждый компонент должен иметь `related_patterns` в frontmatter
> 3. Каждый паттерн должен иметь `related_components` и `related_tokens`
> 4. Все файлы следуют единому frontmatter-стандарту из `00-meta/conventions.md`
> 5. Используй Obsidian wikilinks `[[]]`, не relative paths
> 6. AI-паттерны порождают AI-компоненты — обновляй backlog CoreDS
> 7. Скрипты в `04-automation/scripts/` — единая точка автоматизации
> 8. `npm run scan:freshness` работает на ВЕСЬ vault, не только на patterns
