---
title: "Gemini Deep Research Prompts"
type: "meta"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/meta"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Collection of prompts for Gemini deep research sessions"
---

# Промпты для Gemini Deep Research — Фаза 0–1

> **Проект:** CoreDS Vault (Design System + Pattern Library)
> **Всего промптов:** 18
> **Приоритет:** P0 (8 шт.) → P1 (7 шт.) → P2 (3 шт.)
> **Сохранять в:** `03-research/deep-research/DR-XXX-*.md`

---

## Порядок запуска

```
Неделя 1:  DR-004, DR-005        ← Фундамент (DTCG + Style Dictionary)
Неделя 2:  DR-008, DR-001        ← Figma + Naming convention
Неделя 3:  DR-014, DR-016        ← Platform divergence + AI patterns
Неделя 4:  DR-012, DR-002        ← Heuristics mapping + Token mapping
Далее:     P1 и P2 по мере необходимости
```

---

## 🔴 P0 — Критичные

---

### DR-004: DTCG Design Tokens Specification 2025.10

**Для:** Token Architecture
[[DR-004-dtcg-spec]]

```
Проведи полный технический разбор W3C Design Tokens Community Group (DTCG) Specification версии 2025.10 (stable v1, опубликована 28 октября 2025).

Мне нужно:

1. ФОРМАТ ФАЙЛА:
- Полная структура JSON файла с $value, $type, $description, $extensions
- Правила именования групп (group nesting)
- Поддерживаемый media type (application/design-tokens+json)
- Расширения файлов (.tokens, .tokens.json)

2. ВСЕ ПОДДЕРЖИВАЕМЫЕ ТИПЫ ($type) — для каждого покажи:
- JSON пример со всеми свойствами
- Допустимые значения
- Пример использования в реальной дизайн-системе
Типы: color, dimension, fontFamily, fontWeight, duration, cubicBezier, number, strokeStyle, border (composite), transition (composite), shadow (composite), gradient, typography (composite)

3. АЛИАСЫ (REFERENCES):
- Синтаксис ссылок: {group.token} и JSON Pointer
- Правила разрешения алиасов (resolution)
- Циклические ссылки — как обрабатываются
- Межфайловые ссылки (multi-file support)

4. ЦВЕТОВЫЕ ПРОСТРАНСТВА:
- Все 14 поддерживаемых color spaces
- Синтаксис для oklch, Display P3, Lab, oklab
- Примеры JSON для каждого формата
- Рекомендации: когда sRGB, когда oklch, когда P3

5. COMPOSITE TOKENS:
- typography: полная структура (fontFamily, fontSize, fontWeight, lineHeight, letterSpacing)
- shadow: структура (color, offsetX, offsetY, blur, spread, inset)
- border: структура (color, width, style)
- transition: структура (duration, delay, timingFunction)
- Можно ли ссылаться на отдельные свойства внутри composite token?

6. $EXTENSIONS:
- Назначение и синтаксис
- Как использовать для хранения мета-информации (тем, платформ, описаний)
- Примеры $extensions для theming

7. СОВМЕСТИМОСТЬ С ИНСТРУМЕНТАМИ:
- Style Dictionary v4 — уровень поддержки, ограничения
- Tokens Studio — уровень поддержки
- Figma Variables — маппинг DTCG types на Figma variable types

Формат ответа: структурированный markdown с JSON примерами для каждого пункта. Никаких общих фраз — только конкретные спецификации и примеры кода.
```

---

### DR-005: Style Dictionary v4 — полная конфигурация

**Для:** Token Architecture
[[DR-005-style-dictionary-v4]]

