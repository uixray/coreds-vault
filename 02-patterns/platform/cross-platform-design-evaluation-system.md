---
title: "Cross-Platform Design Evaluation System"
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
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "System for evaluating and comparing cross-platform UI/UX design decisions"
category: "platform"
---

# Cross-Platform Design Evaluation System
## Unified AI-Driven Assessment Framework

> Объединяет: iOS Human Interface Guidelines + Material Design 3 + Android Design Guidelines
> Версия: 1.0 | Февраль 2025
> Назначение: AI-оценка мобильных дизайн-макетов для iOS и Android

---

## 1. System Overview (Обзор системы)

### 1.1 Цель документа

Этот документ предоставляет **единую систему оценки** дизайн-макетов для:
- Валидации соответствия платформенным гайдлайнам
- Выявления несоответствий между iOS и Android версиями
- Обеспечения консистентности кросс-платформенного дизайна
- Автоматизированной проверки через AI

### 1.2 Структура оценки

```
┌─────────────────────────────────────────────────────────────┐
│                    CROSS-PLATFORM BASELINE                  │
│         (Общие требования для обеих платформ)               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────┐     ┌─────────────────────┐       │
│  │      iOS Layer      │     │    Android Layer    │       │
│  │  (Apple HIG specs)  │     │   (MD3 + Android)   │       │
│  └─────────────────────┘     └─────────────────────┘       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                   PLATFORM DELTA ANALYSIS                   │
│           (Различия, требующие адаптации)                   │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 Приоритеты оценки

| Уровень | Категория | Влияние |
|---------|-----------|---------|
| 🔴 **Critical** | Accessibility, Touch Targets | Блокирующие ошибки |
| 🟠 **High** | Navigation, Typography | Серьёзные проблемы UX |
| 🟡 **Medium** | Colors, Spacing | Заметные несоответствия |
| 🟢 **Low** | Animations, Effects | Косметические улучшения |

---

## 2. Universal Requirements (Общие требования)

### 2.1 Touch Targets — CRITICAL

| Параметр | iOS | Android | **Cross-Platform Minimum** |
|----------|-----|---------|---------------------------|
| Minimum touch target | 44×44 pt | 48×48 dp | **48×48** (используем больший) |
| Spacing between targets | 8 pt | 8 dp | **8** |
| Touch target для иконок | 44×44 pt | 48×48 dp | **48×48** |

**Правило:** Всегда использовать **больший** из двух стандартов = **48×48**.

```
┌─────────────────────────────────────────┐
│  TOUCH TARGET VALIDATION                │
│                                         │
│  ✓ Width ≥ 48                          │
│  ✓ Height ≥ 48                         │
│  ✓ Spacing to adjacent target ≥ 8      │
│                                         │
│  Visual size может быть меньше,        │
│  но tap area должен соответствовать    │
└─────────────────────────────────────────┘
```

### 2.2 Text Contrast — CRITICAL

| Контент | iOS | Android | **Cross-Platform** |
|---------|-----|---------|-------------------|
| Normal text | 4.5:1 | 4.5:1 | **4.5:1** |
| Large text (≥18pt/24dp bold) | 3:1 | 3:1 | **3:1** |
| UI components, icons | 3:1 | 3:1 | **3:1** |
| Enhanced accessibility | 7:1 | 7:1 | **7:1** |

**WCAG 2.1 AA** — обязательный стандарт для обеих платформ.

### 2.3 Minimum Text Sizes

| Элемент | iOS | Android | **Cross-Platform** |
|---------|-----|---------|-------------------|
| Absolute minimum | 11 pt | 12 sp | **12** |
| Body text default | 17 pt | 16 sp | **16-17** |
| Caption/label minimum | 11-12 pt | 11-12 sp | **12** |

### 2.4 Accessibility Features Support

| Feature | iOS | Android | Требование |
|---------|-----|---------|------------|
| Screen reader | VoiceOver | TalkBack | **Обязательно** |
| Dynamic text scaling | Dynamic Type | Font scaling | **Обязательно** |
| Reduce motion | Reduce Motion | Remove animations | **Обязательно** |
| High contrast | Increase Contrast | High contrast | **Рекомендуется** |
| Color independence | ✓ | ✓ | **Обязательно** |

---

## 3. Comparative Specifications (Сравнительные спецификации)

### 3.1 Units of Measurement

| Платформа | Единица | Описание |
|-----------|---------|----------|
| **iOS** | **pt** (points) | 1pt = 1px (@1x), 2px (@2x), 3px (@3x) |
| **Android** | **dp** (density-independent pixels) | 1dp = 1px (mdpi), 2px (xhdpi), 3px (xxhdpi) |

**Конвертация:** 1 pt ≈ 1 dp (практически эквивалентны)

### 3.2 Screen Regions Comparison

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              iOS                                        │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │                    Status Bar (54pt Dynamic Island)                 │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │                    Navigation Bar (44-96pt)                         │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │                                                                     │ │
│ │                         CONTENT AREA                                │ │
│ │                                                                     │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │                    Tab Bar (49pt + 34pt Home Indicator = 83pt)      │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                            Android                                      │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │                    Status Bar (~24dp)                               │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │                    Top App Bar (64dp)                               │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │                                                                     │ │
│ │                         CONTENT AREA                                │ │
│ │                                                                     │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │                    Navigation Bar (80dp) / Gesture Nav (~48dp)      │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Navigation Components

| Компонент | iOS | Android | Delta |
|-----------|-----|---------|-------|
| **Top Bar (standard)** | 44 pt | 64 dp | Android +20 |
| **Top Bar (large title)** | 96 pt | 152 dp | Android +56 |
| **Bottom Navigation** | 49 pt (+34 home) = 83 pt | 80 dp | iOS +3 |
| **Status Bar** | 54 pt (Dynamic Island) | ~24 dp | iOS +30 |
| **System gesture area** | 34 pt (bottom) | 24-48 dp (bottom) | Similar |

### 3.4 Typography Comparison

#### Body Text & Primary Styles

| Style | iOS | Android (MD3) | Difference |
|-------|-----|---------------|------------|
| **Body** | 17 pt Regular | 16 sp / 400 | iOS +1 |
| **Headline** | 17 pt Semibold | 24 sp / 400 | Different purpose |
| **Title (large)** | 34 pt Bold | 22-28 sp | Different scale |
| **Caption** | 12 pt Regular | 12 sp / 400 | Same |
| **Label** | 10-11 pt | 11-12 sp | Similar |

#### System Fonts

| Платформа | Primary Font | Weights | Serif Option |
|-----------|--------------|---------|--------------|
| **iOS** | SF Pro | 9 weights | New York |
| **Android** | Roboto | 6 weights | Roboto Serif |

#### Text Style Mapping

| Semantic Role | iOS Text Style | MD3 Text Style |
|---------------|----------------|----------------|
| Large display | Large Title (34pt) | Display Large (57sp) |
| Page title | Title 1 (28pt) | Headline Large (32sp) |
| Section header | Title 2-3 (20-22pt) | Title Large/Medium (22sp) |
| List item | Body (17pt) | Body Large (16sp) |
| Secondary | Subheadline (15pt) | Body Medium (14sp) |
| Caption | Caption 1-2 (11-12pt) | Label Small (11sp) |
| Tab label | 10pt Medium | 12sp Medium |

### 3.5 Color System Comparison

#### Semantic Color Roles

| Role | iOS | Android (MD3) |
|------|-----|---------------|
| **Primary action** | systemBlue (#007AFF) | Primary (custom) |
| **Destructive** | systemRed (#FF3B30) | Error (#B3261E) |
| **Success** | systemGreen (#34C759) | (custom) |
| **Warning** | systemOrange (#FF9500) | (custom) |
| **Background** | systemBackground | Surface |
| **Text primary** | label | On Surface |
| **Text secondary** | secondaryLabel | On Surface Variant |

#### Background Hierarchy

| Level | iOS Light | iOS Dark | MD3 Light | MD3 Dark |
|-------|-----------|----------|-----------|----------|
| Base | #FFFFFF | #000000 | #FFFBFE | #1C1B1F |
| Elevated | #F2F2F7 | #1C1C1E | Surface Container | Surface Container |
| Card | #FFFFFF | #1C1C1E | Surface Container Low | Surface Container Low |

### 3.6 Component Sizes Comparison

| Component | iOS | Android | Cross-Platform Target |
|-----------|-----|---------|----------------------|
| **Button height** | 50 pt | 40 dp | 44-50 (context-dependent) |
| **FAB** | — | 56 dp | Android-only |
| **Text Field** | 44 pt | 56 dp | 48-56 |
| **Switch** | 51×31 pt | 52×32 dp | Similar |
| **Checkbox** | — (use switch) | 18×18 dp | Platform-specific |
| **List row** | 44 pt min | 48-88 dp | 48 min |
| **Segmented Control** | 32 pt | 48 dp (Chips) | Platform-specific |
| **Card corner radius** | 10-16 pt | 12 dp | 12-16 |
| **Dialog corner radius** | 14 pt | 28 dp | Platform-specific |

### 3.7 Spacing & Grid

| Parameter | iOS | Android | Cross-Platform |
|-----------|-----|---------|----------------|
| **Base unit** | 8 pt | 8 dp | **8** |
| **Fine unit** | 4 pt | 4 dp | **4** |
| **Margin (compact)** | 16 pt | 16 dp | **16** |
| **Margin (regular)** | 20 pt | 24 dp | 20-24 |
| **Gutter** | 8-16 pt | 16-24 dp | 16 |

---

## 4. Platform-Specific Patterns (Платформо-специфичные паттерны)

### 4.1 Navigation Paradigms

| Aspect | iOS | Android |
|--------|-----|---------|
| **Primary navigation** | Tab Bar (bottom) | Navigation Bar / Rail / Drawer |
| **Back action** | Left chevron + swipe from left edge | ← arrow + system back |
| **Back gesture** | Swipe from left edge | Swipe from left/right edge |
| **Predictive back** | — | Preview destination (Android 14+) |
| **Tab switching** | Instant | Instant |
| **Navigation depth** | Push/Pop stack | Fragment/Activity stack |

#### iOS-Only Patterns
- Large Title (collapsing on scroll)
- Pull-to-refresh (native)
- Swipe actions on list items (leading/trailing)
- Edge swipe for back

#### Android-Only Patterns
- Navigation Drawer (hamburger menu)
- Navigation Rail (tablets)
- FAB (Floating Action Button)
- Bottom Sheet (persistent)
- Snackbar
- Predictive Back animation

### 4.2 Modal Presentation

| Type | iOS | Android |
|------|-----|---------|
| **Full screen** | Full Screen Modal | Activity / Full screen dialog |
| **Page sheet** | Page Sheet (default) | Bottom Sheet |
| **Half screen** | Sheet with .medium detent | Bottom Sheet |
| **Alert** | UIAlertController | AlertDialog |
| **Action choices** | Action Sheet (bottom) | Bottom Sheet / Dialog |
| **Popover** | Popover (iPad) | Menu / Dropdown |

### 4.3 Selection Controls

| Control | iOS | Android |
|---------|-----|---------|
| **Binary toggle** | Switch | Switch |
| **Single selection (list)** | Checkmark (✓) | Radio Button |
| **Multiple selection** | Checkmarks | Checkbox |
| **Segment selection** | Segmented Control | Chips / Tabs |
| **Date picker** | Wheel / Calendar | Calendar / Input |
| **Time picker** | Wheel | Clock / Input |

### 4.4 Lists & Tables

| Aspect | iOS | Android |
|--------|-----|---------|
| **Default row height** | 44 pt | 48-88 dp |
| **Separator style** | Inset line | Full-width or none |
| **Grouped style** | Rounded cards | Cards or dividers |
| **Swipe actions** | Native | Native (MD3) |
| **Selection indicator** | Checkmark right | Checkbox left |
| **Disclosure indicator** | Chevron right | — (implicit) |

---

## 5. Design Tokens Mapping (Маппинг токенов)

### 5.1 Recommended Token Structure

```
design-tokens/
├── core/
│   ├── colors.json          # Brand colors (platform-agnostic)
│   ├── typography.json      # Font families, base sizes
│   └── spacing.json         # 4/8 grid values
├── semantic/
│   ├── colors.json          # Primary, secondary, error, etc.
│   ├── surfaces.json        # Background levels
│   └── text.json            # Text color roles
├── platforms/
│   ├── ios/
│   │   ├── colors.json      # iOS semantic mapping
│   │   ├── typography.json  # iOS text styles
│   │   └── components.json  # iOS-specific sizes
│   └── android/
│       ├── colors.json      # MD3 color roles
│       ├── typography.json  # MD3 type scale
│       └── components.json  # MD3 component specs
└── components/
    ├── button.json
    ├── input.json
    └── ...
