---
title: "Material Design 3 for Android"
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
description: "Guide to Material Design 3 implementation for Android"
category: "platform"
---

# Исчерпывающий гайд по Material Design 3 для Android

Material Design 3 (MD3) представляет собой новейшую дизайн-систему Google, которая вводит революционный подход к персонализации интерфейсов через динамический цвет, обновлённую типографику и усовершенствованную систему компонентов. Этот гайд содержит **точные числовые спецификации** для оценки дизайн-макетов на соответствие официальным стандартам MD3.

---

## 1. Foundations (Основы)

### 1.1 Color System — цветовая система

MD3 использует **5-ключевую цветовую систему** на основе цветового пространства HCT (Hue, Chroma, Tone), обеспечивающего перцептуально точные расчёты контрастности.

**Ключевые цвета и их роли:**

|Ключевой цвет|Назначение|
|---|---|
|**Primary**|Основные компоненты: кнопки, активные состояния, FAB|
|**Secondary**|Менее заметные компоненты: filter chips, расширенное цветовое выражение|
|**Tertiary**|Контрастные акценты для баланса primary/secondary|
|**Neutral**|Фоны и поверхности|
|**Neutral Variant**|Варианты поверхностей, обводки|

**Тональные палитры:** Каждый ключевой цвет генерирует **13 тонов**: 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100, где Tone 0 = чёрный, Tone 100 = белый.

**Маппинг тонов по темам:**

|Роль|Светлая тема|Тёмная тема|
|---|---|---|
|Primary|Tone 40|Tone 80|
|On Primary|Tone 100|Tone 20|
|Primary Container|Tone 90|Tone 30|
|Surface|Tone 99|Tone 6|
|Surface Container|Tone 94|Tone 12|

**Базовые цвета светлой темы (HEX):**

|Токен|Значение|Назначение|
|---|---|---|
|`primary`|#6750A4|Основной акцент|
|`onPrimary`|#FFFFFF|Текст на primary|
|`primaryContainer`|#CBC0E6|Фон prominent-элементов|
|`secondary`|#625B71|Вторичный акцент|
|`tertiary`|#7D5260|Третичный акцент|
|`error`|#B3261E|Ошибки|
|`surface`|#FFFBFE|Основная поверхность|
|`onSurface`|#1C1B1F|Текст на surface|
|`outline`|#79747E|Границы|
|`outlineVariant`|#CAC4D0|Разделители|

**Dynamic Color (Android 12+)** — извлекает цвета из обоев устройства или in-app контента, обеспечивая персонализированные темы.

---

### 1.2 Typography — типографика

MD3 использует **15 типографических стилей** с базовым шрифтом **Roboto**.

|Стиль|Размер (sp)|Line Height (sp)|Weight|Letter Spacing|
|---|---|---|---|---|
|**displayLarge**|57|64|400 (Regular)|-0.25|
|**displayMedium**|45|52|400|0|
|**displaySmall**|36|44|400|0|
|**headlineLarge**|32|40|400|0|
|**headlineMedium**|28|36|400|0|
|**headlineSmall**|24|32|400|0|
|**titleLarge**|22|28|500 (Medium)|0|
|**titleMedium**|16|24|500|0.15|
|**titleSmall**|14|20|500|0.1|
|**bodyLarge**|16|24|400|0.5|
|**bodyMedium**|14|20|400|0.25|
|**bodySmall**|12|16|400|0.4|
|**labelLarge**|14|20|500|0.1|
|**labelMedium**|12|16|500|0.5|
|**labelSmall**|11|16|500|0.5|

Типографика выравнивается по **baseline grid 4dp**.

---

### 1.3 Layout — компоновка

**Window Size Classes (Брейкпоинты):**

|Класс|Диапазон ширины|Типичные устройства|
|---|---|---|
|**Compact**|< 600dp|99.96% телефонов (portrait)|
|**Medium**|600–839dp|93.73% планшетов (portrait), foldables|
|**Expanded**|840–1199dp|97.22% планшетов (landscape)|
|**Large**|1200–1599dp|Большие планшеты|
|**Extra-Large**|≥ 1600dp|Desktop-дисплеи|