```
Подробный практический гайд по настройке Style Dictionary версии 4 для мультиплатформенной дизайн-системы.

КОНТЕКСТ МОЕГО ПРОЕКТА:
- Source tokens в формате W3C DTCG 2025.10 ($value, $type)
- 3 уровня токенов: primitive → semantic → component (с алиасами через {group.token})
- Целевые платформы: CSS Custom Properties, Swift (UIKit + SwiftUI), Kotlin (Compose)
- Theming: light/dark через отдельные semantic token файлы

Мне нужно:

1. ПОЛНЫЙ config.ts (TypeScript):
- Настройка source paths для DTCG файлов
- Platform definitions для css, ios-swift, android-compose
- Transform groups для каждой платформы
- Output paths и file formats

2. КАСТОМНЫЕ TRANSFORMS — конкретный код для:
- color: DTCG color → css (hex / oklch), swift (UIColor / Color), kotlin (Color)
- dimension: px → rem (css), pt (swift), dp (kotlin)
- typography (composite): → CSS shorthand, swift Typography struct, kotlin TextStyle
- shadow (composite): → CSS box-shadow, swift NSShadow, kotlin Modifier.shadow
- duration: ms → CSS duration, swift TimeInterval, kotlin Long
- cubicBezier: → CSS cubic-bezier(), swift UIView.animate params, kotlin PathInterpolator

3. КАСТОМНЫЕ FORMATS:
- CSS: файл с :root { --token-name: value; }
- Swift: enum/struct с static properties
- Kotlin: object с val properties
- Покажи полный код каждого format

4. outputReferences:
- Как сохранить алиасы в CSS output: --semantic-token: var(--primitive-token)
- Когда outputReferences работает, а когда нет (ограничения)
- Как это работает для Swift и Kotlin

5. MULTI-FILE OUTPUT:
- Разделение по категориям: colors.css, typography.css, spacing.css
- Разделение по темам: light.css, dark.css
- Фильтрация токенов через matcher/filter

6. BUILD SCRIPT (package.json):
- npm run build:tokens — собрать все платформы
- npm run build:theme -- --name=brand — собрать конкретную тему
- Watch mode для разработки

7. ОШИБКИ И ПОДВОДНЫЕ КАМНИ:
- Нельзя комбинировать DTCG и старый SD формат
- Порядок трансформов имеет значение
- Composite tokens требуют кастомных трансформов
- Неразрешённые алиасы — как диагностировать

Формат: полный рабочий код (TypeScript), который я могу скопировать и запустить. Комментарии в коде на русском.
```

---

### DR-008: Figma Variables Architecture

**Для:** Figma Components
**Сохранить как:** `DR-008-figma-variables.md`
[[DR-008-figma-variables]]

```
Лучшие практики организации Figma Variables для кроссплатформенной дизайн-системы.

МОИ ОГРАНИЧЕНИЯ:
- Figma Professional план: 10 modes на коллекцию, Extended Collections недоступны
- Нужно поддержать: Light/Dark тема, 3 breakpoints (Desktop/Tablet/Mobile), плюс мультибрендовость
- Токены уже определены в DTCG JSON: primitives → semantics → components

Мне нужно:

1. РАСПРЕДЕЛЕНИЕ COLLECTIONS И MODES:
Покажи конкретную схему: какие collections создать, сколько modes в каждой, какие типы variables.

Рассмотри два варианта:
- Вариант A: Раздельные коллекции (Color: Light/Dark, Dimension: Desktop/Tablet/Mobile, Typography: Desktop/Tablet/Mobile)
- Вариант B: Комбинированные modes (Light-Desktop, Light-Tablet, Dark-Desktop...)

Для каждого варианта: сколько modes используется из 10, плюсы, минусы, ограничения.

2. ALIASING МЕЖДУ COLLECTIONS:
- Как primitive collection ссылается на semantic collection
- Как component collection ссылается на semantic
- Ограничения: можно ли ссылаться между collections с разным количеством modes?
- Конкретные примеры

3. МУЛЬТИБРЕНДОВОСТЬ БЕЗ EXTENDED COLLECTIONS:
- Стратегия 1: Отдельные файлы Figma с переопределением variables
- Стратегия 2: Tokens Studio plugin для управления брендами
- Стратегия 3: Swap library feature
Для каждой: пошаговая инструкция, плюсы/минусы

4. VARIABLE NAMING:
- Как именовать variables в Figma чтобы они маппились на DTCG токены
- Slash notation (color/action/primary) vs dot notation
- Группировка в Figma variable panel

5. СИНХРОНИЗАЦИЯ FIGMA ↔ CODE:
- Figma Variables → Export JSON → Git → Style Dictionary → Platforms
- Code → Figma: DTCG JSON → Figma REST API → Variables
- Какие инструменты/плагины использовать для каждого направления

6. КОНКРЕТНЫЕ ПРИМЕРЫ из реальных дизайн-систем которые решают аналогичные ограничения на Professional плане.

Формат: конкретные схемы, таблицы, пошаговые инструкции. Не общие рекомендации, а actionable решения.
```

---

### DR-001: Naming Conventions Audit

**Для:** ADR-003 (Naming Convention)
[[DR-001-naming-conventions]]

