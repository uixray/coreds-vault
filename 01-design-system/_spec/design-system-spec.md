---
title: "Design System Specification"
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
description: "CoreDS design system technical specification document"
---

# Техническое задание: Универсальная дизайн-система «CoreDS»

> **Версия документа:** 0.1.0-draft
> **Автор:** Ray (@uixray)
> **Дата:** 2026-02-26
> **Назначение:** Техническое задание для поэтапной разработки с помощью Claude Code
> **Тип продукта:** Open-source дизайн-система
> **Лицензия:** MIT (определить окончательно на этапе 0)

---

## Содержание

1. [Обзор проекта](#1-обзор-проекта)
2. [Контекст и ограничения](#2-контекст-и-ограничения)
3. [Фаза 0 — Инициализация проекта](#3-фаза-0--инициализация-проекта)
4. [Фаза 1 — Исследование и аудит](#4-фаза-1--исследование-и-аудит)
5. [Фаза 2 — Архитектура токенов](#5-фаза-2--архитектура-токенов)
6. [Фаза 3 — Foundation Layer](#6-фаза-3--foundation-layer)
7. [Фаза 4 — Компонентная библиотека Figma](#7-фаза-4--компонентная-библиотека-figma)
8. [Фаза 5 — Тематизация](#8-фаза-5--тематизация)
9. [Фаза 6 — Выбор фреймворка и кодовая реализация](#9-фаза-6--выбор-фреймворка-и-кодовая-реализация)
10. [Фаза 7 — Документация](#10-фаза-7--документация)
11. [Фаза 8 — Автоматизация и CI/CD](#11-фаза-8--автоматизация-и-cicd)
12. [Приложения](#12-приложения)

---

## 1. Обзор проекта

### 1.1. Цель

Создать универсальную open-source дизайн-систему (design system) с архитектурой Core + Themes, которая:

- Служит масштабируемой основой для клиентских проектов (client-specific branches)
- Поддерживает web (desktop / tablet / mobile), iOS и Android
- Позволяет создавать клиентские темы через переопределение токенов без изменения ядра
- Автоматизирует трансформацию токенов из единого источника (single source of truth) в платформенный код
- Публикуется как open-source продукт

### 1.2. Целевые платформы (MVP)

| Платформа | Контексты (contexts) | Выходные форматы (output formats) |
|-----------|---------------------|----------------------------------|
| Web | Desktop, Tablet, Mobile | CSS Custom Properties |
| iOS | iPhone, iPad | Swift (UIKit / SwiftUI) |
| Android | Phone, Tablet | Kotlin (Compose / XML) |

### 1.3. Стек инструментов

| Категория | Инструмент |
|-----------|-----------|
| Дизайн (Design) | Figma (Professional plan) |
| Токены (Tokens) | DTCG spec 2025.10 + Style Dictionary v4 |
| Код (Code) | TypeScript, CSS Custom Properties |
| Документация (Documentation) | Obsidian (markdown) |
| Версионирование (Versioning) | Git + Semantic Versioning |
| Автоматизация (Automation) | Figma MCP, Style Dictionary CLI, GitHub Actions |

### 1.4. Принципы (Design Principles)

Определить на фазе 1 после исследования. Примерные направления:

- **Platform-aware, not platform-specific** — единый дизайн-язык, адаптированный под каждую платформу
- **Token-first** — любое визуальное решение начинается с токена
- **Themeable by default** — каждый компонент поддерживает тематизацию из коробки
- **Accessible** — WCAG 2.2 AA как минимум
- **Open and composable** — framework-agnostic, расширяемый

---

## 2. Контекст и ограничения

### 2.1. Ограничения Figma (Professional plan)

| Параметр | Лимит |
|----------|-------|
| Modes на коллекцию (modes per collection) | **10** |
| Variables на коллекцию (variables per collection) | 5 000 |
| Extended Collections | **Недоступны** (Enterprise only) |
| Slots | Early access, недоступны |
| Check Designs | Early access, недоступны |

**Критическое следствие:** Мультибрендовая тематизация через Extended Collections невозможна. Архитектура должна использовать альтернативную стратегию — отдельные Figma-файлы с переопределением переменных (override strategy) или Tokens Studio plugin.

### 2.2. Ограничения автора

- Единственный разработчик / дизайнер (solo practitioner)
- Изучает программирование — код должен быть хорошо документирован
- Целевой фреймворк для кодовых компонентов не определён (отдельная фаза)
- Железо: Ryzen 7 8845HS, Radeon 780M iGPU, 16GB RAM (учитывать при выборе tooling)

### 2.3. Стандарты и спецификации

| Стандарт | Версия | Применение |
|----------|--------|-----------|
| W3C DTCG Design Tokens Spec | 2025.10 (stable v1) | Формат токенов |
| WCAG | 2.2 Level AA | Доступность (accessibility) |
| HTML5 семантика | Living Standard | Naming conventions |
| Apple HIG | 2025 | iOS адаптации |
| Material Design | 3 | Android адаптации |

---

## 3. Фаза 0 — Инициализация проекта

**Цель:** Создать инфраструктуру репозитория и рабочего окружения.

### 3.1. Структура репозитория (Repository Structure)

```
coreds/
├── README.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── package.json
├── .gitignore
│
├── tokens/                        # Источник истины (source of truth)
│   ├── core/                      # Ядро системы
│   │   ├── color.tokens.json      # Примитивы цвета (color primitives)
│   │   ├── dimension.tokens.json  # Spacing, sizing, radius
│   │   ├── typography.tokens.json # Шрифты, размеры, weights
│   │   ├── shadow.tokens.json     # Elevation / shadows
│   │   └── motion.tokens.json     # Duration, easing
│   ├── semantic/                   # Семантические токены
│   │   ├── color.tokens.json
│   │   ├── dimension.tokens.json
│   │   └── typography.tokens.json
│   └── component/                  # Компонентные токены
│       ├── button.tokens.json
│       └── input.tokens.json
│
├── themes/                         # Клиентские темы
│   ├── _template/                  # Шаблон для новой темы
│   │   └── overrides.tokens.json
│   └── example-brand/
│       └── overrides.tokens.json
│
├── platforms/                      # Выходные файлы после трансформации
│   ├── web/
│   │   └── css/
│   │       ├── variables.css       # CSS Custom Properties
│   │       └── themes/
│   ├── ios/
│   │   └── swift/
│   └── android/
│       └── kotlin/
│
├── config/                         # Конфигурации сборки
│   └── style-dictionary/
│       ├── config.ts               # Основной конфиг Style Dictionary
│       └── transforms/             # Кастомные трансформы
│
├── figma/                          # Figma-связанные файлы
│   ├── README.md                   # Ссылки на Figma-файлы, инструкции
│   └── scripts/                    # Скрипты для Figma API / MCP
│
├── docs/                           # Документация
│   ├── architecture/               # Архитектурные решения (ADR)
│   ├── tokens/                     # Справочник токенов
│   ├── components/                 # Спецификации компонентов
│   └── guides/                     # Гайды для пользователей
│
└── scripts/                        # Утилиты автоматизации
    ├── build-tokens.ts             # Сборка токенов
    ├── validate-tokens.ts          # Валидация DTCG compliance
    └── generate-docs.ts            # Генерация документации
```

### 3.2. Задачи

- [ ] Создать Git-репозиторий на GitHub (`uixray/coreds`)
- [ ] Инициализировать `package.json` с базовыми зависимостями
- [ ] Установить Style Dictionary v4 (`style-dictionary@latest`)
- [ ] Настроить TypeScript конфигурацию
- [ ] Создать структуру директорий
- [ ] Написать README.md с описанием проекта и roadmap
- [ ] Выбрать лицензию (MIT / Apache 2.0)
- [ ] Настроить `.gitignore`, `.editorconfig`
- [ ] Создать шаблон CHANGELOG.md по Keep a Changelog формату

### 3.3. Критерий завершения (Definition of Done)

- Репозиторий создан и доступен публично
- `npm install` и `npm run build` отрабатывают без ошибок (даже если выход пустой)
- Документация README содержит цель проекта, roadmap и инструкции для контрибьюторов

---

## 4. Фаза 1 — Исследование и аудит

**Цель:** Изучить лучшие практики, зафиксировать архитектурные решения.

### 4.1. Исследование существующих систем (Reference Systems Audit)

Изучить и задокументировать ключевые решения из каждой системы:

| Система | Что изучить | Источник |
|---------|-------------|---------|
| Material Design 3 | Token taxonomy, Dynamic Color, Adaptive layouts | m3.material.io |
| Apple HIG | Spacing system, Typography scale, Platform idioms | developer.apple.com/design |
| Atlassian DS | Token naming, Theming architecture | atlassian.design |
| Polaris (Shopify) | Multi-platform tokens, Semantic layers | polaris.shopify.com |
| Carbon (IBM) | Grid system, Accessibility patterns | carbondesignsystem.com |
| Radix / shadcn/ui | Component API patterns, CSS Variables theming | radix-ui.com |
| Open Props | CSS Custom Properties scale, Adaptive sizing | open-props.style |

#### Результат (deliverable):

Файл `docs/architecture/001-reference-audit.md` с таблицей сравнения:
- Naming convention
- Token layers (primitive / semantic / component)
- Theming approach
- Platform support strategy
- Spacing / Typography scale
- Accessibility approach

### 4.2. Изучение спецификаций

| Спецификация | Что зафиксировать |
|-------------|-------------------|
| DTCG 2025.10 | Поддерживаемые типы токенов, $extends, алиасы, composite types, color spaces |
| WCAG 2.2 | Минимальные контрасты, focus indicators, target sizes |
| CSS Color Module 4 | oklch(), Display P3, color-mix() для поддержки modern color |

#### Результат:

Файл `docs/architecture/002-standards-reference.md`

### 4.3. Архитектурные решения (Architecture Decision Records)

Для каждого решения создать ADR файл в `docs/architecture/`:

| ID | Решение | Варианты | Статус |
|----|---------|----------|--------|
| ADR-003 | Naming convention для токенов | CTI (Category/Type/Item), DTCG groups, custom | Pending |
| ADR-004 | Базовая единица spacing | 4px, 8px, custom scale | Pending |
| ADR-005 | Шкала типографики (type scale) | Modular scale, custom stops, platform-dependent | Pending |
| ADR-006 | Color space | sRGB only, sRGB + Display P3, oklch primary | Pending |
| ADR-007 | Стратегия responsive | Breakpoints, fluid, container queries, hybrid | Pending |
| ADR-008 | Grid system | 12-column, 4/8/12 adaptive, custom | Pending |
| ADR-009 | Стратегия иконок (icon strategy) | SVG sprite, individual SVGs, icon font | Pending |
| ADR-010 | Figma architecture | Single file, multi-file, library structure | Pending |

#### Шаблон ADR:

```markdown
# ADR-XXX: [Название]

## Статус
Proposed | Accepted | Deprecated

## Контекст
Какую проблему решаем

## Варианты
### Вариант A: ...
**Плюсы:** ...
**Минусы:** ...

### Вариант B: ...
**Плюсы:** ...
**Минусы:** ...

## Решение
Что выбрано и почему

## Последствия
Что это решение влечёт за собой
```

### 4.4. Определение Design Principles

Сформулировать 5–7 принципов дизайн-системы. Зафиксировать в `docs/architecture/011-design-principles.md`.

### 4.5. Критерий завершения

- Все ADR файлы созданы со статусом Accepted
- Reference audit завершён
- Design Principles сформулированы и утверждены

---

## 5. Фаза 2 — Архитектура токенов

**Цель:** Спроектировать полную иерархию токенов и настроить трансформацию.

### 5.1. Иерархия токенов (Token Hierarchy)

Трёхуровневая архитектура (3-tier token architecture):

```
┌─────────────────────────────────────────┐
│  Component Tokens                        │  button.bg.default → {color.action.primary}
│  (Компонентные — привязаны к UI)        │
├─────────────────────────────────────────┤
│  Semantic Tokens                         │  color.action.primary → {color.blue.600}
│  (Семантические — описывают назначение) │
├─────────────────────────────────────────┤
│  Primitive Tokens                        │  color.blue.600 → #2563EB
│  (Примитивы — сырые значения)           │
└─────────────────────────────────────────┘
```

### 5.2. Типы токенов по DTCG (Token Types)

Реализовать все типы, поддерживаемые DTCG 2025.10:

| DTCG Type | Категория | Примеры |
|-----------|----------|---------|
| `color` | Цвет | Палитра, семантические цвета |
| `dimension` | Размерность | Spacing, sizing, border-radius, border-width |
| `fontFamily` | Шрифт | Sans, serif, mono |
| `fontWeight` | Насыщенность | 400, 500, 600, 700 |
| `duration` | Длительность | Анимации |
| `cubicBezier` | Easing | Кривые анимации |
| `number` | Число | Line-height ratios, opacity |
| `strokeStyle` | Стиль обводки | solid, dashed |
| `border` | Граница (composite) | width + style + color |
| `transition` | Переход (composite) | duration + delay + timingFunction |
| `shadow` | Тень (composite) | offsetX + offsetY + blur + spread + color |
| `gradient` | Градиент | Linear, radial |
| `typography` | Типографика (composite) | fontFamily + fontSize + fontWeight + lineHeight + letterSpacing |

### 5.3. Naming Convention

Определить на основе ADR-003. Предварительная структура:

```
{category}.{type}.{item}.{subitem}.{state}
```

Примеры:

```json
{
  "color": {
    "primitive": {
      "blue": {
        "100": { "$value": "#DBEAFE", "$type": "color" },
        "500": { "$value": "#3B82F6", "$type": "color" },
        "900": { "$value": "#1E3A8A", "$type": "color" }
      }
    },
    "surface": {
      "primary": {
        "$value": "{color.primitive.white}",
        "$type": "color",
        "$description": "Основной цвет поверхности (main surface color)"
      }
    },
    "action": {
      "primary": {
        "default": { "$value": "{color.primitive.blue.600}", "$type": "color" },
        "hover": { "$value": "{color.primitive.blue.700}", "$type": "color" },
        "active": { "$value": "{color.primitive.blue.800}", "$type": "color" },
        "disabled": { "$value": "{color.primitive.gray.300}", "$type": "color" }
      }
    }
  }
}
```

### 5.4. Platform Mapping

Таблица соответствия семантических токенов к платформенным значениям:

| Semantic Token | Web (CSS) | iOS (Swift) | Android (Kotlin) |
|---------------|-----------|-------------|-----------------|
| `space.gap.md` | `--space-gap-md: 16px` | `Spacing.gap.md = 16` | `SpacingTokens.GapMd = 16.dp` |
| `color.surface.primary` | `--color-surface-primary: #fff` | `ColorTokens.surfacePrimary` | `ColorTokens.SurfacePrimary` |
| `typo.body.md.fontSize` | `--typo-body-md-font-size: 1rem` | `Typography.body.md.fontSize = 16` | `Typography.BodyMd.fontSize = 16.sp` |

#### Результат:

Файл `docs/tokens/platform-mapping.md` — полная таблица маппинга

### 5.5. Responsive Token Strategy

На Figma Professional с 10 modes можно реализовать:

**Вариант А — Modes для breakpoints + theme:**

```
Коллекция "Color"     → modes: Light, Dark (2 из 10)
Коллекция "Dimension"  → modes: Desktop, Tablet, Mobile (3 из 10)
Коллекция "Typography" → modes: Desktop, Tablet, Mobile (3 из 10)
```

**Вариант Б — Комбинированные modes:**

```
Коллекция "Primitives" → modes: Default (1)
Коллекция "Semantic"   → modes: Light-Desktop, Light-Tablet, Light-Mobile,
                                  Dark-Desktop, Dark-Tablet, Dark-Mobile (6 из 10)
```

Выбор фиксируется в ADR-012.

### 5.6. Настройка Style Dictionary v4

Создать конфигурацию `config/style-dictionary/config.ts`:

```typescript
// Базовая конфигурация — детали определяются после фазы исследования
// Используется DTCG формат ($value, $type, $description)

export default {
  source: ['tokens/**/*.tokens.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'platforms/web/css/',
      files: [{
        destination: 'variables.css',
        format: 'css/variables',
        options: { outputReferences: true }
      }]
    },
    ios: {
      transformGroup: 'ios-swift',
      buildPath: 'platforms/ios/swift/',
      files: [{
        destination: 'Tokens.swift',
        format: 'ios-swift/enum.swift',
        options: { outputReferences: true }
      }]
    },
    android: {
      transformGroup: 'compose',
      buildPath: 'platforms/android/kotlin/',
      files: [{
        destination: 'Tokens.kt',
        format: 'compose/object',
        options: { outputReferences: true }
      }]
    }
  }
};
```

### 5.7. Задачи

- [ ] Принять решения ADR-003 — ADR-012
- [ ] Создать файлы примитивных токенов в DTCG формате
- [ ] Создать файлы семантических токенов с алиасами
- [ ] Настроить Style Dictionary v4 конфигурацию
- [ ] Реализовать кастомные трансформы для каждой платформы
- [ ] Выполнить первую сборку (`npm run build:tokens`)
- [ ] Валидировать выходные файлы для каждой платформы
- [ ] Создать `docs/tokens/platform-mapping.md`

### 5.8. Критерий завершения

- `npm run build:tokens` генерирует валидные файлы для web (CSS), iOS (Swift), Android (Kotlin)
- Все токены используют DTCG формат с `$value`, `$type`, `$description`
- Алиасы (references) корректно резолвятся на всех платформах
- Документация токенов сгенерирована

---

## 6. Фаза 3 — Foundation Layer

**Цель:** Заполнить все категории токенов конкретными значениями.

### 6.1. Color System

#### 6.1.1. Палитра примитивов (Primitive Palette)

| Категория | Шкала | Описание |
|-----------|-------|----------|
| Neutrals (Gray) | 50–950 (11 ступеней) | Текст, фоны, границы |
| Primary | 50–950 | Основной акцентный цвет |
| Secondary | 50–950 | Вторичный цвет |
| Error / Destructive | 50–950 | Ошибки, удаление |
| Warning | 50–950 | Предупреждения |
| Success | 50–950 | Успешные действия |
| Info | 50–950 | Информационные элементы |

#### 6.1.2. Семантические цвета (Semantic Colors)

| Роль (Role) | Light mode | Dark mode | Описание |
|-------------|-----------|-----------|----------|
| `color.surface.primary` | white | gray.900 | Основной фон |
| `color.surface.secondary` | gray.50 | gray.800 | Вторичный фон |
| `color.surface.tertiary` | gray.100 | gray.700 | Третичный фон |
| `color.on-surface.primary` | gray.900 | gray.50 | Основной текст |
| `color.on-surface.secondary` | gray.600 | gray.400 | Вторичный текст |
| `color.on-surface.disabled` | gray.400 | gray.600 | Disabled текст |
| `color.border.default` | gray.200 | gray.700 | Стандартная граница |
| `color.border.strong` | gray.400 | gray.500 | Акцентная граница |
| `color.action.primary.default` | primary.600 | primary.400 | Основное действие |
| `color.action.primary.hover` | primary.700 | primary.300 | Hover основного действия |
| `color.action.primary.active` | primary.800 | primary.200 | Active основного действия |
| `color.feedback.error` | error.600 | error.400 | Цвет ошибки |
| `color.feedback.warning` | warning.600 | warning.400 | Цвет предупреждения |
| `color.feedback.success` | success.600 | success.400 | Цвет успеха |
| `color.feedback.info` | info.600 | info.400 | Информационный цвет |

#### 6.1.3. Требования доступности (Accessibility Requirements)

- Текст на фоне: минимум 4.5:1 (WCAG AA normal text)
- Крупный текст (large text ≥ 24px / ≥ 18.5px bold): минимум 3:1
- UI компоненты и графика: минимум 3:1
- Focus indicator: минимум 3:1 относительно соседних цветов
- Документировать все пары контрастов в `docs/tokens/color-contrast-matrix.md`

### 6.2. Typography System

#### 6.2.1. Шкала размеров (Type Scale)

Определить на основе ADR-005. Предварительная структура:

| Token | Web Desktop | Web Tablet | Web Mobile | iOS | Android |
|-------|------------|-----------|-----------|-----|---------|
| `typo.display.lg` | 57px | 48px | 36px | 34pt | 57sp |
| `typo.display.md` | 45px | 40px | 32px | 28pt | 45sp |
| `typo.display.sm` | 36px | 32px | 28px | 22pt | 36sp |
| `typo.heading.lg` | 32px | 28px | 24px | 20pt | 32sp |
| `typo.heading.md` | 28px | 24px | 22px | 17pt | 28sp |
| `typo.heading.sm` | 24px | 22px | 20px | 15pt | 24sp |
| `typo.body.lg` | 18px | 18px | 18px | 17pt | 18sp |
| `typo.body.md` | 16px | 16px | 16px | 15pt | 16sp |
| `typo.body.sm` | 14px | 14px | 14px | 13pt | 14sp |
| `typo.label.lg` | 14px | 14px | 14px | 12pt | 14sp |
| `typo.label.md` | 12px | 12px | 12px | 11pt | 12sp |
| `typo.label.sm` | 11px | 11px | 11px | 10pt | 11sp |

*Конкретные значения уточнить после ADR-005*

#### 6.2.2. Font Stacks

```json
{
  "fontFamily": {
    "sans": { "$value": "Inter, system-ui, -apple-system, sans-serif", "$type": "fontFamily" },
    "mono": { "$value": "JetBrains Mono, ui-monospace, monospace", "$type": "fontFamily" },
    "serif": { "$value": "Georgia, Times New Roman, serif", "$type": "fontFamily" }
  }
}
```

*Конкретные шрифты определить в ADR-013*

#### 6.2.3. Line Heights

| Контекст | Ratio |
|---------|-------|
| Display (крупные заголовки) | 1.1–1.2 |
| Heading (заголовки) | 1.2–1.3 |
| Body (основной текст) | 1.4–1.6 |
| Label (подписи) | 1.2–1.4 |

### 6.3. Spacing & Sizing System

#### 6.3.1. Spacing Scale

Базовая единица (base unit) — определить в ADR-004. Предварительно 4px:

| Token | Значение | Применение |
|-------|---------|------------|
| `space.0` | 0px | Нулевой отступ |
| `space.1` | 4px | Минимальный (inline padding) |
| `space.2` | 8px | Tight (иконка-текст) |
| `space.3` | 12px | Compact |
| `space.4` | 16px | Default |
| `space.5` | 20px | Comfortable |
| `space.6` | 24px | Relaxed |
| `space.8` | 32px | Секция (section gap) |
| `space.10` | 40px | Большой разделитель |
| `space.12` | 48px | Layout gap |
| `space.16` | 64px | Секция страницы |
| `space.20` | 80px | Hero spacing |
| `space.24` | 96px | Максимальный |

#### 6.3.2. Semantic Spacing

| Token | Значение | Описание |
|-------|---------|----------|
| `space.gap.xs` | `{space.1}` | Минимальный gap |
| `space.gap.sm` | `{space.2}` | Малый gap |
| `space.gap.md` | `{space.4}` | Стандартный gap |
| `space.gap.lg` | `{space.6}` | Большой gap |
| `space.gap.xl` | `{space.8}` | Увеличенный gap |
| `space.inset.xs` | `{space.1}` | Минимальный padding |
| `space.inset.sm` | `{space.2}` | Малый padding |
| `space.inset.md` | `{space.4}` | Стандартный padding |
| `space.inset.lg` | `{space.6}` | Большой padding |
| `space.stack.sm` | `{space.2}` | Малый вертикальный отступ |
| `space.stack.md` | `{space.4}` | Стандартный вертикальный отступ |
| `space.stack.lg` | `{space.8}` | Большой вертикальный отступ |

### 6.4. Border Radius

| Token | Значение | Применение |
|-------|---------|------------|
| `radius.none` | 0px | Без скругления |
| `radius.sm` | 4px | Мелкие элементы (badges, tags) |
| `radius.md` | 8px | Контролы (inputs, buttons) |
| `radius.lg` | 12px | Карточки (cards) |
| `radius.xl` | 16px | Модалки (modals) |
| `radius.2xl` | 24px | Крупные контейнеры |
| `radius.full` | 9999px | Полное скругление (pills, avatars) |

### 6.5. Elevation / Shadows

| Token | Значение (light) | Применение |
|-------|------------------|------------|
| `shadow.xs` | `0 1px 2px 0 rgba(0,0,0,0.05)` | Subtle lift |
| `shadow.sm` | `0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px -1px rgba(0,0,0,0.1)` | Cards |
| `shadow.md` | `0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1)` | Dropdowns |
| `shadow.lg` | `0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1)` | Modals |
| `shadow.xl` | `0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1)` | Popovers |

### 6.6. Motion / Animation

| Token | Значение | Применение |
|-------|---------|------------|
| `duration.instant` | 100ms | Feedback мгновенный |
| `duration.fast` | 150ms | Hover, focus |
| `duration.normal` | 250ms | Стандартные переходы |
| `duration.slow` | 350ms | Модальные окна |
| `duration.slower` | 500ms | Сложные анимации |
| `easing.default` | `cubic-bezier(0.4, 0, 0.2, 1)` | Стандартный easing |
| `easing.in` | `cubic-bezier(0.4, 0, 1, 1)` | Вход элемента |
| `easing.out` | `cubic-bezier(0, 0, 0.2, 1)` | Выход элемента |
| `easing.in-out` | `cubic-bezier(0.4, 0, 0.2, 1)` | Вход + выход |

### 6.7. Задачи

- [ ] Определить конкретную цветовую палитру (hue, saturation, lightness шаги)
- [ ] Выбрать шрифтовые пары (primary + mono минимум)
- [ ] Заполнить все `.tokens.json` файлы конкретными значениями
- [ ] Создать контрастную матрицу цветов для WCAG AA
- [ ] Собрать и проверить выход для всех платформ
- [ ] Задокументировать все foundation-решения

### 6.8. Критерий завершения

- Все категории токенов заполнены конкретными значениями
- WCAG AA контрасты проверены и задокументированы
- Сборка успешна для web / iOS / Android
- Документация foundation layer полная

---

## 7. Фаза 4 — Компонентная библиотека Figma

**Цель:** Создать библиотеку компонентов в Figma, связанную с токенами.

### 7.1. Структура Figma-файлов

Без Extended Collections (Professional plan) используем multi-file стратегию:

```
📁 [Library] CoreDS — Foundation
  ├── 📄 Variables: Primitives (colors, dimensions — 1 mode: Default)
  ├── 📄 Variables: Semantic Light (aliases → primitives)
  ├── 📄 Variables: Semantic Dark (aliases → primitives)
  ├── 📄 Variables: Dimension Desktop (aliases → primitives)
  ├── 📄 Variables: Dimension Tablet
  ├── 📄 Variables: Dimension Mobile
  └── 📄 Styles: Typography, Effects, Grids

📁 [Library] CoreDS — Components
  ├── 📄 Tier 1: Primitive components
  ├── 📄 Tier 2: Composite components
  └── 📄 Tier 3: Pattern components

📁 [File] Client Theme: Example Brand
  ├── 📄 Variables: Brand overrides (переопределяет semantic)
  └── 📄 Brand-specific component overrides
```

**Альтернативная стратегия** (проще, но менее гибкая):

```
📁 [Library] CoreDS — Single File
  ├── Collection "Primitives"  → 1 mode: Default
  ├── Collection "Semantic"    → modes: Light, Dark (2/10)
  ├── Collection "Spacing"     → modes: Desktop, Tablet, Mobile (3/10)
  ├── Collection "Typography"  → modes: Desktop, Tablet, Mobile (3/10)
  └── Collection "Components"  → 1 mode: Default
```

Итого: 10/10 modes использовано. Выбор фиксируется в ADR-010.

### 7.2. Variables Structure в Figma

#### Collections и Modes:

| Collection | Modes | Тип переменных |
|-----------|-------|----------------|
| Primitives | Default | Color, Number |
| Semantic — Color | Light, Dark | Color (aliases → Primitives) |
| Semantic — Dimension | Desktop, Tablet, Mobile | Number (aliases → Primitives) |
| Semantic — Typography | Desktop, Tablet, Mobile | Number |
| Component | Default | Color, Number (aliases → Semantic) |

**Примечание:** Возможно объединение Dimension и Typography в одну коллекцию для экономии collections (не modes). Решение в ADR-010.

### 7.3. Компоненты — Tier 1 (Primitives)

Базовые неделимые компоненты. Для каждого определить:

| Компонент | Properties / Variants | States |
|----------|----------------------|--------|
| **Button** | size: sm/md/lg, variant: filled/outline/ghost/link, icon: left/right/only/none | default, hover, active, focus, disabled, loading |
| **Input** | size: sm/md/lg, type: text/password/search/number | default, hover, focus, filled, error, disabled, readonly |
| **Checkbox** | size: sm/md/lg | unchecked, checked, indeterminate, disabled |
| **Radio** | size: sm/md/lg | unselected, selected, disabled |
| **Toggle / Switch** | size: sm/md/lg | off, on, disabled |
| **Select** | size: sm/md/lg | default, open, filled, error, disabled |
| **Link** | variant: default/subtle | default, hover, active, focus, visited |
| **Badge** | variant: filled/outline/subtle, color: primary/error/warning/success/info | — |
| **Tag / Chip** | variant: filled/outline, removable: yes/no | default, hover, disabled |
| **Icon** | size: xs(12)/sm(16)/md(20)/lg(24)/xl(32) | — |
| **Avatar** | size: xs/sm/md/lg/xl, type: image/initials/icon | — |
| **Divider** | orientation: horizontal/vertical, variant: solid/dashed | — |

### 7.4. Компоненты — Tier 2 (Composites)

| Компонент | Состав | Properties |
|----------|--------|-----------|
| **Card** | Container + optional header/body/footer | variant: elevated/outline/filled, padding: sm/md/lg |
| **Dialog / Modal** | Overlay + container + header/body/footer | size: sm/md/lg/fullscreen |
| **Toast / Snackbar** | Container + icon + text + action | variant: info/success/warning/error |
| **Tooltip** | Trigger + popup + arrow | placement: top/right/bottom/left |
| **Dropdown Menu** | Trigger + list + items | — |
| **Tabs** | Tab list + tab panels | variant: line/enclosed/pill |
| **Accordion** | Trigger + collapsible content | allowMultiple: yes/no |
| **Breadcrumbs** | List + items + separators | — |
| **Pagination** | Pages + navigation | variant: simple/full |
| **Form Field** | Label + input + helper text + error message | — |

### 7.5. Компоненты — Tier 3 (Patterns)

| Паттерн | Описание | Зависимости |
|---------|----------|-------------|
| **App Bar / Header** | Top navigation bar | Button, Icon, Avatar, Link |
| **Sidebar Navigation** | Vertical navigation | Link, Icon, Divider, Badge |
| **Bottom Navigation** | Mobile bottom bar | Icon, Badge |
| **Data Table** | Sortable, paginated table | Checkbox, Pagination, Badge |
| **Empty State** | Placeholder for empty content | Icon, Button |
| **Loading States** | Skeleton, spinner, progress | — |
| **Error States** | Error pages (404, 500, generic) | Button, Icon |
| **Search** | Search input + results | Input, Icon |

### 7.6. Спецификация компонента (Component Spec Template)

Для каждого компонента создать файл `docs/components/{component-name}.md`:

```markdown
# Component: [Name]

## Описание (Description)
Что делает компонент, когда использовать

## Анатомия (Anatomy)
Диаграмма составных частей

## Properties
| Property | Type | Default | Options |
|----------|------|---------|---------|

## States
Описание каждого состояния с визуальными примерами

## Behavior
- Keyboard interaction
- Mouse / touch interaction
- Focus management

## Accessibility
- ARIA роль и атрибуты
- Keyboard shortcuts
- Screen reader behavior

## Design Tokens
Список компонентных токенов

## Platform Notes
| Platform | Differences |
|----------|------------|

## Do / Don't
Примеры правильного и неправильного использования
```

### 7.7. Задачи

- [ ] Принять ADR-010 (Figma architecture)
- [ ] Создать Figma-файл(ы) с коллекциями переменных
- [ ] Настроить все modes в коллекциях
- [ ] Создать все Tier 1 компоненты с variants и states
- [ ] Подключить все компоненты к переменным (variables)
- [ ] Создать Tier 2 компоненты
- [ ] Создать Tier 3 паттерны
- [ ] Написать component specs для каждого компонента
- [ ] Опубликовать Figma-библиотеку

### 7.8. Критерий завершения

- Все компоненты Tier 1–3 созданы и подключены к variables
- Переключение Light/Dark mode корректно работает на всех компонентах
- Переключение Desktop/Tablet/Mobile корректно адаптирует размеры
- Component specs написаны для всех Tier 1 компонентов (минимум)

---

## 8. Фаза 5 — Тематизация

**Цель:** Создать механизм клиентских тем через переопределение токенов.

### 8.1. Theme Contract (Контракт темы)

Определить какие токены клиент **может** и **не может** переопределять:

#### Переопределяемые (Overridable):

| Категория | Примеры | Уровень |
|-----------|---------|---------|
| Brand colors | Primary, Secondary палитры | Primitive |
| Neutral palette | Gray scale | Primitive |
| Font families | Sans, serif | Primitive |
| Border radius scale | Все значения | Semantic |
| Semantic color mapping | Какой primitive → какая роль | Semantic |

#### Не переопределяемые (Frozen Core):

| Категория | Причина |
|-----------|--------|
| Spacing scale (values) | Обеспечивает ритм и согласованность |
| Component anatomy | Структура компонентов неизменна |
| Accessibility минимумы | Контрасты, target sizes |
| State definitions | Набор состояний фиксирован |
| Animation easing curves | Согласованное ощущение движения |

### 8.2. Theme File Structure (DTCG)

```json
{
  "$description": "Example Brand theme overrides",
  "$extensions": {
    "coreds.theme": {
      "name": "Example Brand",
      "version": "1.0.0",
      "coredsVersion": "^1.0.0"
    }
  },
  "color": {
    "primitive": {
      "primary": {
        "50": { "$value": "#FFF1F2" },
        "100": { "$value": "#FFE4E6" },
        "500": { "$value": "#F43F5E" },
        "600": { "$value": "#E11D48" },
        "900": { "$value": "#881337" }
      }
    }
  },
  "fontFamily": {
    "sans": { "$value": "Montserrat, system-ui, sans-serif" }
  },
  "radius": {
    "md": { "$value": "12px" }
  }
}
```

### 8.3. Figma Theming Strategy (без Extended Collections)

**Подход: Separate File Override**

1. Клиент получает копию Figma-файла
2. Переопределяет variables в коллекции `Primitives` и `Semantic`
3. Компоненты автоматически обновляются через aliases

**Рабочий процесс обновления core:**

```
1. Core DS обновляется (новая версия)
2. Changelog описывает изменения
3. Клиент обновляет свою библиотеку:
   a. Принимает обновления компонентов из Core
   b. Проверяет что его overrides всё ещё корректны
   c. Запускает validate script
4. Публикует обновлённую клиентскую библиотеку
```

### 8.4. Theme Validation

Автоматические проверки темы перед публикацией:

| Проверка | Тип | Описание |
|----------|-----|----------|
| WCAG contrast | Обязательно | Все пары text/bg проходят 4.5:1 |
| Token completeness | Обязательно | Все required токены определены |
| Value range | Предупреждение | Значения в допустимых диапазонах |
| Font availability | Предупреждение | Указанные шрифты существуют |
| Core version compatibility | Обязательно | Тема совместима с версией core |

#### Скрипт валидации:

```
npm run validate:theme -- --theme=example-brand
```

### 8.5. Задачи

- [ ] Написать Theme Contract документ (`docs/guides/theme-contract.md`)
- [ ] Создать шаблон темы (`themes/_template/`)
- [ ] Реализовать скрипт `scripts/validate-theme.ts`
- [ ] Создать пример темы (`themes/example-brand/`)
- [ ] Собрать платформенные выходы для example-brand
- [ ] Написать гайд по созданию темы (`docs/guides/creating-a-theme.md`)
- [ ] Создать Figma-файл примера клиентской темы
- [ ] Протестировать полный flow: override → build → validate → use

### 8.6. Критерий завершения

- Example brand тема собирается и проходит валидацию
- CSS, Swift, Kotlin выходы корректны для кастомной темы
- Figma-файл с темой корректно переключается
- Гайд для создания темы написан

---

## 9. Фаза 6 — Выбор фреймворка и кодовая реализация

**Цель:** Определить технологический стек для кодовых компонентов и реализовать их.

### 9.1. Исследование фреймворков (Framework Evaluation)

| Критерий | Web Components (Lit) | React | Vue | Vanilla CSS + HTML |
|----------|---------------------|-------|-----|-------------------|
| Framework-agnostic | ✅ Нативно | ❌ React only | ❌ Vue only | ✅ Полностью |
| Экосистема | Средняя | Огромная | Большая | N/A |
| SSR поддержка | Ограниченная | Отличная | Отличная | Нативная |
| Порог входа (для автора) | Средний | Средний | Средний | Низкий |
| iOS / Android reuse | ❌ | React Native | ❌ | ❌ |
| Open-source adoption | Средняя | Высокая | Высокая | Высокая |

Принять решение в ADR-014 после анализа целевой аудитории open-source проекта.

### 9.2. Стратегии реализации

#### Вариант A: Tokens + CSS Only (рекомендуется для MVP)

Поставлять:
- CSS Custom Properties файлы
- CSS utility classes (опционально)
- HTML snippets / примеры для каждого компонента
- Swift / Kotlin token файлы для нативных платформ

#### Вариант B: Web Components (Lit)

Поставлять всё из варианта A, плюс:
- Lit-based web components (`<core-button>`, `<core-input>`)
- NPM пакет

#### Вариант C: React Component Library

Поставлять всё из варианта A, плюс:
- React + TypeScript компоненты
- Storybook документация
- NPM пакет

### 9.3. Минимальная кодовая реализация (все варианты)

Независимо от выбора фреймворка, реализовать:

| Артефакт | Описание |
|---------|----------|
| `platforms/web/css/variables.css` | Все токены как CSS Custom Properties |
| `platforms/web/css/reset.css` | CSS reset на основе токенов |
| `platforms/web/css/utilities.css` | Utility classes для spacing, typography, color |
| `platforms/ios/swift/Tokens.swift` | Swift enum / struct с токенами |
| `platforms/android/kotlin/Tokens.kt` | Kotlin object с токенами |

### 9.4. Задачи

- [ ] Провести исследование фреймворков (ADR-014)
- [ ] Реализовать CSS reset и utilities
- [ ] Реализовать HTML/CSS примеры для всех Tier 1 компонентов
- [ ] (если выбран фреймворк) Реализовать компоненты
- [ ] Настроить Storybook или аналог для playground
- [ ] Написать usage guide для каждого компонента

### 9.5. Критерий завершения

- ADR-014 принят
- CSS-реализация работает standalone
- Все Tier 1 компоненты имеют кодовые примеры
- (если фреймворк выбран) NPM пакет собирается

---

## 10. Фаза 7 — Документация

**Цель:** Создать полную документацию для дизайнеров, разработчиков и контрибьюторов.

### 10.1. Структура документации

```
docs/
├── architecture/              # ADR и архитектурные решения
│   ├── 001-reference-audit.md
│   ├── 002-standards-reference.md
│   ├── 003-naming-convention.md
│   └── ...
│
├── getting-started/           # Быстрый старт
│   ├── for-designers.md       # Как подключить Figma-библиотеку
│   ├── for-developers.md      # Как установить и использовать токены
│   └── for-contributors.md    # Как контрибьютить в проект
│
├── tokens/                    # Справочник токенов
│   ├── color.md
│   ├── typography.md
│   ├── spacing.md
│   ├── elevation.md
│   ├── motion.md
│   ├── platform-mapping.md
│   └── color-contrast-matrix.md
│
├── components/                # Спецификации компонентов
│   ├── button.md
│   ├── input.md
│   └── ...
│
├── guides/                    # Практические руководства
│   ├── creating-a-theme.md
│   ├── theme-contract.md
│   ├── figma-library-usage.md
│   ├── accessibility-checklist.md
│   ├── responsive-patterns.md
│   └── migration-guide.md
│
└── changelog/                 # История изменений
    └── CHANGELOG.md
```

### 10.2. Obsidian Integration

Документация ведётся в markdown-формате, совместимом с Obsidian:

- Использовать wikilinks `[[page]]` для внутренних ссылок
- Поддерживать Obsidian callouts для важных заметок
- Frontmatter для метаданных каждой страницы
- Теги для категоризации: `#token`, `#component`, `#guide`, `#adr`

#### Frontmatter шаблон:

```yaml
---
title: Button
category: component
tier: 1
status: stable | draft | deprecated
version: 1.0.0
updated: 2026-02-26
tags: [component, tier-1, interactive]
---
```

### 10.3. Changelog Strategy

Использовать Keep a Changelog формат + Semantic Versioning:

| Изменение | Semver Impact |
|-----------|--------------|
| Новый токен или компонент | Minor (1.X.0) |
| Изменение значения существующего токена | Patch (1.0.X) |
| Удаление / переименование токена | Major (X.0.0) |
| Добавление нового state компонента | Minor |
| Breaking change в API компонента | Major |
| Исправление бага | Patch |

### 10.4. Задачи

- [ ] Создать все файлы структуры docs/
- [ ] Написать getting-started гайды
- [ ] Написать token reference страницы
- [ ] Написать component specs (минимум Tier 1)
- [ ] Написать theme creation guide
- [ ] Настроить автогенерацию token reference из `.tokens.json`
- [ ] Настроить CHANGELOG.md workflow

### 10.5. Критерий завершения

- Новый пользователь может подключить и начать использовать DS за 15 минут, следуя getting-started guide
- Все токены задокументированы с описаниями и примерами
- Все Tier 1 компоненты имеют полные specs

---

## 11. Фаза 8 — Автоматизация и CI/CD

**Цель:** Автоматизировать рутинные процессы и обеспечить качество.

### 11.1. Сборочные скрипты (Build Scripts)

| Скрипт | Команда | Описание |
|--------|---------|----------|
| Сборка токенов | `npm run build:tokens` | Трансформирует DTCG → CSS, Swift, Kotlin |
| Сборка темы | `npm run build:theme -- --name=<theme>` | Собирает конкретную тему |
| Валидация токенов | `npm run validate:tokens` | Проверяет DTCG compliance |
| Валидация темы | `npm run validate:theme -- --name=<theme>` | Проверяет тему |
| Генерация docs | `npm run generate:docs` | Генерирует token reference из JSON |
| Полная сборка | `npm run build` | tokens + themes + docs |

### 11.2. GitHub Actions Pipelines

#### CI Pipeline (on push / PR):

```yaml
# .github/workflows/ci.yml
- Lint tokens (DTCG schema validation)
- Build all platforms
- Run contrast checks
- Validate themes
- Build documentation
```

#### Release Pipeline (on tag):

```yaml
# .github/workflows/release.yml
- Build all platforms
- Generate changelog
- Publish NPM package
- Create GitHub Release
- Deploy documentation
```

### 11.3. Figma ↔ Code Sync

#### Направление 1: Figma → Code (Tokens Studio или Figma REST API)

```
Figma Variables → Export JSON (DTCG) → Git commit → Style Dictionary build → Platform outputs
```

#### Направление 2: Code → Figma (Figma REST API / MCP)

```
tokens.json (git) → Figma Variables API → Update Figma variables
```

#### Направление 3: Figma MCP → Documentation

```
Figma Components → MCP read → Claude → Generate/update markdown specs
```

### 11.4. Quality Gates

| Проверка | Инструмент | Блокирует merge |
|----------|-----------|----------------|
| DTCG schema valid | Custom validator | Да |
| WCAG AA contrasts | Custom script | Да |
| All platforms build | Style Dictionary | Да |
| Token naming convention | Custom linter | Да |
| Theme compatibility | Validate script | Да |
| Docs generated | Generate script | Нет (warning) |

### 11.5. Задачи

- [ ] Реализовать `scripts/build-tokens.ts`
- [ ] Реализовать `scripts/validate-tokens.ts`
- [ ] Реализовать `scripts/validate-theme.ts`
- [ ] Реализовать `scripts/generate-docs.ts`
- [ ] Настроить `package.json` scripts
- [ ] Создать GitHub Actions CI workflow
- [ ] Создать GitHub Actions Release workflow
- [ ] Настроить Figma → Git sync (Tokens Studio plugin или кастом)
- [ ] Настроить Figma MCP интеграцию для аудита

### 11.6. Критерий завершения

- CI pipeline проходит на каждом PR
- Release pipeline публикует пакет автоматически
- Figma → Code sync работает (хотя бы в одном направлении)
- Все quality gates настроены

---

## 12. Приложения

### Приложение A: Глоссарий (Glossary)

| Термин (EN) | Перевод (RU) | Определение |
|-------------|-------------|-------------|
| Design Token | Дизайн-токен | Неделимое значение дизайн-решения |
| Primitive Token | Примитивный токен | Сырое значение (цвет, число) без семантики |
| Semantic Token | Семантический токен | Значение с описанием назначения (aliases primitive) |
| Component Token | Компонентный токен | Значение привязанное к конкретному компоненту |
| DTCG | — | Design Tokens Community Group (W3C) |
| Mode (Figma) | Режим | Вариация значений переменной в коллекции |
| Collection (Figma) | Коллекция | Набор переменных и режимов |
| Theme | Тема | Набор переопределений токенов для бренда/клиента |
| Alias / Reference | Алиас / Ссылка | Токен ссылающийся на другой токен `{token.name}` |
| Style Dictionary | — | Инструмент трансформации токенов в платформенный код |
| ADR | — | Architecture Decision Record |

### Приложение B: Список всех ADR

| ID | Название | Статус |
|----|---------|--------|
| ADR-001 | Reference systems audit | Фаза 1 |
| ADR-002 | Standards reference | Фаза 1 |
| ADR-003 | Naming convention для токенов | Фаза 1 |
| ADR-004 | Базовая единица spacing | Фаза 1 |
| ADR-005 | Шкала типографики | Фаза 1 |
| ADR-006 | Color space strategy | Фаза 1 |
| ADR-007 | Responsive strategy | Фаза 1 |
| ADR-008 | Grid system | Фаза 1 |
| ADR-009 | Icon strategy | Фаза 1 |
| ADR-010 | Figma file architecture | Фаза 4 |
| ADR-011 | Design principles | Фаза 1 |
| ADR-012 | Figma modes allocation | Фаза 2 |
| ADR-013 | Font selection | Фаза 3 |
| ADR-014 | Frontend framework | Фаза 6 |

### Приложение C: Ссылки и ресурсы

| Ресурс | URL |
|--------|-----|
| DTCG Specification | https://www.designtokens.org |
| DTCG GitHub | https://github.com/design-tokens/community-group |
| Style Dictionary v4 | https://styledictionary.com |
| Figma Variables Guide | https://help.figma.com/hc/en-us/articles/15339657135383 |
| Figma Schema 2025 Recap | https://www.figma.com/blog/schema-2025-design-systems-recap/ |
| WCAG 2.2 | https://www.w3.org/TR/WCAG22/ |
| Material Design 3 | https://m3.material.io |
| Apple HIG | https://developer.apple.com/design/human-interface-guidelines |

### Приложение D: Roadmap

```
v0.1.0  — Фаза 0 + 1: Репозиторий, исследование, ADR
v0.2.0  — Фаза 2: Архитектура токенов, Style Dictionary
v0.3.0  — Фаза 3: Foundation layer полностью заполнен
v0.4.0  — Фаза 4: Figma компоненты Tier 1
v0.5.0  — Фаза 4: Figma компоненты Tier 2 + 3
v0.6.0  — Фаза 5: Тематизация и example brand
v0.7.0  — Фаза 6: Кодовая реализация (CSS minimum)
v0.8.0  — Фаза 7: Документация
v0.9.0  — Фаза 8: CI/CD и автоматизация
v1.0.0  — Public release: stable API, полная документация
```

---

> **Примечание для Claude Code:**
> Этот документ является техническим заданием для поэтапной разработки. При работе с каждой фазой:
> 1. Читай соответствующий раздел целиком
> 2. Сверяйся с разделом «Контекст и ограничения»
> 3. Проверяй критерии завершения перед переходом к следующей фазе
> 4. Комментируй код на русском языке
> 5. Все файлы создавай в структуре, описанной в Фазе 0