**Система сетки:**

|Брейкпоинт|Колонки|Отступы (Gutters)|Поля (Margins)|
|---|---|---|---|
|360dp (Compact)|4|16dp|16dp|
|600dp (Medium)|8|24dp|24–32dp|
|840dp+ (Expanded)|12|24dp|32dp|

**Базовая единица сетки: 8dp** — все измерения кратны этому значению.

**Spacing Scale:**

|Токен|Значение|
|---|---|
|`space-xs`|4dp|
|`space-sm`|8dp|
|`space-md`|16dp|
|`space-lg`|24dp|
|`space-xl`|32dp|
|`space-xxl`|48dp|

---

### 1.4 Shape — формы

**Shape Scale (Радиусы скругления):**

|Токен|Corner Radius|Применение|
|---|---|---|
|**None**|0dp|Острые углы|
|**Extra Small**|4dp|Badges, checkboxes, text fields|
|**Small**|8dp|Chips, small cards|
|**Medium**|12dp|Cards, dialogs, menus|
|**Large**|16dp|FABs, navigation drawers|
|**Large Increased**|20dp|Expanded FABs|
|**Extra Large**|28dp|Bottom sheets, large cards|
|**Full**|50% (pill)|Кнопки, pills|

---

### 1.5 Elevation — возвышение

MD3 использует **тональную элевацию** вместо традиционных теней — наложение Surface Tint на основе Primary color.

**Уровни элевации:**

|Уровень|Значение|Opacity тинта|Компоненты|
|---|---|---|---|
|Level 0|0dp|0%|Flat surfaces, filled buttons|
|Level 1|1dp|5%|Elevated cards, bottom sheets|
|Level 2|3dp|8%|Navigation bar, menus|
|Level 3|6dp|11%|FABs, dialogs, snackbars|
|Level 4|8dp|12%|Navigation drawer|
|Level 5|12dp|14%|Modal bottom sheets|

---

### 1.6 Motion — анимации

**Easing Curves:**

|Тип|Cubic-Bezier|Применение|
|---|---|---|
|**Standard**|`(0.4, 0, 0.2, 1)`|Большинство переходов|
|**Decelerate**|`(0.0, 0, 0.2, 1)`|Элементы входят на экран|
|**Accelerate**|`(0.4, 0, 1, 1)`|Элементы покидают экран|
|**Sharp**|`(0.4, 0, 0.6, 1)`|Элементы, которые могут вернуться|

**Duration Tokens:**

|Категория|Длительность|Применение|
|---|---|---|
|Short 1-4|50–200ms|Micro-interactions, ripples|
|Medium 1-4|250–400ms|Стандартные переходы UI|
|Long 1-4|450–600ms|Page transitions, complex animations|

**Рекомендуемая длительность по умолчанию: 300ms**. Мобильные анимации: 300–400ms для крупных элементов.

---

### 1.7 Icons — иконки (Material Symbols)

**Размеры иконок:**

|Размер|Применение|Touch Target|
|---|---|---|
|20dp|Dense desktop layouts|40dp|
|**24dp**|**Стандартный (по умолчанию)**|48dp|
|36dp|Large display|N/A|
|48dp|Extra large display|N/A|

**Параметры Material Symbols (Variable Font):**

|Ось|Диапазон|По умолчанию|
|---|---|---|
|**Weight**|100–700|400|
|**Fill**|0–1|0 (outlined)|
|**Grade**|-25 to 200|0|
|**Optical Size**|20–48|24|

Стандартная ширина обводки иконок: **2dp**.

---

## 2. Components (Компоненты)

### 2.1 Actions — Кнопки

#### Common Buttons (Filled, Outlined, Text, Elevated, Tonal)

**Когда использовать:**

- **Filled**: Наивысший приоритет — Save, Confirm, Join
- **Filled Tonal**: Средний приоритет — Next в onboarding
- **Outlined**: Важные, но не первичные действия
- **Elevated**: Визуальное отделение от паттерн-фонов
- **Text**: Самый низкий приоритет, множественные опции

**Анатомия:** Container → Label text → Icon (optional) → State layer