```
Проведи сравнительный анализ naming conventions для design tokens в следующих дизайн-системах:
1. Material Design 3 (Google)
2. Shopify Polaris
3. IBM Carbon
4. Atlassian Design System
5. Salesforce Lightning Design System (SLDS)
6. Adobe Spectrum
7. GitHub Primer
8. Open Props

Для каждой системы собери:

1. ФОРМАТ ИМЕНОВАНИЯ:
- Разделитель: dot (.) / slash (/) / dash (-) / camelCase
- Регистр: kebab-case, camelCase, PascalCase
- Примеры полных имён токенов

2. СТРУКТУРА ИМЕНИ — конкретные примеры для 3 уровней:
- Primitive: цвет blue-600, размер spacing-4, шрифт font-sans
- Semantic: action-primary, surface-default, text-body
- Component: button-bg-default, input-border-error

3. ПАТТЕРН ИМЕНОВАНИЯ:
- CTI (Category/Type/Item): color.action.primary
- DTCG groups: color.brand.primary.500
- Role-based: interactive.default, decorative.subtle
- Какой паттерн использует каждая система?

4. СОСТОЯНИЯ И МОДИФИКАТОРЫ:
- Как именуют состояния: hover, active, focus, disabled
- Где стоит состояние в имени: в конце (button.bg.hover) или в середине (button.hover.bg)?
- Default — пишется явно или подразумевается?

Создай ИТОГОВУЮ ТАБЛИЦУ СРАВНЕНИЯ и сформулируй РЕКОМЕНДАЦИЮ для новой open-source дизайн-системы, которая:
- Поддерживает Web + iOS + Android
- Использует DTCG формат
- Должна быть интуитивно понятна новым пользователям
- Должна хорошо работать в CSS (--token-name), Swift (enum), Kotlin (object)
```

---

### DR-014: Platform Divergence Matrix 

**Для:** Platform Patterns
**Сохранить как:** `DR-014-platform-divergence.md`
[[DR-014-platform-divergence]]

```
Создай полную матрицу UI/UX различий между Web, iOS и Android для всех основных категорий интерфейсных решений.

Для каждого пункта укажи:
- Конкретное значение / паттерн для Web (с CSS/HTML reference)
- Конкретное значение / паттерн для iOS (Apple HIG reference, актуальная версия)
- Конкретное значение / паттерн для Android (Material Design 3 reference)
- Рекомендация для мультиплатформенной дизайн-системы: converge или diverge

КАТЕГОРИИ:

1. NAVIGATION:
- Primary navigation (tabs, sidebar, drawer, bottom bar)
- Back navigation (browser back, swipe, system button)
- Breadcrumbs, Tab bars, Modal/Sheet navigation, Deep linking

2. INPUT & INTERACTION:
- Minimum touch/click targets (конкретные px, pt, dp)
- Gesture vocabulary (tap, double tap, long press, swipe, pinch, rotate)
- Keyboard types, Date/time pickers, Text selection, Context menus, Drag and drop

3. LAYOUT:
- Safe areas (notch, Dynamic Island, navigation bar, status bar)
- Breakpoints / Size classes / Window size classes
- Grid system, Scroll behavior, Keyboard avoidance, Split view

4. TYPOGRAPHY:
- System fonts: San Francisco, Roboto, system-ui
- Dynamic Type (iOS) / Font scaling (Android) / font-size (web)
- Конкретные размеры body, caption, heading по платформам
- Font weight mapping (400-700 → platform equivalents)

5. SYSTEM UI:
- Status bar, Navigation bar, Alerts/Dialogs, Action sheets/Bottom sheets
- Toast/Snackbar, Notifications, Permission requests

6. FEEDBACK:
- Haptic feedback — типы, когда использовать
- Loading indicators, Pull-to-refresh, Sound feedback

7. ACCESSIBILITY:
- Screen readers: VoiceOver, TalkBack, browser screen readers
- Contrast ratios, Focus indicators, Reduced motion, Voice control

Формат: для каждого пункта — таблица Web | iOS | Android | Рекомендация DS. Конкретные числовые значения и названия нативных компонентов.
```

---

### DR-016: AI UX Patterns Catalog 2025

**Для:** AI Patterns
**Сохранить как:** `DR-016-ai-ux-patterns.md`