```

### 5.2 Color Token Mapping

```json
{
  "color": {
    "primary": {
      "value": "#0066CC",
      "ios": "systemBlue or custom",
      "android": "md.sys.color.primary"
    },
    "background": {
      "default": {
        "ios": "systemBackground",
        "android": "md.sys.color.surface"
      },
      "elevated": {
        "ios": "secondarySystemBackground",
        "android": "md.sys.color.surface-container"
      }
    },
    "text": {
      "primary": {
        "ios": "label",
        "android": "md.sys.color.on-surface"
      },
      "secondary": {
        "ios": "secondaryLabel",
        "android": "md.sys.color.on-surface-variant"
      }
    }
  }
}
```

### 5.3 Typography Token Mapping

```json
{
  "typography": {
    "display": {
      "ios": { "style": "largeTitle", "size": 34, "weight": "bold" },
      "android": { "style": "displayLarge", "size": 57, "weight": 400 }
    },
    "headline": {
      "ios": { "style": "title1", "size": 28, "weight": "bold" },
      "android": { "style": "headlineLarge", "size": 32, "weight": 400 }
    },
    "body": {
      "ios": { "style": "body", "size": 17, "weight": "regular" },
      "android": { "style": "bodyLarge", "size": 16, "weight": 400 }
    },
    "caption": {
      "ios": { "style": "caption1", "size": 12, "weight": "regular" },
      "android": { "style": "labelSmall", "size": 11, "weight": 500 }
    }
  }
}
```

### 5.4 Component Token Mapping

```json
{
  "component": {
    "button": {
      "height": {
        "ios": 50,
        "android": 40,
        "crossPlatform": 48
      },
      "cornerRadius": {
        "ios": 12,
        "android": 20,
        "note": "Platform-specific (iOS rounded rect, Android stadium)"
      },
      "minTouchTarget": 48
    },
    "input": {
      "height": {
        "ios": 44,
        "android": 56,
        "crossPlatform": 48
      }
    },
    "listRow": {
      "minHeight": {
        "ios": 44,
        "android": 48,
        "crossPlatform": 48
      }
    }
  }
}
```

---

## 6. Evaluation Criteria (Критерии оценки)

### 6.1 Scoring System

| Score | Description | Action |
|-------|-------------|--------|
| **100** | Fully compliant | None |
| **80-99** | Minor issues | Recommendations |
| **60-79** | Moderate issues | Required fixes |
| **40-59** | Significant issues | Major revision needed |
| **0-39** | Critical failures | Redesign required |

### 6.2 Category Weights

| Category | Weight | Rationale |
|----------|--------|-----------|
| **Accessibility** | 25% | Legal/ethical requirement |
| **Touch Targets** | 20% | Core usability |
| **Typography** | 15% | Readability |
| **Navigation** | 15% | Information architecture |
| **Color & Contrast** | 10% | Visual hierarchy |
| **Layout & Spacing** | 10% | Visual polish |
| **Platform Compliance** | 5% | Native feel |

### 6.3 Evaluation Checklist

#### 🔴 CRITICAL (Must Pass)

```
ACCESSIBILITY
□ All text meets 4.5:1 contrast (normal) or 3:1 (large)
□ All interactive elements have accessibility labels
□ Color is not the only means of conveying information
□ Dynamic Type / Font scaling is supported
□ Screen reader navigation is logical

