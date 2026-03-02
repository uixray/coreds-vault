---
title: "Design System Foundation"
type: "research"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/research"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Foundational research and principles for the CoreDS design system"
---

# Universal Design System — Foundation Document

**Версия:** 1.0.0  
**Дата:** 2025-02-13  
**Автор:** Ray (uixray)

---

## Оглавление

1. [Архитектура системы](#архитектура-системы)
2. [Структура файлов](#структура-файлов)
3. [Naming Convention](#naming-convention)
4. [Foundation Tokens](#foundation-tokens)
5. [Платформенная специфика](#платформенная-специфика)
6. [Версионирование и миграции](#версионирование-и-миграции)
7. [Workflow](#workflow)

---

## Архитектура системы

### Концепция: Core + Themes

Система разделена на два слоя:

**Core (ядро)** — универсальная база, независимая от проектов:
- Компоненты без брендинга (структура, логика, поведение)
- Токены как переменные (slots, не конкретные значения)
- Паттерны взаимодействия
- Accessibility правила

**Theme (тема)** — специфика клиента поверх Core:
- Цветовая палитра
- Типографика
- Скругления, тени, эффекты
- Брендированные иконки

**Принцип:** Core работает с любой темой без изменений. Если для клиента нужно менять структуру компонента — это недоработка Core, а не задача темы.

---

### Платформы и Figma Variables

**Проблема:** Figma даёт только 4 режима (modes) переменных на файл. Невозможно вместить веб (Desktop Wide, Desktop Narrow, Tablet, Mobile) + iOS (iPhone, iPad) + Android (Phone, Tablet) в один файл.

**Решение:** Split по платформам с единой логикой токенов.

**Структура Figma файлов:**

```
Core/
├── Core-Foundation.fig  → Семантические токены без режимов (цвета, типографика)
├── Core-Web.fig         → 4 режима: Desktop-Wide, Desktop-Narrow, Tablet, Mobile
├── Core-iOS.fig         → 4 режима: iPhone, iPad, (+ 2 резервных)
└── Core-Android.fig     → 4 режима: Phone, Tablet, (+ 2 резервных)
```

**Принцип работы:**
- `Core-Foundation.fig` хранит платформо-независимые токены (primitive colors, базовые размеры шрифтов)
- Платформенные файлы ссылаются на Foundation через aliasing и добавляют свои режимы для spacing, sizing, layout

---

## Структура файлов

### Git Repository (monorepo)

```
design-system/
├── core/
│   ├── foundation/
│   │   ├── colors.md
│   │   ├── typography.md
│   │   ├── spacing.md
│   │   ├── elevation.md
│   │   └── radius.md
│   ├── platforms/
│   │   ├── web/
│   │   │   ├── spacing.md
│   │   │   ├── breakpoints.md
│   │   │   └── components/
│   │   ├── ios/
│   │   │   ├── spacing.md
│   │   │   ├── safe-areas.md
│   │   │   └── components/
│   │   └── android/
│   │       ├── spacing.md
│   │       ├── material-guidelines.md
│   │       └── components/
│   ├── migrations/
│   │   ├── v1-to-v2.md
│   │   └── v2-to-v3.md
│   ├── CHANGELOG.md
│   └── README.md
├── themes/
│   ├── client-a/
│   │   ├── core-version.txt  → "v2.0.0"
│   │   ├── platform.txt      → "web"
│   │   └── tokens.md
│   ├── client-b/
│   │   ├── core-version.txt  → "v1.2.0"
│   │   ├── platform.txt      → "ios"
│   │   └── tokens.md
│   └── _template/
│       └── tokens-template.md
└── README.md
```

### Obsidian Vault

Та же структура, но в Obsidian для удобной работы с markdown, внутренними ссылками и автоматизации через Claude MCP.

---

## Naming Convention

### Общая структура токена

```
[category]/[subcategory]/[variant]/[state]
```

**Примеры:**
- `color/surface/primary/default`
- `spacing/component/gap/large`
- `typography/body/size/medium`

### Принципы именования

1. **Семантика над абстракцией** — имена описывают роль, а не внешний вид
   - ✅ `color/interactive/primary`
   - ❌ `color/blue/500`

2. **Платформенная нейтральность** — Core использует агностичные имена
   - ✅ `color/surface/primary`
   - ❌ `color/background` (HTML-специфично)

3. **Алиасинг для платформ** — платформенные файлы маппят Core токены на нативные концепции
   - Core: `color/surface/primary`
   - Web: `background-color`
   - iOS: `systemBackground`
   - Material: `surface`

---

## Foundation Tokens

### 1. Colors

#### Primitive Colors (базовая палитра)

Сырые цвета без семантики. Числовая шкала 50-900 (как Tailwind/Radix).

**Red Scale:**
```
color/primitive/red/50    → #FEF2F2
color/primitive/red/100   → #FEE2E2
color/primitive/red/500   → #EF4444  (base)
color/primitive/red/900   → #7F1D1D
```

**Blue Scale:**
```
color/primitive/blue/50   → #EFF6FF
color/primitive/blue/500  → #3B82F6  (base)
color/primitive/blue/900  → #1E3A8A
```

**Gray Scale:**
```
color/primitive/gray/50   → #F9FAFB
color/primitive/gray/100  → #F3F4F6
color/primitive/gray/200  → #E5E7EB
color/primitive/gray/300  → #D1D5DB
color/primitive/gray/400  → #9CA3AF
color/primitive/gray/500  → #6B7280  (base)
color/primitive/gray/600  → #4B5563
color/primitive/gray/700  → #374151
color/primitive/gray/800  → #1F2937
color/primitive/gray/900  → #111827
```

**Дополнительные цвета:**
```
color/primitive/green/50-900   → Success states
color/primitive/orange/50-900  → Warning states
color/primitive/yellow/50-900  → Info/caution states
```

---

#### Semantic Colors (семантические токены)

Кроссплатформенные роли цветов. Алиасы на primitive colors.

**Surfaces (фоны):**
```
color/surface/primary     → Основной фон
  Web: body background
  iOS: systemBackground
  Material: surface

color/surface/secondary   → Вторичный фон (карточки, панели)
  Web: panel background
  iOS: secondarySystemBackground
  Material: surfaceVariant

color/surface/tertiary    → Третичный фон (elevated элементы)
  Web: elevated cards
  iOS: tertiarySystemBackground
  Material: surfaceContainer
```

**Content (текст и иконки):**
```
color/content/primary     → Основной текст
  Web: default text color
  iOS: label
  Material: onSurface

color/content/secondary   → Вторичный текст
  iOS: secondaryLabel
  Material: onSurfaceVariant

color/content/tertiary    → Tertiary текст
  iOS: tertiaryLabel

color/content/disabled    → Disabled состояние
  iOS: quaternaryLabel
  Material: onSurface @ 38% opacity
```

**Interactive (интерактивные элементы):**
```
color/interactive/primary           → Основной accent
  Web: links, primary buttons
  iOS: tintColor
  Material: primary

color/interactive/primary-hover     → Hover state (web-only)
color/interactive/primary-active    → Active/pressed state
color/interactive/primary-disabled  → Disabled state

color/interactive/secondary         → Вторичный accent
```

**Feedback (системные состояния):**
```
color/feedback/success   → Успешное действие
  HTML/ARIA: role="status"
  iOS: systemGreen
  Material: tertiary (green)

color/feedback/error     → Ошибка
  HTML/ARIA: role="alert"
  iOS: systemRed
  Material: error

color/feedback/warning   → Предупреждение
  iOS: systemOrange
  Material: warning

color/feedback/info      → Информация
  iOS: systemBlue
  Material: info
```

**Borders & Dividers:**
```
color/border/default   → Базовая обводка
color/border/subtle    → Едва заметная (разделители)
color/border/strong    → Акцентная обводка
color/border/focus     → Focus ring
```

**Overlays:**
```
color/overlay/scrim     → Затемнение под модалами (Material: scrim)
color/overlay/backdrop  → Фон модальных окон (обычно black @ 50% opacity)
```

---

### 2. Typography

#### Font Families

```
typography/family/base      → Основной шрифт
  Web: Inter / System UI
  iOS: SF Pro
  Android: Roboto

typography/family/heading   → Заголовочный (часто = base)

typography/family/mono      → Моноширинный (код)
  Web: JetBrains Mono / Consolas
  iOS: SF Mono
  Android: Roboto Mono
```

---

#### Font Sizes (абстрактная шкала)

T-shirt sizing + numeric для гибкости:

```
typography/size/xs    → 12px / 0.75rem
typography/size/sm    → 14px / 0.875rem
typography/size/base  → 16px / 1rem     (body text)
typography/size/lg    → 18px / 1.125rem
typography/size/xl    → 20px / 1.25rem
typography/size/2xl   → 24px / 1.5rem
typography/size/3xl   → 30px / 1.875rem
typography/size/4xl   → 36px / 2.25rem
typography/size/5xl   → 48px / 3rem
typography/size/6xl   → 60px / 3.75rem
```

---

#### Line Heights (относительные)

```
typography/lineheight/tight   → 1.2    (заголовки)
typography/lineheight/snug    → 1.375  (подзаголовки)
typography/lineheight/normal  → 1.5    (body text, WCAG compliant)
typography/lineheight/relaxed → 1.75   (длинные тексты)
typography/lineheight/loose   → 2.0    (очень длинные тексты)
```

---

#### Font Weights

```
typography/weight/regular   → 400
typography/weight/medium    → 500
typography/weight/semibold  → 600
typography/weight/bold      → 700
```

---

#### Text Styles (композитные токены)

Опираются на HTML5 семантику:

```
typography/style/h1
  family: heading
  size: 4xl (36px)
  weight: bold
  lineheight: tight (1.2)

typography/style/h2
  family: heading
  size: 3xl (30px)
  weight: bold
  lineheight: tight

typography/style/h3
  family: heading
  size: 2xl (24px)
  weight: semibold
  lineheight: tight

typography/style/h4
  family: heading
  size: xl (20px)
  weight: semibold
  lineheight: snug

typography/style/body-lg
  family: base
  size: lg (18px)
  weight: regular
  lineheight: normal

typography/style/body
  family: base
  size: base (16px)
  weight: regular
  lineheight: normal

typography/style/body-sm
  family: base
  size: sm (14px)
  weight: regular
  lineheight: normal

typography/style/caption
  family: base
  size: xs (12px)
  weight: regular
  lineheight: normal

typography/style/label
  family: base
  size: sm (14px)
  weight: medium
  lineheight: tight

typography/style/code
  family: mono
  size: sm (14px)
  weight: regular
  lineheight: normal
```

---

### 3. Spacing & Sizing

#### Base Unit

```
spacing/base → 4px
```

Система построена на 4px/8px grid (стандарт iOS, Material, большинство веб-фреймворков).

---

#### Spacing Scale (8pt grid)

```
spacing/0    → 0px
spacing/1    → 4px   (0.25rem)
spacing/2    → 8px   (0.5rem)
spacing/3    → 12px  (0.75rem)
spacing/4    → 16px  (1rem)
spacing/5    → 20px  (1.25rem)
spacing/6    → 24px  (1.5rem)
spacing/8    → 32px  (2rem)
spacing/10   → 40px  (2.5rem)
spacing/12   → 48px  (3rem)
spacing/16   → 64px  (4rem)
spacing/20   → 80px  (5rem)
spacing/24   → 96px  (6rem)
spacing/32   → 128px (8rem)
```

---

#### Семантические Spacing (роль, не размер)

**Component Gap (расстояния между элементами внутри компонента):**
```
spacing/component/gap/xs   → spacing/2  (8px)
spacing/component/gap/sm   → spacing/3  (12px)
spacing/component/gap/md   → spacing/4  (16px)
spacing/component/gap/lg   → spacing/6  (24px)
spacing/component/gap/xl   → spacing/8  (32px)
```

**Component Padding (внутренние отступы):**
```
spacing/component/padding/xs   → spacing/2  (8px)
spacing/component/padding/sm   → spacing/3  (12px)
spacing/component/padding/md   → spacing/4  (16px)
spacing/component/padding/lg   → spacing/6  (24px)
spacing/component/padding/xl   → spacing/8  (32px)
```

**Layout Spacing (отступы между секциями):**
```
spacing/layout/section     → spacing/16 (64px)
spacing/layout/container   → spacing/8  (32px)
spacing/layout/stack/sm    → spacing/4  (16px)
spacing/layout/stack/md    → spacing/6  (24px)
spacing/layout/stack/lg    → spacing/8  (32px)
```

---

#### Sizing (размеры компонентов)

**Icons:**
```
sizing/icon/xs   → 12px
sizing/icon/sm   → 16px
sizing/icon/md   → 24px
sizing/icon/lg   → 32px
sizing/icon/xl   → 48px
```

**Buttons:**
```
sizing/button/height/sm  → 32px
sizing/button/height/md  → 40px
sizing/button/height/lg  → 48px
sizing/button/height/xl  → 56px
```

**Inputs:**
```
sizing/input/height/sm   → 32px
sizing/input/height/md   → 40px
sizing/input/height/lg   → 48px
```

**Avatar:**
```
sizing/avatar/xs   → 24px
sizing/avatar/sm   → 32px
sizing/avatar/md   → 40px
sizing/avatar/lg   → 48px
sizing/avatar/xl   → 64px
sizing/avatar/2xl  → 96px
```

---

### 4. Border Radius

```
radius/none   → 0px
radius/sm     → 4px
radius/md     → 8px
radius/lg     → 12px
radius/xl     → 16px
radius/2xl    → 24px
radius/full   → 9999px (pill shape / circle)
```

**Семантические алиасы:**
```
radius/button  → radius/md  (8px)
radius/input   → radius/md  (8px)
radius/card    → radius/lg  (12px)
radius/modal   → radius/xl  (16px)
```

---

### 5. Elevation / Shadows

Material использует elevation levels (0-5), iOS — blur + offset. Core определяет уровни абстрактно.

```
elevation/0  → Нет тени (flat)
  Web: box-shadow: none
  iOS: no shadow
  Material: elevation 0dp

elevation/1  → Subtle (карточки на фоне)
  Web: box-shadow: 0 1px 3px rgba(0,0,0,0.1)
  iOS: shadow offset (0, 1), blur 2, opacity 0.1
  Material: elevation 1dp

elevation/2  → Medium (dropdown, поповеры)
  Web: box-shadow: 0 4px 6px rgba(0,0,0,0.1)
  iOS: shadow offset (0, 2), blur 8, opacity 0.15
  Material: elevation 3dp

elevation/3  → High (modal dialogs)
  Web: box-shadow: 0 10px 15px rgba(0,0,0,0.1)
  iOS: shadow offset (0, 4), blur 16, opacity 0.2
  Material: elevation 8dp

elevation/4  → Highest (tooltip поверх модала)
  Web: box-shadow: 0 20px 25px rgba(0,0,0,0.15)
  iOS: shadow offset (0, 8), blur 24, opacity 0.25
  Material: elevation 16dp
```

В Figma это Effects (drop shadow), которые платформы переопределяют своими значениями.

---

### 6. Boolean Variables (Presentation Mode)

Для скрытия рабочих элементов при презентации клиенту или handoff разработчикам.

```
mode/show-specs        → true/false  (размеры, аннотации)
mode/show-grid         → true/false  (сетка)
mode/show-redlines     → true/false  (redlines для dev handoff)
mode/show-annotations  → true/false  (комментарии дизайнера)
mode/show-placeholders → true/false  (placeholder контент)
```

В Figma это Boolean Variables, управляющие видимостью слоёв через conditional visibility.

---

## Платформенная специфика

### Web Platform

**Файл:** `Core-Web.fig`

**Режимы (Modes):**
1. Desktop-Wide (>1440px)
2. Desktop-Narrow (1024-1439px)
3. Tablet (768-1023px)
4. Mobile (<768px)

**Специфические токены:**

```
# Breakpoints
breakpoint/mobile   → 0px
breakpoint/tablet   → 768px
breakpoint/desktop  → 1024px
breakpoint/wide     → 1440px

# Container widths
container/mobile    → 100%
container/tablet    → 720px
container/desktop   → 960px
container/wide      → 1280px

# Responsive spacing (меняются по режимам)
spacing/component/gap/md:
  Desktop-Wide: 24px
  Desktop-Narrow: 20px
  Tablet: 16px
  Mobile: 12px
```

**Hover states:** обязательны для интерактивных элементов.

---

### iOS Platform

**Файл:** `Core-iOS.fig`

**Режимы (Modes):**
1. iPhone
2. iPad
3. (резерв)
4. (резерв)

**Специфические токены:**

```
# Safe Areas (dynamic, зависит от устройства)
safearea/top     → dynamic (notch/status bar)
safearea/bottom  → dynamic (home indicator)
safearea/leading → dynamic
safearea/trailing → dynamic

# iOS HIG minimum sizes
sizing/tap-target/min  → 44px  (minimum tap target iOS HIG)

# iOS-specific spacing
spacing/component/gap/md:
  iPhone: 16px
  iPad: 20px
```

**Шрифт:** SF Pro (system font), использует Dynamic Type.

**Elevation:** iOS использует слои с blur, а не стандартные тени.

---

### Android Platform

**Файл:** `Core-Android.fig`

**Режимы (Modes):**
1. Phone
2. Tablet
3. (резерв)
4. (резерв)

**Специфические токены:**

```
# Material Design 3 minimum sizes
sizing/tap-target/min  → 48dp  (minimum touch target M3)

# Responsive spacing
spacing/component/gap/md:
  Phone: 16dp
  Tablet: 24dp
```

**Шрифт:** Roboto (system font), использует Material Type Scale.

**Elevation:** Material Design elevation (0-16dp), реализуется через shadowColor + shadowOffset.

---

## Версионирование и миграции

### Semantic Versioning

```
vMAJOR.MINOR.PATCH
```

- **MAJOR (1.x.x)** — Breaking changes (изменение структуры токенов, API компонентов)
- **MINOR (x.2.x)** — Новые компоненты или опциональные токены (backwards compatible)
- **PATCH (x.x.3)** — Багфиксы, визуальные улучшения без изменения API

**Примеры:**
```
v1.0.0  → Initial Core release
v1.1.0  → Added Dropdown component
v1.2.0  → Added dark mode tokens (optional)
v2.0.0  → BREAKING: Renamed all spacing tokens to numerical scale
```

---

### Версионирование тем клиентов

Каждая тема пиннится к конкретной версии Core:

```
themes/client-a/
├── tokens.md
├── core-version.txt  → "v1.2.0"
└── platform.txt      → "web"
```

**Принцип:** тема может оставаться на старой версии Core, если не требуется обновление. Migration происходит только при необходимости.

---

### Migration Strategy

При выходе breaking change (major version):

1. **Создать Migration Guide** — пошаговая инструкция с примерами
2. **Мигрировать одну тестовую тему** — proof of concept
3. **Обновить остальные темы по мере необходимости** — когда клиент заказывает обновление

**Пример Migration Guide структуры:**

```markdown
# Migration Guide: v1.x → v2.0

## Breaking Changes

### Spacing tokens renamed
- OLD: `spacing/sm`, `spacing/md`, `spacing/lg`
- NEW: `spacing/100`, `spacing/200`, `spacing/300`

**Migration steps:**
1. Open your theme file Variables panel
2. Find-replace: `spacing/sm` → `spacing/100`
3. Find-replace: `spacing/md` → `spacing/200`
4. Find-replace: `spacing/lg` → `spacing/300`

### Button component: removed `small` variant
- OLD: Button had 3 sizes (small, medium, large)
- NEW: Button has 2 sizes (medium, large)

**Migration steps:**
If you used `small` buttons, replace with `medium` and adjust spacing manually.

## Non-breaking Changes
- Added `elevation/5` level
- Added `color/feedback/info` token
```

---

### Changelog

Ведётся в `core/CHANGELOG.md`:

```markdown
# Changelog

All notable changes to Core Design System will be documented here.

## [Unreleased]

## [2.0.0] - 2025-03-15
### BREAKING CHANGES
- Renamed all spacing tokens to numerical scale (spacing/4, spacing/8, etc.)
- Removed `Button/small` variant
- Changed elevation system to 5 levels (was 4)

### Added
- `elevation/4` level for highest z-index elements

### Migration
See [Migration Guide v1→v2](migrations/v1-to-v2.md)

## [1.2.0] - 2025-02-20
### Added
- Dark mode support via `color/mode/dark` tokens
- New component: `Dropdown`

### Changed
- Updated `color/interactive/primary` hover state opacity

## [1.1.0] - 2025-01-15
### Added
- New component: `Tooltip`
- `sizing/avatar` tokens

## [1.0.0] - 2025-01-01
### Added
- Initial Core release
- Foundation tokens (colors, typography, spacing, elevation, radius)
- Platform files (Web, iOS, Android)
```

---

## Workflow

### Workflow 1: Новый клиент

1. **Дублировать template:**
   ```bash
   cp -r themes/_template themes/client-c
   ```

2. **Заполнить токены:**
   - Открыть `themes/client-c/tokens.md`
   - Заполнить цвета, шрифты из брендбука клиента
   - Указать версию Core: `v1.2.0`
   - Указать платформу: `web` или `ios` или `android`

3. **Создать Figma Theme файл:**
   - Новый файл в Figma
   - Подключить соответствующий Core файл как библиотеку
   - Переопределить Variables согласно `tokens.md`

4. **Закоммитить:**
   ```bash
   git add themes/client-c/
   git commit -m "Add theme for Client C (v1.2.0, web)"
   git push
   ```

---

### Workflow 2: Обновление Core

1. **Внести изменения в Core:**
   - Обновить Figma файлы (Foundation, платформенные)
   - Обновить документацию в `core/foundation/` или `core/platforms/`

2. **Определить версию:**
   - Breaking change? → major version (v2.0.0)
   - Новый компонент? → minor version (v1.3.0)
   - Багфикс? → patch version (v1.2.1)

3. **Создать Migration Guide (если breaking):**
   - `core/migrations/v1-to-v2.md`

4. **Обновить Changelog:**
   - Добавить запись в `core/CHANGELOG.md`

5. **Тегировать версию:**
   ```bash
   git add core/
   git commit -m "Core v2.0.0: Rename spacing tokens"
   git tag v2.0.0
   git push origin v2.0.0
   ```

6. **Опубликовать библиотеку в Figma:**
   - Обновить Core-Foundation.fig, Core-Web.fig и т.д.
   - Опубликовать (Publish) библиотеки

---

### Workflow 3: Миграция темы клиента

1. **Выбрать тему для миграции:**
   ```bash
   cd themes/client-a
   cat core-version.txt  # v1.2.0
   ```

2. **Прочитать Migration Guide:**
   - `core/migrations/v1-to-v2.md`

3. **Мигрировать тему:**
   - Открыть Figma файл темы
   - Выполнить шаги из Migration Guide
   - Обновить Variables

4. **Обновить документацию темы:**
   - Изменить `themes/client-a/core-version.txt` → `v2.0.0`
   - Обновить `themes/client-a/tokens.md` если нужно

5. **Закоммитить:**
   ```bash
   git add themes/client-a/
   git commit -m "Migrate Client A theme to Core v2.0.0"
   git push
   ```

---

### Workflow 4: Автоматизация через Claude MCP

**Генерация документации компонента:**

1. Создать/обновить компонент в Figma
2. Дать Claude ссылку на Figma компонент через MCP
3. Claude читает структуру, токены, состояния
4. Claude генерирует/обновляет Markdown документ

**Проверка темы на соответствие Core:**

1. Дать Claude две ссылки: Core + Theme
2. Claude проверяет использование токенов, находит хардкод
3. Claude выдаёт список проблем

**Batch-аудит всех тем:**

1. Запросить у Claude проверку всех тем
2. Claude проходит по `themes/*/`, читает `core-version.txt`
3. Claude выдаёт список: какие темы на каких версиях, есть ли deprecated токены

---

## Следующие шаги

### Phase 1: Foundation (1-2 недели)

- [ ] Создать структуру папок в Git
- [ ] Настроить Obsidian vault
- [ ] Создать Figma файл `Core-Foundation.fig`
- [ ] Задокументировать все Foundation токены в Markdown
- [ ] Создать первую версию v1.0.0

**Документы для создания:**
- `core/foundation/colors.md`
- `core/foundation/typography.md`
- `core/foundation/spacing.md`
- `core/foundation/elevation.md`
- `core/foundation/radius.md`

---

### Phase 2: Платформенные файлы (1-2 недели)

- [ ] Создать `Core-Web.fig` с 4 режимами
- [ ] Создать `Core-iOS.fig` с 2 режимами
- [ ] Создать `Core-Android.fig` с 2 режимами
- [ ] Задокументировать платформенную специфику

**Документы для создания:**
- `core/platforms/web/spacing.md`
- `core/platforms/web/breakpoints.md`
- `core/platforms/ios/spacing.md`
- `core/platforms/ios/safe-areas.md`
- `core/platforms/android/spacing.md`

---

### Phase 3: Базовые компоненты (2-3 недели)

- [ ] Создать 5-7 базовых компонентов в Core
  - Button
  - Input
  - Card
  - Typography
  - Icon
  - Dropdown
  - Tooltip
- [ ] Задокументировать каждый компонент
- [ ] Опубликовать как библиотеки в Figma

**Документы для создания:**
- `core/platforms/web/components/button.md`
- `core/platforms/web/components/input.md`
- и т.д.

---

### Phase 4: Proof of Concept (1 неделя)

- [ ] Взять один реальный проект
- [ ] Создать для него Theme (Client A)
- [ ] Задокументировать в `themes/client-a/`
- [ ] Протестировать workflow
- [ ] Отрефакторить Core на основе опыта

---

### Phase 5: Масштабирование

- [ ] Мигрировать остальные проекты на Core
- [ ] Создать темы для каждого клиента
- [ ] Настроить автоматизацию через Claude MCP
- [ ] Обучить процессу команду (если есть)

---

## Инструменты и автоматизация

### Obsidian

- Vault для документации
- Внутренние ссылки между токенами и компонентами
- Templates для новых компонентов/тем
- Плагины: Git, Dataview (для автоматических индексов)

### Git

- Версионирование документации
- Теги для релизов Core
- Отдельные ветки для экспериментов

### Claude MCP (Figma integration)

- Чтение Figma файлов
- Генерация документации
- Проверка консистентности
- Автоматическое обновление Markdown при изменениях в Figma

### Figma

- Core файлы как Published Libraries
- Themes файлы подключают Core
- Variables для токенов
- Boolean Variables для presentation mode

---

## Ссылки и ресурсы

### Стандарты и гайдлайны

- **HTML5 Semantic Elements:** https://developer.mozilla.org/en-US/docs/Web/HTML/Element
- **W3C ARIA:** https://www.w3.org/TR/wai-aria/
- **iOS Human Interface Guidelines:** https://developer.apple.com/design/human-interface-guidelines/
- **Material Design 3:** https://m3.material.io/

### Референсы для токенов

- **Tailwind CSS Scale:** https://tailwindcss.com/docs/customizing-colors
- **Radix Colors:** https://www.radix-ui.com/colors
- **Open Props:** https://open-props.style/

### Системы от крупных компаний

- **GitHub Primer:** https://primer.style/
- **Shopify Polaris:** https://polaris.shopify.com/
- **Atlassian Design System:** https://atlassian.design/

---

## Контакты

**GitHub:** [uixray](https://github.com/uixray)  
**Design System Repository:** `design-system` (создать)

---

**Документ создан:** 2025-02-13  
**Версия документа:** 1.0  
**Последнее обновление:** 2025-02-13
