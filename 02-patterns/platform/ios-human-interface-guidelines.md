---
title: "iOS Human Interface Guidelines"
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
  - "platform/ios"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "iOS"
description: "Apple iOS Human Interface Guidelines reference and summary"
category: "platform"
---

# iOS Human Interface Guidelines
## Comprehensive Design Specifications for AI Evaluation

> Источник: Apple Human Interface Guidelines (developer.apple.com/design/human-interface-guidelines)
> Версия: iOS 17/18, обновлено 2024-2025
> Назначение: AI-driven оценка iOS дизайн-макетов

---

## 1. Design Principles (Принципы дизайна)

### 1.1 Три основных принципа iOS

| Принцип | Описание |
|---------|----------|
| **Clarity (Ясность)** | Текст читаем, иконки понятны, украшения минимальны и уместны |
| **Deference (Уважение к контенту)** | UI уступает контенту, не конкурирует с ним |
| **Depth (Глубина)** | Визуальные слои и реалистичная анимация создают иерархию |

### 1.2 Ключевые характеристики iOS-дизайна
- **Полноэкранный контент**: контент заполняет весь экран
- **Translucency (Полупрозрачность)**: материалы и blur-эффекты
- **Gesture-based navigation**: свайпы, тапы, multi-touch
- **System consistency**: использование системных компонентов

---

## 2. Layout & Screen Anatomy (Макет и анатомия экрана)

### 2.1 Единицы измерения

| Единица | Описание | Использование |
|---------|----------|---------------|
| **Points (pt)** | Логическая единица, независимая от плотности пикселей | ВСЕ размеры в дизайне |
| **Pixels (px)** | Физические пиксели экрана | Только для экспорта |
| **@1x** | 1 point = 1 pixel | Базовый scale factor |
| **@2x** | 1 point = 2×2 pixels | Retina displays |
| **@3x** | 1 point = 3×3 pixels | Super Retina displays |

### 2.2 iPhone Screen Sizes (Актуальные модели)

| Модель | Screen Size | Points (Viewport) | Pixels | Scale |
|--------|-------------|-------------------|--------|-------|
| iPhone SE (3rd gen) | 4.7" | 375×667 | 750×1334 | @2x |
| iPhone 14 | 6.1" | 390×844 | 1170×2532 | @3x |
| iPhone 14 Plus | 6.7" | 428×926 | 1284×2778 | @3x |
| iPhone 14 Pro | 6.1" | 393×852 | 1179×2556 | @3x |
| iPhone 14 Pro Max | 6.7" | 430×932 | 1290×2796 | @3x |
| iPhone 15 | 6.1" | 393×852 | 1179×2556 | @3x |
| iPhone 15 Pro | 6.1" | 393×852 | 1179×2556 | @3x |
| iPhone 15 Pro Max | 6.7" | 430×932 | 1290×2796 | @3x |
| iPhone 16 | 6.1" | 393×852 | 1179×2556 | @3x |
| iPhone 16 Pro | 6.3" | 402×874 | 1206×2622 | @3x |
| iPhone 16 Pro Max | 6.9" | 440×956 | 1320×2868 | @3x |

**Рекомендация**: Для дизайна использовать **393×852 pt** (iPhone 15/16) как базовый размер.

### 2.3 Safe Areas & Insets

#### Status Bar
| Тип устройства | Высота Status Bar |
|----------------|-------------------|
| iPhone с Dynamic Island | 54 pt |
| iPhone с Notch | 47 pt |
| iPhone без notch (SE) | 20 pt |

#### Safe Area Insets (iPhone 15/16 series)

**Portrait:**
- Top: 59 pt (с Dynamic Island)
- Bottom: 34 pt (Home Indicator)
- Left/Right: 0 pt

**Landscape:**
- Top: 0 pt
- Bottom: 21 pt
- Left/Right: 59 pt

#### Home Indicator
- Высота области: **34 pt** (portrait)
- Высота области: **21 pt** (landscape)
- Сам индикатор: тонкая полоса внизу экрана
- Цвет: чёрный на светлом фоне, белый на тёмном

### 2.4 Standard Margins