TOUCH TARGETS
□ All tappable elements ≥ 48×48
□ Spacing between targets ≥ 8
□ No overlapping touch areas
```

#### 🟠 HIGH PRIORITY

```
NAVIGATION
□ iOS: Tab Bar ≤ 5 items
□ Android: Navigation Bar 3-5 items (7 max with rail)
□ Back navigation is clear and consistent
□ Current location is always indicated
□ Navigation depth ≤ 3-4 levels typical

TYPOGRAPHY
□ Body text 16-17 pt/sp
□ Minimum text ≥ 12 pt/sp
□ Type hierarchy is clear (max 3 levels per screen)
□ Line length 40-80 characters
□ Text styles used (not arbitrary sizes)
```

#### 🟡 MEDIUM PRIORITY

```
LAYOUT
□ Safe areas respected (status bar, home indicator, notch)
□ Margins consistent (16 minimum)
□ Grid alignment (8pt/dp base)
□ Content doesn't touch edges
□ Scrollable areas have proper insets

COLORS
□ Semantic colors used appropriately
□ Dark mode supported and tested
□ Brand colors don't override critical UI
□ Error/success/warning states clear
```

#### 🟢 LOW PRIORITY

```
PLATFORM COMPLIANCE
□ iOS: Uses iOS-native patterns (sheets, tab bar style)
□ Android: Uses MD3 patterns (FAB, navigation drawer)
□ Icons match platform style (SF Symbols vs Material Symbols)
□ Animations follow platform conventions
□ Haptic feedback appropriate

