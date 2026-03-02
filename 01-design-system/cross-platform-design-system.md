---
title: "Cross-Platform Design System"
type: "guide"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/guide"
  - "platform/web"
  - "platform/ios"
  - "platform/android"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Cross-platform design system guidelines and implementation"
---

# Cross-Platform Design Evaluation System
## Unified AI-Driven Design Review Framework

> Версия: 1.0 | Дата: 2025-02
> Источники: Material Design 3, Android Design Guidelines, Apple Human Interface Guidelines
> Назначение: Единая система AI-оценки дизайн-макетов для iOS и Android

---

## Содержание

1. [Философия и принципы](#1-философия-и-принципы)
2. [Единицы измерения](#2-единицы-измерения)
3. [Touch Targets & Accessibility](#3-touch-targets--accessibility)
4. [Typography](#4-typography)
5. [Color System](#5-color-system)
6. [Layout & Spacing](#6-layout--spacing)
7. [Navigation](#7-navigation)
8. [Components](#8-components)
9. [Modals & Overlays](#9-modals--overlays)
10. [Icons](#10-icons)
11. [Motion & Animation](#11-motion--animation)
12. [Dark Mode](#12-dark-mode)
13. [Platform Detection](#13-platform-detection)
14. [Universal Checklist](#14-universal-checklist)
15. [Platform-Specific Checklist](#15-platform-specific-checklist)
16. [Evaluation Scoring](#16-evaluation-scoring)

---

## 1. Философия и принципы

### 1.1 Общие принципы (Universal)

| Принцип | Описание |
|---------|----------|
| **Clarity** | Контент понятен, иерархия очевидна |
| **Consistency** | Единообразие в рамках приложения и платформы |
| **Accessibility** | Доступность для всех пользователей |
| **Feedback** | Система отвечает на действия пользователя |
| **User Control** | Пользователь контролирует взаимодействие |

### 1.2 Platform-Specific Philosophy

| Аспект | iOS (Apple HIG) | Android (Material Design) |
|--------|-----------------|---------------------------|
| **Философия** | Clarity, Deference, Depth | Material as metaphor, Bold/Graphic/Intentional |
| **Метафора** | Стекло, слои, полупрозрачность | Физический материал, поверхности, elevation |
| **Глубина** | Blur, vibrancy, translucency | Shadows, elevation, tonal surfaces |
| **Движение** | Естественное, пружинное | Физически обоснованное, easing curves |
| **Брендинг** | Сдержанный, системный стиль | Выраженный через Dynamic Color |

### 1.3 Ключевое правило

> **При оценке макета сначала определи целевую платформу, затем применяй соответствующие guidelines.**
> Если платформа не указана — проверяй по универсальным критериям.

---

## 2. Единицы измерения

### 2.1 Comparison Table

| Платформа | Единица | Описание | Базовая плотность |
|-----------|---------|----------|-------------------|
| **iOS** | pt (points) | Логическая единица | 163 PPI (@1x) |
| **Android** | dp (density-independent pixels) | Логическая единица | 160 DPI (mdpi) |
| **Web** | px (CSS pixels) | Логическая единица | 96 DPI |

### 2.2 Conversion (Approximate)

```
1 pt (iOS) ≈ 1 dp (Android) ≈ 1 px (CSS at 1x)
```

**Scale Factors:**

| iOS | Android | Multiplier |
|-----|---------|------------|
| @1x | mdpi | 1× |
| @2x | xhdpi | 2× |
| @3x | xxhdpi | 3× |
| — | xxxhdpi | 4× |

### 2.3 Universal Rule

> **Для AI-оценки: считать pt и dp эквивалентными.**
> Все спецификации в этом документе используют `pt/dp` как взаимозаменяемые единицы.

---

## 3. Touch Targets & Accessibility

### 3.1 Minimum Touch Target Sizes

| Платформа | Minimum Size | Recommended | Критично |
|-----------|--------------|-------------|----------|
| **iOS** | 44×44 pt | ≥44×44 pt | ❌ < 44 pt |
| **Android** | 48×48 dp | ≥48×48 dp | ❌ < 48 dp |
| **WCAG AAA** | 44×44 px | — | — |
| **WCAG AA** | 24×24 px | — | — |

### 3.2 Universal Standard

> **Рекомендация: использовать 48×48 pt/dp как универсальный минимум.**
> Это удовлетворяет требованиям обеих платформ.

### 3.3 Spacing Between Targets

| Платформа | Minimum Spacing |
|-----------|-----------------|
| **iOS** | 8 pt |
| **Android** | 8 dp |
| **Universal** | **≥8 pt/dp** |

### 3.4 Accessibility Requirements (Universal)

| Требование | iOS | Android | Universal |
|------------|-----|---------|-----------|
| Screen Reader | VoiceOver | TalkBack | ✅ Required |
| Text Scaling | Dynamic Type | Font Scale | ✅ Required |
| Reduce Motion | Reduce Motion | Remove Animations | ✅ Required |
| High Contrast | Increase Contrast | High Contrast | ✅ Required |
| Color Independence | ✅ | ✅ | Не полагаться только на цвет |

### 3.5 Contrast Requirements

| Контент | WCAG AA | WCAG AAA | iOS | Android |
|---------|---------|----------|-----|---------|
| Normal text | 4.5:1 | 7:1 | 4.5:1 | 4.5:1 |
| Large text (≥18pt/24px bold) | 3:1 | 4.5:1 | 3:1 | 3:1 |
| UI Components | 3:1 | — | 3:1 | 3:1 |
| Non-text (icons) | 3:1 | — | 3:1 | 3:1 |

> **Universal Standard: 4.5:1 для текста, 3:1 для UI элементов**

---

## 4. Typography

### 4.1 System Fonts

| Платформа | Primary Font | Monospace | Serif |
|-----------|--------------|-----------|-------|
| **iOS** | SF Pro (Text/Display) | SF Mono | New York |
| **Android** | Roboto | Roboto Mono | Noto Serif |

### 4.2 Type Scale Comparison

| Role | iOS Text Style | iOS Size | Android Style | Android Size |
|------|----------------|----------|---------------|--------------|
| Display Large | — | — | Display Large | 57 sp |
| Display Medium | — | — | Display Medium | 45 sp |
| Display Small | — | — | Display Small | 36 sp |
| **Large Title** | Large Title | **34 pt** | Headline Large | 32 sp |
| Title 1 | Title 1 | 28 pt | Headline Medium | 28 sp |
| Title 2 | Title 2 | 22 pt | Headline Small | 24 sp |
| Title 3 | Title 3 | 20 pt | Title Large | 22 sp |
| Headline | Headline | 17 pt Semi | Title Medium | 16 sp Medium |
| **Body** | Body | **17 pt** | Body Large | **16 sp** |
| Body 2 | Callout | 16 pt | Body Medium | 14 sp |
| Subhead | Subheadline | 15 pt | Body Small | 12 sp |
| Footnote | Footnote | 13 pt | Label Large | 14 sp |
| Caption 1 | Caption 1 | 12 pt | Label Medium | 12 sp |
| Caption 2 | Caption 2 | 11 pt | Label Small | 11 sp |

### 4.3 Universal Typography Rules

| Правило | iOS | Android | Universal |
|---------|-----|---------|-----------|
| **Minimum text size** | 11 pt | 12 sp (рекомендуется) | **11-12 pt/sp** |
| **Body text** | 17 pt | 14-16 sp | **14-17 pt/sp** |
| **Primary actions** | 17 pt Semibold | 14 sp Medium | **14-17 pt/sp Medium+** |
| **Line height** | ~1.3× | 1.2-1.5× | **1.2-1.5×** |
| **Max line length** | ~80 chars | 40-60 chars | **40-80 chars** |

### 4.4 Dynamic Text Sizing

| Платформа | Механизм | Диапазон |
|-----------|----------|----------|
| **iOS** | Dynamic Type | xSmall → AX5 (7+5 sizes) |
| **Android** | Font Scale | 0.85× → 2.0× |

> **Universal: Дизайн должен поддерживать увеличение текста минимум до 200%**

---

## 5. Color System

### 5.1 Semantic Color Roles

| Role | iOS Name | Android Name | Usage |
|------|----------|--------------|-------|
| **Primary** | Tint Color | Primary | Ключевые элементы, акценты |
| **On Primary** | — | On Primary | Контент на Primary |
| **Secondary** | — | Secondary | Менее важные элементы |
| **Error** | systemRed | Error | Ошибки, деструктивные действия |
| **Success** | systemGreen | — | Успех, подтверждение |
| **Warning** | systemOrange | — | Предупреждения |
| **Background** | systemBackground | Surface | Основной фон |
| **Surface** | secondarySystemBackground | Surface Container | Карточки, elevated surfaces |
| **On Surface** | label | On Surface | Основной текст |
| **Outline** | separator | Outline | Границы, разделители |

### 5.2 Background Hierarchy

| Level | iOS Light | iOS Dark | Android Light | Android Dark |
|-------|-----------|----------|---------------|--------------|
| Base | #FFFFFF | #000000 | #FEF7FF | #141218 |
| Level 1 | #F2F2F7 | #1C1C1E | Surface Container | Surface Container |
| Level 2 | #FFFFFF | #2C2C2E | Surface Container High | Surface Container High |

### 5.3 Text/Label Colors

| Level | iOS Light | iOS Dark | Android Light | Android Dark |
|-------|-----------|----------|---------------|--------------|
| Primary | #000000 | #FFFFFF | On Surface | On Surface |
| Secondary | 60% opacity | 60% opacity | On Surface Variant | On Surface Variant |
| Tertiary | 30% opacity | 30% opacity | — | — |
| Disabled | 30% opacity | 30% opacity | 38% opacity | 38% opacity |

### 5.4 System Colors (Quick Reference)

| Color | iOS Light | iOS Dark | M3 Equivalent |
|-------|-----------|----------|---------------|
| Blue | #007AFF | #0A84FF | Primary (customizable) |
| Green | #34C759 | #30D158 | — |
| Red | #FF3B30 | #FF453A | Error |
| Orange | #FF9500 | #FF9F0A | — |
| Yellow | #FFCC00 | #FFD60A | — |
| Gray | #8E8E93 | #8E8E93 | Outline |

### 5.5 Dynamic Color (Android 12+)

Android поддерживает Dynamic Color на основе обоев пользователя.
iOS не имеет аналогичной системы — используется фиксированный Tint Color.

> **Universal: Использовать semantic color roles, не hardcoded HEX values**

---

## 6. Layout & Spacing

### 6.1 Grid Systems

| Параметр | iOS | Android |
|----------|-----|---------|
| **Base unit** | Нет строгой сетки | 8 dp (4 dp для мелких) |
| **Columns (Phone)** | Fluid | 4 columns |
| **Columns (Tablet)** | Fluid | 8-12 columns |
| **Gutter** | — | 16-24 dp |

### 6.2 Margins

| Контекст | iOS | Android | Universal |
|----------|-----|---------|-----------|
| **Screen edge (Phone)** | 16 pt | 16 dp | **16 pt/dp** |
| **Screen edge (Tablet)** | 20+ pt | 24-32 dp | **24 pt/dp** |
| **Content spacing** | 8-16 pt | 8-16 dp | **8-16 pt/dp** |
| **Section spacing** | 20-35 pt | 24-32 dp | **24 pt/dp** |

### 6.3 Safe Areas

#### iOS Safe Areas
| Area | iPhone (Dynamic Island) | iPhone (Notch) |
|------|-------------------------|----------------|
| Top | 59 pt | 47 pt |
| Bottom | 34 pt | 34 pt |
| Left/Right (Portrait) | 0 pt | 0 pt |

#### Android Safe Areas
| Area | Gesture Nav | 3-Button Nav |
|------|-------------|--------------|
| Top (Status Bar) | 24 dp | 24 dp |
| Bottom (Nav Bar) | 48 dp (gesture) | 48 dp |
| Bottom (Gesture Handle) | 20-24 dp | — |

### 6.4 Spacing Scale (Universal)

```
4 pt/dp  — Micro (внутри компонентов)
8 pt/dp  — Small (между связанными элементами)
12 pt/dp — Medium
16 pt/dp — Standard (основной spacing)
24 pt/dp — Large (между секциями)
32 pt/dp — XL
48 pt/dp — XXL (major sections)
```

> **Universal Rule: Все spacing кратны 4 или 8**

---

## 7. Navigation

### 7.1 Primary Navigation Patterns

| Pattern | iOS | Android |
|---------|-----|---------|
| **Tab-based** | Tab Bar (bottom) | Navigation Bar (bottom) |
| **Hierarchical** | Navigation Controller | Navigation Drawer + Back |
| **Sidebar** | Sidebar (iPad) | Navigation Rail / Drawer |
| **Modal** | Sheets, Modals | Bottom Sheets, Dialogs |

### 7.2 Bottom Navigation Comparison

| Параметр | iOS Tab Bar | Android Nav Bar |
|----------|-------------|-----------------|
| **Height** | 49 pt | 80 dp |
| **With Home Indicator** | 83 pt | — |
| **Max items** | 5 | 3-5 |
| **Icon size** | 25-28 pt | 24 dp |
| **Label size** | 10 pt | 12 sp |
| **Icon style** | Filled (selected) | Filled (iOS 15+) |
| **Background** | Translucent blur | Solid/Surface |
| **Indicator** | None (color change) | Pill shape |

### 7.3 Top Navigation Comparison

| Параметр | iOS Navigation Bar | Android Top App Bar |
|----------|--------------------|--------------------|
| **Height (small)** | 44 pt | 64 dp |
| **Height (large)** | 96 pt | 152 dp (Large) |
| **Title position** | Center (small), Left (large) | Left |
| **Title size (small)** | 17 pt Semibold | 22 sp |
| **Title size (large)** | 34 pt Bold | 28 sp |
| **Back button** | Chevron + label | Arrow only |
| **Background** | Translucent blur | Solid/Surface |

### 7.4 Navigation Summary Table

| Screen Width | iOS | Android |
|--------------|-----|---------|
| **Compact (<600dp)** | Tab Bar | Navigation Bar |
| **Medium (600-839dp)** | Tab Bar / Sidebar | Navigation Rail |
| **Expanded (≥840dp)** | Sidebar | Navigation Drawer |

### 7.5 Back Navigation

| Платформа | Gesture | Button |
|-----------|---------|--------|
| **iOS** | Swipe from left edge | Top-left chevron |
| **Android** | Swipe from left/right edge | Top-left arrow, System back |

---

## 8. Components

### 8.1 Buttons

| Параметр | iOS | Android | Universal Min |
|----------|-----|---------|---------------|
| **Height (standard)** | 44-50 pt | 40 dp | **40 pt/dp** |
| **Touch target** | 44×44 pt | 48×48 dp | **44-48 pt/dp** |
| **Corner radius** | 10-14 pt | 20 dp (full) | Varies |
| **Text size** | 17 pt | 14 sp | **14-17 pt/sp** |
| **Horizontal padding** | 16 pt | 24 dp | **16-24 pt/dp** |

#### Button Styles Mapping

| Style | iOS | Android M3 |
|-------|-----|------------|
| Primary/CTA | Filled Button | Filled Button |
| Secondary | Gray/Tinted Button | Tonal Button |
| Tertiary | Plain/Text Button | Text Button |
| Outlined | — | Outlined Button |
| Destructive | Red text/fill | — |

### 8.2 Text Fields

| Параметр | iOS | Android | Universal |
|----------|-----|---------|-----------|
| **Height** | 44 pt | 56 dp | **44-56 pt/dp** |
| **Corner radius** | 10 pt | 4 dp (outlined) | Varies |
| **Text size** | 17 pt | 16 sp | **16-17 pt/sp** |
| **Label** | Placeholder only | Floating label | — |
| **Padding** | 12 pt | 16 dp | **12-16 pt/dp** |

### 8.3 Switches / Toggles

| Параметр | iOS Switch | Android Switch |
|----------|------------|----------------|
| **Size** | 51×31 pt | 52×32 dp |
| **Track radius** | 15.5 pt | 16 dp |
| **Thumb size** | 27 pt | 24 dp (off) / 28 dp (on) |
| **On color** | systemGreen | Primary |
| **Off color** | systemGray | Surface Variant |

### 8.4 Lists / Table Views

| Параметр | iOS | Android | Universal Min |
|----------|-----|---------|---------------|
| **Row height (min)** | 44 pt | 48-88 dp | **44 pt/dp** |
| **Row height (standard)** | 44 pt | 56 dp (one-line) | **48-56 pt/dp** |
| **Leading padding** | 16 pt | 16 dp | **16 pt/dp** |
| **Trailing padding** | 16 pt | 24 dp | **16-24 pt/dp** |
| **Separator inset** | 16 pt (or icon+16) | Full width | — |
| **Divider height** | 0.5 pt | 1 dp | **0.5-1 pt/dp** |

### 8.5 Cards

| Параметр | iOS | Android | Universal |
|----------|-----|---------|-----------|
| **Corner radius** | 10-16 pt | 12 dp | **10-16 pt/dp** |
| **Elevation/Shadow** | Subtle shadow | 1-3 dp elevation | Varies |
| **Padding** | 16 pt | 16 dp | **16 pt/dp** |
| **Background** | secondarySystemBackground | Surface Container |— |

### 8.6 Chips / Tags

| Параметр | iOS | Android |
|----------|-----|---------|
| **Height** | ~32 pt (custom) | 32 dp |
| **Corner radius** | 8-16 pt | 8 dp |
| **Text size** | 13-15 pt | 14 sp |
| **Horizontal padding** | 12 pt | 16 dp |

### 8.7 Component Size Quick Reference

| Component | iOS | Android | Universal Min |
|-----------|-----|---------|---------------|
| Button height | 44-50 pt | 40 dp | 40 pt/dp |
| FAB | — | 56 dp | 56 dp |
| FAB Small | — | 40 dp | 40 dp |
| Text Field | 44 pt | 56 dp | 44 pt/dp |
| Switch | 51×31 pt | 52×32 dp | ~52×32 |
| Segmented Control | 32 pt | 48 dp | 32-48 |
| Slider thumb | 28 pt | 20 dp | 20-28 |
| Checkbox | — | 18×18 dp | 18 dp |
| Radio | — | 20×20 dp | 20 dp |
| List row | 44+ pt | 48-88 dp | 44 pt/dp |
| Nav Bar (top) | 44 pt | 64 dp | 44-64 |
| Tab Bar / Nav Bar (bottom) | 49 pt (83 w/home) | 80 dp | 49-80 |

---

## 9. Modals & Overlays

### 9.1 Modal Types Comparison

| Type | iOS | Android |
|------|-----|---------|
| **Alert** | Alert | Alert Dialog |
| **Confirmation** | Alert with actions | Confirmation Dialog |
| **Action List** | Action Sheet | Bottom Sheet |
| **Form/Task** | Sheet (Page/Form) | Full-screen Dialog / Bottom Sheet |
| **Info popup** | Popover (iPad) | Menu / Tooltip |

### 9.2 Sheets / Bottom Sheets

| Параметр | iOS Sheet | Android Bottom Sheet |
|----------|-----------|---------------------|
| **Corner radius** | ~10 pt (top) | 28 dp (top) |
| **Drag indicator** | 36×5 pt | 32×4 dp |
| **Detents** | Medium (~50%), Large | Collapsed, Half, Expanded |
| **Scrim** | Black translucent | Black 32% opacity |
| **Dismiss** | Swipe down | Swipe down, tap scrim |

### 9.3 Alerts / Dialogs

| Параметр | iOS Alert | Android Dialog |
|----------|-----------|----------------|
| **Width** | 270 pt | 280-560 dp |
| **Corner radius** | 14 pt | 28 dp |
| **Title size** | 17 pt Semibold | 24 sp |
| **Body size** | 13 pt | 14 sp |
| **Button height** | 44 pt | 40 dp |
| **Max buttons (inline)** | 2 | 2 |
| **Button alignment** | Horizontal | Horizontal (right-aligned) |

### 9.4 Snackbars / Toasts

| Параметр | iOS | Android |
|----------|-----|---------|
| **Component** | Нет системного (custom banner) | Snackbar |
| **Position** | Top (usually) | Bottom |
| **Height** | Varies | 48 dp (one-line) |
| **Duration** | Varies | 4-10 seconds |
| **Action** | Optional | Optional (one action) |

---

## 10. Icons

### 10.1 Icon Systems

| Платформа | System | Count | Format |
|-----------|--------|-------|--------|
| **iOS** | SF Symbols | 6,000+ | Vector, 9 weights, 3 scales |
| **Android** | Material Symbols | 3,000+ | Vector, 7 weights, 3 grades, fill |

### 10.2 Icon Sizes by Context

| Context | iOS | Android | Universal |
|---------|-----|---------|-----------|
| **Tab Bar** | 25-28 pt | 24 dp | **24-28 pt/dp** |
| **Navigation Bar** | 22-24 pt | 24 dp | **22-24 pt/dp** |
| **Toolbar** | 22-24 pt | 24 dp | **22-24 pt/dp** |
| **List row** | 20-24 pt | 24 dp | **20-24 pt/dp** |
| **Inline with text** | Match text size | Match text size | **Match text** |
| **FAB** | — | 24 dp | **24 dp** |

### 10.3 Icon Styles

| Context | iOS (SF Symbols) | Android (Material) |
|---------|------------------|-------------------|
| **Tab Bar (selected)** | Filled | Filled |
| **Tab Bar (unselected)** | Filled (lighter) | Outlined |
| **Toolbar** | Stroke/Outline | Outlined |
| **Navigation** | Stroke | Outlined |

### 10.4 App Icon Sizes

| Platform | App Icon | App Store/Play Store |
|----------|----------|---------------------|
| **iOS** | 60×60 pt (@2x: 120px, @3x: 180px) | 1024×1024 px |
| **Android** | 48×48 dp (xxxhdpi: 192px) | 512×512 px |

---

## 11. Motion & Animation

### 11.1 Duration Guidelines

| Animation Type | iOS | Android | Universal |
|----------------|-----|---------|-----------|
| **Quick feedback** | 0.1-0.15s | 50-100ms | **~100ms** |
| **Standard transition** | 0.25-0.35s | 200-300ms | **200-350ms** |
| **Complex/Emphasis** | 0.4-0.5s | 300-500ms | **300-500ms** |
| **Page transition** | 0.35s | 300ms | **300-350ms** |

### 11.2 Easing Curves

| Type | iOS | Android (M3) |
|------|-----|--------------|
| **Standard** | easeInOut | Emphasized (0.2, 0, 0, 1) |
| **Enter** | easeOut | Emphasized Decelerate |
| **Exit** | easeIn | Emphasized Accelerate |
| **Spring** | Spring animation | — |

### 11.3 Reduce Motion Support

Обе платформы требуют поддержки Reduce Motion:

| Платформа | Setting | Fallback |
|-----------|---------|----------|
| **iOS** | Reduce Motion | Crossfade instead of slide |
| **Android** | Remove Animations | Instant transitions |

> **Universal: Всегда проверять настройку Reduce Motion и упрощать анимации**

---

## 12. Dark Mode

### 12.1 Support Requirements

| Платформа | Introduced | Required |
|-----------|------------|----------|
| **iOS** | iOS 13 | Expected by users |
| **Android** | Android 10 | Expected by users |

### 12.2 Key Principles

| Principle | iOS | Android |
|-----------|-----|---------|
| **Don't invert** | ✅ | ✅ |
| **Use semantic colors** | ✅ | ✅ |
| **Elevation = lighter** | ✅ | ✅ (tonal surfaces) |
| **Reduce saturation** | Slightly | Yes (via tonal palette) |
| **Pure black background** | Sometimes (#000) | Base (#000 or near) |

### 12.3 Dark Mode Checklist (Universal)

- [ ] Semantic colors adapt automatically
- [ ] Images have light/dark variants where needed
- [ ] Sufficient contrast maintained
- [ ] Shadows adjusted (often reduced/removed)
- [ ] No inverted colors
- [ ] Test both modes

---

## 13. Platform Detection

### 13.1 Visual Indicators: iOS

| Indicator | Description |
|-----------|-------------|
| **Navigation Bar** | Centered title, translucent blur |
| **Tab Bar** | Translucent, no pill indicator |
| **Back button** | Chevron + text label |
| **Switches** | Green when on |
| **Corners** | Continuous (squircle) |
| **Typography** | SF Pro characteristics |
| **Status Bar** | Dynamic Island / Notch |
| **Sheets** | Rounded corners, drag indicator |

### 13.2 Visual Indicators: Android

| Indicator | Description |
|-----------|-------------|
| **Top App Bar** | Left-aligned title, solid/tonal |
| **Navigation Bar** | Pill indicator on selected |
| **FAB** | Floating Action Button present |
| **Back button** | Arrow icon only |
| **Switches** | Primary color when on, thumb icon |
| **Corners** | Circular or slight radius |
| **Typography** | Roboto characteristics |
| **Status Bar** | Notch or hole-punch |
| **Bottom Sheets** | Large corner radius (28dp) |

### 13.3 Detection Algorithm

```
IF (Tab Bar has translucent blur AND no pill indicator) → iOS
IF (FAB present OR Nav Bar has pill indicator) → Android
IF (Back button has text label) → iOS
IF (Switch is green when ON) → iOS
IF (Large corner radius ~28dp on sheets) → Android
IF (Dynamic Island visible) → iOS
```

---

## 14. Universal Checklist

### 14.1 Critical (Must Pass)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 1 | Touch targets | ≥44pt (iOS) / ≥48dp (Android) | 🔴 Critical |
| 2 | Touch spacing | ≥8 pt/dp between targets | 🔴 Critical |
| 3 | Text contrast | ≥4.5:1 (normal), ≥3:1 (large) | 🔴 Critical |
| 4 | UI contrast | ≥3:1 for components | 🔴 Critical |
| 5 | Minimum text | ≥11 pt/sp | 🔴 Critical |
| 6 | Safe areas | Content respects safe areas | 🔴 Critical |

### 14.2 Important (Should Pass)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 7 | Body text size | 14-17 pt/sp | 🟠 Important |
| 8 | Margins | 16 pt/dp minimum | 🟠 Important |
| 9 | Spacing grid | Multiples of 4 or 8 | 🟠 Important |
| 10 | Dynamic Type / Font Scale | Supported | 🟠 Important |
| 11 | Dark Mode | Both modes look correct | 🟠 Important |
| 12 | Color independence | Info not conveyed by color alone | 🟠 Important |

### 14.3 Recommended (Nice to Have)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 13 | Animation duration | 100-500ms | 🟡 Recommended |
| 14 | Reduce Motion | Alternative animations | 🟡 Recommended |
| 15 | Semantic colors | Using system colors | 🟡 Recommended |
| 16 | Platform consistency | Follows platform patterns | 🟡 Recommended |

---

## 15. Platform-Specific Checklist

### 15.1 iOS-Specific

| # | Criterion | Requirement |
|---|-----------|-------------|
| 1 | Tab Bar height | 49 pt (+34 pt with Home Indicator) |
| 2 | Navigation Bar | 44 pt (small) / 96 pt (large title) |
| 3 | Status Bar | 54 pt (Dynamic Island) |
| 4 | Home Indicator | 34 pt reserved |
| 5 | Touch target | ≥44×44 pt |
| 6 | Body text | 17 pt |
| 7 | Tab Bar labels | 10 pt |
| 8 | Switch | 51×31 pt, green when ON |
| 9 | SF Symbols | Used appropriately |
| 10 | Translucent bars | Navigation/Tab bars have blur |

### 15.2 Android-Specific

| # | Criterion | Requirement |
|---|-----------|-------------|
| 1 | Navigation Bar height | 80 dp |
| 2 | Top App Bar | 64 dp |
| 3 | Status Bar | 24 dp |
| 4 | Gesture handle | 20-24 dp |
| 5 | Touch target | ≥48×48 dp |
| 6 | Body text | 14-16 sp |
| 7 | Nav Bar labels | 12 sp |
| 8 | FAB | 56 dp (if present) |
| 9 | Material Symbols | Used appropriately |
| 10 | Baseline grid | 8 dp (4 dp for small) |
| 11 | Button height | 40 dp |
| 12 | Text Field height | 56 dp |
| 13 | Edge-to-edge | Content extends under system bars |

---

## 16. Evaluation Scoring

### 16.1 Scoring System

| Category | Weight | Max Points |
|----------|--------|------------|
| **Accessibility** | 30% | 30 |
| **Layout & Spacing** | 20% | 20 |
| **Typography** | 15% | 15 |
| **Components** | 15% | 15 |
| **Platform Compliance** | 10% | 10 |
| **Visual Polish** | 10% | 10 |
| **Total** | 100% | **100** |

### 16.2 Accessibility Scoring (30 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Touch targets | 10 | All ≥44/48 pt/dp |
| Touch spacing | 5 | All ≥8 pt/dp |
| Text contrast | 8 | All ≥4.5:1 |
| UI contrast | 4 | All ≥3:1 |
| Color independence | 3 | Not relying on color alone |

### 16.3 Layout & Spacing Scoring (20 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Safe areas | 6 | Properly respected |
| Margins | 5 | Consistent ≥16 pt/dp |
| Spacing grid | 5 | Multiples of 4/8 |
| Alignment | 4 | Elements properly aligned |

### 16.4 Typography Scoring (15 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Minimum size | 5 | ≥11 pt/sp |
| Hierarchy | 5 | Clear visual hierarchy |
| Consistency | 5 | Consistent text styles |

### 16.5 Components Scoring (15 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Correct sizes | 8 | Components match specs |
| Proper states | 4 | Hover, pressed, disabled |
| Consistency | 3 | Consistent styling |

### 16.6 Platform Compliance Scoring (10 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Navigation pattern | 4 | Follows platform norms |
| Component style | 3 | Platform-appropriate |
| Interaction patterns | 3 | Expected behaviors |

### 16.7 Visual Polish Scoring (10 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Dark Mode | 4 | Both modes correct |
| Animations | 3 | Appropriate durations |
| Overall aesthetics | 3 | Professional appearance |

### 16.8 Score Interpretation

| Score | Grade | Interpretation |
|-------|-------|----------------|
| 90-100 | A | Excellent, production ready |
| 80-89 | B | Good, minor improvements needed |
| 70-79 | C | Acceptable, several issues |
| 60-69 | D | Below standard, significant issues |
| <60 | F | Failing, major rework needed |

---

## 17. AI Evaluation Prompt Template

```markdown
## Design Evaluation Request

**Platform**: [iOS / Android / Cross-platform / Unknown]
**Screen Type**: [e.g., Login, Dashboard, Settings, List]
**Design File**: [attached]

### Evaluate against:
1. Universal requirements (touch targets, contrast, spacing)
2. Platform-specific requirements (if platform known)
3. Provide score breakdown by category
4. List specific issues with locations
5. Suggest fixes for each issue

### Output Format:
- Overall Score: X/100 (Grade)
- Category Scores
- Critical Issues (must fix)
- Important Issues (should fix)
- Recommendations (nice to have)
- Platform Compliance Notes
```

---

## 18. Quick Reference Card

### Universal Minimums

```
┌─────────────────────────────────────────────────────┐
│  UNIVERSAL DESIGN MINIMUMS                          │
├─────────────────────────────────────────────────────┤
│  Touch Target:     44-48 pt/dp                      │
│  Touch Spacing:    8 pt/dp                          │
│  Text Contrast:    4.5:1 (normal), 3:1 (large)      │
│  UI Contrast:      3:1                              │
│  Min Text Size:    11-12 pt/sp                      │
│  Body Text:        14-17 pt/sp                      │
│  Margins:          16 pt/dp                         │
│  Spacing Grid:     4 or 8 pt/dp increments          │
│  Button Height:    40-50 pt/dp                      │
│  List Row:         44-56 pt/dp                      │
│  Animation:        100-500ms                        │
└─────────────────────────────────────────────────────┘
```

### Platform Comparison

```
┌──────────────────┬──────────────┬──────────────────┐
│  Element         │  iOS         │  Android         │
├──────────────────┼──────────────┼──────────────────┤
│  Touch Target    │  44×44 pt    │  48×48 dp        │
│  Body Text       │  17 pt       │  14-16 sp        │
│  Nav Bar (top)   │  44-96 pt    │  64 dp           │
│  Tab/Nav (btm)   │  49-83 pt    │  80 dp           │
│  Button          │  44-50 pt    │  40 dp           │
│  Text Field      │  44 pt       │  56 dp           │
│  Switch          │  51×31 pt    │  52×32 dp        │
│  FAB             │  —           │  56 dp           │
│  Card Radius     │  10-16 pt    │  12 dp           │
│  Sheet Radius    │  ~10 pt      │  28 dp           │
│  System Font     │  SF Pro      │  Roboto          │
│  Icon System     │  SF Symbols  │  Material Symbols│
└──────────────────┴──────────────┴──────────────────┘
```

---

## Версия документа

| Параметр | Значение |
|----------|----------|
| Версия | 1.0 |
| Дата создания | 2025-02 |
| Источники | Apple HIG, Material Design 3, Android Design Guidelines |
| Назначение | Кросс-платформенная AI-оценка дизайн-макетов |

---

## Связанные документы

1. `material-design-3-guidelines.md` — Полный гайд Material Design 3
2. `android-design-guidelines.md` — Android-специфичные рекомендации
3. `ios-human-interface-guidelines.md` — Apple iOS HIG

> **Использование**: Этот документ служит единой точкой входа для AI-оценки.
> Для детальных спецификаций обращаться к platform-specific документам.
