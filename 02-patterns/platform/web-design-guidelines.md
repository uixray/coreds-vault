---
title: "Web Design Guidelines"
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
  - "platform/web"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
description: "Web platform design guidelines and best practices"
category: "platform"
---

# Web Design Guidelines
## AI-Driven Design Evaluation Framework for Web

> Версия: 1.0 | Дата: 2025-02
> Источники: WCAG 2.2, W3C WAI, MDN, USWDS, Nielsen Norman Group
> Назначение: AI-оценка веб-дизайн макетов на соответствие современным стандартам

---

## Содержание

1. [Основные принципы](#1-основные-принципы)
2. [Единицы измерения](#2-единицы-измерения)
3. [Accessibility (WCAG 2.2)](#3-accessibility-wcag-22)
4. [Typography](#4-typography)
5. [Color System](#5-color-system)
6. [Layout & Grid](#6-layout--grid)
7. [Breakpoints & Responsive](#7-breakpoints--responsive)
8. [Spacing System](#8-spacing-system)
9. [Components](#9-components)
10. [Navigation](#10-navigation)
11. [Forms & Inputs](#11-forms--inputs)
12. [Motion & Animation](#12-motion--animation)
13. [Dark Mode](#13-dark-mode)
14. [Performance Considerations](#14-performance-considerations)
15. [Critical Checklist](#15-critical-checklist)
16. [Evaluation Scoring](#16-evaluation-scoring)

---

## 1. Основные принципы

### 1.1 WCAG 2.2 Four Principles (POUR)

| Principle | Description | Key Focus |
|-----------|-------------|-----------|
| **Perceivable** | Контент воспринимаем всеми пользователями | Text alternatives, captions, contrast |
| **Operable** | Интерфейс можно использовать | Keyboard access, time limits, navigation |
| **Understandable** | Контент и UI понятны | Readable, predictable, input assistance |
| **Robust** | Совместимость с технологиями | Parsing, name/role/value |

### 1.2 Web Design Principles

| Principle | Description |
|-----------|-------------|
| **Mobile-First** | Дизайн начинается с мобильных устройств |
| **Progressive Enhancement** | Базовый опыт + улучшения для мощных устройств |
| **Content-First** | Контент определяет структуру |
| **Semantic HTML** | Использование семантической разметки |
| **Performance** | Быстрая загрузка и отзывчивость |

### 1.3 Ключевое правило

> **Веб-дизайн должен быть responsive, accessible и performant.**
> Эти три качества не опциональны — они обязательны.

---

## 2. Единицы измерения

### 2.1 CSS Units Comparison

| Unit | Type | Use Case | Responsive |
|------|------|----------|------------|
| **px** | Absolute | Fixed elements, borders | ❌ |
| **rem** | Relative (root) | Typography, spacing | ✅ |
| **em** | Relative (parent) | Component spacing | ✅ |
| **%** | Relative (parent) | Widths, layouts | ✅ |
| **vw/vh** | Viewport | Hero sections | ✅ |
| **svh/lvh/dvh** | Viewport (new) | Mobile-safe viewport | ✅ |
| **ch** | Character width | Input fields | ✅ |

### 2.2 Base Size Convention

```css
/* Стандартный базовый размер */
html {
  font-size: 100%; /* = 16px в большинстве браузеров */
}

/* Расчёты */
1rem = 16px (при стандартных настройках)
0.5rem = 8px
0.75rem = 12px
1.5rem = 24px
2rem = 32px
```

### 2.3 Рекомендации

| Context | Recommended Unit |
|---------|------------------|
| **Font sizes** | rem |
| **Line height** | Unitless (1.5) |
| **Margins/Padding** | rem, em |
| **Border** | px |
| **Border radius** | px, rem |
| **Width/Max-width** | %, rem, ch |
| **Media queries** | px (for breakpoints) |

> **Universal Rule: Использовать rem для scaling, px для fixed elements**

---

## 3. Accessibility (WCAG 2.2)

### 3.1 Conformance Levels

| Level | Description | Legal Requirement |
|-------|-------------|-------------------|
| **A** | Minimum accessibility | Basic |
| **AA** | Standard (recommended) | Most regulations (ADA, EN 301 549) |
| **AAA** | Enhanced | Optional, aspirational |

### 3.2 Color Contrast Requirements

| Content Type | WCAG AA | WCAG AAA |
|--------------|---------|----------|
| **Normal text** (<18pt / <14pt bold) | **4.5:1** | 7:1 |
| **Large text** (≥18pt / ≥14pt bold) | **3:1** | 4.5:1 |
| **UI Components** | **3:1** | — |
| **Graphics/Icons** | **3:1** | — |
| **Focus indicators** | **3:1** | — |

#### Size Definitions
```
Large text:
- Regular: ≥18pt (24px)
- Bold: ≥14pt (18.5px / ~19px)
```

### 3.3 Touch/Click Target Sizes

| Standard | Minimum Size | Recommended |
|----------|--------------|-------------|
| **WCAG 2.2 (Level AA)** | 24×24 px | — |
| **WCAG 2.2 (Level AAA)** | 44×44 px | ≥44×44 px |
| **Apple HIG** | 44×44 pt | ≥44×44 pt |
| **Material Design** | 48×48 dp | ≥48×48 dp |
| **Best Practice** | — | **≥44×44 px** |

### 3.4 Target Spacing

| Requirement | Value |
|-------------|-------|
| **Minimum spacing** | 8 px |
| **Recommended** | 8-16 px |

### 3.5 Keyboard Accessibility

| Requirement | Description |
|-------------|-------------|
| **Tab navigation** | All interactive elements reachable |
| **Focus visible** | Clear focus indicator (≥3:1 contrast) |
| **Focus order** | Logical reading order |
| **No keyboard trap** | User can always navigate away |
| **Skip links** | Skip to main content option |

### 3.6 WCAG 2.2 New Success Criteria (Level AA)

| Criterion | Requirement |
|-----------|-------------|
| **2.4.11 Focus Not Obscured (Minimum)** | Focused element not fully hidden |
| **2.4.12 Focus Not Obscured (Enhanced)** | Focused element not partially hidden |
| **2.5.7 Dragging Movements** | Alternative to drag-and-drop |
| **2.5.8 Target Size (Minimum)** | ≥24×24 px (with exceptions) |
| **3.2.6 Consistent Help** | Help mechanisms in same location |
| **3.3.7 Redundant Entry** | Don't require re-entering info |
| **3.3.8 Accessible Authentication** | No cognitive function tests |

### 3.7 Accessibility Quick Checklist

| # | Requirement | Priority |
|---|-------------|----------|
| 1 | Color contrast ≥4.5:1 (text) | 🔴 Critical |
| 2 | Color contrast ≥3:1 (UI, large text) | 🔴 Critical |
| 3 | Touch targets ≥44×44 px | 🔴 Critical |
| 4 | Keyboard navigable | 🔴 Critical |
| 5 | Focus indicators visible | 🔴 Critical |
| 6 | Alt text for images | 🔴 Critical |
| 7 | Form labels | 🔴 Critical |
| 8 | Semantic HTML | 🟠 Important |
| 9 | Skip navigation link | 🟠 Important |
| 10 | ARIA where needed | 🟠 Important |
| 11 | Reduce motion support | 🟡 Recommended |
| 12 | Text resizable to 200% | 🟡 Recommended |

---

## 4. Typography

### 4.1 Font Size Scale

| Role | Size (px) | Size (rem) | Line Height |
|------|-----------|------------|-------------|
| **Display 1** | 72 | 4.5 | 1.1 |
| **Display 2** | 60 | 3.75 | 1.1 |
| **H1** | 48 | 3 | 1.2 |
| **H2** | 36 | 2.25 | 1.2 |
| **H3** | 30 | 1.875 | 1.3 |
| **H4** | 24 | 1.5 | 1.3 |
| **H5** | 20 | 1.25 | 1.4 |
| **H6** | 18 | 1.125 | 1.4 |
| **Body Large** | 18 | 1.125 | 1.5 |
| **Body** | 16 | 1 | 1.5 |
| **Body Small** | 14 | 0.875 | 1.5 |
| **Caption** | 12 | 0.75 | 1.4 |
| **Overline** | 12 | 0.75 | 1.4 |

### 4.2 Font Size by Context

| Context | Desktop | Mobile | Min |
|---------|---------|--------|-----|
| **Body text** | 16-18 px | 16-17 px | **16 px** |
| **Secondary text** | 14 px | 14 px | 14 px |
| **Caption** | 12 px | 12 px | **11 px** (absolute min) |
| **Button text** | 14-16 px | 14-16 px | 14 px |
| **Input text** | 16 px | **16 px** (prevents zoom on iOS) | 16 px |
| **H1 (page title)** | 36-48 px | 28-36 px | 24 px |
| **Nav links** | 14-16 px | 14-16 px | 14 px |

### 4.3 Line Height (Leading)

| Content Type | Line Height | Notes |
|--------------|-------------|-------|
| **Headings** | 1.1-1.3 | Compact for visual weight |
| **Body text** | 1.5-1.6 | Optimal readability |
| **Long-form reading** | 1.6-1.75 | More space for comfort |
| **UI elements** | 1.2-1.4 | Tighter for controls |
| **Buttons** | 1-1.2 | Single line |

### 4.4 Line Length (Measure)

| Context | Characters | Notes |
|---------|------------|-------|
| **Optimal** | 45-75 | Best readability |
| **Minimum** | 40 | Below = too choppy |
| **Maximum** | 80 | Above = hard to track |
| **Mobile** | 35-50 | Constrained by width |

```css
/* Рекомендуемые значения */
.content {
  max-width: 65ch; /* ~65 символов */
}
```

### 4.5 Letter Spacing

| Context | Value | Notes |
|---------|-------|-------|
| **Body text** | 0 (normal) | No adjustment needed |
| **Uppercase text** | 0.05-0.1em | Improves readability |
| **Large headings** | -0.01 to -0.03em | Tighter for impact |
| **Small text (<12px)** | 0.01-0.02em | Slightly looser |

### 4.6 Font Weight Usage

| Weight | Name | Use Case |
|--------|------|----------|
| 300 | Light | Display text only |
| 400 | Regular | Body text, UI |
| 500 | Medium | Emphasis, buttons |
| 600 | Semibold | Headings, labels |
| 700 | Bold | Strong emphasis |

### 4.7 System Font Stacks

```css
/* Sans-serif (Modern) */
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 
             Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 
             sans-serif;

/* Serif */
font-family: Georgia, 'Times New Roman', Times, serif;

/* Monospace */
font-family: 'SF Mono', SFMono-Regular, Consolas, 
             'Liberation Mono', Menlo, monospace;
```

### 4.8 Web-Safe Font Pairs

| Heading Font | Body Font | Style |
|--------------|-----------|-------|
| Montserrat | Open Sans | Modern |
| Playfair Display | Lato | Elegant |
| Roboto Slab | Roboto | Material-like |
| Inter | Inter | Neutral |
| Poppins | Nunito | Friendly |

---

## 5. Color System

### 5.1 Semantic Color Roles

| Role | Description | Example Usage |
|------|-------------|---------------|
| **Primary** | Brand color, main actions | Buttons, links, accents |
| **Secondary** | Complementary | Secondary buttons |
| **Accent** | Highlights | Notifications, badges |
| **Success** | Positive states | Confirmations, valid inputs |
| **Warning** | Caution states | Warnings, alerts |
| **Error/Danger** | Negative states | Errors, destructive actions |
| **Info** | Informational | Tips, help text |
| **Neutral** | Grays | Text, borders, backgrounds |

### 5.2 Neutral Palette (Grays)

| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| **Neutral 50** | #FAFAFA | — | Lightest background |
| **Neutral 100** | #F5F5F5 | — | Light background |
| **Neutral 200** | #EEEEEE | — | Subtle background |
| **Neutral 300** | #E0E0E0 | #424242 | Borders |
| **Neutral 400** | #BDBDBD | #616161 | Disabled |
| **Neutral 500** | #9E9E9E | #757575 | Placeholder |
| **Neutral 600** | #757575 | #9E9E9E | Secondary text |
| **Neutral 700** | #616161 | #BDBDBD | Primary text (Dark) |
| **Neutral 800** | #424242 | #E0E0E0 | Headings |
| **Neutral 900** | #212121 | #FAFAFA | Primary text |

### 5.3 Contrast-Safe Colors on White (#FFFFFF)

| Color | Hex | Contrast Ratio | WCAG AA (Normal) |
|-------|-----|----------------|------------------|
| Black | #000000 | 21:1 | ✅ Pass |
| Gray 900 | #212121 | 16.1:1 | ✅ Pass |
| Gray 700 | #616161 | 5.9:1 | ✅ Pass |
| Gray 600 | #757575 | 4.6:1 | ✅ Pass (minimum) |
| Gray 500 | #9E9E9E | 3.5:1 | ❌ Fail |
| Blue | #1565C0 | 6.1:1 | ✅ Pass |
| Red | #C62828 | 5.6:1 | ✅ Pass |
| Green | #2E7D32 | 5.3:1 | ✅ Pass |

### 5.4 Background Colors

| Context | Light Mode | Dark Mode |
|---------|------------|-----------|
| **Page background** | #FFFFFF | #121212 |
| **Surface/Card** | #FFFFFF | #1E1E1E |
| **Elevated surface** | #FFFFFF (shadow) | #2D2D2D |
| **Subtle background** | #F5F5F5 | #2D2D2D |

### 5.5 Link Colors

| State | Light Mode | Dark Mode | Notes |
|-------|------------|-----------|-------|
| **Default** | #0066CC | #6AB7FF | Must meet 4.5:1 contrast |
| **Visited** | #551A8B | #CE93D8 | Distinct from default |
| **Hover** | #004499 | #90CAF9 | Darker/lighter |
| **Active** | #003366 | #BBDEFB | Pressed state |

### 5.6 Color Independence Rule

> **Никогда не полагаться только на цвет для передачи информации.**
> Всегда добавлять: иконки, текст, паттерны или другие визуальные индикаторы.

Examples:
- ❌ Red = error, Green = success (color only)
- ✅ Red + ⚠️ icon + "Error" text

---

## 6. Layout & Grid

### 6.1 Common Grid Systems

| System | Columns | Gutter | Max Width |
|--------|---------|--------|-----------|
| **12-column** | 12 | 16-24 px | 1200-1440 px |
| **16-column** | 16 | 16-20 px | 1440 px |
| **Fluid** | Variable | 16-32 px | 100% |

### 6.2 Standard Container Widths

| Breakpoint | Container Max-Width |
|------------|---------------------|
| **xs** (<576px) | 100% |
| **sm** (≥576px) | 540 px |
| **md** (≥768px) | 720 px |
| **lg** (≥992px) | 960 px |
| **xl** (≥1200px) | 1140 px |
| **xxl** (≥1400px) | 1320 px |

### 6.3 Margin & Gutter Sizes

| Breakpoint | Side Margins | Gutter |
|------------|--------------|--------|
| **Mobile** | 16 px | 16 px |
| **Tablet** | 24 px | 24 px |
| **Desktop** | 32 px | 24-32 px |
| **Large Desktop** | Auto-center | 24-32 px |

### 6.4 Column Count by Breakpoint

| Breakpoint | Columns | Common Usage |
|------------|---------|--------------|
| **Mobile** (<600px) | 4 | 1-2 column layouts |
| **Tablet** (600-1200px) | 8 | 2-3 column layouts |
| **Desktop** (≥1200px) | 12 | 3-4+ column layouts |

### 6.5 CSS Grid Example

```css
.grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 24px;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px;
}

@media (max-width: 768px) {
  .grid {
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
  }
}
```

### 6.6 Flexbox vs Grid

| Use Flexbox | Use Grid |
|-------------|----------|
| One-dimensional layouts | Two-dimensional layouts |
| Content-driven sizing | Fixed structure |
| Navigation menus | Page layouts |
| Card alignment | Complex grids |

---

## 7. Breakpoints & Responsive

### 7.1 Standard Breakpoints

| Name | Min-Width | Target Devices |
|------|-----------|----------------|
| **xs** | 0 | Small phones |
| **sm** | 576 px | Large phones |
| **md** | 768 px | Tablets (portrait) |
| **lg** | 992 px | Tablets (landscape), laptops |
| **xl** | 1200 px | Desktops |
| **xxl** | 1400 px | Large desktops |

### 7.2 Bootstrap 5 Breakpoints

| Breakpoint | Class infix | Dimensions |
|------------|-------------|------------|
| **X-Small** | None | <576 px |
| **Small** | sm | ≥576 px |
| **Medium** | md | ≥768 px |
| **Large** | lg | ≥992 px |
| **Extra large** | xl | ≥1200 px |
| **Extra extra large** | xxl | ≥1400 px |

### 7.3 Tailwind CSS Breakpoints

| Breakpoint | Min-Width |
|------------|-----------|
| **sm** | 640 px |
| **md** | 768 px |
| **lg** | 1024 px |
| **xl** | 1280 px |
| **2xl** | 1536 px |

### 7.4 Mobile-First Media Queries

```css
/* Mobile first approach */
.element {
  /* Mobile styles (default) */
  font-size: 16px;
}

@media (min-width: 768px) {
  .element {
    /* Tablet and up */
    font-size: 18px;
  }
}

@media (min-width: 1200px) {
  .element {
    /* Desktop and up */
    font-size: 20px;
  }
}
```

### 7.5 Content-Based Breakpoints

> **Best Practice: Breakpoints должны определяться контентом, а не устройствами.**

Добавляйте breakpoint когда:
- Layout "ломается" или выглядит плохо
- Текст становится слишком широким/узким
- Элементы перестают умещаться

### 7.6 Responsive Patterns

| Pattern | Description | Breakpoint |
|---------|-------------|------------|
| **Stack to horizontal** | Вертикально на mobile → горизонтально на desktop | ~768 px |
| **Show/hide** | Hamburger menu → full nav | ~992 px |
| **Card reflow** | 1 → 2 → 3 → 4 columns | 576/768/1200 px |
| **Sidebar** | Hidden → visible | ~992 px |

---

## 8. Spacing System

### 8.1 Spacing Scale (8px Base)

| Token | Value | Rem |
|-------|-------|-----|
| **space-0** | 0 | 0 |
| **space-1** | 4 px | 0.25rem |
| **space-2** | 8 px | 0.5rem |
| **space-3** | 12 px | 0.75rem |
| **space-4** | 16 px | 1rem |
| **space-5** | 24 px | 1.5rem |
| **space-6** | 32 px | 2rem |
| **space-7** | 40 px | 2.5rem |
| **space-8** | 48 px | 3rem |
| **space-9** | 64 px | 4rem |
| **space-10** | 80 px | 5rem |
| **space-11** | 96 px | 6rem |

### 8.2 Spacing by Context

| Context | Recommended |
|---------|-------------|
| **Inline (icons, text)** | 4-8 px |
| **Component internal** | 8-16 px |
| **Between components** | 16-24 px |
| **Section spacing** | 48-96 px |
| **Page margins** | 16-32 px |

### 8.3 Vertical Rhythm

```css
/* Базовый вертикальный ритм */
body {
  font-size: 16px;
  line-height: 1.5; /* = 24px */
}

/* Все spacing кратны базовой line-height */
p { margin-bottom: 24px; } /* 1× */
h2 { margin-top: 48px; }   /* 2× */
section { padding: 72px 0; } /* 3× */
```

### 8.4 Spacing Rules

| Rule | Description |
|------|-------------|
| **Consistency** | Используйте spacing scale, не произвольные значения |
| **Proximity** | Связанные элементы ближе друг к другу |
| **Whitespace** | Достаточно пустого пространства для "дыхания" |
| **Hierarchy** | Больше spacing = больше разделение |

---

## 9. Components

### 9.1 Buttons

#### 9.1.1 Button Sizes

| Size | Height | Padding (H) | Font Size | Use Case |
|------|--------|-------------|-----------|----------|
| **Small** | 32 px | 12 px | 14 px | Dense UI, tables |
| **Medium** | 40-44 px | 16-20 px | 14-16 px | Default |
| **Large** | 48-56 px | 24-32 px | 16-18 px | Primary CTA |

#### 9.1.2 Button Anatomy

| Element | Specification |
|---------|---------------|
| **Min width** | 88 px (or fit content + padding) |
| **Touch target** | ≥44×44 px |
| **Border radius** | 4-8 px (or 9999px for pill) |
| **Text** | Semibold (500-600) |
| **Padding ratio** | 1:2 (vertical:horizontal) |
| **Icon spacing** | 8 px from text |

#### 9.1.3 Button States

| State | Visual Treatment |
|-------|------------------|
| **Default** | Base color |
| **Hover** | Slightly darker/lighter |
| **Focus** | Focus ring (2-4 px, offset 2 px) |
| **Active/Pressed** | Darker, possibly scaled down |
| **Disabled** | 30-50% opacity |
| **Loading** | Spinner or progress |

#### 9.1.4 Button Hierarchy

| Type | Visual | Use |
|------|--------|-----|
| **Primary** | Filled, brand color | Main CTA, 1 per screen |
| **Secondary** | Outlined or tonal | Secondary actions |
| **Tertiary/Ghost** | Text only | Less important actions |
| **Destructive** | Red/danger color | Delete, remove |

### 9.2 Cards

| Property | Value |
|----------|-------|
| **Border radius** | 8-16 px |
| **Padding** | 16-24 px |
| **Shadow (subtle)** | 0 1px 3px rgba(0,0,0,0.1) |
| **Shadow (elevated)** | 0 4px 6px rgba(0,0,0,0.1) |
| **Border** | 1 px (if no shadow) |
| **Max width** | Context-dependent |

### 9.3 Modals/Dialogs

| Property | Desktop | Mobile |
|----------|---------|--------|
| **Width** | 400-560 px | 90-100% |
| **Max height** | 85vh | 90vh |
| **Border radius** | 8-16 px | 16 px (top) |
| **Padding** | 24-32 px | 16-24 px |
| **Overlay opacity** | 50-70% | 50-70% |
| **Z-index** | 1000+ | 1000+ |

### 9.4 Tooltips

| Property | Value |
|----------|-------|
| **Max width** | 200-300 px |
| **Padding** | 8-12 px |
| **Font size** | 12-14 px |
| **Border radius** | 4-8 px |
| **Background** | Dark (light mode) / Light (dark mode) |
| **Delay (appear)** | 200-500 ms |

### 9.5 Badges/Tags

| Property | Value |
|----------|-------|
| **Height** | 20-28 px |
| **Padding** | 4-8 px horizontal |
| **Font size** | 12-14 px |
| **Border radius** | 4 px (or pill) |
| **Font weight** | Medium (500) |

### 9.6 Avatars

| Size | Dimensions | Use Case |
|------|------------|----------|
| **XS** | 24 px | Inline, dense lists |
| **Small** | 32 px | Comments, compact UI |
| **Medium** | 40-48 px | List items, cards |
| **Large** | 64-96 px | Profile headers |
| **XL** | 128+ px | Profile pages |

---

## 10. Navigation

### 10.1 Header/Navbar

| Property | Desktop | Mobile |
|----------|---------|--------|
| **Height** | 60-80 px | 56-64 px |
| **Max height** | 100 px | 80 px |
| **Position** | Fixed or sticky | Fixed or sticky |
| **Z-index** | 100+ | 100+ |
| **Logo height** | 24-40 px | 24-32 px |

### 10.2 Navigation Link Spacing

| Property | Value |
|----------|-------|
| **Horizontal spacing** | 16-32 px between items |
| **Vertical padding** | 8-16 px |
| **Touch target** | ≥44 px height |

### 10.3 Mobile Navigation

| Pattern | When to Use |
|---------|-------------|
| **Hamburger menu** | ≤992 px (или когда nav не умещается) |
| **Bottom nav** | Mobile apps, key actions |
| **Tab bar** | Mobile, 3-5 items |
| **Slide-out drawer** | Complex navigation |

### 10.4 Sidebar

| Property | Value |
|----------|-------|
| **Width (collapsed)** | 64-72 px |
| **Width (expanded)** | 200-280 px |
| **Item height** | 40-48 px |
| **Icon size** | 20-24 px |
| **Item padding** | 12-16 px |

### 10.5 Breadcrumbs

| Property | Value |
|----------|-------|
| **Font size** | 12-14 px |
| **Separator** | /, >, • |
| **Spacing** | 8 px around separator |
| **Max items visible** | 4-5 (truncate middle) |

### 10.6 Tabs

| Property | Value |
|----------|-------|
| **Height** | 40-48 px |
| **Padding** | 12-24 px horizontal |
| **Font size** | 14-16 px |
| **Indicator height** | 2-3 px |
| **Min touch target** | 44 px |

---

## 11. Forms & Inputs

### 11.1 Input Fields

| Property | Desktop | Mobile |
|----------|---------|--------|
| **Height** | 40-48 px | 44-48 px |
| **Padding** | 12-16 px | 12-16 px |
| **Font size** | 14-16 px | **16 px** (prevents iOS zoom) |
| **Border radius** | 4-8 px | 4-8 px |
| **Border** | 1 px | 1 px |

### 11.2 Input States

| State | Border Color | Background | Notes |
|-------|--------------|------------|-------|
| **Default** | Gray (#CCC) | White | — |
| **Hover** | Darker gray | White | — |
| **Focus** | Primary color | White | + Focus ring |
| **Filled** | Gray | White | — |
| **Error** | Red | White or light red | + Error message |
| **Disabled** | Light gray | Gray (#F5F5F5) | 50% opacity text |
| **Read-only** | Light gray | Gray (#F5F5F5) | Cursor: default |

### 11.3 Form Labels

| Property | Value |
|----------|-------|
| **Font size** | 14 px |
| **Font weight** | Medium (500) |
| **Margin bottom** | 4-8 px |
| **Required indicator** | * (asterisk) |

### 11.4 Form Layout

| Property | Value |
|----------|-------|
| **Field spacing** | 16-24 px vertical |
| **Label position** | Above field (preferred) |
| **Max form width** | 400-600 px |
| **Button alignment** | Left or full-width (mobile) |

### 11.5 Input Types & Sizes

| Input Type | Recommended Width |
|------------|-------------------|
| **Email** | 100% or ~300 px |
| **Password** | 100% or ~300 px |
| **Short text** | Context-based (~200 px) |
| **Long text** | 100% |
| **Phone** | ~200 px |
| **Postal code** | 100-150 px |
| **Date** | ~200 px |
| **Number (small)** | 80-120 px |

### 11.6 Validation Messages

| Property | Value |
|----------|-------|
| **Font size** | 12-14 px |
| **Color (error)** | Red (#D32F2F) |
| **Color (success)** | Green (#388E3C) |
| **Margin top** | 4-8 px |
| **Icon** | 16 px, inline |

### 11.7 Checkboxes & Radio Buttons

| Property | Value |
|----------|-------|
| **Size** | 18-24 px |
| **Touch target** | ≥44 px |
| **Label spacing** | 8-12 px |
| **Vertical spacing** | 8-16 px between options |

### 11.8 Select/Dropdown

| Property | Value |
|----------|-------|
| **Height** | 40-48 px (same as input) |
| **Dropdown max-height** | 300-400 px |
| **Option height** | 40-44 px |
| **Option padding** | 12-16 px |

---

## 12. Motion & Animation

### 12.1 Duration Guidelines

| Animation Type | Duration | Easing |
|----------------|----------|--------|
| **Micro-interactions** | 100-200 ms | ease-out |
| **Hover states** | 150-250 ms | ease |
| **Enter animations** | 200-300 ms | ease-out |
| **Exit animations** | 150-200 ms | ease-in |
| **Page transitions** | 300-500 ms | ease-in-out |
| **Complex animations** | 400-600 ms | custom |

### 12.2 Easing Functions

| Name | CSS | Use Case |
|------|-----|----------|
| **ease** | ease | General purpose |
| **ease-in** | ease-in | Exit animations |
| **ease-out** | ease-out | Enter animations |
| **ease-in-out** | ease-in-out | Symmetrical |
| **linear** | linear | Progress, loaders |
| **Material** | cubic-bezier(0.4, 0, 0.2, 1) | Natural feel |

### 12.3 Reduce Motion

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

> **Обязательно: Всегда поддерживать prefers-reduced-motion**

### 12.4 Animation Best Practices

| Do | Don't |
|----|-------|
| Keep animations short (<500ms) | Animate layout properties (width, height) |
| Use transform & opacity | Auto-play video/audio |
| Provide purpose | Flashing >3 times/second |
| Respect reduce motion | Infinite animations without pause |

---

## 13. Dark Mode

### 13.1 Color Adjustments

| Element | Light Mode | Dark Mode |
|---------|------------|-----------|
| **Background** | #FFFFFF | #121212 |
| **Surface** | #FFFFFF | #1E1E1E |
| **Primary text** | #212121 (87%) | #FFFFFF (87%) |
| **Secondary text** | #666666 (60%) | #B3B3B3 (60%) |
| **Disabled text** | #9E9E9E (38%) | #666666 (38%) |
| **Dividers** | #E0E0E0 | #424242 |
| **Shadows** | Black 10-20% | Reduced or none |
| **Primary color** | Brand color | Lighter/desaturated |

### 13.2 Dark Mode Principles

| Principle | Description |
|-----------|-------------|
| **Elevation = lightness** | Higher elevation = lighter surface |
| **Don't invert** | Перерисовывать, не инвертировать |
| **Reduce saturation** | Яркие цвета → более приглушённые |
| **Maintain contrast** | 4.5:1 still required |
| **Test separately** | Проверять оба режима |

### 13.3 Implementation

```css
/* CSS Variables approach */
:root {
  --bg-primary: #FFFFFF;
  --text-primary: #212121;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: #121212;
    --text-primary: #FFFFFF;
  }
}

/* Или через класс */
.dark-theme {
  --bg-primary: #121212;
  --text-primary: #FFFFFF;
}
```

---

## 14. Performance Considerations

### 14.1 Image Optimization

| Format | Use Case | Notes |
|--------|----------|-------|
| **WebP** | Photos, complex graphics | 25-35% smaller than JPEG |
| **AVIF** | Modern browsers | Even smaller |
| **SVG** | Icons, logos | Scalable, small |
| **PNG** | Transparency, simple graphics | Lossless |
| **JPEG** | Photos (fallback) | Good compression |

### 14.2 Font Performance

| Recommendation | Impact |
|----------------|--------|
| **font-display: swap** | Prevents FOIT |
| **Subset fonts** | Reduces file size |
| **Limit font weights** | 2-3 weights max |
| **Preload critical fonts** | Faster LCP |
| **Use system fonts** | Zero loading time |

### 14.3 Above-the-Fold Content

| Metric | Target |
|--------|--------|
| **First Contentful Paint (FCP)** | <1.8s |
| **Largest Contentful Paint (LCP)** | <2.5s |
| **Cumulative Layout Shift (CLS)** | <0.1 |
| **First Input Delay (FID)** | <100ms |

### 14.4 Design Impact on Performance

| Practice | Impact |
|----------|--------|
| **Limit web fonts** | Faster load |
| **Optimize images** | Smaller payload |
| **Lazy load below-fold** | Faster initial load |
| **Avoid layout shifts** | Better CLS |
| **Reduce DOM complexity** | Faster rendering |

---

## 15. Critical Checklist

### 15.1 Accessibility (Must Pass)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 1 | Text contrast | ≥4.5:1 | 🔴 Critical |
| 2 | Large text contrast | ≥3:1 | 🔴 Critical |
| 3 | UI component contrast | ≥3:1 | 🔴 Critical |
| 4 | Touch targets | ≥44×44 px | 🔴 Critical |
| 5 | Touch spacing | ≥8 px | 🔴 Critical |
| 6 | Keyboard accessible | All interactive elements | 🔴 Critical |
| 7 | Focus visible | Clear focus indicator | 🔴 Critical |
| 8 | Alt text | All meaningful images | 🔴 Critical |
| 9 | Form labels | All inputs labeled | 🔴 Critical |

### 15.2 Typography (Should Pass)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 10 | Minimum font size | ≥11 px | 🔴 Critical |
| 11 | Body text size | 16 px+ | 🟠 Important |
| 12 | Line height | 1.4-1.6 for body | 🟠 Important |
| 13 | Line length | 45-75 characters | 🟠 Important |
| 14 | Text resizable | Up to 200% | 🟠 Important |

### 15.3 Layout (Should Pass)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 15 | Responsive design | Works on all breakpoints | 🔴 Critical |
| 16 | Mobile-first | Designed for mobile | 🟠 Important |
| 17 | Consistent spacing | Using spacing scale | 🟠 Important |
| 18 | Grid alignment | Elements aligned to grid | 🟡 Recommended |

### 15.4 Components (Should Pass)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 19 | Button height | ≥40 px | 🟠 Important |
| 20 | Input height | ≥44 px on mobile | 🟠 Important |
| 21 | Input font size | 16 px on mobile | 🟠 Important |
| 22 | Component states | Hover, focus, disabled | 🟠 Important |

### 15.5 Performance (Recommended)

| # | Criterion | Requirement | Severity |
|---|-----------|-------------|----------|
| 23 | Font loading | 2-3 weights max | 🟡 Recommended |
| 24 | Image optimization | WebP/AVIF | 🟡 Recommended |
| 25 | Reduce motion | Supported | 🟡 Recommended |
| 26 | Dark mode | Supported | 🟡 Recommended |

---

## 16. Evaluation Scoring

### 16.1 Scoring System

| Category | Weight | Max Points |
|----------|--------|------------|
| **Accessibility** | 35% | 35 |
| **Typography** | 15% | 15 |
| **Layout & Responsive** | 20% | 20 |
| **Components** | 15% | 15 |
| **Visual Polish** | 10% | 10 |
| **Performance** | 5% | 5 |
| **Total** | 100% | **100** |

### 16.2 Accessibility Scoring (35 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Text contrast | 10 | All text ≥4.5:1 |
| UI contrast | 5 | All UI ≥3:1 |
| Touch targets | 8 | All ≥44×44 px |
| Keyboard access | 5 | All elements reachable |
| Focus visible | 4 | Clear focus indicators |
| Form labels | 3 | All inputs labeled |

### 16.3 Typography Scoring (15 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Font sizes | 5 | ≥16px body, hierarchy clear |
| Line height | 4 | 1.4-1.6 for body |
| Line length | 3 | 45-75 characters |
| Font loading | 3 | 2-3 weights, proper loading |

### 16.4 Layout & Responsive Scoring (20 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Mobile layout | 6 | Works on mobile |
| Tablet layout | 4 | Works on tablet |
| Desktop layout | 4 | Works on desktop |
| Spacing consistency | 3 | Using spacing scale |
| Grid alignment | 3 | Elements aligned |

### 16.5 Components Scoring (15 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Button specs | 5 | Correct sizes & states |
| Input specs | 5 | Correct sizes & states |
| Navigation | 5 | Proper height & spacing |

### 16.6 Visual Polish Scoring (10 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Dark mode | 4 | Proper implementation |
| Animations | 3 | Smooth, purposeful |
| Consistency | 3 | Unified design system |

### 16.7 Performance Scoring (5 points)

| Criterion | Points | Condition |
|-----------|--------|-----------|
| Image optimization | 2 | Modern formats |
| Font strategy | 2 | Efficient loading |
| Reduce motion | 1 | Supported |

### 16.8 Score Interpretation

| Score | Grade | Interpretation |
|-------|-------|----------------|
| 90-100 | A | Excellent, production ready |
| 80-89 | B | Good, minor improvements needed |
| 70-79 | C | Acceptable, several issues |
| 60-69 | D | Below standard, significant issues |
| <60 | F | Failing, major rework needed |

---

## 17. Quick Reference Card

### Universal Minimums (Web)

```
┌─────────────────────────────────────────────────────┐
│  WEB DESIGN MINIMUMS                                │
├─────────────────────────────────────────────────────┤
│  Text Contrast:        4.5:1 (normal), 3:1 (large)  │
│  UI Contrast:          3:1                          │
│  Touch Target:         ≥44×44 px                    │
│  Touch Spacing:        ≥8 px                        │
│  Body Font Size:       ≥16 px                       │
│  Min Font Size:        ≥11 px                       │
│  Line Height:          1.4-1.6 (body)               │
│  Line Length:          45-75 characters             │
│  Button Height:        40-48 px                     │
│  Input Height:         44-48 px                     │
│  Input Font (Mobile):  16 px (prevents zoom)        │
│  Page Margins:         16-32 px                     │
│  Animation Duration:   100-500 ms                   │
└─────────────────────────────────────────────────────┘
```

### Breakpoints Summary

```
┌──────────────┬──────────┬───────────────────┐
│  Name        │  Width   │  Columns          │
├──────────────┼──────────┼───────────────────┤
│  Mobile      │  <576px  │  4                │
│  Tablet      │  ≥768px  │  8                │
│  Desktop     │  ≥1200px │  12               │
│  Large       │  ≥1400px │  12               │
└──────────────┴──────────┴───────────────────┘
```

### Component Sizes

```
┌──────────────────┬──────────────────────────┐
│  Component       │  Size                    │
├──────────────────┼──────────────────────────┤
│  Header Height   │  56-80 px                │
│  Button (sm)     │  32 px                   │
│  Button (md)     │  40-44 px                │
│  Button (lg)     │  48-56 px                │
│  Input Field     │  40-48 px                │
│  Card Padding    │  16-24 px                │
│  Card Radius     │  8-16 px                 │
│  Modal Width     │  400-560 px (desktop)    │
│  Sidebar         │  200-280 px              │
│  Tab Height      │  40-48 px                │
│  Avatar (md)     │  40-48 px                │
└──────────────────┴──────────────────────────┘
```

---

## 18. AI Evaluation Prompt Template

```markdown
## Web Design Evaluation Request

**Design Type**: [Landing Page / Dashboard / E-commerce / Blog / App]
**Primary Viewport**: [Desktop / Mobile / Both]
**Design File**: [attached]

### Evaluate against:
1. WCAG 2.2 AA accessibility requirements
2. Typography specifications
3. Responsive layout across breakpoints
4. Component sizes and states
5. Provide score breakdown by category
6. List specific issues with locations
7. Suggest fixes for each issue

### Output Format:
- Overall Score: X/100 (Grade)
- Category Scores
- Critical Issues (must fix for accessibility)
- Important Issues (should fix for quality)
- Recommendations (nice to have)
- Responsive Notes
```

---

## Версия документа

| Параметр | Значение |
|----------|----------|
| Версия | 1.0 |
| Дата создания | 2025-02 |
| Источники | WCAG 2.2, W3C WAI, MDN, USWDS, NNGroup, Bootstrap, Tailwind |
| Назначение | AI-оценка веб-дизайн макетов |

---

## Связанные документы

1. `cross-platform-design-system.md` — Кросс-платформенная система (iOS + Android)
2. `ios-human-interface-guidelines.md` — Apple iOS HIG
3. `android-design-guidelines.md` — Android Design Guidelines
4. `material-design-3-guidelines.md` — Material Design 3

> **Использование**: Этот документ специфичен для веб-дизайна.
> Для мобильного дизайна используйте platform-specific документы.