```
Создай полный каталог AI UX паттернов на 2025–2026 год. Структурируй по этапам AI interaction flow:

1. INITIATE (начало):
- Blank prompt / empty state
- Prompt suggestions / starters
- AI feature discovery

2. COMPOSE (создание запроса):
- Free-form prompt input
- Contextual AI (Notion AI, Figma AI)
- Scoping / Context setting (Claude Projects, Perplexity Focus)
- Prompt templates (Midjourney, GPT Actions)
- Multimodal input (текст + изображение + файл + голос)
- Refinement controls (tone, length, format)
- Model selection

3. PROCESS (обработка):
- Streaming output
- Thinking indicators (Claude thinking, o1 reasoning)
- Progress for long tasks
- Cancel / stop generation

4. RECEIVE (результат):
- Structured output (artifacts, canvas)
- Progressive disclosure (summary → details)
- Source attribution / citations
- Confidence indicators
- Multi-artifact

5. REFINE (уточнение):
- Edit / regenerate
- Branch / compare
- Follow-up prompts
- History / versions

6. TRUST (доверие):
- AI vs Human badge (EU AI Act)
- Explainability
- Human-in-the-loop
- Undo / rollback
- Data privacy controls

7. AGENTIC (агенты):
- Task delegation (Copilot Workspace, Devin, Claude Code)
- Multi-step task visualization
- Agent-human handoff
- Autonomy levels
- Multi-agent orchestration

Для КАЖДОГО паттерна:
- Описание (2-3 предложения)
- Конкретные примеры из реальных продуктов
- Какие UI компоненты нужны
- Accessibility considerations
- Когда НЕ использовать

Также: анти-паттерны, emerging patterns 2025-2026, regulatory patterns (EU AI Act).
```

---

### DR-012: UX Heuristics → Design System Mapping

**Для:** Foundations
**Сохранить как:** `DR-012-heuristics-mapping.md`

```
Создай маппинг между основными UX-эвристиками и компонентами дизайн-системы.

3 набора принципов:

НАБОР 1 — Nielsen's 10 Usability Heuristics (все 10)
НАБОР 2 — Don Norman's Design Principles (Affordance, Signifiers, Mapping, Feedback, Constraints, Conceptual Model)
НАБОР 3 — Laws of UX (Fitts, Hick, Miller, Jakob, Doherty, Von Restorff, Aesthetic-Usability, Peak-End, Zeigarnik, Tesler, Postel)

Для КАЖДОГО принципа/закона:

1. КОМПОНЕНТЫ которые его реализуют (Button, Input, Toast, Dialog, Progress Bar и т.д.) — как именно
2. DESIGN TOKENS которые его поддерживают (motion.duration, color.state.error, space.target.min)
3. UX ПАТТЕРНЫ основанные на нём (loading states, form validation, empty states)
4. ACCESSIBILITY REQUIREMENTS (WCAG критерии)
5. ПЛАТФОРМЕННЫЕ РАЗЛИЧИЯ (Web vs iOS vs Android)

Формат: структурированная таблица для каждого принципа с 5 колонками. Примеры из реальных продуктов.
```

---

### DR-002: Platform Token Mapping

**Для:** Token Architecture
**Сохранить как:** `DR-002-platform-token-mapping.md`

```
Как мультиплатформенные дизайн-системы маппят design tokens на web (CSS), iOS (Swift/SwiftUI) и Android (Kotlin/Compose)?

Конкретный маппинг для каждой категории:

1. COLOR: hex → CSS custom property, UIColor (Swift), Color (Compose). Opacity, Dynamic color, P3/wide gamut.

2. DIMENSION: px → rem/em (CSS), pt (iOS), dp (Android). Формулы конвертации.

3. TYPOGRAPHY: fontSize, lineHeight, fontWeight, fontFamily, letterSpacing — конвертация для каждой платформы. Dynamic Type (iOS), font scaling (Android).

4. SHADOW / ELEVATION: CSS box-shadow → iOS layer.shadow → Android elevation (dp).

5. MOTION: duration и easing — CSS, Swift, Kotlin.

6. BORDER: width, radius, style — по платформам.

Для каждой категории:
- DTCG JSON токен (input)
- Сгенерированный output для CSS, Swift, Kotlin
- Примеры из Material Design 3 и Apple HIG

Формат: таблицы с конкретными значениями и примерами кода.
```

---

## 🟡 P1 — Важные

---

### DR-003: Accessibility Token Patterns

**Для:** Foundation Layer
**Сохранить как:** `DR-003-accessibility-tokens.md`