| Элемент | Значение |
|---------|----------|
| Leading/Trailing margin | **16 pt** |
| Content margin (текст, списки) | 16 pt |
| Grouped table view margin | 20 pt (inset) |
| Edge-to-edge content | 0 pt |

---

## 3. Navigation Components (Компоненты навигации)

### 3.1 Navigation Bar

| Состояние | Высота (без Status Bar) | Полная высота |
|-----------|-------------------------|---------------|
| Standard (small title) | 44 pt | 44 + 59 = **103 pt** |
| Large Title | 44 + 52 = **96 pt** | 96 + 59 = **155 pt** |
| С Search Bar | +56 pt | варьируется |

**Спецификации:**
- Background: translucent/opaque с blur
- Title (small): 17 pt Semibold, centered
- Title (large): 34 pt Bold, left-aligned
- Back button: chevron.left + label
- Bar button items: 44×44 pt touch target

### 3.2 Tab Bar

| Параметр | iPhone | iPad |
|----------|--------|------|
| Высота (без Home Indicator) | 49 pt | 50 pt |
| Полная высота (с Home Indicator) | **83 pt** | 50 pt |
| Высота в Landscape | 32 pt | 50 pt |
| Максимум табов | 5 | 7 |

**Спецификации:**
- Icon size: 25×25 pt (maximum 28×28 pt)
- Label font: 10 pt Medium
- Spacing icon-to-label: 2 pt
- Touch target: распределяется равномерно
- Background: translucent с blur

**Состояния:**
- Unselected: серый цвет (systemGray)
- Selected: tint color (systemBlue по умолчанию)
- Badge: красный круг, min 18 pt diameter

### 3.3 Toolbar

| Параметр | iPhone | iPad |
|----------|--------|------|
| Высота (без Home Indicator) | 44 pt | 50 pt |
| Полная высота (с Home Indicator) | **78 pt** | 50 pt |

**Спецификации:**
- Background: translucent с blur
- Items: распределены с flexible space
- Icon style: stroke/outline (не filled)

### 3.4 Search Bar

| Параметр | Значение |
|----------|----------|
| Высота | 36 pt (поле) / 56 pt (с padding) |
| Corner radius | 10 pt |
| Placeholder font | 17 pt Regular |
| Text font | 17 pt Regular |
| Icon (magnifying glass) | 13×13 pt |
| Clear button | 14×14 pt |

---

## 4. Typography (Типографика)

### 4.1 System Font: San Francisco

**Варианты:**
- **SF Pro**: основной шрифт для iOS/macOS
- **SF Pro Text**: для размеров ≤19 pt
- **SF Pro Display**: для размеров ≥20 pt
- **SF Pro Rounded**: скруглённая версия
- **SF Mono**: моноширинный
- **New York**: serif шрифт

### 4.2 Text Styles (Dynamic Type)

| Text Style | Default Size | Weight | Leading |
|------------|--------------|--------|---------|
| Large Title | 34 pt | Bold | 41 pt |
| Title 1 | 28 pt | Bold | 34 pt |
| Title 2 | 22 pt | Bold | 28 pt |
| Title 3 | 20 pt | Semibold | 25 pt |
| Headline | 17 pt | Semibold | 22 pt |
| **Body** | **17 pt** | Regular | 22 pt |
| Callout | 16 pt | Regular | 21 pt |
| Subheadline | 15 pt | Regular | 20 pt |
| Footnote | 13 pt | Regular | 18 pt |
| Caption 1 | 12 pt | Regular | 16 pt |
| Caption 2 | 11 pt | Regular | 13 pt |

### 4.3 Dynamic Type Scaling

Text styles масштабируются в зависимости от настроек пользователя:
- **xSmall** → **xxxLarge**: 7 стандартных размеров
- **Accessibility sizes**: 5 дополнительных больших размеров

**Важно:**
- Body (17 pt) может масштабироваться от 14 pt до 53 pt
- Caption 2 имеет минимум 11 pt (не уменьшается ниже)
- Всегда использовать Text Styles, не фиксированные размеры

### 4.4 Типографические правила

| Правило | Значение |
|---------|----------|
| Minimum font size | 11 pt (для читаемости) |
| Body text | 17 pt Regular |
| Primary action button | 17 pt Semibold |
| Navigation title | 17 pt Semibold |
| Large title | 34 pt Bold |
| Tab bar label | 10 pt Medium |
| Minimum line length | ~40 characters |
| Maximum line length | ~80 characters |

