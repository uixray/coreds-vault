---
title: "Tab Bar / Bottom Navigation"
type: pattern
category: platform
status: draft
version: "0.1.0"
created: 2026-02-27
updated: 2026-02-27
freshness: current
freshness_checked: 2026-02-27
tags:
  - type/pattern
  - category/platform
  - platform/web
  - platform/ios
  - platform/android
  - navigation
related_components:
  - "[[bottom-navigation]]"
  - "[[icon]]"
  - "[[badge]]"
related_tokens:
  - "[[spacing]]"
  - "[[color]]"
  - "[[typography]]"
related_patterns:
  - "[[sidebar-navigation]]"
  - "[[back-navigation]]"
related_heuristics:
  - "[[nielsen-10#recognition-over-recall]]"
  - "[[millers-law]]"
  - "[[fitts-law]]"
platforms: [web, iOS, Android]
---

# Tab Bar / Bottom Navigation

## Проблема (Problem)

Пользователю нужно быстро переключаться между 3–5 основными разделами приложения, сохраняя ориентацию в структуре и понимание текущего положения.

## Контекст (Context)

### Когда использовать
- Приложение имеет 3–5 равнозначных разделов верхнего уровня
- Пользователь часто переключается между разделами
- Каждый раздел имеет собственную навигацию внутри
- Мобильное приложение или мобильная версия web

### Когда НЕ использовать
- Менее 3 разделов (используй другой паттерн навигации)
- Более 5 разделов (используй hamburger menu / sidebar + more)
- Контент-ориентированное приложение с линейным flow (используй back navigation)
- Только desktop web (используй horizontal nav / sidebar)

## Решение (Solution)

Фиксированная панель внизу экрана с 3–5 иконками (опционально + текстовые метки), каждая ведёт к корневому экрану раздела. Активный раздел визуально выделен. Панель всегда видна вне зависимости от скролла контента.

