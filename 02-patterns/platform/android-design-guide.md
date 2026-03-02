---
title: "Android Design Guide"
type: "guide"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/guide"
  - "category/platform"
  - "platform/android"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "Android"
description: "Design guide for Android platform UI conventions"
category: "platform"
---

# Android Design Guidelines: Полный справочник

> Официальный гайд по дизайну Android-приложений на основе документации developer.android.com/design.
> Для использования AI при оценке дизайн-макетов на соответствие Android guidelines.

---

## Содержание

1. [Foundations (Основы)](#1-foundations-основы)
2. [Styles (Стили)](#2-styles-стили)
3. [Layout & Content (Макет и контент)](#3-layout--content-макет-и-контент)
4. [Components (Компоненты)](#4-components-компоненты)
5. [Patterns (Паттерны)](#5-patterns-паттерны)
6. [Home Screen (Домашний экран)](#6-home-screen-домашний-экран)
7. [Widgets (Виджеты)](#7-widgets-виджеты)
8. [App Icons (Иконки приложения)](#8-app-icons-иконки-приложения)
9. [Quality Guidelines (Требования качества)](#9-quality-guidelines-требования-качества)
10. [Краткая шпаргалка](#10-краткая-шпаргалка)

---

## 1. Foundations (Основы)

### 1.1 System Bars (Системные панели)

Системные панели — status bar, caption bar и navigation bar — отображают важную информацию (уровень батареи, время, уведомления) и обеспечивают взаимодействие с устройством.

#### Status Bar (Строка состояния)
- **Расположение:** Верх экрана
- **Содержимое:** Notification icons слева, system icons справа (время, батарея, сигнал)
- **Взаимодействие:** Свайп вниз открывает notification shade
- **Стиль:** Прозрачная или полупрозрачная

**Требования к стилю:**
- Делать status bar прозрачной для edge-to-edge контента
- Android 15+: edge-to-edge обязателен по умолчанию
- Использовать `enableEdgeToEdge()` для обратной совместимости
- Иконки автоматически адаптируют цвет в зависимости от фона (dynamic color adaptation)

#### Navigation Bar (Панель навигации)
- **Типы:** Gesture navigation (жесты) или 3-button navigation (кнопки)
- **Gesture navigation:** Один gesture handle внизу экрана
- **3-button navigation:** Back, Home, Overview кнопки

**Gesture Navigation:**
- Свайп от левого/правого края → Back
- Свайп снизу вверх → Home
- Свайп снизу вверх + удержание → Overview
- Handle автоматически меняет цвет (dynamic color adaptation)

**Требования:**
- Navigation bar должна быть прозрачной для gesture navigation
- Для 3-button: можно использовать translucent scrim
- `Window.setNavigationBarContrastEnforced(false)` для прозрачности
- Избегать размещения touch targets под gesture insets

#### Display Cutouts (Вырезы дисплея)
- Учитывать область камеры/датчиков
- Использовать `displayCutout` insets для безопасных зон
- Контент не должен обрезаться вырезами

### 1.2 Accessibility (Доступность)

Android требует соблюдения accessibility стандартов для ~15% мирового населения с ограниченными возможностями.

#### Дизайн для зрения

**Типографика:**
- Размер шрифта в scalable pixels (sp)
- Минимальный body text: **12 sp**
- Соответствует Material typescale по умолчанию

**Цветовой контраст (WCAG):**
| Элемент | Минимальный контраст |
|---------|---------------------|
| Текст <18pt (или bold <14pt) | **4.5:1** |
| Крупный текст | **3:1** |
| Non-text элементы (иконки, границы) | **3:1** |

**Визуальные affordances:**
- Не полагаться только на цвет для индикации действий
- Использовать дополнительные индикаторы: font weight, underline, icons
- Декоративные элементы помечать как decorative (null description)

#### Дизайн для слуха (TalkBack)
- Все UI элементы должны иметь текстовые описания
- Использовать Semantics properties в Compose
- Иконки и изображения требуют contentDescription
- Группировать связанные UI элементы

#### Дизайн для моторики (Switch Access)
- **Минимальный touch target: 48×48 dp**
- Touch target может выходить за визуальные границы элемента
- Не полагаться только на жесты — создавать альтернативные действия
- Использовать haptic feedback

---

## 2. Styles (Стили)

### 2.1 Color (Цвет)

Android использует Material 3 color system с поддержкой Dynamic Color (Android 12+).

#### Ключевые цвета (Key Colors)
Цветовая схема строится на **5 ключевых цветах:**
1. **Primary** — основной акцент
2. **Secondary** — второстепенный акцент
3. **Tertiary** — дополнительный акцент
4. **Neutral** — фоны и поверхности
5. **Neutral Variant** — контуры и средние акценты

#### Tonal Palettes (Тональные палитры)
Каждый ключевой цвет генерирует палитру из **13 тонов:**
- 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100

**Маппинг тонов для светлой темы:**
| Роль | Тон |
|------|-----|
| Primary | 40 |
| On Primary | 100 |
| Primary Container | 90 |
| On Primary Container | 10 |
| Surface | 99 |
| On Surface | 10 |

**Маппинг тонов для тёмной темы:**
| Роль | Тон |
|------|-----|
| Primary | 80 |
| On Primary | 20 |
| Primary Container | 30 |
| On Primary Container | 90 |
| Surface | 10 |
| On Surface | 90 |

#### Surface Colors
Surfaces занимают большую часть UI:
- **surface** — базовый фон
- **surfaceDim** — затемнённый фон
- **surfaceBright** — осветлённый фон
- **surfaceContainerLowest** — самый светлый контейнер
- **surfaceContainerLow** — светлый контейнер
- **surfaceContainer** — средний контейнер
- **surfaceContainerHigh** — тёмный контейнер
- **surfaceContainerHighest** — самый тёмный контейнер

#### Dynamic Color (Android 12+)
- Цвета генерируются из обоев пользователя
- Использовать Material Theme Builder для превью
- Обязательно создавать fallback custom theme

#### Правила использования цвета
- Проверять контраст красный/зелёный (color blindness)
- Придерживаться ограниченной палитры
- Повторять установленные цветовые паттерны
- Создавать light и dark color schemes
- **Hex format:** 6-digit RGB, 8-digit с opacity (AARRGGBB)

### 2.2 Themes (Темы)

#### Типы тем
1. **System themes** — влияют на весь UI устройства (light/dark/contrast)
2. **App themes** — применяются только внутри приложения

#### Material Baseline Theme
- Использует purple color scheme
- Шрифт Roboto
- Применяется если не определены custom theme attributes

#### Custom Themes
- Для полной кастомизации look and feel
- Как fallback когда dynamic color недоступен
- Можно создавать множественные схемы для выбора пользователем

#### Content-Based Color
- UI наследует цвета от контента (album art, movie posters)
- Для фокусировки внимания на конкретном контенте

#### Theme Tokens
- **Reference tokens** → System tokens → Component tokens
- Использовать tokens вместо hard-coded hex values
- Tokens обеспечивают консистентность и масштабируемость

---

## 3. Layout & Content (Макет и контент)

### 3.1 Layout Basics (Основы макета)

#### Принципы
- Учитывать разные aspect ratios, size classes, resolutions
- Проверять landscape и portrait ориентации
- Honor device safe areas (cutouts, insets, keyboards, system bars)
- Держать essential interactions в reachable screen area

#### App Anatomy (Анатомия приложения)
Экран состоит из:
1. **System Bars** (status + navigation)
2. **App Bar** (top/bottom)
3. **Navigation** (bar/rail/drawer)
4. **Body Region** (основной контент)

Body region должен продолжаться под system bars (edge-to-edge).

### 3.2 Grids and Units (Сетки и единицы)

#### Единицы измерения
- **dp (density-independent pixels)** — для layout и spacing
- **sp (scalable pixels)** — для текста
- **Базовая единица:** 8 dp (кратность)
- **Мелкая единица:** 4 dp (для иконок и мелких элементов)

#### Column Grid (Колоночная сетка)
Количество колонок по Window Size Class:

| Size Class | Width | Columns | Margins | Gutters |
|------------|-------|---------|---------|---------|
| **Compact** | <600 dp | 4 | 16 dp | 16 dp |
| **Medium** | 600-839 dp | 8 | 24 dp | 24 dp |
| **Expanded** | 840+ dp | 12 | 24 dp | 24 dp |

**Правила:**
- Контент размещается в колонках
- Margins защищают контент от краёв экрана
- Gutters — пространство между колонками
- Избегать слишком гранулярной сетки

#### Window Size Classes (Классы размеров окна)
| Class | Width | Типичные устройства |
|-------|-------|---------------------|
| **Compact** | <600 dp | 99.96% телефонов в portrait |
| **Medium** | 600-839 dp | 93.73% планшетов в portrait |
| **Expanded** | 840+ dp | 97.22% планшетов в landscape |

#### Aspect Ratios
Распространённые соотношения сторон:
- **16:9** — широкоформатное видео
- **3:2** — фотографии
- **4:3** — традиционное
- **1:1** — квадратное (аватары, thumbnails)

### 3.3 Content Structure (Структура контента)

#### Margins (Поля)
- **Compact:** 16 dp минимум
- Margins адаптируются для larger screens
- Обеспечивают inset safe zones

#### Containment (Группировка)
Два типа группировки контента:
1. **Implicit** — через white space
2. **Explicit** — через dividers, cards, outlines

#### Spacing
- Использовать consistent spacing между like elements
- Spacing scale: 4, 8, 12, 16, 24, 32, 48 dp

### 3.4 Edge-to-Edge Design

#### Типы Insets
1. **System bar insets** — для tappable UI, не должен перекрываться system bars
2. **System gesture insets** — области жестов ОС (приоритет над приложением)
3. **Display cutout insets** — области камеры/датчиков

#### Status Bar Considerations
- Top app bar коллапсируется при скролле
- При sticky app bar: коллапс до высоты status bar
- При non-sticky: добавить matching background gradient
- Translucent status bar когда UI скроллится под ней

#### Navigation Bar Considerations
- Bottom app bar коллапсируется при скролле
- Gesture navigation: всегда прозрачная, без дополнительного scrim
- 3-button navigation: можно добавить translucent scrim

#### Gradient Protection
- Для adaptive layouts: отдельные градиенты для panes с разным фоном
- Navigation drawer требует отдельный gradient от основного контента
- Не накладывать несколько status bar protections

### 3.5 Canonical Layouts (Канонические макеты)

#### List-Detail
- Для messaging apps, contact managers, file browsers
- Compact: только list или detail view
- Expanded: list и detail рядом

#### Feed
- Для новостей, social media, galleries
- List-based или grid-based
- Динамический контент из API

#### Supporting Pane
- Основной контент + дополнительная панель
- Productivity apps, document viewers

#### Grid
- Rows и columns
- Может быть rigid или staggered
- Consistent spacing и logic

### 3.6 Adapt Layout (Адаптивный макет)

#### Responsive Patterns
- **Reveal** — показывать больше контента на larger screens
- **Transform** — менять компоненты (nav bar → nav rail)
- **Divide** — разделять на panes
- **Reflow** — перестраивать grid

#### Breakpoints
- Используются Window Size Classes как breakpoints
- Не каждое приложение должно быть на каждом размере экрана
- Дизайнить key screens для основных size classes

---

## 4. Components (Компоненты)

### 4.1 Material Components Overview

Android рекомендует использовать Material Design 3 компоненты для консистентного UX.

#### Основные категории компонентов:

**Actions:**
- Buttons (Filled, Tonal, Elevated, Outlined, Text)
- FAB (Floating Action Button)
- Extended FAB
- Icon Buttons
- Segmented Buttons

**Communication:**
- Badges
- Progress Indicators (Circular, Linear)
- Snackbars
- Tooltips

**Containment:**
- Bottom Sheets
- Cards (Elevated, Filled, Outlined)
- Dialogs
- Dividers
- Lists

**Navigation:**
- Navigation Bar
- Navigation Rail
- Navigation Drawer
- Top App Bar
- Tabs
- Search

**Selection:**
- Checkbox
- Chips
- Radio Buttons
- Sliders
- Switches
- Date/Time Pickers

**Text Inputs:**
- Text Fields (Filled, Outlined)

### 4.2 Key Component Specifications

#### Buttons
| Тип | Высота | Min Width | Corner Radius | Use Case |
|-----|--------|-----------|---------------|----------|
| Filled | 40 dp | 64 dp | 20 dp (full) | Primary actions |
| Tonal | 40 dp | 64 dp | 20 dp | Secondary actions |
| Elevated | 40 dp | 64 dp | 20 dp | Needs lift from surface |
| Outlined | 40 dp | 64 dp | 20 dp | Alternative actions |
| Text | 40 dp | 48 dp | 20 dp | Low emphasis |

**Padding:** 24 dp horizontal

#### FAB (Floating Action Button)
| Размер | Dimensions | Icon Size | Corner Radius |
|--------|------------|-----------|---------------|
| Small | 40×40 dp | 24 dp | 12 dp |
| Standard | 56×56 dp | 24 dp | 16 dp |
| Large | 96×96 dp | 36 dp | 28 dp |

**Extended FAB:** Min width 80 dp, height 56 dp

#### Navigation Bar
- **Высота:** 80 dp
- **Icon size:** 24 dp
- **Active indicator:** 64×32 dp pill
- **Destinations:** 3-5
- **Label:** Always visible

#### Navigation Rail
- **Ширина:** 80 dp
- **Icon size:** 24 dp
- **Active indicator:** 56×32 dp pill
- **Destinations:** 3-7
- Для Medium и Expanded window sizes

#### Top App Bar
| Тип | Высота (collapsed) | Высота (expanded) |
|-----|-------------------|-------------------|
| Small | 64 dp | — |
| Medium | 64 dp | 112 dp |
| Large | 64 dp | 152 dp |

#### Cards
- **Corner radius:** 12 dp
- **Elevation:** Level 0 (Filled), Level 1 (Elevated)
- **Padding:** 16 dp

#### Lists
| Тип | Высота |
|-----|--------|
| Single-line | 56 dp |
| Two-line | 72 dp |
| Three-line | 88 dp |

**Padding:** 16 dp horizontal

#### Dialogs
- **Max width:** 560 dp
- **Padding:** 24 dp
- **Corner radius:** 28 dp
- **Elevation:** Level 3

#### Text Fields
- **Высота:** 56 dp (48 dp dense)
- **Corner radius:** 4 dp (top corners для Filled)
- **Padding:** 16 dp
- **Label transition:** bodyLarge (16 sp) → bodySmall (12 sp)
- **Indicator:** 1 dp (unfocused), 2 dp (focused)

#### Chips
- **Высота:** 32 dp
- **Corner radius:** 8 dp
- **Padding:** 16 dp horizontal
- **Icon size:** 18 dp
- **Spacing между chips:** 8 dp

#### Switches
- **Track size:** 52×32 dp
- **Handle:** 16 dp (off), 24 dp (on/pressed)
- **Corner radius:** 16 dp full (track)

---

## 5. Patterns (Паттерны)

### 5.1 Predictive Back

Predictive back позволяет пользователям предварительно видеть результат back gesture перед его завершением.

#### Принцип работы
- User starts back gesture → Preview destination
- User commits (lifts finger) → Navigate back
- User cancels (returns finger) → Stay in current view

#### System Animations (Android 15+)
1. **Back-to-home** — превью домашнего экрана
2. **Cross-activity** — переход между activities
3. **Cross-task** — переход между tasks

#### Custom Transitions Guidelines

**Full-screen surfaces:**
- Inner area scales down по мере gesture progress
- При commit threshold: fade through к next state
- Interpolator обеспечивает быстрый exit

**Surface specifications:**
- **Margins:** 5% ширины с каждой стороны
- **Scale:** От 100% до 90%
- **Corner radius:** Увеличивается при scale down

**Shared element transitions:**
- Surface полностью отделяется от края экрана
- User может напрямую манипулировать элементом
- Не показывать что элемент dismiss в направлении gesture

#### Gesture Insets
- Избегать touch targets полностью под gesture areas
- System gesture insets имеют приоритет над приложением
- ~20-24 dp от краёв экрана для back gesture

### 5.2 Navigation Patterns

#### Primary Navigation
1. **Navigation Bar** — 3-5 destinations, bottom of screen
2. **Navigation Rail** — для larger screens, side of screen
3. **Navigation Drawer** — >5 destinations, более complex hierarchy

#### Secondary Navigation
- **Tabs** — группировка sibling content
- **Bottom App Bar** — secondary actions

#### Navigation Hierarchy
- Back возвращает к previous view
- Home переходит на home screen устройства
- Up возвращает к parent в app hierarchy

### 5.3 Settings Pattern

#### Структура
- Организовать settings в логические группы
- Использовать consistent visual hierarchy
- Preference library обеспечивает Material theme

#### Компоненты
- Switches для on/off settings
- Radio buttons для single selection
- Checkboxes для multiple selection
- Sliders для ranges

### 5.4 Help & Feedback

- Интегрировать help в контекст использования
- Inline tips и contextual help
- Feedback mechanisms доступны из settings

---

## 6. Home Screen (Домашний экран)

### 6.1 Notifications

Notifications позволяют отображать информацию вне основного UI приложения.

#### Места отображения
1. **Status bar** — icon notification
2. **Notification drawer** — expanded view
3. **Lock screen** — requires double-tap + unlock
4. **Badge** — на app icon
5. **Paired Wear OS** — автоматически синхронизируется

#### Notification Anatomy
| Компонент | Описание | Обязательность |
|-----------|----------|----------------|
| Small icon | 24×24 dp monochrome | Required |
| App name | Предоставляется системой | Auto |
| Time stamp | Можно скрыть/override | Auto |
| Large icon | Contact photos, не для app icon | Optional |
| Title | setContentTitle() | Optional |
| Text | setContentText() | Optional |

#### Notification Templates

**Basic:**
- Small icon, title, text
- Expandable для большего контента

**Big Text:**
- Для длинных текстовых сообщений
- Показывает больше текста при expand

**Big Picture:**
- Large image attachment
- Ideal для photos, screenshots

**Media:**
- Collapsed: до 3 actions
- Expanded: до 5-6 actions
- Large image (album art)
- Автоматически наследует цвета из image

**Messaging:**
- Real-time communication
- Reply action прямо из notification
- Conversation grouping

**Call:**
- Large format для incoming/outgoing calls
- Full-screen intent для high priority

#### Actions
- До 3 actions в expanded view
- Типы: text buttons, reply input, media controls
- Duplicate tapping behavior на body

#### Best Practices
- Succinctly summarize в header
- Preview content в text
- Set channels и categories
- Group notifications если multiple
- Используйте appropriate priority

### 6.2 Picture-in-Picture (PiP)

- Для video playback, video calls
- Overlay поверх других apps
- Minimal controls для space efficiency

---

## 7. Widgets (Виджеты)

Widgets — customizable home screen elements, "at-a-glance" views важных данных и функций.

### 7.1 Widget Types

1. **Information widgets** — отображают crucial info (weather, stocks)
2. **Collection widgets** — список items (messages, articles)
3. **Control widgets** — remote controls (media player, home automation)
4. **Hybrid widgets** — комбинация типов

### 7.2 Widget Layouts

#### Toolbar Layout
- Quick access к frequently used tasks
- Search toolbar фокусирует на search как primary action
- Buttons для toggles и task links
- **Min button size:** 48 dp tappable

#### List Layout
- Organize items в scannable format
- News headlines, to-do lists, messages
- Containerized или containerless presentation

#### Grid Layout
- Rows и columns
- Gallery views, app shortcuts

#### Single-Item Layout
- Focus на одном piece of content
- Progress, statistics, hero content

### 7.3 Widget Sizing

#### Recommended Sizes (Pixel devices)
| Cells | Portrait Width | Landscape Width |
|-------|---------------|-----------------|
| 2×2 | 171 dp | 201 dp |
| 3×2 | 261 dp | 307 dp |
| 4×2 | 351 dp | 413 dp |
| 5×2 | 441 dp | 519 dp |

**Правила:**
- Widget должен заполнять allocated grid space полностью
- Container stretches edge-to-edge
- Responsive к разным sizes

#### Breakpoints
- Design для минимум одного recommended size
- Thoroughly test на разных devices

### 7.4 Widget Style

#### Color
- Material color roles и tokens
- Support dynamic color (Android 12+)
- Dark mode adaptation

#### Shape
- System corner radius property
- Consistency across devices
- Prevents content clipping

#### Typography
- 5 text roles: display, headline, title, subtitle, body
- Font weight и size для hierarchy
- Line spacing и letter spacing

### 7.5 Widget Configuration

#### When to Configure
- **During placement:** если widget пустой без settings
- **After placement:** если есть preferred default

#### Configuration Best Practices
- Limit picker previews to 6-8 variations
- Clear path through options
- Material Design components для configuration UI
- 1-2 screens максимум

### 7.6 Widget Discovery

- High quality previews в widget picker
- Appropriate sizing
- Clear value proposition

---

## 8. App Icons (Иконки приложения)

### 8.1 Adaptive Icons (Android 8.0+)

Adaptive icons адаптируются к разным устройствам и user theming.

#### Структура
1. **Foreground layer** — main artwork
2. **Background layer** — solid color или image
3. **Monochrome layer** — для themed icons (Android 13+)

#### Specifications
- **Full asset size:** 108×108 dp
- **Safe zone (visible area):** 72×72 dp (центр)
- **Mask area:** 66×66 dp
- **Visual artifacts:** Избегать в outer 18 dp

#### Shapes
Adaptive icons поддерживают разные masks:
- Circle
- Squircle
- Rounded square
- Square
- Teardrop

OEM определяет mask для device.

#### Themed Icons (Android 13+)
- User может включить themed app icons
- System tints icon используя wallpaper colors
- Требуется monochrome layer
- Android 16 QPR 2: auto-theming для apps без monochrome

### 8.2 Google Play Store Icons

#### Specifications
- **Size:** 512×512 px
- **Format:** PNG (32-bit)
- **Corner radius:** Динамически применяется Google Play (30% от размера)
- **Shadow:** Динамически применяется Google Play

#### Guidelines
- Artwork может заполнять всё пространство (full bleed)
- Или использовать keyline grid для logos
- Background color без transparency
- Избегать text в icon

---

## 9. Quality Guidelines (Требования качества)

### 9.1 Core App Quality

#### Visual Design & Interaction
- Standard Android visual design patterns
- Material Design Components вместо platform components
- Consistent user experience

#### Touch Targets
- **Minimum:** 48×48 dp
- **Spacing между targets:** 8 dp

#### Color Contrast
- Text: минимум 4.5:1
- Large text: минимум 3:1
- UI components: минимум 3:1

### 9.2 User Experience Quality

- Responsive UI (fast launch, no lag)
- Smooth 60 fps animations
- Preserve state across configuration changes
- Support screen rotation

### 9.3 Technical Quality

- No crashes или ANRs
- Efficient battery usage
- Minimal memory footprint
- Follow security best practices

### 9.4 Accessibility Quality

- TalkBack compatibility
- Switch Access support
- Proper content descriptions
- Keyboard navigation

---

## 10. Краткая шпаргалка

### Ключевые числа

| Метрика | Значение |
|---------|----------|
| **Touch target minimum** | 48×48 dp |
| **Text contrast minimum** | 4.5:1 |
| **Large text contrast** | 3:1 |
| **UI element contrast** | 3:1 |
| **Baseline grid unit** | 8 dp |
| **Fine grid unit** | 4 dp |
| **Min body text** | 12 sp |
| **Compact margin** | 16 dp |
| **Standard button height** | 40 dp |
| **FAB standard size** | 56×56 dp |
| **Navigation bar height** | 80 dp |
| **Top app bar height** | 64 dp |
| **List item single-line** | 56 dp |
| **Card corner radius** | 12 dp |
| **Dialog corner radius** | 28 dp |
| **Chip height** | 32 dp |
| **Text field height** | 56 dp |

### Window Size Classes

| Class | Width | Columns |
|-------|-------|---------|
| Compact | <600 dp | 4 |
| Medium | 600-839 dp | 8 |
| Expanded | 840+ dp | 12 |

### System Bars

| Element | Height |
|---------|--------|
| Status bar | ~24 dp |
| Gesture navigation bar | ~24 dp |
| 3-button navigation bar | ~48 dp |

### Navigation Components

| Component | Когда использовать |
|-----------|-------------------|
| Navigation Bar | 3-5 destinations, Compact |
| Navigation Rail | 3-7 destinations, Medium+ |
| Navigation Drawer | >5 destinations, complex hierarchy |
| Tabs | Secondary grouping |

### Edge-to-Edge Checklist

- [ ] Status bar transparent
- [ ] Navigation bar transparent (gesture) или translucent (buttons)
- [ ] Content draws behind system bars
- [ ] Content padded from system bar insets
- [ ] Touch targets not under gesture insets
- [ ] Display cutouts accounted for

### Accessibility Checklist

- [ ] Touch targets ≥48 dp
- [ ] Text contrast ≥4.5:1
- [ ] Font size in sp
- [ ] Content descriptions для images/icons
- [ ] Not relying on color alone
- [ ] Support для TalkBack
- [ ] Support для Switch Access

---

## Источники

- [developer.android.com/design/ui/mobile](https://developer.android.com/design/ui/mobile)
- [developer.android.com/design/ui/mobile/guides](https://developer.android.com/design/ui/mobile/guides)
- [Material Design 3](https://m3.material.io)
- [Android UI Kit Figma](https://goo.gle/android-ui-kit)
- [Material Theme Builder](https://m3.material.io/theme-builder)

---

*Версия документа: 2026-02-04*
*Источник: developer.android.com/design*