```
Какие design tokens нужны для WCAG 2.2 AA accessibility в кроссплатформенной дизайн-системе?

Рассмотри: контрасты (пары цветов с ratios, APCA vs sRGB), target size (24×24 minimum, 44×44 enhanced, платформенный маппинг), focus indicators (цвет, толщина, offset), motion/reduced motion (prefers-reduced-motion, iOS/Android equivalents), text readability (minimum font size, line height 1.5, letter spacing), color independence (не только цветом).

Покажи: конкретные DTCG JSON токены для accessibility, контрастная матрица всех цветовых пар, примеры из Shopify Polaris, IBM Carbon, GitHub Primer.
```

---

### DR-006: Color System Engineering

**Для:** Foundation Layer
**Сохранить как:** `DR-006-color-system.md`

```
Как построить масштабируемую цветовую палитру для open-source дизайн-системы с light/dark mode и пользовательскими темами?

Сравни 3 подхода:
1. HSL с фиксированным hue (Tailwind approach)
2. OKLCH perceptually uniform (современный подход)
3. Material Dynamic Color HCT (Google approach)

Для каждого: алгоритм генерации шкалы 50-950 из seed color, WCAG проверка пар, dark mode инверсия, themability (1 seed → вся палитра).

Дополнительно: neutrals с tint от primary, feedback colors (error/warning/success/info) с гарантированной accessibility, semantic mapping primitive → semantic roles.

Рекомендация: какой подход для DTCG + кроссплатформенность + accessibility из коробки.
```

---

### DR-007: Typography Scale Systems

**Для:** Foundation Layer
**Сохранить как:** `DR-007-typography-scale.md`

```
Сравни типографические шкалы в дизайн-системах и рекомендуй для кроссплатформенной DS (web + iOS + Android).

1. Подходы: modular scale (ratio-based), custom stops, platform-derived, fluid typography.

2. Таблица сравнения конкретных значений (px/pt/sp) для ролей Display/Heading/Body/Caption/Label из: Material Design 3, Apple HIG, IBM Carbon, Shopify Polaris, Tailwind.

3. Адаптация по breakpoints: Desktop → Tablet → Mobile, Dynamic Type (iOS), sp scaling (Android).

4. Line height по ролям, font stacks (open-source шрифты: Inter vs IBM Plex vs Geist), fallback стеки.

5. Рекомендация: конкретная шкала с ролями display/heading/body/label в размерах lg/md/sm, значения для каждого breakpoint, DTCG JSON пример composite typography token.
```

---

### DR-009: Tokens Studio for Figma Workflow

**Для:** Figma Components
**Сохранить как:** `DR-009-tokens-studio.md`

```
Подробный workflow Tokens Studio for Figma для мультибрендовой дизайн-системы.

Контекст: Figma Professional (10 modes), токены в DTCG JSON, sync с GitHub.

Нужно: setup, организация token sets (primitive → semantic → component), themes (light/dark, brand-a/brand-b), GitHub sync workflow, Style Dictionary integration, ограничения Free vs Pro, конкретные JSON примеры token sets.

Пошаговая инструкция создания новой клиентской темы через Tokens Studio.
```

---

### DR-010: Multi-Brand Theming Architecture

**Для:** Theming
**Сохранить как:** `DR-010-multi-brand-theming.md`

```
Архитектурные паттерны мультибрендовой тематизации в open-source дизайн-системах.

1. Theme Contract: что тема может переопределять, что нет. Примеры из Shopify, Atlassian, IBM.
2. Theme file structure: DTCG-совместимый JSON override, минимальный набор токенов для бренда.
3. Theme validation: WCAG контрасты, completeness, автоматизация на TypeScript.
4. Versioning: SemVer для тем, совместимость тема v1.2 + core v1.5.
5. Figma theming без Extended Collections.
6. Примеры: Salesforce SLDS theming, Shopify multi-brand, Atlassian (Jira/Confluence/Trello).
```

---

### DR-013: Cognitive Psychology for UI Design

**Для:** Foundations
**Сохранить как:** `DR-013-cognitive-psychology.md`

```
Обзор законов когнитивной психологии для UI/UX дизайна.

Для КАЖДОГО закона (Fitts, Hick, Miller, Jakob, Doherty, Von Restorff, Aesthetic-Usability, Peak-End, Zeigarnik, Tesler, Postel, Serial Position, Gestalt Principles, Weber-Fechner):

1. Точная формулировка + простое объяснение
2. Кто открыл, когда
3. Как проявляется в UI (3+ примеров)
4. Конкретные design guidelines (что делать / не делать)
5. Связь с компонентами дизайн-системы
6. Примеры нарушений в реальных продуктах
7. Как измерить соблюдение (usability metrics)

Формат: карточка по 7 пунктам для каждого закона. Практично для дизайнера, не для учёного.
```