POLISH
□ Loading states present
□ Empty states designed
□ Error states designed
□ Transitions smooth
□ Visual consistency across screens
```

---

## 7. Platform Delta Report Template

### 7.1 Report Structure

```markdown
# Cross-Platform Design Evaluation Report

## Project: [Name]
## Date: [Date]
## Evaluator: AI / [Name]

---

## Executive Summary
- Overall Score: [X]/100
- iOS Compliance: [X]%
- Android Compliance: [X]%
- Critical Issues: [N]
- Recommendations: [N]

---

## Critical Issues (Must Fix)

### Issue 1: [Title]
- **Severity:** Critical
- **Platform:** Both / iOS / Android
- **Location:** [Screen/Component]
- **Current:** [Description]
- **Required:** [Specification]
- **Fix:** [Recommendation]

---

## Platform Comparison Matrix

| Aspect | iOS Design | Android Design | Status |
|--------|------------|----------------|--------|
| Touch Targets | [Value] | [Value] | ✓/✗ |
| Typography | [Value] | [Value] | ✓/✗ |
| Navigation | [Pattern] | [Pattern] | ✓/✗ |
| Colors | [System] | [System] | ✓/✗ |

---

## Detailed Findings

### Accessibility
[Findings]

### Touch Targets
[Findings]