**Размеры:**

|Свойство|Значение|
|---|---|
|**Высота**|40dp|
|**Мин. ширина**|64dp (рекомендуемая 88dp)|
|**Corner radius**|20dp (pill shape)|
|**Horizontal padding**|24dp (только текст), 16dp (с иконкой)|
|**Icon size**|18dp|
|**Icon-to-label spacing**|8dp|
|**Touch target**|≥48dp|
|**Outline width**|1dp|

**States:**

|Состояние|State Layer Opacity|
|---|---|
|Enabled|0%|
|Disabled|Content 38%, container 12%|
|Hovered|8%|
|Focused|12%|
|Pressed|12%|

**Color Tokens:**

|Тип кнопки|Container|Label/Icon|
|---|---|---|
|Filled|`primary`|`onPrimary`|
|Filled Tonal|`secondaryContainer`|`onSecondaryContainer`|
|Elevated|`surfaceContainerLow`|`primary`|
|Outlined|Transparent|`primary`|
|Text|Transparent|`primary`|

**Typography:** `labelLarge` (14sp, Medium 500)

**✅ Do's:** Чёткие action-oriented labels; выбор типа по иерархии важности **❌ Don'ts:** Несколько filled кнопок на одном уровне; обрезка текста labels

---

#### FAB (Floating Action Button)

**Когда использовать:** Наиболее важное действие на экране — Create, Compose, Add. **Только один FAB на экран.**

**Размеры:**

|Вариант|Размер|Icon|Corner Radius|Elevation|
|---|---|---|---|---|
|**Small FAB**|40×40dp|24dp|12dp|3dp|
|**FAB (default)**|56×56dp|24dp|16dp|3dp|
|**Large FAB**|96×96dp|36dp|28dp|3dp|
|**Extended FAB**|56dp height|24dp|16dp|3dp|

Extended FAB: min width 80dp, horizontal padding 16dp, icon-to-label spacing 12dp.

**Color Tokens:** Container: `primaryContainer`, Icon: `onPrimaryContainer`

**✅ Do's:** Конструктивные действия; позиция bottom-right (LTR) **❌ Don'ts:** Деструктивные действия (delete); множественные FAB

---

#### Icon Buttons

**Размеры:**

|Свойство|Значение|
|---|---|
|**Container**|40×40dp|
|**Icon**|24dp|
|**Touch target**|48×48dp|
|**Shape**|Circle (full)|

**Типы:** Standard (no background), Filled, Filled Tonal, Outlined

---

#### Segmented Buttons

**Для 2–5 опций** — single-select или multi-select.

|Свойство|Значение|
|---|---|
|**Высота**|40dp|
|**Min segment width**|48dp|
|**Segment padding**|12dp|
|**Icon size**|18dp|
|**Corner radius (container)**|20dp (pill)|
|**Outline width**|1dp|

---

### 2.2 Communication — Коммуникации

#### Badges

|Тип|Размер|Corner Radius|
|---|---|---|
|**Small (dot)**|6×6dp|3dp (circle)|
|**Large (1 digit)**|16×16dp|8dp|
|**Large (2+ digits)**|16dp height × variable|8dp|

Позиция: offset -4dp от top-right anchor-элемента. Horizontal padding (large): 4dp.

**Color:** Container: `error`, Text: `onError`

**✅ Do's:** Truncate большие числа (99+); скрывать при count=0

---

#### Progress Indicators

|Компонент|Свойство|Значение|
|---|---|---|
|**Circular**|Default size|48dp|
||Track thickness|4dp|
|**Linear**|Track height|4dp|
||Corner radius|2dp (rounded ends)|

**Color:** Active indicator: `primary`, Track: `surfaceContainerHighest`

**Типы:** Determinate (известный прогресс), Indeterminate (неизвестная длительность)

---

#### Snackbars

|Свойство|Значение|
|---|---|
|**Min height (single-line)**|48dp|
|**Max height (two-line)**|68dp|
|**Min width**|344dp|
|**Max width**|672dp|
|**Corner radius**|4dp|
|**Horizontal padding**|16dp|
|**Elevation**|6dp|
|**Bottom margin**|8dp от edge|