---

## 5. Color System (Цветовая система)

### 5.1 System Colors (Semantic)

| Color Name | Light Mode | Dark Mode | Usage |
|------------|------------|-----------|-------|
| systemBlue | #007AFF | #0A84FF | Interactive elements |
| systemGreen | #34C759 | #30D158 | Success, positive |
| systemIndigo | #5856D6 | #5E5CE6 | — |
| systemOrange | #FF9500 | #FF9F0A | Warnings |
| systemPink | #FF2D55 | #FF375F | — |
| systemPurple | #AF52DE | #BF5AF2 | — |
| systemRed | #FF3B30 | #FF453A | Errors, destructive |
| systemTeal | #5AC8FA | #64D2FF | — |
| systemYellow | #FFCC00 | #FFD60A | — |

### 5.2 Gray Colors (6 оттенков серого)

| Name | Light Mode | Dark Mode |
|------|------------|-----------|
| systemGray | #8E8E93 | #8E8E93 |
| systemGray2 | #AEAEB2 | #636366 |
| systemGray3 | #C7C7CC | #48484A |
| systemGray4 | #D1D1D6 | #3A3A3C |
| systemGray5 | #E5E5EA | #2C2C2E |
| systemGray6 | #F2F2F7 | #1C1C1E |

### 5.3 Background Colors

**System Backgrounds:**
| Level | Light Mode | Dark Mode |
|-------|------------|-----------|
| systemBackground | #FFFFFF | #000000 |
| secondarySystemBackground | #F2F2F7 | #1C1C1E |
| tertiarySystemBackground | #FFFFFF | #2C2C2E |

**Grouped Backgrounds:**
| Level | Light Mode | Dark Mode |
|-------|------------|-----------|
| systemGroupedBackground | #F2F2F7 | #000000 |
| secondarySystemGroupedBackground | #FFFFFF | #1C1C1E |
| tertiarySystemGroupedBackground | #F2F2F7 | #2C2C2E |

### 5.4 Label Colors

| Name | Light Mode | Dark Mode |
|------|------------|-----------|
| label | #000000 | #FFFFFF |
| secondaryLabel | #3C3C43 (60%) | #EBEBF5 (60%) |
| tertiaryLabel | #3C3C43 (30%) | #EBEBF5 (30%) |
| quaternaryLabel | #3C3C43 (18%) | #EBEBF5 (18%) |

### 5.5 Fill Colors

| Name | Light Mode | Dark Mode |
|------|------------|-----------|
| systemFill | #787880 (20%) | #787880 (36%) |
| secondarySystemFill | #787880 (16%) | #787880 (32%) |
| tertiarySystemFill | #767680 (12%) | #767680 (24%) |
| quaternarySystemFill | #747480 (8%) | #767680 (18%) |

### 5.6 Separator Colors

| Name | Light Mode | Dark Mode |
|------|------------|-----------|
| separator | #3C3C43 (29%) | #545458 (60%) |
| opaqueSeparator | #C6C6C8 | #38383A |

### 5.7 Contrast Requirements

| Контент | Минимальный контраст |
|---------|---------------------|
| Normal text (<17pt) | **4.5:1** |
| Large text (≥17pt Bold, ≥14pt Bold) | **3:1** |
| UI components, icons | **3:1** |
| Enhanced (accessibility) | **7:1** |

---

## 6. Touch Targets & Accessibility

### 6.1 Touch Target Sizes

| Элемент | Минимальный размер | Рекомендуемый |
|---------|-------------------|---------------|
| **Tappable area** | **44×44 pt** | ≥44×44 pt |
| Small inline controls | 44×44 pt (touch area) | Визуально может быть меньше |
| visionOS | 60×60 pt | — |

**Критично:** Визуальный размер может быть меньше 44 pt, но touch target должен быть ≥44×44 pt.

### 6.2 Spacing Requirements

| Параметр | Значение |
|----------|----------|
| Минимум между touch targets | **8 pt** |
| Рекомендуемый spacing | 12-16 pt |
| Между строками списка | Minimum 44 pt row height |

