---
title: "Admin Panel Design Guide"
type: "guide"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/guide"
  - "category/domain"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Design guide for admin panel and SaaS dashboard interfaces"
category: "domain"
---

# 📊 Полный гайд по созданию качественной админ-панели для кроссплатформенной разработки

**Версия:** 2025  
**Назначение:** UI/UX дизайнеры, создающие админ-панели на Flutter, Web и Desktop  
**Время на изучение:** 30-45 минут

---

## 📑 Содержание

1. [Принципы дизайна админ-панели](#принципы)
2. [Архитектура и структура](#архитектура)
3. [Компоненты и паттерны](#компоненты)
4. [Кроссплатформенный дизайн](#кроссплатформа)
5. [Система цвета и типография](#система)
6. [Навигация и взаимодействие](#навигация)
7. [Таблицы данных](#таблицы)
8. [Отзывчивость](#отзывчивость)
9. [Доступность](#доступность)
10. [Контрольный список](#контрольный-список)

---

## 🎯 Принципы дизайна админ-панели {#принципы}

### 1. **Простота и четкость интерфейса**
- Удалите лишние элементы, оставьте только необходимое
- Интерфейс должен быть понятен с первого взгляда
- Избегайте визуального шума и перегруженности

**Почему это важно для админов:**
- Администраторы — опытные пользователи, ценящие скорость
- Они часто используют панель в условиях цейтнота
- Неправильные клики стоят времени и деньги

### 2. **Эффективность и производительность**
- Все часто используемые действия — максимум в 2 клика
- Быстрая загрузка данных (< 1 сек для первого экрана)
- Интуитивная навигация без обучения

### 3. **Последовательность дизайна**
- Единственный внешний вид на всех платформах
- Консистентные элементы: кнопки, иконки, пробелы, цвета
- Одинаковые правила для одинаковых действий

### 4. **Полезность для администратора**
- Дизайн построен вокруг реальных задач админов
- Каждый элемент служит цели
- Модернизируется на основе feedback

### 5. **Быстрота выполнения операций**
- Горячие клавиши и ярлыки для опытных пользователей
- Сортировка, фильтры, поиск всегда в видимости
- Массовые операции (bulk actions) для экономии времени

---

## 🏗️ Архитектура и структура {#архитектура}

### Классический макет 3-колонной админ-панели

```
┌─────────────────────────────────────────────────────┐
│                     TOP BAR (Header)                │ ← 56-64px
├──────────┬─────────────────────────────────────────┤
│          │                                         │
│ SIDEBAR  │           MAIN CONTENT AREA             │
│ (Nav)    │          (Pages/Screens)               │
│          │                                         │
│ 256px    │                Flex                     │
│ (desktop)│                                         │
│          │                                         │
└──────────┴─────────────────────────────────────────┘
```

### Компоненты архитектуры:

| Компонент | Назначение | Размер |
|-----------|-----------|--------|
| **Header/Top Bar** | Логотип, поиск, профиль, уведомления | 56-64px высота |
| **Sidebar** | Основная навигация | 256px (desktop), 280px (tablet) |
| **Main Content** | Основной контент страницы | Flex |
| **Right Panel** (опционально) | Фильтры, быстрые действия, детали | 300-320px |

### Виды сайдбара

#### 1. **Persistent Sidebar** (для Desktop)
- Всегда видимый, не занимает место
- Показывает иконку + текст или только иконку (свернут)
- Позволяет быстро переключаться между разделами

#### 2. **Collapsible Sidebar** (для Tablet)
- Может быть свернут в иконки
- При клике на иконку = сворачивается/разворачивается
- Сохраняет выбранное состояние (localStorage)

#### 3. **Modal/Drawer Sidebar** (для Mobile)
- Выезжает поверх контента с анимацией
- Закрывается кликом на контент или крестик
- Hamburger меню в header

---

## 🎨 Компоненты и паттерны {#компоненты}

### 1. **Кнопки и действия**

```
SIZES:
├─ Small (Sm): 32px × 12-16px text (для secondary actions)
├─ Medium (Md): 40px × 14px text (стандарт)
├─ Large (Lg): 48px × 16px text (для CTA или важных действий)
└─ Extra Large (Xl): 56px × 18px text (редко)

VARIANTS:
├─ Primary (filled): Основные действия (создать, сохранить, отправить)
├─ Secondary (outlined): Вторичные действия (отмена, назад)
├─ Tertiary (ghost): Редкие действия, ссылки (помощь, детали)
└─ Danger (red): Деструктивные действия (удалить, отключить)

STATES:
├─ Default: Основное состояние
├─ Hover: +10% светлее/темнее
├─ Active: Нажата (более интенсивный цвет)
├─ Disabled: 50% opacity + cursor: not-allowed
└─ Loading: Spinner + disabled состояние
```

**Пример использования:**
- ✅ Создать новую запись → Primary Large
- ✅ Фильтры → Secondary Medium
- ✅ Отмена → Secondary Medium или Tertiary
- ✅ Удалить → Danger Medium

### 2. **Формы и поля ввода**

```
ПОЛЕ ВВОДА:
├─ Высота: 40px (standard) или 36px (compact)
├─ Padding: 8px-12px (горизонтальное), 10px-12px (вертикальное)
├─ Border: 1px solid (по умолчанию в цвете border)
├─ Border-radius: 6-8px
├─ Font: 14px, line-height 1.5
└─ Placeholder: -40% opacity от основного текста

STATES:
├─ Default: Border серый, фон светлый
├─ Focus: Border primary color, outline 2px solid (focus ring)
├─ Disabled: 50% opacity, курсор not-allowed
├─ Error: Border красный, error message под полем
└─ Success: Border зеленый, success message под полем

ТИПЫ:
├─ Text input: Для текста, email, URL
├─ Number input: Со стрелочками ↑↓ (или выключить)
├─ Select dropdown: Список значений
├─ Textarea: Для многострочного текста
├─ Checkbox: Для boolean значений
├─ Radio button: Для выбора одного из нескольких
├─ Toggle/Switch: Вкл/Выкл
└─ Date picker: Для выбора даты/времени
```

### 3. **Карточки (Cards)**

```
СТРУКТУРА:
┌─────────────────────────┐
│ [Icon/Image] Title      │ ← Header (опционально)
├─────────────────────────┤
│                         │
│  Основной контент      │ ← Body
│  (текст, числа, и т.д.)│
│                         │
├─────────────────────────┤
│ [Button1]  [Button2]   │ ← Footer (опционально)
└─────────────────────────┘

ПАРАМЕТРЫ:
├─ Padding: 16px-24px
├─ Border-radius: 8-12px
├─ Box-shadow: 0 1px 3px rgba(0,0,0,0.1)
├─ Hover shadow: 0 4px 12px rgba(0,0,0,0.15)
├─ Background: white (light mode) / charcoal (dark mode)
└─ Border: 1px solid (optional, для структуры)
```

### 4. **Модалы и диалоги**

```
СТРУКТУРА:
┌──────────────────────────────┐
│ [Title]            [Close X] │ ← Header
├──────────────────────────────┤
│                              │
│  Основной контент            │ ← Body (max 600px ширина)
│  (вопрос, форма, и т.д.)    │
│                              │
├──────────────────────────────┤
│ [Cancel]        [Confirm]   │ ← Footer (actions)
└──────────────────────────────┘

ПРАВИЛА:
├─ Max-width: 600px (небольшие), 800px (средние), 1000px (большие)
├─ Backdrop: rgba(0,0,0,0.5) (затемнение)
├─ Z-index: высокий (выше всех элементов)
├─ Появление: Fade in (200-250ms)
├─ Закрытие: ESC, click на backdrop, click на close
└─ Keyboard support: Tab, Enter для подтверждения
```

### 5. **Уведомления и Toast**

```
ТИПЫ:
├─ Success (зеленый): "Сохранено успешно"
├─ Error (красный): "Ошибка загрузки данных"
├─ Warning (оранжевый): "Это действие необратимо"
├─ Info (голубой): "Новые данные доступны"
└─ Loading (серый): "Загрузка в процессе..."

ПОЗИЦИЯ:
├─ Top-right: Стандарт (заметна, не мешает)
├─ Top-center: Важные сообщения
├─ Bottom-center: Мобильные уведомления
└─ Bottom-right: Альтернатива

ПАРАМЕТРЫ:
├─ Ширина: 300-400px (touch-friendly)
├─ Padding: 16px
├─ Border-radius: 8px
├─ Shadow: 0 4px 12px rgba(0,0,0,0.15)
├─ Auto-close: 4-6 сек (кроме error)
└─ Animation: Slide in (top/bottom) или Fade in
```

---

## 🌐 Кроссплатформенный дизайн {#кроссплатформа}

### Стратегия адаптации под платформы

#### **Desktop Web (1920px и выше)**
```
├─ Полный макет: Sidebar + Content + Right Panel
├─ Использование всего пространства экрана
├─ Наведение (hover) = основной interaction
├─ Keyboard shortcuts (Cmd+K для поиска, и т.д.)
├─ Context menu при правом клике
└─ Возможность закреплять/перетаскивать панели
```

#### **Tablet (600px - 1024px)**
```
├─ Компактный sidebar (только иконки)
├─ Content занимает большинство места
├─ Right panel может быть спрятана в drawer
├─ Touch-friendly элементы (48px minimum)
├─ Навигация: Hamburger меню или Tab navigation
└─ Landscape ориентация = desktop layout
```

#### **Mobile (320px - 599px)**
```
├─ Fullscreen content (sidebar скрыт)
├─ Hamburger меню в header
├─ Bottom navigation (опционально)
├─ Touch-friendly: минимум 48px × 48px для кнопок
├─ Вертикальная ориентация = stack все в колонку
├─ Drawer для фильтров вместо sidebar
└─ Модальные окна на весь экран
```

### Responsive Breakpoints (Flutter + Web)

```
MOBILE:
├─ Extra Small (xs): 320px - 479px (старые телефоны)
├─ Small (sm): 480px - 599px (стандартные телефоны)

TABLET:
├─ Medium (md): 600px - 839px (планшеты в портретной)
├─ Large (lg): 840px - 1023px (планшеты в ландшафтной)

DESKTOP:
├─ Extra Large (xl): 1024px - 1279px (ноутбуки)
├─ 2XL (2xl): 1280px - 1535px (мониторы 1080p)
├─ 3XL (3xl): 1536px - 1919px (мониторы 1440p)
└─ 4XL (4xl): 1920px+ (ultrawide / 4K)

Flutter equivalent:
final screenWidth = MediaQuery.of(context).size.width;
if (screenWidth < 600) {
  // Mobile layout
} else if (screenWidth < 1024) {
  // Tablet layout
} else {
  // Desktop layout
}
```

### Принципы адаптации компонентов

| Компонент | Mobile | Tablet | Desktop |
|-----------|--------|--------|---------|
| **Sidebar** | Drawer | Compact (icons) | Full (persistent) |
| **Button size** | 48×48px | 40×40px | 40×40px |
| **Padding** | 12px | 16px | 20-24px |
| **Font size** | 14px | 14px | 14px |
| **Card width** | Full | 300-400px | 350-450px |
| **Table columns** | 2-3 | 4-6 | 6-10 |
| **Navigation** | Hamburger | Compact tabs | Full sidebar |

---

## 🎨 Система цвета и типография {#система}

### Палитра цветов для админ-панели

```
PRIMARY COLORS (основные):
├─ Primary: #208D9F (teal, для CTA и important actions)
├─ Primary-hover: #1A7485
├─ Primary-active: #1A6471
└─ Primary-disabled: rgba(32, 141, 159, 0.5)

NEUTRAL COLORS (фоны и текст):
├─ Background (light): #FCFCF9
├─ Surface (light): #FFFFFF
├─ Text primary (dark): #134252
├─ Text secondary (muted): #626C71
└─ Border: rgba(94, 82, 64, 0.2)

STATUS COLORS:
├─ Success: #2B8041 (зеленый, для успешных действий)
├─ Warning: #A84B2F (оранжевый, для предупреждений)
├─ Error: #C01530 (красный, для ошибок)
└─ Info: #627C71 (серый, для информации)

DARK MODE:
├─ Background: #1F2121
├─ Surface: #262828
├─ Text primary: #F5F5F5
├─ Text secondary: #A7A9A9
└─ Primary: #32B8C6
```

**Контрастность (WCAG AA минимум):**
- Text vs Background: 4.5:1 (normal text)
- Large text (18pt+): 3:1
- UI components: 3:1

### Типография

```
FONT FAMILY:
├─ Headings: System font stack (-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto)
├─ Body text:같은 (inter, Geist, or system fonts)
└─ Monospace: Monaco, 'Menlo', 'Ubuntu Mono' (для code, IDs)

SIZE & WEIGHT:
├─ H1 (Page title): 32px, 600 weight
├─ H2 (Section title): 24px, 600 weight
├─ H3 (Subsection): 20px, 600 weight
├─ H4 (Card title): 18px, 600 weight
├─ H5 (Label): 16px, 600 weight
├─ Body (regular): 14px, 400 weight
├─ Body (emphasis): 14px, 500 weight
├─ Small (caption): 12px, 400 weight
└─ Monospace (code): 13px, 400 weight

LINE HEIGHT:
├─ Headings: 1.2
├─ Body text: 1.5
├─ Tight text: 1.35
└─ Captions: 1.4

LETTER SPACING:
├─ Headings: -0.01em (tight)
├─ Body: 0
└─ Buttons: 0.5px
```

---

## 🧭 Навигация и взаимодействие {#навигация}

### Структура навигации в сайдбаре

```
SIDEBARE STRUCTURE:
┌──────────────────────┐
│  Logo/Branding      │ ← 64px
├──────────────────────┤
│  🔍 Search          │ ← Quick search
├──────────────────────┤
│                      │
│ Main Navigation      │ ← Primary items (max 8-10)
│ ├─ Dashboard         │
│ ├─ Users            │
│ ├─ Products         │
│ ├─ Orders           │
│ └─ Settings         │
│                      │
├──────────────────────┤
│                      │
│ Secondary Nav       │ ← Collapsible sections
│ ├─ Help             │
│ ├─ Documentation    │
│ └─ Settings         │
│                      │
├──────────────────────┤
│ [👤 Profile]        │ ← Sticky (внизу)
│ [⚙️ Settings]       │
│ [🚪 Logout]         │
└──────────────────────┘
```

### Иконки в навигации

```
✅ ИСПОЛЬЗУЙ ИКОНКИ ДЛЯ:
├─ Быстрого визуального распознания
├─ Экономии пространства (compact mode)
├─ Усиления узнаваемости (Dashboard, Users, Cart)
└─ Поддержки интернационализации (без текста)

ПРАВИЛА:
├─ Одинаковый стиль всех иконок (все линии или все filled)
├─ Размер: 24px (normal) или 20px (compact)
├─ Цвет: primary color или neutral (при hover)
├─ Всегда подпиши иконку текстом (для accessibility)
└─ Используй Material Icons, Lucide, или Heroicons

ИКОНКИ ДЛЯ АДМИН-ПАНЕЛИ:
├─ Dashboard: 📊 bar-chart-2 / grid
├─ Users: 👥 users / people
├─ Products: 📦 box / shopping-bag
├─ Orders: 📋 list / shopping-cart
├─ Analytics: 📈 trending-up / line-chart
├─ Settings: ⚙️ settings / sliders
├─ Reports: 📄 file-text / document
└─ Notifications: 🔔 bell
```

### Взаимодействия и состояния

```
NAVIGATION ITEM STATES:

DEFAULT (неактивный):
├─ Цвет текста: Secondary (muted)
├─ Иконка: Secondary color
└─ Background: Transparent

HOVER (наведение мыши):
├─ Background: Primary color @ 10% opacity
├─ Цвет текста: Primary color
├─ Иконка: Primary color
└─ Transition: 150ms ease

ACTIVE (текущая страница):
├─ Background: Primary color @ 15% opacity
├─ Цвет текста: Primary color (bold)
├─ Иконка: Primary color
├─ Левый border: 4px primary color
└─ Font-weight: 600

COLLAPSED SIDEBAR (compact):
├─ Только иконки показываются
├─ На hover = tooltip с названием
├─ Active indicator = точка/подсветка под иконкой
└─ Width: 64px (vs 256px полный)
```

---

## 📊 Таблицы данных {#таблицы}

### Структура и компоновка таблицы

```
┌─────────────────────────────────────────────────────┐
│ [Toolbar]                                           │
│ ├─ [+ Create]  [🔍 Search]  [⚙️ Filters] [⋮ More] │
├─────────────────────────────────────────────────────┤
│ ☐ | Name        | Email        | Role  | Actions  │ ← Header
├─────────────────────────────────────────────────────┤
│ ☑ | John Doe    | john@ex.com  | Admin | ⋮ menu  │ ← Row (selected)
│ ☐ | Jane Smith  | jane@ex.com  | User  | ⋮ menu  │
│ ☐ | Mike Brown  | mike@ex.com  | User  | ⋮ menu  │
│ ☐ | ...         | ...          | ...   | ...    │
├─────────────────────────────────────────────────────┤
│ Showing 1-10 of 87  | [< Prev] [1] [2] [3] [Next >] │ ← Pagination
└─────────────────────────────────────────────────────┘
```

### Параметры таблицы

```
РАЗМЕРЫ:
├─ Row height: 48px (normal) или 56px (spacious)
├─ Header height: 44px
├─ Padding (cell): 12px-16px (горизонтальное)
├─ Min column width: 80px
└─ Max column width: зависит от контента

ТИПЫ КОЛОНОК:
├─ Text: Обычный текст
├─ Number: Выровнен по правому краю
├─ Status: С badge/tag
├─ Date: Formatted (DD.MM.YYYY или MM/DD/YYYY)
├─ Avatar: Иконка/фото слева
└─ Actions: Меню (три точки) или кнопки

ИНТЕРАКТИВНОСТЬ:
├─ Row click: Открыть детали / редактор
├─ Checkbox: Выбрать для массовых операций
├─ Sort: Кликнуть на заголовок колонки
├─ Filter: Значок фильтра в заголовке
├─ Search: Поле поиска в toolbar
├─ Pagination: Выбор количества (10, 25, 50)
├─ Expand row: Раскрыть дополнительные детали
└─ Inline edit: Редактировать прямо в таблице
```

### Мобильная версия таблицы

```
ВАРИАНТ 1: Card layout
┌─────────────────────────┐
│ John Doe         [⋮]    │ ← Name + action menu
├─────────────────────────┤
│ Email: john@ex.com     │
│ Role: Admin            │
│ Status: Active         │
└─────────────────────────┘

ВАРИАНТ 2: Свернутая таблица
┌─────────────────────────┐
│ John Doe    Admin [→]   │ ← Tap to expand
│ john@ex.com             │
└─────────────────────────┘

ВАРИАНТ 3: Bottom sheet
┌─────────────────────────┐
│ Детали                  │ (вынырнуть bottom sheet
│ ├─ Name: John Doe      │  при нажатии на row)
│ ├─ Email: john@...     │
│ ├─ Role: Admin         │
│ └─ [Edit] [Delete]    │
└─────────────────────────┘
```

---

## 📱 Отзывчивость {#отзывчивость}

### Контрольный список отзывчивости

```
MOBILE (320px - 599px):
├─ [ ] Все элементы вертикально стакированы
├─ [ ] Минимум 48px × 48px для кнопок/касаний
├─ [ ] Максимум ширина текста 100% (word-wrap)
├─ [ ] No horizontal scroll (кроме таблиц)
├─ [ ] Hamburger меню вместо sidebar
├─ [ ] Упрощенные формы (1 колонка)
├─ [ ] Уменьшены отступы (12px вместо 20px)
├─ [ ] Иконки/изображения масштабированы
├─ [ ] Touch targets не перекрываются
├─ [ ] Шрифты читаемы (минимум 14px)
└─ [ ] Таблицы преобразованы в card layout

TABLET (600px - 1023px):
├─ [ ] Двух-колонный layout возможен
├─ [ ] Sidebar может быть compact (иконки)
├─ [ ] Content + Right panel side-by-side
├─ [ ] Grid: 2-3 колонки для карточек
├─ [ ] Padding: 16px (стандарт)
├─ [ ] Font size: 14px (как desktop)
├─ [ ] Таблицы: 4-6 колонок видимо
└─ [ ] Модальные окна: 90% width (max 600px)

DESKTOP (1024px+):
├─ [ ] Полный layout: sidebar + content + right panel
├─ [ ] Padding: 20-24px
├─ [ ] Grid: 3-4+ колонки для карточек
├─ [ ] Таблицы: 6-10+ колонок (с горизонтальным scroll)
├─ [ ] Hover effects работают
├─ [ ] Context menus доступны
├─ [ ] Keyboard shortcuts функционируют
└─ [ ] Multi-panel workflow поддерживается
```

---

## ♿ Доступность (Accessibility) {#доступность}

### WCAG 2.1 Level AA Чеклист

```
ЗРЕНИЕ:
├─ [ ] Контрастность текста минимум 4.5:1
├─ [ ] Не полагаться только на цвет (добавь иконку/текст)
├─ [ ] Focus indicator видим (outline: 2px solid)
├─ [ ] Text size увеличивается на 200% без потери функциональности
├─ [ ] No flashing (> 3 раз в секунду)
└─ [ ] Images имеют alt text, icons имеют aria-label

СЛУХ:
├─ [ ] Звуковые сигналы имеют визуальную альтернативу
├─ [ ] Видео имеет субтитры
└─ [ ] Важная информация не только в аудио

МОТОРИКА (Keyboard):
├─ [ ] Все функции доступны через клавиатуру
├─ [ ] Tab order логичен и визуален
├─ [ ] Можно закрыть модальное окно через ESC
├─ [ ] Нет keyboard trap (не застревают в элементе)
├─ [ ] Можно использовать стрелки для выбора
├─ [ ] Skip links для быстрого перехода (например, к контенту)
└─ [ ] Hover и click имеют одинаковый результат

КОГНИТИВНОСТЬ:
├─ [ ] Язык простой и понятный
├─ [ ] Предсказуемая навигация
├─ [ ] Четкие error messages (что не так + как исправить)
├─ [ ] Labels для всех input полей
├─ [ ] Подтверждение перед деструктивными действиями
└─ [ ] Достаточно времени на взаимодействие (no timeout)

СКРИНРИДЕРЫ (Screen Readers):
├─ [ ] Semantic HTML (<button>, <input>, <label>, <nav>)
├─ [ ] ARIA labels где нужно (<nav aria-label="main">)
├─ [ ] ARIA roles для custom компонентов
├─ [ ] ARIA live regions для обновления контента
├─ [ ] Таблицы имеют <th> и <caption>
└─ [ ] Form fields связаны с labels (<label for="id">)
```

### Примеры кода для доступности

```html
<!-- ХОРОШО: Semantic HTML -->
<nav aria-label="Main navigation">
  <a href="/dashboard" aria-current="page">Dashboard</a>
  <a href="/users">Users</a>
</nav>

<!-- ПЛОХО: Div с onclick -->
<div role="button" onclick="navigate('/dashboard')">
  Dashboard
</div>

<!-- ХОРОШО: Form с labels -->
<label for="email">Email Address</label>
<input 
  id="email" 
  type="email" 
  placeholder="john@example.com"
  aria-describedby="email-help"
/>
<small id="email-help">We'll never share your email.</small>

<!-- ХОРОШО: Status update с aria-live -->
<div aria-live="polite" aria-atomic="true">
  Items saved successfully
</div>

<!-- ХОРОШО: Data table -->
<table role="grid">
  <caption>User List</caption>
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th>Role</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>John Doe</td>
      <td>john@example.com</td>
      <td>Admin</td>
    </tr>
  </tbody>
</table>
```

---

## 🔐 Безопасность и разрешения {#безопасность}

### Role-Based Access Control (RBAC)

```
РОЛИ И РАЗРЕШЕНИЯ:

Admin:
├─ Просмотр: Все
├─ Редактирование: Все
├─ Удаление: Все
├─ Управление пользователями: Да
└─ Доступ к аналитике: Да

Manager:
├─ Просмотр: Свой отдел + подчиненные
├─ Редактирование: Свой отдел
├─ Удаление: Ограничено
├─ Управление пользователями: Только подчиненные
└─ Доступ к аналитике: Свой отдел

User:
├─ Просмотр: Только свои данные
├─ Редактирование: Только свои данные
├─ Удаление: Нет
├─ Управление пользователями: Нет
└─ Доступ к аналитике: Ограничено

IMPLEMENTATION:
├─ Скрывай недоступные пункты меню
├─ Отключай кнопки для которых нет доступа
├─ Показывай tooltip "У вас нет доступа"
├─ Логируй попытки несанкционированного доступа
└─ Используй backend проверку (не полагайся только на frontend)
```

### Визуальные индикаторы разрешений

```
ВАРИАНТЫ ОТОБРАЖЕНИЯ:

1. Скрывание элемента (best):
   Если нет доступа → элемент не видим вообще

2. Отключение элемента:
   [Create User] (disabled) ← Gray out
   💡 "Upgraded plan required" (tooltip на hover)

3. Modal блокировка:
   Пользователь кликает на кнопку → модаль
   "Upgrade to Pro to access this feature"

4. Иконка с подсказкой:
   [Edit] 🔒 (locked icon)
   "Only admins can edit" (title attribute)
```

---

## 🎬 Анимации и переходы {#анимации}

### Рекомендуемые длительности

```
СТАНДАРТНЫЕ ДЛИТЕЛЬНОСТИ:

Fast (150ms):
├─ Button hover/focus
├─ Dropdown menu появление
├─ Toggle switch
└─ Checkbox/radio check

Normal (250ms) - DEFAULT:
├─ Modal появление
├─ Sidebar toggle
├─ Theme change
└─ Page transition

Slow (400ms):
├─ Complex animations
├─ Page load spinner
└─ Важные уведомления

EASING FUNCTIONS:

ease-in-out: Стандартный (cubic-bezier(0.4, 0, 0.2, 1))
ease-out: Быстрое начало, медленное завершение (для входа)
ease-in: Медленное начало, быстрое завершение (для выхода)
linear: Редко (для rotating loaders)

ПРИМЕРЫ:
├─ Появление элемента: fade-in (200ms ease-out)
├─ Скрытие элемента: fade-out (150ms ease-in)
├─ Переместить элемент: transform 250ms ease-in-out
└─ Изменение цвета: background-color 200ms ease-in-out
```

### Анимации для админ-панели

```
SIDEBAR TOGGLE:
├─ Width изменяется (256px → 64px)
├─ Duration: 250ms
├─ Easing: ease-in-out
├─ Text fade out одновременно
└─ Иконки stay visible

MODAL ENTRANCE:
├─ Backdrop fade in (200ms)
├─ Modal scale up (0.9 → 1.0) + fade in (200ms)
├─ Both simultaneous
└─ Easing: ease-out

TABLE ROW SELECTION:
├─ Checkbox animation: scale (0.8 → 1.0)
├─ Row background color change (200ms)
├─ No dramatic movements
└─ Easing: ease-out

LOADING SPINNER:
├─ Rotate 360deg (1500ms)
├─ Linear easing (continuous)
├─ Пульсирование opacity для варианта 2
└─ Overlay blur background (200ms)
```

---

## ✅ Контрольный список перед передачей разработчику {#контрольный-список}

### Дизайн-аспекты

- [ ] **Структура**
  - [ ] Все страницы имеют согласованный layout
  - [ ] Навигация одинакова на всех страницах
  - [ ] Header и Footer uniform

- [ ] **Компоненты**
  - [ ] Все кнопки имеют estados (default, hover, active, disabled)
  - [ ] Все input поля имеют states (default, focus, error, disabled)
  - [ ] Модальные окна имеют animations
  - [ ] Tables имеют hover и selected states

- [ ] **Цвета**
  - [ ] Используются только цвета из palette
  - [ ] Контрастность минимум 4.5:1
  - [ ] Dark mode версия создана
  - [ ] Color variables документированы

- [ ] **Типография**
  - [ ] Используется одна font family (максимум 2)
  - [ ] Font sizes соответствуют системе (не random)
  - [ ] Line heights применены правильно
  - [ ] Font weights используются для иерархии

- [ ] **Отзывчивость**
  - [ ] Mobile layout спроектирован (320px)
  - [ ] Tablet layout спроектирован (768px)
  - [ ] Desktop layout спроектирован (1024px)
  - [ ] Breakpoints четко определены

- [ ] **Доступность**
  - [ ] WCAG AA контрастность проверена
  - [ ] Focus states видимы (на всех интерактивных элементах)
  - [ ] Alt text для изображений
  - [ ] Aria labels для иконок

### Документация

- [ ] **Дизайн-система**
  - [ ] Color palette с hex кодами
  - [ ] Typography scale (sizes, weights, line-heights)
  - [ ] Spacing scale (padding, margin, gap)
  - [ ] Border radius values
  - [ ] Shadow definitions
  - [ ] Animation durations и easing

- [ ] **Компоненты**
  - [ ] Component library в Figma
  - [ ] Все states задокументированы
  - [ ] Размеры и spacing ясны
  - [ ] Hover/Focus/Disabled states показаны

- [ ] **Pages/Screens**
  - [ ] Все page states созданы (empty, loading, error, success)
  - [ ] Form validations визуализированы
  - [ ] Error messages показаны
  - [ ] Success states показаны
  - [ ] Loading states показаны

- [ ] **Спецификации**
  - [ ] Figma dev mode enabled (для flutter/web реализации)
  - [ ] Все spacing/sizing экспортируется
  - [ ] Z-index hierarchy задана
  - [ ] Animation timing задано

### Передача разработчику (Handoff)

- [ ] Figma file shared (edit или comment access)
- [ ] Dev mode включен в Figma
- [ ] Все component properties задокументированы
- [ ] Дизайн-система экспортирована (colors, fonts, sizes)
- [ ] README с инструкциями использования компонентов
- [ ] Design tokens или JSON с переменными
- [ ] FAQ для частых вопросов
- [ ] Ссылка на design guidelines (этот документ или Figma page)

---

## 📚 Дополнительные ресурсы и инструменты

### Figma UI Kits (бесплатные)
- **Untitled UI** - 10,000+ компонентов (untitledui.com)
- **Sneat** - Admin panel kit (themeselection.com)
- **Material Design 3** - Official Google kit (figma.com/community)

### Flutter Design Resources
- **Flutter documentation** - flutter.dev/docs/ui
- **Material Design 3 for Flutter** - material.io/blog/flutter
- **Responsive Design Patterns** - flutter.dev/docs/development/ui/layout

### Web Design References
- **Tabler.io** - Bootstrap admin template
- **Shadcn/ui** - React components library
- **Storybook** - Component documentation

### Color Tools
- **Accessible Colors** - webaim.org/resources/contrastchecker
- **ColorBox** - colorbox.io (generate color scales)
- **Coolors** - coolors.co (color palette generator)

### Typography Tools
- **Google Fonts** - fonts.google.com
- **Font Pair** - fontpair.co
- **Type Scale** - typescale.com

### Performance Tools
- **Lighthouse** - Chrome DevTools
- **PageSpeed Insights** - pagespeed.web.dev
- **WebPageTest** - webpagetest.org

---

## 🎓 Итоговые выводы

### Ключевые принципы качественной админ-панели

1. **Простота над красотой** - Функциональность важнее
2. **Консистентность** - Одинаковое поведение везде
3. **Эффективность** - Администраторы ценят скорость
4. **Доступность** - WCAG AA минимум
5. **Отзывчивость** - Работает на всех размерах
6. **Документация** - Разработчик должен понимать дизайн

### Workflow

```
1. Research (понимание задач админов)
   ↓
2. Wireframe (структура, не дизайн)
   ↓
3. Design System (цвета, типография, компоненты)
   ↓
4. High-fidelity Design (детали, animations)
   ↓
5. Prototyping (взаимодействие, flow)
   ↓
6. Handoff (документация, спецификации)
   ↓
7. Implementation (Flutter разработка)
   ↓
8. QA & Refinement (feedback цикл)
```

---

## 📞 Вопросы?

Используйте этот гайд как:
- ✅ Чеклист перед началом дизайна
- ✅ Справочник при создании компонентов
- ✅ Документация при передаче разработчику
- ✅ Reference когда сомневаетесь в решении

**Помните:** Лучший дизайн админ-панели — это тот, который разработчики и администраторы будут использовать с удовольствием.

---

**Документ версия:** 2025 Q4  
**Последнее обновление:** December 2025  
**Автор:** UI/UX Design Guide