**Timing:** Short: 4s, Long: 10s, Indefinite: до dismiss

**Color:** Container: `inverseSurface`, Text: `inverseOnSurface`

**✅ Do's:** Краткие сообщения; позиция выше FAB **❌ Don'ts:** Не использовать для критичных ошибок (используйте dialog)

---

#### Tooltips

|Тип|Max Width|Min Height|Padding|Corner Radius|
|---|---|---|---|---|
|**Plain**|200dp|24dp|8dp H, 4dp V|4dp|
|**Rich**|320dp|Variable|16dp H, 12dp V|12dp|

**Timing:** Entrance 150ms, Display 1500ms, Exit 75ms, Hover delay (desktop) 500ms

---

### 2.3 Containment — Контейнеры

#### Bottom Sheets

**Анатомия:** Container → Drag handle (32×4dp) → Header → Content → Scrim (modal)

|Свойство|Значение|
|---|---|
|**Screen edge margins**|16dp (left/right)|
|**List-item height**|48dp|
|**List title height**|56dp|
|**Grid margin**|24dp|
|**Divider**|1dp|

**Color:** Container: `surfaceContainerLow`

---

#### Cards

**Типы:** Elevated, Filled, Outlined

|Свойство|Elevated|Filled|Outlined|
|---|---|---|---|
|**Corner radius**|12dp|12dp|12dp|
|**Elevation (resting)**|Level 1 (1dp)|Level 0|Level 0|
|**Elevation (dragged)**|Level 4 (8dp)|Level 3 (6dp)|Level 3 (6dp)|
|**Stroke width**|—|—|1dp|

**Recommended margin:** 8dp (mobile), **Bottom padding:** 16dp (с actions), 24dp (без)

---

#### Dialogs

|Свойство|Значение|
|---|---|
|**Max width**|560dp|
|**Padding content**|24dp|
|**Padding title-body**|20dp|
|**Button area height**|52dp|
|**Button padding**|8dp|
|**Elevation**|Level 3|
|**Corner radius**|28dp (extra-large)|

**Typography:** Headline: `headlineSmall` (24sp), Body: `bodyMedium` (16sp)

---

#### Dividers

**Thickness:** 1dp, **Color:** `outlineVariant`

**Типы:** Full-bleed, Inset (padding 16dp), Middle

---

#### Lists

|Конфигурация|Высота|
|---|---|
|Single-line|56dp|
|Single-line (dense)|48dp|
|Two-line|72dp|
|Two-line (dense)|60dp|
|Three-line|88dp|

**Padding:** Left/right 16dp, Top/bottom list 8dp

**Avatar size:** 40dp, **Icon size:** 24dp

---

### 2.4 Navigation — Навигация

#### Navigation Bar (Bottom Navigation)

**Для 3–5 destinations на мобильных устройствах.**

|Свойство|Значение|
|---|---|
|**Высота**|80dp|
|**Icon size**|24×24dp|
|**Active indicator**|64×32dp (pill)|
|**Label typography**|12sp|
|**Item width**|Equal distribution (min 80dp, max 168dp)|
|**Elevation**|Level 2|

**Color:** Active indicator: `secondaryContainer`, Active icon: `onSecondaryContainer`

---

#### Navigation Rail

**Для mid-sized устройств (tablets, landscape phones). 3–7 destinations + FAB.**

|Свойство|Значение|
|---|---|
|**Width**|80dp (collapsed)|
|**Icon size**|24dp|
|**Active indicator**|56×32dp (pill)|
|**Item vertical spacing**|12dp|

---

#### Navigation Drawer

|Свойство|Значение|
|---|---|
|**Width**|360dp|
|**Item height**|56dp|
|**Icon size**|24dp|
|**Horizontal padding**|28dp (start), 24dp (end)|
|**Active indicator corner radius**|28dp (full)|

---

#### Top App Bar

|Вариант|Высота (collapsed)|Высота (expanded)|
|---|---|---|
|**Small/Center-aligned**|64dp|—|
|**Medium**|64dp|112dp|
|**Large**|64dp|152dp|