### 6.3 Accessibility Features

| Feature | Описание |
|---------|----------|
| **VoiceOver** | Screen reader для слепых/слабовидящих |
| **Dynamic Type** | Масштабирование текста пользователем |
| **Reduce Motion** | Уменьшение анимаций |
| **Increase Contrast** | Увеличение контраста |
| **Bold Text** | Утолщение всего текста |
| **Reduce Transparency** | Отключение blur/transparency |
| **Differentiate Without Color** | Не полагаться только на цвет |

### 6.4 Accessibility Labels

- Все интерактивные элементы должны иметь accessibility label
- Изображения: accessibilityLabel описывает содержимое
- Decorative images: isAccessibilityElement = false
- Buttons: описывать действие, не внешний вид

---

## 7. Components (Компоненты)

### 7.1 Buttons

| Тип | Высота | Стиль |
|-----|--------|-------|
| System Button | 44 pt touch target | Tinted text |
| Filled Button | 50 pt | Rounded rect, filled |
| Gray Button | 50 pt | Gray background |
| Tinted Button | 50 pt | Tinted background |
| Plain Button | 44 pt | Text only |

**Button Corner Radius:**
- Small buttons: 6-8 pt
- Medium buttons: 10-12 pt
- Large buttons: 14-16 pt
- Capsule: height/2

### 7.2 Text Fields

| Параметр | Значение |
|----------|----------|
| Высота | 44 pt (minimum) |
| Border radius | 10 pt |
| Padding horizontal | 12 pt |
| Placeholder color | tertiaryLabel |
| Text size | 17 pt |

### 7.3 Switches (Toggle)

| Параметр | Значение |
|----------|----------|
| Размер | 51×31 pt |
| Track corner radius | 15.5 pt (полукруг) |
| Thumb diameter | 27 pt |
| On color | systemGreen |
| Off color | systemGray4 / systemGray5 |

### 7.4 Segmented Controls

| Параметр | Значение |
|----------|----------|
| Высота | 32 pt (default) |
| Corner radius | 9 pt |
| Segment padding | 12 pt horizontal |
| Font | 13 pt Regular |

### 7.5 Sliders

| Параметр | Значение |
|----------|----------|
| Track height | 4 pt |
| Thumb diameter | 28 pt |
| Touch target height | 44 pt |
| Min track color | tint color |
| Max track color | systemGray4 |

### 7.6 Progress Indicators

**Progress Bar:**
- Height: 4 pt
- Corner radius: 2 pt

**Activity Indicator:**
- Small: 20×20 pt
- Medium: 37×37 pt (default)
- Large: 50×50 pt

### 7.7 Lists (Table Views)

| Тип ячейки | Высота |
|------------|--------|
| Default (basic) | 44 pt |
| Subtitle | 57 pt |
| Value (right detail) | 44 pt |
| Custom | ≥44 pt |

**Insets:**
- Plain style: content edge-to-edge
- Grouped style: 20 pt inset (iOS 13+)
- Inset grouped: 16 pt horizontal margin

**Separators:**
- Default leading inset: 16 pt
- Без иконки: 16 pt
- С иконкой: icon + padding + 16 pt

### 7.8 Cards

| Параметр | Значение |
|----------|----------|
| Corner radius | 10-16 pt |
| Shadow opacity | 0.1-0.2 |
| Shadow radius | 8-16 pt |
| Padding | 16 pt |

---

## 8. Sheets & Modals (Модальные окна)

### 8.1 Sheet Presentation Styles

| Стиль | Описание | Использование |
|-------|----------|---------------|
| **Page Sheet** | Покрывает почти весь экран, оставляя parent видимым сверху | Default в iOS 13+ |
| **Form Sheet** | Центрированный на iPad, fullscreen на iPhone | Формы, диалоги |
| **Full Screen** | Полностью покрывает экран | Иммерсивный контент |
| **Current Context** | Размер parent view | Split view panes |
| **Overful Screen** | Поверх всего, без убирания предыдущего | Редко |

### 8.2 Sheet Detents (iOS 15+)

| Detent | Высота |
|--------|--------|
| **Medium** | ~50% высоты экрана |
| **Large** | Почти полная высота |
| **Custom** | Любое значение |

