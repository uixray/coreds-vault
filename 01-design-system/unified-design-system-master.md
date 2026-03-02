---
title: "Unified Design System Master"
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
description: "Master reference for unified cross-platform design system architecture"
---

# Unified Design System
## Master Reference for AI-Driven Design Evaluation

> **Версия**: 2.0 | **Дата**: 2025-02
> **Платформы**: iOS, Android, Web
> **Назначение**: Единый референс для AI-оценки дизайн-макетов всех платформ

---

## Навигация по документу

| Раздел | Содержание |
|--------|------------|
| [1. Quick Reference](#1-quick-reference) | Универсальные минимумы |
| [2. Platform Comparison](#2-platform-comparison) | Сравнительные таблицы |
| [3. Units & Measurements](#3-units--measurements) | Единицы измерения |
| [4. Accessibility](#4-accessibility) | Доступность (WCAG) |
| [5. Typography](#5-typography) | Типографика |
| [6. Color System](#6-color-system) | Цветовая система |
| [7. Layout & Grid](#7-layout--grid) | Сетка и макет |
| [8. Components](#8-components) | Компоненты |
| [9. Navigation](#9-navigation) | Навигация |
| [10. Motion](#10-motion) | Анимация |
| [11. Scoring System](#11-scoring-system) | Система оценки |
| [12. AI Evaluation](#12-ai-evaluation) | Промпты для AI |

---

## Связанные документы

| Документ | Платформа | Размер |
|----------|-----------|--------|
| `ios-human-interface-guidelines.md` | iOS | ~27K |
| `android-design-guidelines.md` | Android | ~30K |
| `web-design-guidelines.md` | Web | ~50K |
| `cross-platform-design-system.md` | iOS + Android | ~32K |

---

# 1. Quick Reference

## 1.1 Universal Minimums

```
┌─────────────────────────────────────────────────────────────────┐
│  UNIVERSAL DESIGN MINIMUMS — ВСЕ ПЛАТФОРМЫ                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ACCESSIBILITY (Доступность)                                   │
│  ├─ Text contrast (normal):     ≥4.5:1                          │
│  ├─ Text contrast (large):      ≥3:1                            │
│  ├─ UI component contrast:      ≥3:1                            │
│  ├─ Touch target minimum:       ≥44×44 (iOS pt / Web px)        │
│  │                              ≥48×48 (Android dp)             │
│  └─ Touch spacing:              ≥8 (all platforms)              │
│                                                                 │
│  TYPOGRAPHY (Типографика)                                       │
│  ├─ Body text minimum:          ≥16 (all platforms)             │
│  ├─ Absolute minimum:           ≥11 (caption/legal text)        │
│  ├─ Line height (body):         1.4-1.6                         │
│  └─ Line length (web):          45-75 characters                │
│                                                                 │
│  LAYOUT (Макет)                                                 │
│  ├─ Page margins (mobile):      16                              │
│  ├─ Component spacing:          8, 16, 24 (scale)               │
│  └─ Grid base:                  8 (all platforms)               │
│                                                                 │
│  COMPONENTS (Компоненты)                                        │
│  ├─ Button height:              ≥40 (desktop), ≥44 (mobile)     │
│  ├─ Input height:               ≥44 (mobile), ≥40 (desktop)     │
│  ├─ Input font (mobile):        16px (prevents iOS zoom)        │
│  └─ Icon size (touch):          24 minimum                      │
│                                                                 │
│  ANIMATION (Анимация)                                           │
│  ├─ Micro-interactions:         100-200ms                       │
│  ├─ Standard transitions:       200-400ms                       │
│  ├─ Complex animations:         ≤500ms                          │
│  └─ Reduce motion:              ОБЯЗАТЕЛЬНО поддерживать        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 1.2 Platform-Specific Minimums

| Metric | iOS (pt) | Android (dp) | Web (px) |
|--------|----------|--------------|----------|
| **Touch target** | 44×44 | 48×48 | 44×44 |
| **Body font** | 17 | 14-16 | 16 |
| **Button height** | 44-50 | 40 | 40-48 |
| **Nav bar height** | 44-96 | 64 | 56-80 |
| **Tab bar height** | 49-83 | 80 | 40-48 |
| **Input height** | 34-44 | 56 | 40-48 |
| **Icon size** | 22-28 | 24 | 20-24 |
| **Side margins** | 16 | 16 | 16-32 |

---

# 2. Platform Comparison

## 2.1 Design Philosophy

| Aspect | iOS | Android (M3) | Web |
|--------|-----|--------------|-----|
| **Philosophy** | Clarity, Deference, Depth | Material metaphor, Surfaces | Responsive, Accessible |
| **Visual style** | Flat with blur effects | Layered surfaces, elevation | Flexible, content-first |
| **Color system** | System colors + tints | Dynamic Color, Tonal palettes | CSS variables, theming |
| **Typography** | SF Pro (system) | Roboto (system) | System fonts / Web fonts |
| **Motion** | Spring physics | Emphasized/Standard easing | CSS transitions |
| **Iconography** | SF Symbols | Material Symbols | SVG, icon fonts |

## 2.2 Component Comparison

### Buttons

| Property | iOS | Android | Web |
|----------|-----|---------|-----|
| **Height** | 44-50 pt | 40 dp | 40-56 px |
| **Corner radius** | 10-14 pt | 20 dp (full) | 4-8 px |
| **Min width** | — | 48 dp | 88 px |
| **Primary style** | Filled/Tinted | Filled | Filled |
| **Secondary style** | Gray/Tinted | Outlined/Tonal | Outlined |
| **Tertiary style** | Plain text | Text | Ghost/Text |

### Navigation

| Component | iOS | Android | Web |
|-----------|-----|---------|-----|
| **Top bar name** | Navigation Bar | Top App Bar | Header/Navbar |
| **Top bar height** | 44-96 pt | 64 dp | 56-80 px |
| **Bottom bar name** | Tab Bar | Navigation Bar | Tab Bar/Bottom Nav |
| **Bottom bar height** | 49-83 pt | 80 dp | 56-64 px |
| **Drawer** | — (Sheet) | Navigation Drawer | Sidebar/Drawer |
| **Back action** | Swipe + Button | System gesture + Button | Button only |

### Input Fields

| Property | iOS | Android | Web |
|----------|-----|---------|-----|
| **Height** | 34-44 pt | 56 dp | 40-48 px |
| **Style** | Rounded rect | Outlined/Filled | Various |
| **Label position** | Placeholder | Floating label | Above/Floating |
| **Corner radius** | 10 pt | 4 dp | 4-8 px |
| **Font size** | 17 pt | 16 sp | 16 px |

### Cards

| Property | iOS | Android | Web |
|----------|-----|---------|-----|
| **Corner radius** | 10-16 pt | 12 dp | 8-16 px |
| **Padding** | 16 pt | 16 dp | 16-24 px |
| **Elevation** | Shadow | 1-3 levels | Shadow |
| **Border** | None | None/1dp | Optional |

## 2.3 Spacing Systems

### iOS Spacing

| Token | Value | Use |
|-------|-------|-----|
| Compact | 4 pt | Tight inline spacing |
| Standard | 8 pt | Default spacing |
| Medium | 12 pt | Related groups |
| Large | 16 pt | Section margins |
| XL | 20-24 pt | Major sections |

### Android Spacing (Material 3)

| Token | Value | Use |
|-------|-------|-----|
| space-0 | 0 dp | — |
| space-1 | 4 dp | Inline |
| space-2 | 8 dp | Tight |
| space-3 | 12 dp | Compact |
| space-4 | 16 dp | Standard |
| space-5 | 24 dp | Comfortable |
| space-6 | 32 dp | Large |
| space-7 | 48 dp | Section |

### Web Spacing

| Token | Value | Use |
|-------|-------|-----|
| space-1 | 4 px | Inline |
| space-2 | 8 px | Component internal |
| space-3 | 12 px | Compact |
| space-4 | 16 px | Standard |
| space-5 | 24 px | Between components |
| space-6 | 32 px | Large |
| space-8 | 48 px | Section |
| space-9 | 64 px | Major section |

---

# 3. Units & Measurements

## 3.1 Unit Conversion

| Platform | Unit | Base | Conversion |
|----------|------|------|------------|
| **iOS** | pt (points) | 1pt = 1pt | @2x: 1pt = 2px, @3x: 1pt = 3px |
| **Android** | dp (density-independent pixels) | 1dp ≈ 1/160 inch | 160dpi: 1dp = 1px |
| **Web** | px (CSS pixels) | varies | rem = px/16 |

## 3.2 Practical Equivalence

```
При стандартных условиях:
1 pt (iOS) ≈ 1 dp (Android) ≈ 1 px (Web @1x)

Но помните:
- iOS @3x: 1pt = 3 физических пикселя
- Android xxhdpi: 1dp = 3 физических пикселя
- Web: зависит от device pixel ratio
```

## 3.3 Recommended Units by Context

| Context | iOS | Android | Web |
|---------|-----|---------|-----|
| Font sizes | pt | sp | rem |
| Spacing | pt | dp | rem, px |
| Borders | pt | dp | px |
| Icons | pt | dp | px, rem |
| Border radius | pt | dp | px, rem |

---

# 4. Accessibility

## 4.1 WCAG 2.2 Requirements

| Criterion | Level | Requirement |
|-----------|-------|-------------|
| **1.4.3 Contrast (Minimum)** | AA | Text ≥4.5:1, Large ≥3:1 |
| **1.4.6 Contrast (Enhanced)** | AAA | Text ≥7:1, Large ≥4.5:1 |
| **1.4.11 Non-text Contrast** | AA | UI components ≥3:1 |
| **2.4.7 Focus Visible** | AA | Clear focus indicators |
| **2.5.5 Target Size** | AAA | ≥44×44 CSS px |
| **2.5.8 Target Size (Minimum)** | AA | ≥24×24 CSS px |

## 4.2 Touch Target Requirements

| Platform | Standard | Requirement | Spacing |
|----------|----------|-------------|---------|
| **iOS** | Apple HIG | 44×44 pt | 8 pt min |
| **Android** | Material 3 | 48×48 dp | 8 dp min |
| **Web** | WCAG 2.2 AA | 24×24 px min | 8 px min |
| **Web** | Best Practice | 44×44 px | 8 px min |

## 4.3 Color Contrast Table

| Foreground | Background | Ratio | Pass AA Text | Pass AA Large | Pass UI |
|------------|------------|-------|--------------|---------------|---------|
| #000000 | #FFFFFF | 21:1 | ✅ | ✅ | ✅ |
| #212121 | #FFFFFF | 16.1:1 | ✅ | ✅ | ✅ |
| #616161 | #FFFFFF | 5.9:1 | ✅ | ✅ | ✅ |
| #757575 | #FFFFFF | 4.6:1 | ✅ | ✅ | ✅ |
| #9E9E9E | #FFFFFF | 3.5:1 | ❌ | ✅ | ✅ |
| #BDBDBD | #FFFFFF | 2.2:1 | ❌ | ❌ | ❌ |

## 4.4 Accessibility Checklist

| # | Requirement | iOS | Android | Web | Priority |
|---|-------------|-----|---------|-----|----------|
| 1 | Text contrast ≥4.5:1 | ✓ | ✓ | ✓ | 🔴 Critical |
| 2 | UI contrast ≥3:1 | ✓ | ✓ | ✓ | 🔴 Critical |
| 3 | Touch targets ≥44pt/48dp/44px | ✓ | ✓ | ✓ | 🔴 Critical |
| 4 | VoiceOver/TalkBack labels | ✓ | ✓ | — | 🔴 Critical |
| 5 | Keyboard accessible | — | — | ✓ | 🔴 Critical |
| 6 | Focus visible | ✓ | ✓ | ✓ | 🔴 Critical |
| 7 | Dynamic Type support | ✓ | — | — | 🟠 Important |
| 8 | Text scalable to 200% | — | — | ✓ | 🟠 Important |
| 9 | Reduce motion support | ✓ | ✓ | ✓ | 🟠 Important |
| 10 | Color independence | ✓ | ✓ | ✓ | 🟠 Important |

---

# 5. Typography

## 5.1 Type Scales Comparison

### iOS (SF Pro)

| Style | Size | Weight | Leading |
|-------|------|--------|---------|
| Large Title | 34 pt | Bold | 41 pt |
| Title 1 | 28 pt | Bold | 34 pt |
| Title 2 | 22 pt | Bold | 28 pt |
| Title 3 | 20 pt | Semibold | 25 pt |
| Headline | 17 pt | Semibold | 22 pt |
| Body | 17 pt | Regular | 22 pt |
| Callout | 16 pt | Regular | 21 pt |
| Subhead | 15 pt | Regular | 20 pt |
| Footnote | 13 pt | Regular | 18 pt |
| Caption 1 | 12 pt | Regular | 16 pt |
| Caption 2 | 11 pt | Regular | 13 pt |

### Android (Material 3)

| Style | Size | Weight | Line Height |
|-------|------|--------|-------------|
| Display Large | 57 sp | Regular | 64 sp |
| Display Medium | 45 sp | Regular | 52 sp |
| Display Small | 36 sp | Regular | 44 sp |
| Headline Large | 32 sp | Regular | 40 sp |
| Headline Medium | 28 sp | Regular | 36 sp |
| Headline Small | 24 sp | Regular | 32 sp |
| Title Large | 22 sp | Regular | 28 sp |
| Title Medium | 16 sp | Medium | 24 sp |
| Title Small | 14 sp | Medium | 20 sp |
| Body Large | 16 sp | Regular | 24 sp |
| Body Medium | 14 sp | Regular | 20 sp |
| Body Small | 12 sp | Regular | 16 sp |
| Label Large | 14 sp | Medium | 20 sp |
| Label Medium | 12 sp | Medium | 16 sp |
| Label Small | 11 sp | Medium | 16 sp |

### Web

| Style | Size (px) | Size (rem) | Line Height |
|-------|-----------|------------|-------------|
| Display 1 | 72 | 4.5 | 1.1 |
| H1 | 48 | 3 | 1.2 |
| H2 | 36 | 2.25 | 1.2 |
| H3 | 30 | 1.875 | 1.3 |
| H4 | 24 | 1.5 | 1.3 |
| H5 | 20 | 1.25 | 1.4 |
| H6 | 18 | 1.125 | 1.4 |
| Body | 16 | 1 | 1.5 |
| Small | 14 | 0.875 | 1.5 |
| Caption | 12 | 0.75 | 1.4 |

## 5.2 Typography Rules

| Rule | iOS | Android | Web |
|------|-----|---------|-----|
| **Min body size** | 17 pt | 14 sp | 16 px |
| **Absolute minimum** | 11 pt | 11 sp | 11 px |
| **Line height (body)** | 1.3 | 1.4-1.5 | 1.5-1.6 |
| **Line length** | — | — | 45-75 chars |
| **Font weights used** | 2-3 | 2-3 | 2-3 |

---

# 6. Color System

## 6.1 Semantic Color Roles

| Role | Description | iOS | Android | Web |
|------|-------------|-----|---------|-----|
| **Primary** | Brand, main actions | System Blue | Primary | Primary |
| **Secondary** | Complementary | — | Secondary | Secondary |
| **Tertiary** | Accents | — | Tertiary | Accent |
| **Error** | Errors, destructive | System Red | Error | Error (#D32F2F) |
| **Success** | Positive states | System Green | — | Success (#388E3C) |
| **Warning** | Caution | System Yellow | — | Warning (#F57C00) |

## 6.2 Background Colors

| Context | iOS Light | iOS Dark | Android Light | Android Dark | Web Light | Web Dark |
|---------|-----------|----------|---------------|--------------|-----------|----------|
| **Primary BG** | #FFFFFF | #000000 | #FFFBFE | #1C1B1F | #FFFFFF | #121212 |
| **Secondary BG** | #F2F2F7 | #1C1C1E | #E6E0E9 | #2B2930 | #F5F5F5 | #1E1E1E |
| **Elevated** | #FFFFFF | #1C1C1E | Surface + tint | Surface + tint | Shadow | #2D2D2D |

## 6.3 Text Colors

| Context | iOS Light | iOS Dark | Android | Web |
|---------|-----------|----------|---------|-----|
| **Primary text** | #000000 (100%) | #FFFFFF (100%) | #1C1B1F | #212121 |
| **Secondary text** | 60% opacity | 60% opacity | On-surface-variant | #666666 |
| **Tertiary text** | 30% opacity | 30% opacity | — | #9E9E9E |
| **Disabled** | 20% opacity | 20% opacity | 38% opacity | 38% opacity |

---

# 7. Layout & Grid

## 7.1 Screen Size Categories

### iOS

| Category | Width (pt) | Example |
|----------|------------|---------|
| Compact | <390 | iPhone SE |
| Regular | 390-430 | iPhone 14-16 |
| Large | >430 | iPhone Pro Max, iPad |

### Android

| Window Class | Width (dp) | Example |
|--------------|------------|---------|
| Compact | <600 | Phone portrait |
| Medium | 600-839 | Tablet portrait, Foldable |
| Expanded | ≥840 | Tablet landscape |

### Web

| Breakpoint | Width (px) | Columns |
|------------|------------|---------|
| XS | <576 | 4 |
| SM | ≥576 | 4 |
| MD | ≥768 | 8 |
| LG | ≥992 | 12 |
| XL | ≥1200 | 12 |
| XXL | ≥1400 | 12 |

## 7.2 Grid Systems

| Platform | Columns | Gutter | Margins |
|----------|---------|--------|---------|
| **iOS (Phone)** | Flexible | 8-16 pt | 16 pt |
| **iOS (Tablet)** | 4-6 | 16-20 pt | 20 pt |
| **Android (Compact)** | 4 | 16 dp | 16 dp |
| **Android (Medium)** | 8 | 24 dp | 24 dp |
| **Android (Expanded)** | 12 | 24 dp | 24 dp |
| **Web (Mobile)** | 4 | 16 px | 16 px |
| **Web (Tablet)** | 8 | 24 px | 24 px |
| **Web (Desktop)** | 12 | 24-32 px | 32 px |

## 7.3 Safe Areas

### iOS

| Area | Portrait | Landscape |
|------|----------|-----------|
| **Top (Dynamic Island)** | 59 pt | 0 pt |
| **Top (Notch)** | 47 pt | 0 pt |
| **Bottom (Home Indicator)** | 34 pt | 21 pt |
| **Left/Right** | 0 pt | 59 pt |

### Android

| Area | Value |
|------|-------|
| **Status bar** | ~24 dp |
| **Navigation bar (gesture)** | ~24 dp |
| **Navigation bar (buttons)** | ~48 dp |
| **Gesture insets** | 20-24 dp from edges |

---

# 8. Components

## 8.1 Buttons

### Size Comparison

| Size | iOS | Android | Web |
|------|-----|---------|-----|
| **Small** | 32 pt | 32 dp | 32 px |
| **Medium** | 44 pt | 40 dp | 40-44 px |
| **Large** | 50 pt | 56 dp | 48-56 px |

### States

| State | All Platforms |
|-------|---------------|
| **Default** | Base appearance |
| **Hover** | Subtle highlight (web/desktop) |
| **Pressed** | Darker/opacity change |
| **Focused** | Focus ring/outline |
| **Disabled** | 30-50% opacity |
| **Loading** | Spinner/progress |

## 8.2 Input Fields

| Property | iOS | Android | Web |
|----------|-----|---------|-----|
| **Height** | 34-44 pt | 56 dp | 40-48 px |
| **Font size** | 17 pt | 16 sp | 16 px |
| **Label** | Placeholder | Floating | Above |
| **Border radius** | 10 pt | 4 dp | 4-8 px |
| **Padding** | 8-12 pt | 16 dp | 12-16 px |

## 8.3 Cards

| Property | iOS | Android | Web |
|----------|-----|---------|-----|
| **Corner radius** | 10-16 pt | 12 dp | 8-16 px |
| **Padding** | 16 pt | 16 dp | 16-24 px |
| **Elevation** | Shadow | 1-3 levels | Shadow |
| **Gap between** | 8-16 pt | 8 dp | 16-24 px |

## 8.4 Lists

| Property | iOS | Android | Web |
|----------|-----|---------|-----|
| **Row height (min)** | 44 pt | 56 dp | 48 px |
| **Row height (standard)** | 44-88 pt | 72-88 dp | 48-72 px |
| **Separator** | Inset line | None/Divider | Line |
| **Padding horizontal** | 16 pt | 16 dp | 16-24 px |
| **Padding vertical** | 8-12 pt | 12-16 dp | 12-16 px |

---

# 9. Navigation

## 9.1 Top Navigation

| Component | iOS | Android | Web |
|-----------|-----|---------|-----|
| **Name** | Navigation Bar | Top App Bar | Header/Navbar |
| **Height (standard)** | 44 pt | 64 dp | 56-80 px |
| **Height (large title)** | 96 pt | — | — |
| **Title alignment** | Center | Left | Left/Center |
| **Leading element** | Back button | Nav icon/Back | Logo/Nav |
| **Trailing elements** | Actions (1-3) | Actions (1-3) | Actions + Menu |

## 9.2 Bottom Navigation

| Component | iOS | Android | Web |
|-----------|-----|---------|-----|
| **Name** | Tab Bar | Navigation Bar | Bottom Nav |
| **Height** | 49-83 pt | 80 dp | 56-64 px |
| **Items** | 2-5 | 3-5 | 3-5 |
| **Icon size** | 22-28 pt | 24 dp | 24 px |
| **Label** | Always | Always/Selected | Optional |

## 9.3 Side Navigation

| Component | iOS | Android | Web |
|-----------|-----|---------|-----|
| **Name** | — (use Sheet) | Navigation Drawer | Sidebar |
| **Width (collapsed)** | — | 72 dp | 64-72 px |
| **Width (expanded)** | — | 360 dp | 200-280 px |
| **Item height** | — | 56 dp | 40-48 px |

---

# 10. Motion

## 10.1 Duration Guidelines

| Animation Type | iOS | Android | Web |
|----------------|-----|---------|-----|
| **Micro-interaction** | 100-200ms | 50-200ms | 100-200ms |
| **Enter/Exit** | 200-350ms | 200-400ms | 200-300ms |
| **Page transition** | 350-450ms | 300-400ms | 300-500ms |
| **Complex** | 350-500ms | 300-500ms | 400-600ms |

## 10.2 Easing Functions

| Type | iOS | Android | Web |
|------|-----|---------|-----|
| **Default** | Spring | Emphasized | ease |
| **Enter** | Spring (underdamped) | Emphasized decelerate | ease-out |
| **Exit** | Spring (overdamped) | Emphasized accelerate | ease-in |
| **Linear** | Linear | Linear | linear |

### CSS Easing Examples

```css
/* iOS-like spring (approximation) */
transition: transform 350ms cubic-bezier(0.175, 0.885, 0.32, 1.275);

/* Material emphasized */
transition: transform 300ms cubic-bezier(0.2, 0, 0, 1);

/* Standard web */
transition: all 200ms ease;
```

## 10.3 Reduce Motion

| Platform | API | Fallback |
|----------|-----|----------|
| **iOS** | UIAccessibility.isReduceMotionEnabled | Crossfade |
| **Android** | Settings.Global.ANIMATOR_DURATION_SCALE | Instant |
| **Web** | prefers-reduced-motion: reduce | Minimal/none |

---

# 11. Scoring System

## 11.1 Unified Scoring (100 points)

| Category | Weight | Points |
|----------|--------|--------|
| **Accessibility** | 35% | 35 |
| **Typography** | 15% | 15 |
| **Layout & Spacing** | 20% | 20 |
| **Components** | 15% | 15 |
| **Visual Polish** | 10% | 10 |
| **Performance** | 5% | 5 |
| **Total** | 100% | **100** |

## 11.2 Accessibility Breakdown (35 points)

| Criterion | Points | Requirement |
|-----------|--------|-------------|
| Text contrast | 10 | ≥4.5:1 for all text |
| UI contrast | 5 | ≥3:1 for UI components |
| Touch targets | 8 | ≥44pt/48dp/44px |
| Keyboard/Focus | 5 | All elements reachable |
| Labels | 4 | All inputs labeled |
| Color independence | 3 | Not relying on color alone |

## 11.3 Typography Breakdown (15 points)

| Criterion | Points | Requirement |
|-----------|--------|-------------|
| Size hierarchy | 5 | Clear visual hierarchy |
| Readability | 4 | Correct line height |
| Font weights | 3 | 2-3 weights used well |
| Consistency | 3 | Type scale followed |

## 11.4 Layout Breakdown (20 points)

| Criterion | Points | Requirement |
|-----------|--------|-------------|
| Grid alignment | 5 | Elements on grid |
| Spacing consistency | 5 | Using spacing scale |
| Responsive | 5 | Works all sizes |
| Safe areas | 5 | Respects platform insets |

## 11.5 Components Breakdown (15 points)

| Criterion | Points | Requirement |
|-----------|--------|-------------|
| Correct sizes | 5 | Per platform specs |
| States | 5 | All states designed |
| Platform native | 5 | Uses correct patterns |

## 11.6 Visual Polish Breakdown (10 points)

| Criterion | Points | Requirement |
|-----------|--------|-------------|
| Color consistency | 3 | Using color system |
| Elevation/Depth | 3 | Proper layering |
| Icons/Assets | 2 | Consistent style |
| Dark mode | 2 | Proper implementation |

## 11.7 Score Interpretation

| Score | Grade | Description |
|-------|-------|-------------|
| 90-100 | A | Excellent, production ready |
| 80-89 | B | Good, minor improvements |
| 70-79 | C | Acceptable, several issues |
| 60-69 | D | Below standard, significant issues |
| <60 | F | Failing, major rework needed |

---

# 12. AI Evaluation

## 12.1 Platform Detection

```markdown
IDENTIFY PLATFORM by visual indicators:

iOS indicators:
- SF Pro typography
- Blue tint system colors
- Tab Bar at bottom (49-83pt)
- Navigation Bar with centered title
- Large Title style headers
- SF Symbols iconography
- Rounded rect buttons
- No FAB

Android indicators:
- Roboto typography
- Material You colors
- Navigation Bar at bottom (80dp)
- Top App Bar with left-aligned title
- FAB (Floating Action Button)
- Material Symbols iconography
- Pill-shaped buttons
- Dynamic Color

Web indicators:
- Custom typography (Inter, etc.)
- Full-width layouts
- Header with logo
- Sidebar navigation
- Card-based layouts
- Hover states designed
```

## 12.2 Evaluation Prompt Template

```markdown
## Design Evaluation Request

**Platform**: [iOS / Android / Web / Cross-platform]
**Design Type**: [App Screen / Website / Dashboard / etc.]
**File**: [attached]

### Evaluate against:

1. **Accessibility (35 points)**
   - Check text contrast ratios (≥4.5:1)
   - Verify touch targets (iOS: 44pt, Android: 48dp, Web: 44px)
   - Ensure UI component contrast (≥3:1)

2. **Typography (15 points)**
   - Verify type scale compliance
   - Check line heights and spacing
   - Ensure readability (min sizes)

3. **Layout (20 points)**
   - Check grid alignment
   - Verify spacing consistency
   - Confirm safe area compliance

4. **Components (15 points)**
   - Verify component sizes
   - Check all states (hover, pressed, disabled)
   - Confirm platform-native patterns

5. **Visual Polish (10 points)**
   - Color system consistency
   - Proper elevation/shadows
   - Dark mode support

6. **Performance (5 points)**
   - Image optimization
   - Font loading strategy

### Output Format:
- Overall Score: X/100 (Grade)
- Category Breakdown
- Critical Issues (must fix)
- Recommendations
- Platform Compliance Notes
```

## 12.3 Quick Validation Checklist

```markdown
□ Text contrast ≥4.5:1
□ UI contrast ≥3:1
□ Touch targets ≥44pt/48dp/44px
□ Body text ≥16-17
□ Min text ≥11
□ Line height 1.4-1.6
□ Safe areas respected
□ Spacing from scale (8px base)
□ Grid alignment
□ All states designed
□ Platform patterns followed
□ Color system used
□ Dark mode ready
```

---

# Appendix A: Color Contrast Calculator

```
Formula: (L1 + 0.05) / (L2 + 0.05)

Where L1 = lighter color luminance
      L2 = darker color luminance

Common ratios needed:
- Normal text: 4.5:1 (AA), 7:1 (AAA)
- Large text: 3:1 (AA), 4.5:1 (AAA)
- UI components: 3:1 (AA)

Online tools:
- WebAIM Contrast Checker
- Figma Contrast plugin
- Stark (Figma/Sketch)
```

---

# Appendix B: Unit Converter

```
iOS to Android:
1 pt ≈ 1 dp

iOS to Web:
1 pt ≈ 1 px (at standard density)

Android to Web:
1 dp ≈ 1 px (at standard density)

Font units:
iOS: pt
Android: sp (scales with system font size)
Web: px, rem (1rem = 16px default)
```

---

# Appendix C: Quick Reference Cards

## Card 1: Touch Targets

```
┌────────────────────────────────────┐
│  TOUCH TARGETS                     │
├────────────────────────────────────┤
│  iOS:      44×44 pt minimum        │
│  Android:  48×48 dp minimum        │
│  Web:      44×44 px recommended    │
│            24×24 px WCAG AA min    │
│  Spacing:  8px minimum between     │
└────────────────────────────────────┘
```

## Card 2: Typography Minimums

```
┌────────────────────────────────────┐
│  TYPOGRAPHY MINIMUMS               │
├────────────────────────────────────┤
│  Body text:      ≥16-17            │
│  Secondary:      ≥14               │
│  Caption:        ≥11-12            │
│  Absolute min:   ≥11               │
│  Line height:    1.4-1.6           │
│  Line length:    45-75 chars (web) │
└────────────────────────────────────┘
```

## Card 3: Contrast Ratios

```
┌────────────────────────────────────┐
│  CONTRAST RATIOS (WCAG AA)         │
├────────────────────────────────────┤
│  Normal text:    ≥4.5:1            │
│  Large text:     ≥3:1              │
│  UI components:  ≥3:1              │
│  Focus rings:    ≥3:1              │
│  Icons:          ≥3:1              │
└────────────────────────────────────┘
```

## Card 4: Component Heights

```
┌────────────────────────────────────┐
│  COMPONENT HEIGHTS                 │
├────────────────────────────────────┤
│           iOS     Android   Web    │
│  Button   44pt    40dp     40-48px │
│  Input    34-44pt 56dp     40-48px │
│  List row 44pt    56dp     48px    │
│  Top nav  44-96pt 64dp     56-80px │
│  Tab bar  49-83pt 80dp     56-64px │
└────────────────────────────────────┘
```

---

## Версия документа

| Параметр | Значение |
|----------|----------|
| Версия | 2.0 |
| Дата | 2025-02 |
| Автор | AI-generated |
| Платформы | iOS 17-18, Android 14-15, Web (WCAG 2.2) |
| Источники | Apple HIG, Material Design 3, WCAG 2.2, MDN |

---

**END OF DOCUMENT**