**Icon size:** 24dp, **Edge padding:** 16dp

**Typography:**

- Small: `titleLarge` (22sp)
- Medium: `headlineSmall` (24sp)
- Large: `headlineMedium` (28sp)

---

#### Tabs

|Свойство|Значение|
|---|---|
|**Высота (icons/text only)**|48dp|
|**Высота (icons + text)**|64dp|
|**Min tab width**|72dp (small), 160dp (large)|
|**Max tab width**|264dp|
|**Indicator height (Primary)**|3dp|
|**Indicator height (Secondary)**|2dp|

---

#### Search

|Свойство|Значение|
|---|---|
|**Высота**|56dp|
|**Corner radius**|28dp (pill)|
|**Icon size**|24dp|
|**Horizontal padding**|16dp|
|**Elevation**|6dp|

---

### 2.5 Selection — Выбор

#### Checkbox

|Свойство|Значение|
|---|---|
|**Checkbox size**|18×18dp|
|**Touch target**|≥48×48dp|
|**Stroke width**|2dp|

**States:** Unselected, Selected (checkmark), Indeterminate (dash), Disabled, Error

---

#### Chips

**Типы:** Assist, Filter, Input, Suggestion

|Свойство|Значение|
|---|---|
|**Высота**|32dp|
|**Corner radius**|8dp|
|**Horizontal padding**|16dp (label only), 8dp (с icons)|
|**Icon size**|18dp|
|**Avatar size**|24dp|
|**Chip spacing**|8dp|

---

#### Radio Buttons

|Свойство|Значение|
|---|---|
|**Radio button size**|20dp diameter|
|**Inner dot (selected)**|10dp diameter|
|**Touch target**|≥48×48dp|
|**Stroke width**|2dp|

---

#### Sliders

|Свойство|Значение|
|---|---|
|**Track height**|4dp|
|**Thumb diameter (default)**|20dp|
|**Thumb diameter (pressed)**|28dp|
|**Value label size**|28×28dp|
|**Touch target height**|48dp|
|**Tick mark size**|4dp|

---

#### Switches

|Свойство|Значение|
|---|---|
|**Track width**|52dp|
|**Track height**|32dp|
|**Track corner radius**|16dp (full)|
|**Handle (off)**|16dp|
|**Handle (on)**|24dp|
|**Handle (pressed)**|28dp|
|**Icon size**|16dp|
|**Touch target height**|≥48dp|

---

#### Date Pickers

**Modal (Portrait):** Width 360dp, Height 568dp, Header 120dp, Corner radius 28dp

**Modal (Landscape):** Width 568dp, Height 360dp

---

#### Time Pickers

**Modal Dial:** Width 328dp, Height 456dp, Clock face diameter 256dp, Corner radius 28dp

---

### 2.6 Text Inputs — Текстовые поля

|Свойство|Filled|Outlined|
|---|---|---|
|**Высота**|56dp|56dp|
|**Dense height**|48dp|—|
|**Corner radius**|4dp (top only)|4dp (all)|
|**Indicator/Outline (idle)**|1dp|1dp|
|**Indicator/Outline (focused)**|2dp|2dp|
|**Horizontal padding**|16dp|16dp|

**Typography:**

- Label: `bodyLarge` (16sp) → `bodySmall` (12sp) при float
- Input text: `bodyLarge` (16sp)
- Supporting text: `bodySmall` (12sp)

**✅ Do's:** Всегда используйте labels; показывайте error states с иконками **❌ Don'ts:** Не смешивайте filled и outlined в одной секции

---

## 3. Styles & Theming

### 3.1 Иерархия токенов

```
Reference Tokens (сырые значения: md-ref-primary-primary40)
    ↓
System Tokens (семантические: md-sys-color-primary)
    ↓
Component Tokens (специфичные: button-filled-container-color)
    ↓
Custom Overrides
```

### 3.2 Material Theme Builder

**Платформы:** Web (m3.material.io/theme-builder), Figma Plugin

**Экспорт:** Jetpack Compose, Android XML, Web CSS, Flutter, DSP

**Возможности:** Генерация из source color/image, light/dark темы, Medium/High contrast варианты