### Typography
[Findings]

### Navigation
[Findings]

### Layout
[Findings]

### Colors
[Findings]

---

## Recommendations

### High Priority
1. [Recommendation]
2. [Recommendation]

### Medium Priority
1. [Recommendation]

### Low Priority
1. [Recommendation]

---

## Appendix: Screenshots with Annotations
[Annotated screenshots highlighting issues]
```

---

## 8. Quick Reference Cards

### 8.1 Universal Minimums (Memorize These)

```
┌─────────────────────────────────────────────────────────────┐
│                    UNIVERSAL MINIMUMS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Touch Target:     48 × 48                                 │
│   Touch Spacing:    8                                       │
│   Text Minimum:     12                                      │
│   Body Text:        16-17                                   │
│   Margins:          16                                      │
│   Grid Unit:        8 (fine: 4)                            │
│   Contrast (text):  4.5:1                                   │
│   Contrast (UI):    3:1                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.2 iOS Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│                      iOS SPECIFICS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Status Bar:       54pt (Dynamic Island)                   │
│   Nav Bar:          44pt (small) / 96pt (large)             │
│   Tab Bar:          49pt + 34pt home = 83pt                 │
│   Home Indicator:   34pt bottom area                        │
│                                                             │
│   Touch Target:     44×44pt (use 48 for cross-platform)     │
│   Body Font:        17pt SF Pro                             │
│   Tab Label:        10pt Medium                             │
│                                                             │
│   Primary Color:    systemBlue (#007AFF)                    │
│   Background:       systemBackground                        │
│                                                             │
│   Back Gesture:     Swipe from LEFT edge only               │
│   Icons:            SF Symbols (filled for tab bar)         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.3 Android Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│                    ANDROID SPECIFICS                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Status Bar:       ~24dp                                   │
│   Top App Bar:      64dp (small) / 152dp (large)            │
│   Nav Bar:          80dp (3-button) / 48dp (gesture)        │
│   Gesture Handle:   ~20dp area                              │
│                                                             │
│   Touch Target:     48×48dp                                 │
│   Body Font:        16sp Roboto                             │
│   Nav Label:        12sp Medium                             │
│                                                             │
│   FAB:              56dp (standard) / 96dp (large)          │
│   Button Height:    40dp                                    │
│   Card Radius:      12dp                                    │
│                                                             │
│   Back Gesture:     Swipe from LEFT or RIGHT edge           │
│   Icons:            Material Symbols                        │
│                                                             │
│   Columns:          4 (compact) / 8 (medium) / 12 (expanded)│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.4 Side-by-Side Comparison Card

```
┌────────────────────────┬────────────────────────┐
│          iOS           │        Android         │
├────────────────────────┼────────────────────────┤
│ Points (pt)            │ Density-independent    │
│                        │ pixels (dp/sp)         │
├────────────────────────┼────────────────────────┤
│ SF Pro                 │ Roboto                 │
├────────────────────────┼────────────────────────┤
│ Tab Bar (bottom)       │ Nav Bar/Rail/Drawer    │
├────────────────────────┼────────────────────────┤
│ Navigation Bar (top)   │ Top App Bar            │
├────────────────────────┼────────────────────────┤
│ Sheets                 │ Bottom Sheets          │
├────────────────────────┼────────────────────────┤
│ Action Sheet           │ Bottom Sheet / Dialog  │
├────────────────────────┼────────────────────────┤
│ Alert                  │ Dialog                 │
├────────────────────────┼────────────────────────┤
│ Switch                 │ Switch                 │
├────────────────────────┼────────────────────────┤
│ Segmented Control      │ Chips / Tabs           │
├────────────────────────┼────────────────────────┤
│ — (no equivalent)      │ FAB                    │
├────────────────────────┼────────────────────────┤
│ — (no equivalent)      │ Snackbar               │
├────────────────────────┼────────────────────────┤
│ Checkmark (✓)          │ Radio / Checkbox       │
├────────────────────────┼────────────────────────┤
│ SF Symbols             │ Material Symbols       │
├────────────────────────┼────────────────────────┤
│ Large Title collapse   │ Collapsing Toolbar     │
├────────────────────────┼────────────────────────┤
│ Dynamic Type           │ Font scaling + sp      │
├────────────────────────┼────────────────────────┤
│ Dark Mode              │ Dark Theme +           │
│                        │ Dynamic Color          │
└────────────────────────┴────────────────────────┘
```

---

## 9. AI Evaluation Prompts

### 9.1 General Evaluation Prompt

```
Analyze this mobile design mockup against cross-platform guidelines:

1. IDENTIFY platform (iOS/Android/both)
2. CHECK critical requirements:
   - Touch targets ≥ 48×48
   - Text contrast ≥ 4.5:1
   - Minimum text ≥ 12pt/sp
   - Accessibility labels present

3. VERIFY platform compliance:
   - iOS: HIG patterns (tab bar, navigation bar, sheets)
   - Android: MD3 patterns (nav bar/rail, FAB, bottom sheets)

4. REPORT findings with:
   - Severity (Critical/High/Medium/Low)
   - Location (screen/component)
   - Current value vs. Required value
   - Specific fix recommendation

5. CALCULATE compliance score (0-100)
```

### 9.2 Touch Target Audit Prompt

```
Audit all interactive elements for touch target compliance:

For each tappable element:
1. Measure visual size
2. Determine touch target area
3. Check: touch area ≥ 48×48?
4. Check: spacing to adjacent targets ≥ 8?
5. Flag any violations with exact measurements
```

### 9.3 Typography Audit Prompt

```
Audit typography against platform guidelines:

1. List all text styles used with sizes
2. Map to platform text styles (iOS/Android)
3. Check hierarchy:
   - Is there clear visual hierarchy?
   - Are sizes from the type scale?
   - Is body text 16-17?
   - Is any text < 12?
4. Check Dynamic Type / font scaling support
5. Flag non-compliant text with recommendations
```

### 9.4 Color & Contrast Audit Prompt

```
Audit colors and contrast:

1. Extract all colors used
2. Test contrast ratios:
   - Text on backgrounds
   - Icons on backgrounds
   - Interactive elements
3. Check semantic color usage:
   - Primary actions
   - Destructive actions
   - Success/error/warning states
4. Verify Dark Mode compatibility
5. Flag contrast failures with exact ratios
```

### 9.5 Cross-Platform Comparison Prompt

```
Compare iOS and Android versions of this design:

1. Create side-by-side comparison matrix
2. Identify intentional platform differences
3. Flag unintentional inconsistencies:
   - Different functionality
   - Missing features
   - Different visual hierarchy
4. Check platform-appropriate patterns:
   - iOS uses iOS patterns
   - Android uses MD3 patterns
5. Recommend alignment where appropriate
```

---

## 10. Implementation Checklist

### 10.1 Design System Setup

```
□ Define core brand tokens (colors, fonts)
□ Create semantic token layer
□ Map tokens to iOS values
□ Map tokens to Android/MD3 values
□ Document platform-specific patterns
□ Create component specifications for both platforms
□ Set up Figma libraries with variants
```

### 10.2 Design Review Process

```
□ Self-review against this checklist
□ Run accessibility audit
□ Test with Dynamic Type / font scaling
□ Test Dark Mode
□ Platform-specific review (iOS patterns, Android patterns)
□ Cross-platform consistency check
□ Final compliance score calculation
```

### 10.3 Handoff Requirements

```
□ Specifications in platform-native units (pt for iOS, dp for Android)
□ Color tokens mapped to system colors
□ Typography mapped to text styles
□ Touch target areas annotated
□ Safe area handling documented
□ Platform-specific behaviors noted
□ Accessibility requirements specified
```

---

## Appendix A: Reference Links

### Official Documentation
- **Apple HIG**: developer.apple.com/design/human-interface-guidelines
- **Material Design 3**: m3.material.io
- **Android Design**: developer.android.com/design

### Tools
- **SF Symbols**: developer.apple.com/sf-symbols
- **Material Symbols**: fonts.google.com/icons
- **Contrast Checker**: webaim.org/resources/contrastchecker
- **Figma iOS/Android UI Kits**: Apple/Google Design Resources

### Related Documents
- `material-design-3-guidelines.md` — MD3 полные спецификации
- `android-design-guidelines.md` — Android-специфичные требования
- `ios-human-interface-guidelines.md` — iOS HIG полные спецификации

---

## Document Info

| Field | Value |
|-------|-------|
| Version | 1.0 |
| Created | February 2025 |
| Sources | Apple HIG, Material Design 3, Android Design Guidelines |
| Purpose | AI-driven cross-platform design evaluation |
| Maintained by | Design System Team |