---

### DR-015: Responsive Spatial System

**Для:** Foundation Layer + Platform Patterns
**Сохранить как:** `DR-015-spatial-system.md`

```
Единая пространственная система для web (desktop/tablet/mobile) + iOS (iPhone/iPad) + Android (phone/tablet).

1. Grid: 12-column web, Layout Margins iOS, Material 3 grid — конкретные значения columns/margins/gutters по breakpoints.
2. Breakpoints/Size classes: маппинг web breakpoints ↔ iOS size classes ↔ Android window size classes.
3. Spacing scale: base 4px vs 8px, linear vs exponential, semantic spacing (gap.xs..xl, inset.xs..xl) с конкретными значениями.
4. Container queries vs media queries vs size classes.
5. Safe areas по платформам с конкретными значениями.
6. Keyboard avoidance паттерны.
7. Density: comfortable/compact/spacious.

Результат: таблица spacing tokens с значениями для каждой платформы и breakpoint.
```

---

### DR-017: Agentic UX Design Framework

**Для:** AI Patterns
**Сохранить как:** `DR-017-agentic-ux.md`

```
Фреймворк проектирования Agentic UX — интерфейсов где AI-агенты выполняют задачи автономно.

1. Уровни автономии (Level 0-4): Manual → Suggestion → Approve → Supervised → Autonomous. Для каждого: примеры продуктов, UI паттерны, компоненты.
2. Delegation patterns: scope, constraints, context. Примеры: Copilot Workspace, Cursor, Devin.
3. Multi-step visualization: план, прогресс, вмешательство на конкретном шаге.
4. Agent-human handoff: когда передавать, UI, seamless transition.
5. Error & uncertainty: неуверенность, застревание, rollback, graceful degradation.
6. Multi-agent: UI для нескольких агентов, координация, CrewAI/AutoGen.
7. Trust calibration: track record, transparency, настройка автономии.

Примеры из продуктов 2025: GitHub Copilot Workspace, Cursor, Claude Code, Devin, Replit Agent.
```

---

## 🟢 P2 — Полезные

---

### DR-018: AI + Traditional UI Integration Patterns

**Для:** AI Patterns (Hybrid)
**Сохранить как:** `DR-018-ai-ui-integration.md`

```
Как интегрировать AI-функционал в традиционные GUI интерфейсы?

3 модели:
1. AI как copilot (sidebar/inline) — VS Code Copilot, Notion AI
2. AI как feature (enhancement существующих функций) — Gmail Smart Reply, Figma AI
3. AI-first (chat/agent как основной интерфейс) — ChatGPT, Claude

Для каждой: когда выбирать, design patterns, transition между AI и manual mode, примеры из реальных продуктов (Notion AI, Figma AI, Adobe Firefly, Google Search AI Overview).

Какие компоненты дизайн-системы нужны для каждой модели?
```

---

### DR-011: Framework Decision Matrix

**Для:** Code Implementation
**Сохранить как:** `DR-011-framework-matrix.md`

```
Матрица выбора фреймворка для кодовой реализации компонентов open-source дизайн-системы.

Сравни: Web Components (Lit), React, Vue, Svelte, CSS-only, framework-agnostic tokens.

Критерии: adoption, DX, accessibility, SSR, bundle size, Figma code connect, Storybook support, community.

Для соло-разработчика дизайнера, не fullstack. Что даст максимум пользы при минимальных усилиях?
```

---

### DR-006b: Motion & Easing Systems

**Для:** Foundation Layer
**Сохранить как:** `DR-006b-motion-system.md`

```
Система анимации для кроссплатформенной дизайн-системы.

1. Duration scale: какие значения использовать (instant, fast, normal, slow, deliberate) с конкретными ms.
2. Easing curves: стандартные для каждой платформы (CSS ease-in-out, iOS spring animations, Material motion).
3. Semantic motion tokens: feedback, enter, exit, expand, collapse.
4. Reduced motion: как деградировать gracefully.
5. Platform differences: CSS transitions vs iOS UIView.animate vs Compose animate*.
6. DTCG JSON примеры для duration и cubicBezier.

Примеры из Material Motion, Apple Human Interface Guidelines, IBM Carbon Motion.
```