### 8.3 Sheet Specifications

| Параметр | Значение |
|----------|----------|
| Corner radius (top) | Continuous, ~10 pt |
| Drag indicator | 36×5 pt, centered, 6 pt from top |
| Drag indicator color | opaque gray |
| Dimming view | чёрный с прозрачностью |
| Dismiss gesture | Swipe down |

### 8.4 Alerts

| Параметр | Значение |
|----------|----------|
| Width | 270 pt (iPhone) |
| Corner radius | 14 pt |
| Title font | 17 pt Semibold |
| Message font | 13 pt Regular |
| Button height | 44 pt |
| Max buttons inline | 2 |

**Alert Types:**
- **Alert**: важная информация, требует действия
- **Action Sheet**: список действий, появляется снизу

### 8.5 Popovers (iPad)

| Параметр | Значение |
|----------|----------|
| Arrow size | 13 pt |
| Corner radius | 13 pt |
| Max width | 320 pt (default) |
| Background | blur + tint |

---

## 9. SF Symbols (Иконки)

### 9.1 Overview

- **Количество**: 6,000+ символов (SF Symbols 6)
- **Интеграция**: с San Francisco font
- **Форматы**: векторные, масштабируемые

### 9.2 Symbol Scales

| Scale | Использование |
|-------|---------------|
| **Small** | Плотный UI, рядом с мелким текстом |
| **Medium** | Default, большинство случаев |
| **Large** | Акцент, крупные touch targets |

### 9.3 Symbol Weights

9 весов, соответствующих San Francisco:
- Ultralight, Thin, Light, Regular, Medium, Semibold, Bold, Heavy, Black

### 9.4 Rendering Modes

| Mode | Описание |
|------|----------|
| **Monochrome** | Один цвет (tint color) |
| **Hierarchical** | Один цвет с прозрачностью слоёв |
| **Palette** | 2-3 пользовательских цвета |
| **Multicolor** | Фиксированные цвета (Apple-defined) |

### 9.5 Icon Sizes по контексту

| Контекст | Рекомендуемый размер |
|----------|---------------------|
| Tab Bar | 25-28 pt |
| Navigation Bar | 22-24 pt |
| Toolbar | 22-24 pt |
| List row accessory | 17-20 pt |
| Inline with body text | match text style |

### 9.6 Tab Bar Icons

- **Стиль**: Filled (iOS 15+)
- **Размер**: Maximum 25×25 pt (может быть до 28×28 pt)
- **Touch target**: вся ширина таба

### 9.7 Toolbar/Navigation Bar Icons

- **Стиль**: Stroke/Outline
- **Stroke width**: 1-1.5 pt
- **Touch target**: 44×44 pt

---

## 10. App Icons

### 10.1 App Icon Sizes

| Платформа | Размер (pt) | Размер (@1x/@2x/@3x) |
|-----------|-------------|----------------------|
| iPhone App | 60×60 pt | 120×120, 180×180 px |
| iPad App | 76×76 pt | 76×76, 152×152 px |
| iPad Pro | 83.5×83.5 pt | 167×167 px |
| App Store | 1024×1024 pt | 1024×1024 px |
| Spotlight (iPhone) | 40×40 pt | 80×80, 120×120 px |
| Settings | 29×29 pt | 58×58, 87×87 px |

### 10.2 App Icon Guidelines

- **Форма**: Система применяет rounded superellipse mask
- **Не добавлять**: тени, скругления (применяются автоматически)
- **Формат**: PNG, без alpha channel
- **Содержимое**: одна узнаваемая графика
- **Avoid**: фото, много текста, скриншоты UI

---

## 11. Materials & Visual Effects

### 11.1 Materials (Blur Effects)

| Material | Описание | Использование |
|----------|----------|---------------|
| **Ultra Thin** | Самый лёгкий blur | — |
| **Thin** | Лёгкий blur | — |
| **Regular** | Стандартный blur | Навигация, таб бары |
| **Thick** | Сильный blur | Выделение |
| **Chrome** | Системный материал | Toolbars |

### 11.2 Vibrancy

- Добавляет яркость контенту на blur-фоне
- Типы: label, secondaryLabel, fill, separator
- Адаптируется к Light/Dark Mode

### 11.3 Shadows