### 3.3 Surface Tokens (полный список)

|Токен|Назначение|
|---|---|
|`surface`|Основной фон|
|`surfaceDim`|Тёмная вариация surface|
|`surfaceBright`|Светлая вариация|
|`surfaceContainerLowest`|Самая низкая elevation|
|`surfaceContainerLow`|Низкая elevation|
|`surfaceContainer`|Default container|
|`surfaceContainerHigh`|Высокая elevation|
|`surfaceContainerHighest`|Самая высокая elevation|

---

## 4. Accessibility (Доступность)

### 4.1 Touch Targets

|Спецификация|Значение|
|---|---|
|**Минимальный touch target**|**48×48dp**|
|**Физический размер**|~9mm|
|**Минимальный spacing между targets**|**8dp**|

### 4.2 Контраст (WCAG)

|Тип текста|Минимум (AA)|Улучшенный (AAA)|
|---|---|---|
|Normal text (<18pt)|**4.5:1**|7:1|
|Large text (≥18pt или 14pt bold)|**3:1**|4.5:1|
|UI Components, icons|**3:1**|—|

### 4.3 State Layer Opacities

|Состояние|Opacity|
|---|---|
|Hover|8%|
|Focus|12%|
|Pressed|12%|
|Dragged|16%|

### 4.4 Motion Sensitivity

- Автовоспроизведение контента должно останавливаться после **5 секунд**
- Limit flashing до **3 раз в секунду** максимум
- Поддержка `prefers-reduced-motion: reduce`

---

## 5. Android-Specific Guidelines

### 5.1 Window Size Classes (Брейкпоинты)

|Ширина|Значение|Покрытие устройств|
|---|---|---|
|**Compact**|< 600dp|99.96% телефонов (portrait)|
|**Medium**|600–839dp|93.73% планшетов (portrait)|
|**Expanded**|840–1199dp|97.22% планшетов (landscape)|
|**Large**|1200–1599dp|Большие планшеты|
|**Extra-Large**|≥ 1600dp|Desktop|

### 5.2 System Bars

|Компонент|Высота|
|---|---|
|**Status bar**|24dp|
|**Gesture navigation bar**|24dp|
|**3-button navigation bar**|48dp|

### 5.3 Edge-to-Edge Design

**Android 15+ (API 35):** Edge-to-edge применяется **автоматически**.

**Ключевые принципы:**

- Top app bar растягивается до верха экрана за status bar
- Bottom navigation растягивается до низа за navigation bar
- Скроллируемый контент появляется за navigation bar
- Используйте `clipToPadding="false"` на scrollable containers

### 5.4 Insets

|Тип|Назначение|
|---|---|
|`systemBars()`|Status bar + navigation bar|
|`displayCutout()`|Области камеры/notch|
|`systemGestures()`|Back gesture + home gesture areas|
|`ime()`|On-screen keyboard|
|`safeDrawing`|Безопасная область для отрисовки|
|`safeGestures`|Безопасная область от конфликтов с жестами|

### 5.5 Gesture Navigation

**Gesture inset areas:**

- **Back gesture:** ~20–24dp от левого и правого края
- **Home gesture:** Нижняя inset область

**Рекомендации:** Избегайте touch targets в gesture inset areas; используйте `setSystemGestureExclusionRects()` только для критичных drag handles.

---

## Краткая шпаргалка для проверки макетов

|Критерий|Требование MD3|
|---|---|
|Touch targets|≥48×48dp, spacing ≥8dp|
|Text contrast|≥4.5:1 (normal), ≥3:1 (large)|
|Baseline grid|Кратно 8dp (4dp для мелких элементов)|
|Button height|40dp|
|FAB size|56×56dp (standard)|
|Navigation bar height|80dp|
|Top app bar height|64dp|
|List item height|56dp (single), 72dp (two-line)|
|Card corner radius|12dp|
|Dialog corner radius|28dp|
|Chip height|32dp|
|Text field height|56dp|
|Compact margin|16dp|

---

_Источники: Официальная документация Material Design 3 (m3.material.io), Android Developers (developer.android.com)_