**Ключевые принципы:**
- Иконки + текст > только иконки (распознаваемость, [[nielsen-10#recognition-over-recall|Heuristic #6]])
- 3–5 элементов ([[millers-law|Miller's Law]] — меньше когнитивной нагрузки)
- Большие touch targets ([[fitts-law|Fitts's Law]] — элементы внизу экрана ближе к большому пальцу)
- Активный элемент визуально отличается (цвет, размер, заливка иконки)

## Платформенные адаптации (Platform Adaptations)

| Аспект | Web (mobile) | iOS | Android |
|--------|-------------|-----|---------|
| **Компонент** | `<nav>` с role="tablist" | `UITabBarController` / `TabView` (SwiftUI) | `NavigationBar` (Material 3) |
| **Расположение** | Фиксированно внизу viewport | Фиксированно внизу, над Home Indicator | Фиксированно внизу |
| **Максимум элементов** | 5 | 5 (+ "More" tab) | 5 |
| **Текстовые метки** | Под иконкой | Под иконкой (обязательно по HIG) | Под иконкой (опционально в M3) |
| **Badge** | Кастомный | Нативный `UITabBarItem.badgeValue` | `BadgedBox` в Material 3 |
| **Анимация перехода** | CSS transition / нет | Нативный crossfade | Container transform (M3) |
| **Safe areas** | `env(safe-area-inset-bottom)` | Home Indicator автоматически | Gesture navigation bar |
| **Haptic feedback** | Нет | UIImpactFeedbackGenerator (.light) | HapticFeedbackConstants |
| **Min touch target** | 44×44px (WCAG) | 44×44pt (HIG) | 48×48dp (Material) |

### Web (Mobile)

```html
<nav role="tablist" aria-label="Main navigation">
  <a role="tab" aria-selected="true" href="/home">
    <svg><!-- icon --></svg>
    <span>Home</span>
  </a>
  <a role="tab" aria-selected="false" href="/search">
    <svg><!-- icon --></svg>
    <span>Search</span>
  </a>
</nav>
```

Токены:
- Высота: `space.component.tab-bar.height` (56px mobile, скрыто на desktop)
- Фон: `color.surface.primary`
- Активный цвет: `color.action.primary.default`
- Неактивный: `color.on-surface.secondary`
- Border top: `color.border.default`, 1px

### iOS (HIG)

- Используй системный `UITabBarController` — он автоматически обрабатывает safe areas, haptics, VoiceOver
- Иконки: SF Symbols (filled для active, outlined для inactive)
- Текстовые метки **обязательны** (HIG: "Always include text labels")
- Badge: системный `.badgeValue` — красный кружок с числом
- Translucent background по умолчанию (blur)
- Не скрывай tab bar при скролле (anti-pattern на iOS)

### Android (Material Design 3)

- `NavigationBar` из Material 3 Compose
- Иконки: Material Symbols (filled для active)
- Active indicator: цветная подложка под активной иконкой (M3 signature)
- Текстовые метки: показывать для активного элемента, опционально для остальных
- Badge: `BadgedBox` — число или точка
- Может скрываться при скролле вниз (M3 допускает)
- Minimum 3 destinations, maximum 5

## Связанные компоненты CoreDS

- [[bottom-navigation]] — основной компонент
- [[icon]] — иконки в tab items
- [[badge]] — notification badges на tab items

## Связанные токены

| Токен | Значение | Описание |
|-------|---------|----------|
| `space.component.tab-bar.height` | 56px / 56pt / 80dp | Высота панели (Android 80dp с label) |
| `space.target.min` | 44px / 44pt / 48dp | Минимальный touch target |
| `color.surface.primary` | — | Фон панели |
| `color.action.primary.default` | — | Цвет активного элемента |
| `color.on-surface.secondary` | — | Цвет неактивного элемента |
| `color.border.default` | — | Верхняя граница (web) |
| `typo.label.sm` | 10–12sp | Размер текстовых меток |

## Эвристики и принципы

| Эвристика | Как этот паттерн её поддерживает |
|-----------|--------------------------------|
| [[nielsen-10#visibility\|#1 Visibility of system status]] | Активный tab показывает текущее положение |
| [[nielsen-10#recognition-over-recall\|#6 Recognition over recall]] | Иконки + метки не требуют запоминания |
| [[nielsen-10#consistency\|#4 Consistency]] | Панель всегда на месте, одинаковое поведение |
| [[fitts-law\|Fitts's Law]] | Нижнее расположение — в зоне большого пальца |
| [[millers-law\|Miller's Law]] | 3–5 элементов — не перегружает рабочую память |
| [[jakobs-law\|Jakob's Law]] | Пользователи ожидают tab bar внизу на мобильных |

## Accessibility

- **WCAG:** Role `tablist` + `tab`, `aria-selected`, `aria-label`
- **Keyboard:** Tab/Shift+Tab для навигации, Enter/Space для активации
- **Screen reader:** Объявляет "Tab N of M, selected/not selected"
- **Motor:** Минимальный touch target 44px/48dp, достаточный отступ между элементами
- **Visual:** Контраст активного/неактивного ≥ 3:1 для иконок

## Примеры из реальных продуктов

| Продукт | Платформа | Реализация |
|---------|----------|------------|
| Instagram | iOS + Android | 5 tabs: Home, Search, Reels, Shop, Profile. Brand-oriented — одинаково на обеих платформах |
| Telegram | iOS | 5 tabs с системным UITabBarController. Platform-oriented |
| Telegram | Android | Bottom navigation с Material 3 active indicator. Platform-oriented |
| Twitter/X | iOS + Android | 4 tabs: Home, Search, Notifications, Messages. Brand-oriented approach |
| Spotify | iOS + Android | 3 tabs: Home, Search, Library. Минималистичный, brand-oriented |

## Источники

- [Apple HIG: Tab Bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars)
- [Material Design 3: Navigation Bar](https://m3.material.io/components/navigation-bar)
- [Nielsen Norman Group: Navigation for Mobile](https://www.nngroup.com/articles/mobile-navigation/)
- [W3C WAI: Tabs Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/)

## Changelog

| Дата | Версия | Изменение |
|------|--------|-----------|
| 2026-02-27 | 0.1.0 | Создание |