| Элемент | Shadow Specs |
|---------|--------------|
| Cards | offset: 0, 2 pt; blur: 8 pt; opacity: 0.1 |
| Modals | offset: 0, 2-4 pt; blur: 16-24 pt; opacity: 0.2-0.3 |
| Buttons (raised) | offset: 0, 1-2 pt; blur: 4-8 pt; opacity: 0.15 |

---

## 12. Animation & Motion

### 12.1 Standard Durations

| Тип анимации | Длительность |
|--------------|--------------|
| Quick (tap feedback) | 0.1-0.15s |
| Standard (transitions) | 0.25-0.35s |
| Emphasis (attention) | 0.4-0.5s |
| Page transitions | 0.35s |
| Modal presentation | 0.35s |
| Sheet dismiss | 0.25s |

### 12.2 Spring Animations

iOS использует spring-based анимации:
- **Response**: ~0.55 (время до завершения)
- **Damping fraction**: ~0.85 (затухание)

### 12.3 Easing Curves

| Curve | Использование |
|-------|---------------|
| **easeInOut** | Default для большинства |
| **easeOut** | Появление элементов |
| **easeIn** | Исчезновение элементов |
| **linear** | Progress indicators |
| **spring** | Интерактивные элементы |

### 12.4 Reduce Motion

Когда включено:
- Заменять slide transitions на fade
- Отключать parallax
- Уменьшать/отключать bouncing
- Использовать простые crossfade

---

## 13. Gestures (Жесты)

### 13.1 Standard Gestures

| Жест | Действие |
|------|----------|
| **Tap** | Выбор, активация |
| **Double Tap** | Zoom in/out |
| **Long Press** | Context menu (>500ms) |
| **Swipe** | Навигация, действия |
| **Pan/Drag** | Перемещение, скролл |
| **Pinch** | Zoom |
| **Rotate** | Вращение |

### 13.2 Edge Gestures

| Жест | Действие |
|------|----------|
| **Swipe from left edge** | Back navigation |
| **Swipe from bottom** | Home / App Switcher |
| **Swipe from top-right** | Control Center |
| **Swipe from top-left** | Notification Center |

### 13.3 Swipe Actions (Lists)

- **Leading swipe**: Позитивные действия (mark, pin)
- **Trailing swipe**: Негативные/деструктивные действия (delete, archive)
- Full swipe: выполняет первое действие

---

## 14. Dark Mode

### 14.1 Принципы Dark Mode

- **Не инвертировать**: цвета не просто инвертируются
- **Semantic colors**: использовать системные цвета
- **Backgrounds**: тёмные, но не pure black везде
- **Elevation**: более светлые поверхности = выше
- **Vibrancy**: увеличена для читаемости

### 14.2 Background Hierarchy (Dark Mode)

| Level | Color | Использование |
|-------|-------|---------------|
| Base | #000000 | Основной фон |
| Elevated | #1C1C1E | Карточки, sheets |
| Secondary | #2C2C2E | Вложенные элементы |

### 14.3 Dark Mode Guidelines

- Тестировать оба режима
- Не предлагать app-specific toggle (использовать системный)
- SF Symbols автоматически адаптируются
- Использовать Asset Catalogs для разных версий изображений

---

## 15. Adaptive Layout & Size Classes

### 15.1 Size Classes

| Size Class | Width | Height | Устройства |
|------------|-------|--------|------------|
| Compact × Regular | cW × rH | iPhone portrait |
| Compact × Compact | cW × cH | iPhone landscape |
| Regular × Regular | rW × rH | iPad full screen |
| Regular × Compact | rW × cH | iPad split (narrow) |

### 15.2 Adaptive Patterns

| Pattern | Compact Width | Regular Width |
|---------|---------------|---------------|
| Navigation | Tab Bar | Sidebar / Tab Bar |
| Master-Detail | Stacked | Side-by-side |
| Popovers | Full screen sheet | Popover |
| Lists | Full width | Inset / Sectioned |

### 15.3 Split View (iPad)

| Режим | Primary Width | Secondary Width |
|-------|---------------|-----------------|
| 1/3 - 2/3 | ~320 pt | остаток |
| 1/2 - 1/2 | 50% | 50% |
| 2/3 - 1/3 | остаток | ~320 pt |

---

## 16. Quick Reference: Component Sizes

### 16.1 Вертикальные размеры

| Компонент | Высота |
|-----------|--------|
| Status Bar (Dynamic Island) | 54 pt |
| Navigation Bar (small title) | 44 pt |
| Navigation Bar (large title) | 96 pt |
| Tab Bar | 49 pt (83 pt с Home Indicator) |
| Toolbar | 44 pt (78 pt с Home Indicator) |
| Search Bar | 36-56 pt |
| Table Row (default) | 44 pt |
| Button (filled) | 50 pt |
| Text Field | 44 pt |
| Segmented Control | 32 pt |
| Home Indicator area | 34 pt |

### 16.2 Touch Targets

| Элемент | Минимум |
|---------|---------|
| Any tappable element | **44×44 pt** |
| Spacing between targets | **8 pt** |

### 16.3 Corner Radii

| Элемент | Radius |
|---------|--------|
| Cards | 10-16 pt |
| Buttons (medium) | 10-12 pt |
| Text Fields | 10 pt |
| Search Bar | 10 pt |
| Alerts | 14 pt |
| Sheets | ~10 pt (continuous) |
| App Icon | System-applied |

---

## 17. Critical Checklist (Контрольный список)

### ✅ Touch & Interaction
- [ ] Touch targets ≥ **44×44 pt**
- [ ] Spacing между targets ≥ **8 pt**
- [ ] Interactive elements имеют accessibility labels
- [ ] Поддержка VoiceOver

### ✅ Typography
- [ ] Использовать Text Styles (не фиксированные размеры)
- [ ] Body text: **17 pt**
- [ ] Minimum text: **11 pt**
- [ ] Поддержка Dynamic Type

### ✅ Color & Contrast
- [ ] Normal text contrast ≥ **4.5:1**
- [ ] Large text / UI contrast ≥ **3:1**
- [ ] Использовать semantic system colors
- [ ] Не полагаться только на цвет

### ✅ Layout
- [ ] Margins: **16 pt** minimum
- [ ] Safe Areas учтены
- [ ] Status Bar: 54 pt (Dynamic Island)
- [ ] Home Indicator: 34 pt

### ✅ Navigation
- [ ] Navigation Bar: 44 pt (small) / 96 pt (large)
- [ ] Tab Bar: 49 pt (+34 pt Home Indicator)
- [ ] Max tabs: 5 (iPhone)

### ✅ Components
- [ ] Switch: 51×31 pt
- [ ] Segmented Control: 32 pt height
- [ ] List rows: ≥44 pt height

### ✅ Dark Mode
- [ ] Тестировать в обоих режимах
- [ ] Semantic colors адаптируются
- [ ] Images имеют light/dark варианты

### ✅ Accessibility
- [ ] Поддержка Reduce Motion
- [ ] Поддержка Bold Text
- [ ] Поддержка Increase Contrast
- [ ] Content descriptions для изображений

---

## 18. Resources (Ресурсы)

### 18.1 Official Resources

- **Apple HIG**: developer.apple.com/design/human-interface-guidelines
- **SF Symbols App**: developer.apple.com/sf-symbols
- **Apple Design Resources**: developer.apple.com/design/resources
- **Figma iOS 17 UI Kit**: Apple Design Resources

### 18.2 Fonts

- **SF Pro**: developer.apple.com/fonts
- **SF Symbols**: 6,000+ векторных иконок
- **New York**: Serif шрифт от Apple

### 18.3 Additional Topics

| Тема | Ресурс |
|------|--------|
| Widgets | HIG > App Extensions > Widgets |
| Live Activities | HIG > System Experiences |
| CarPlay | HIG > Designing for CarPlay |
| watchOS | HIG > Designing for watchOS |
| iPadOS Sidebar | HIG > Components > Sidebars |
| Keyboard shortcuts | HIG > Inputs > Hardware Keyboards |

---

## Версия документа

| Параметр | Значение |
|----------|----------|
| Версия | 1.0 |
| Дата | 2025-02 |
| iOS версия | 17/18 |
| Источник | Apple Human Interface Guidelines |
| Назначение | AI-оценка iOS дизайн-макетов |
