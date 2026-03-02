---
title: "Android Design Guidelines"
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
description: "Android design guidelines and best practices reference"
category: "platform"
---

# Android Design Guidelines: Полный гайд для мобильных приложений

Этот гайд основан на официальной документации Android (developer.android.com/design) и содержит Android-специфичные рекомендации по дизайну, которые дополняют Material Design 3. Используйте его для оценки дизайн-макетов на соответствие стандартам платформы.

---

## 1. Foundations — Основы Android-дизайна

### 1.1 Анатомия приложения (App Anatomy)

Каждое Android-приложение состоит из трёх основных регионов:

|Регион|Описание|Элементы|
|---|---|---|
|**System Bars**|Системные панели вверху и внизу экрана|Status bar, Navigation bar, Caption bar|
|**Navigation**|Навигация приложения|Navigation bar, Navigation drawer, Tabs|
|**Body**|Основной контент экрана|Контент, компоненты, действия|

**Критическое правило:** Body-контент должен продолжаться **под** navigation и system bar regions при использовании edge-to-edge дизайна.

---

### 1.2 System Bars — Системные панели

#### Status Bar (Строка состояния)

|Свойство|Значение|
|---|---|
|**Высота**|~24dp (варьируется)|
|**Позиция**|Верх экрана|
|**Содержимое**|Notification icons, system icons (время, батарея, сеть)|
|**Стили**|Transparent, Translucent|

**Рекомендации:**

- ✅ Делайте status bar **transparent** или **translucent**
- ✅ Контент приложения должен простираться за status bar (edge-to-edge)
- ✅ Иконки status bar должны иметь достаточный контраст с фоном
- ❌ Не используйте непрозрачный (opaque) status bar

#### Navigation Bar (Панель навигации)

**Типы навигации:**

|Тип|Описание|Высота|
|---|---|---|
|**Gesture Navigation**|Свайпы для навигации, только gesture handle|~24dp|
|**3-Button Navigation**|Кнопки Back, Home, Overview|~48dp|
|**2-Button Navigation**|Устаревший, Back + Home|~48dp|

**Gesture Navigation:**

- Свайп от левого/правого края → Назад
- Свайп вверх от низа → Домой
- Свайп вверх и удержание → Overview (последние приложения)

**Важные спецификации:**

```
Gesture handle insets: ~20-24dp от левого и правого края
Gesture navigation bar: всегда прозрачная
3-button navigation: полупрозрачная с scrim
```

**Рекомендации:**

- ✅ Gesture navigation bar — **всегда прозрачная**
- ✅ Поддерживайте dynamic color adaptation
- ✅ Избегайте touch targets и drag gestures в gesture inset areas
- ❌ Не добавляйте background к gesture navigation bar

#### Dynamic Color Adaptation (Android 15+)

Система автоматически адаптирует цвет системных элементов (gesture handle) в зависимости от контента под ними:

- Светлый контент → тёмный handle
- Тёмный контент → светлый handle

---

### 1.3 Edge-to-Edge Design

**Edge-to-edge** — дизайн-подход, при котором контент приложения отрисовывается под системными панелями для иммерсивного опыта.

**Android 15+:** Edge-to-edge применяется **автоматически**. Для обратной совместимости используйте `enableEdgeToEdge()`.

#### Типы Insets

|Тип Inset|Применение|
|---|---|
|**System Bar Insets**|UI, которому нужно избежать перекрытия system bars|
|**System Gesture Insets**|Области жестов системы (back gesture, home gesture)|
|**Display Cutout Insets**|Области камеры, notch, punch-hole|
|**IME Insets**|Область экранной клавиатуры|
|**Safe Drawing**|Безопасная зона для отрисовки|
|**Safe Gestures**|Безопасная зона от конфликтов с системными жестами|

#### Правила Edge-to-Edge

|Элемент|Поведение|
|---|---|
|**Backgrounds**|Растягиваются edge-to-edge|
|**Dividers**|Растягиваются edge-to-edge|
|**Text & Buttons**|Должны быть inset от system bars|
|**Critical UI**|Не размещайте под display cutouts|
|**Touch targets**|Не размещайте полностью под gesture insets|

**Пример: Top App Bar**

```
✅ Фон top app bar растягивается до верха экрана за status bar
✅ Контент (title, icons) inset на высоту status bar
✅ При скролле — добавьте translucent gradient protection
```

**Пример: Bottom Navigation**

```
✅ Фон растягивается до низа экрана за navigation bar
✅ Icons и labels inset на высоту navigation bar
```

#### Display Cutouts (Вырезы дисплея)

|Рекомендация|Описание|
|---|---|
|**Critical UI**|Inset с помощью display cutout insets|
|**Solid app bars**|Могут рисоваться в область cutout|
|**Horizontal carousels**|Должны прокручиваться через cutout|
|**Landscape mode**|Особое внимание к cutouts по краям|

---

### 1.4 Accessibility — Доступность

#### Touch Targets

|Спецификация|Значение|
|---|---|
|**Минимальный touch target**|**≥48dp × 48dp**|
|**Физический размер**|~9mm|
|**Минимальный spacing**|**≥8dp** между targets|

**Правило:** Touch target может быть больше визуального элемента. Например, иконка 24dp должна иметь touch target 48dp.

#### Color Contrast (WCAG)

|Тип контента|Минимальный контраст|
|---|---|
|**Текст (normal)**|**≥4.5:1**|
|**Текст (large, ≥18pt)**|**≥3:1**|
|**Non-text elements**|**≥3:1**|

**Проверка контраста:**

- Используйте Material's Accessible color system
- HCT (Hue, Chroma, Tone) обеспечивает перцептуально точные расчёты
- Цвета с одинаковым tone недоступны для определённых контекстов

#### Screen Readers (TalkBack)

- Описывайте UI-элементы в коде через Semantics properties
- Предоставляйте текстовые описания для иконок и изображений
- Не полагайтесь только на жесты — создавайте accessibility actions

#### Additional Accessibility Features

|Функция|Описание|
|---|---|
|**Voice Access**|Голосовое управление устройством|
|**Switch Access**|Управление через внешние устройства|
|**Haptic feedback**|Тактильная обратная связь|

---

## 2. Layout & Content — Компоновка и контент

### 2.1 Window Size Classes (Классы размеров окна)

Android использует **3 основных класса размеров**:

|Класс|Ширина|Типичные устройства|
|---|---|---|
|**Compact**|< 600dp|99.96% телефонов (portrait)|
|**Medium**|600–839dp|93.73% планшетов (portrait), foldables|
|**Expanded**|≥ 840dp|97.22% планшетов (landscape), desktop|

**Адаптивная навигация:**

```
Compact → Navigation Bar (bottom)
Medium → Navigation Rail (side)
Expanded → Navigation Drawer (persistent)
```

### 2.2 Grids & Units — Сетки и единицы измерения

#### Density-Independent Pixels (dp)

|Единица|Описание|
|---|---|
|**dp**|Density-independent pixels для размеров|
|**sp**|Scalable pixels для шрифтов (учитывает user preferences)|

**Критическое правило:** Всегда указывайте размеры шрифтов в **sp**, а не в dp или px.

#### Baseline Grid

|Grid|Применение|
|---|---|
|**8dp**|Основной grid для большинства UI-элементов|
|**4dp**|Для мелких элементов (иконки, spacing)|

**Рекомендация:** Все размеры и отступы должны быть кратны 4dp или 8dp.

#### Column Grid System

|Breakpoint|Колонки|Margins|Gutters|
|---|---|---|---|
|Compact (< 600dp)|4|16dp|16dp|
|Medium (600–839dp)|8|24–32dp|24dp|
|Expanded (≥ 840dp)|12|32dp|24dp|

### 2.3 Margins & Spacing

|Класс размера|Margins|
|---|---|
|**Compact**|**16dp**|
|**Medium**|24–32dp|
|**Expanded**|32dp+|

**Важно:** Margins определяют границы контента от краёв экрана. Body content и actions должны оставаться в пределах margins.

### 2.4 Aspect Ratios

Рекомендуемые соотношения сторон:

|Ratio|Применение|
|---|---|
|**1:1**|Квадратные изображения, аватары|
|**4:3**|Фотографии, thumbnails|
|**16:9**|Видео, hero images|
|**3:2**|Фотографии|

### 2.5 Content Structure — Структура контента

#### Containment (Контейнеризация)

|Тип|Описание|
|---|---|
|**Implicit containment**|Белое пространство для визуальной группировки|
|**Explicit containment**|Dividers, cards, surfaces для группировки|

**Принцип:** Группируйте связанный контент вместе, разделяйте несвязанный.

#### Gravity & Positioning

|Позиция|CSS-аналог|
|---|---|
|Start|left (LTR) / right (RTL)|
|End|right (LTR) / left (RTL)|
|Center|center|
|Top/Bottom|top/bottom|

### 2.6 Images & Graphics

#### Типы графики

|Тип|Формат|Применение|
|---|---|---|
|**Icons**|Vector (SVG, VectorDrawable)|Системные иконки, navigation|
|**Illustrations**|Vector или высокого разрешения|Hero images, spot illustrations|
|**Photos**|Bitmap (JPEG, PNG, WebP)|Фотоконтент|

**Рекомендации:**

- ✅ Используйте vector formats первыми, когда возможно
- ✅ Предоставляйте assets для разных density buckets (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- ✅ Избегайте текста внутри графических ассетов
- ✅ Добавляйте scrim между фоновыми изображениями и текстом

#### Animated Graphics

- **Animated Vector Drawables** — для маленьких UI-анимаций
- **Lottie** — для сложных анимаций
- **Programmatic animations** — для гибкости и меньшего размера

---

## 3. Styles — Стили

### 3.1 Themes — Темы

#### Типы тем

|Тип|Область действия|
|---|---|
|**System themes**|Весь UI устройства|
|**App themes**|Только внутри приложения|

#### System Themes

|Тема|Описание|
|---|---|
|**Light**|Светлые поверхности, тёмный текст|
|**Dark**|Тёмные поверхности, светлый текст|
|**Dynamic Color**|Цвета из обоев пользователя (Android 12+)|
|**High Contrast**|Повышенный контраст для accessibility|

**Рекомендации:**

- ✅ Поддерживайте и Light, и Dark темы
- ✅ Respect системные настройки пользователя
- ✅ Создайте custom fallback тему, если dynamic color недоступен
- ❌ Не "залочивайте" приложение только на Light тему

#### Dynamic Color (Material You)

Доступен с **Android 12+**. Извлекает цвета из обоев пользователя.

**Тональные палитры:**

```
Primary, Secondary, Tertiary, Neutral, Neutral Variant
Каждая с тонами: 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100
```

### 3.2 Color — Цвет

#### Color Roles

|Role|Применение|
|---|---|
|**Primary**|Главные интерактивные элементы|
|**On Primary**|Контент на primary|
|**Primary Container**|Фон выделенных элементов|
|**Secondary**|Менее prominent элементы|
|**Tertiary**|Акценты для баланса|
|**Surface**|Фоны поверхностей|
|**Outline**|Границы, разделители|
|**Error**|Ошибки и предупреждения|

#### Tonal Surfaces

MD3 использует **тональную элевацию** — все цвета производятся из тональных палитр для глубины и контраста.

|Surface Role|Тон (Light)|Тон (Dark)|
|---|---|---|
|Surface|99|6|
|Surface Container Lowest|100|4|
|Surface Container Low|96|10|
|Surface Container|94|12|
|Surface Container High|92|17|
|Surface Container Highest|90|22|

#### Color Tokens

**Используйте токены вместо hardcoded hex-значений:**

```
✅ button-container-color = primary
❌ button-container-color = #6750A4
```

### 3.3 Typography — Типографика

#### Type Scale (Material Design 3)

|Role|Size (sp)|Line Height|Weight|
|---|---|---|---|
|**Display Large**|57|64|400|
|**Display Medium**|45|52|400|
|**Display Small**|36|44|400|
|**Headline Large**|32|40|400|
|**Headline Medium**|28|36|400|
|**Headline Small**|24|32|400|
|**Title Large**|22|28|500|
|**Title Medium**|16|24|500|
|**Title Small**|14|20|500|
|**Body Large**|16|24|400|
|**Body Medium**|14|20|400|
|**Body Small**|12|16|400|
|**Label Large**|14|20|500|
|**Label Medium**|12|16|500|
|**Label Small**|11|16|500|

**Default typeface:** Roboto

#### Typography Best Practices

- ✅ Используйте **sp** для всех размеров шрифтов
- ✅ Поддерживайте user font size preferences
- ✅ Line height ratio: ~1.2× (120%) от размера шрифта
- ✅ Создавайте иерархию через weight, size, и color
- ❌ Не используйте декоративные шрифты для body text

---

## 4. Behaviors & Patterns — Поведение и паттерны

### 4.1 Navigation Patterns

#### Primary Navigation

|Компонент|Window Size|Destinations|
|---|---|---|
|**Navigation Bar**|Compact|3–5|
|**Navigation Rail**|Medium|3–7 + FAB|
|**Navigation Drawer**|Expanded|5+|

#### Secondary Navigation

|Компонент|Применение|
|---|---|
|**Tabs**|Группировка sibling-контента|
|**Bottom App Bar**|Дополнительные actions + FAB|
|**Top App Bar**|Navigation icon, title, actions|

### 4.2 Predictive Back

**Predictive Back** — жест навигации назад с превью destination перед commit.

#### Поведение

1. Пользователь свайпает от края экрана
2. Приложение показывает preview назначения
3. Пользователь решает:
    - Отпустить до 50% → отмена, возврат к текущему экрану
    - Продолжить за 50% → commit, переход назад

#### Motion Specifications (Full-Screen Surface)

|Параметр|Значение|
|---|---|
|**Margins**|5% ширины с каждой стороны|
|**Scale (max)**|90%|
|**Corner radius (max)**|32dp|
|**Commit threshold**|50%|
|**Interpolator**|(0.1, 0.1, 0, 1)|

**Рекомендации:**

- ✅ Не размещайте touch targets под gesture insets
- ✅ При отмене — плавный возврат к исходному состоянию
- ✅ При commit — fade through к следующему состоянию

### 4.3 Settings

#### Принципы

|Правило|Описание|
|---|---|
|**Include**|Редко используемые preferences|
|**Exclude**|Часто используемые actions (разместите в контексте)|
|**Save**|Всегда сохраняйте user preferences|
|**Avoid**|App info, account management, system-level settings|

#### Расположение Settings

|Приоритет|Позиция|
|---|---|
|High priority|В primary navigation (nav bar, drawer, rail)|
|Standard|В top app bar menu (после всех items, кроме Help)|
|Combined|Можно объединить с Account/Profile|

#### UX Patterns для Settings

|Pattern|Применение|
|---|---|
|**Toggle (Switch)**|Boolean settings|
|**Radio buttons**|Single choice из нескольких опций|
|**Slider**|Range values|
|**Date/Time picker**|Сбор даты/времени|
|**List**|Навигация к subscreens|

### 4.4 Sharing

Android Sharesheet позволяет делиться контентом между приложениями.

**Рекомендации:**

- ✅ Используйте системный Share sheet
- ✅ Поддерживайте соответствующие MIME types
- ✅ Предоставляйте preview контента

---

## 5. Home Screen Features

### 5.1 Notifications

#### Анатомия уведомления

|Элемент|Описание|
|---|---|
|**App icon**|Монохромная 2D-иконка приложения|
|**Header text**|Название приложения или канала|
|**Timestamp**|Время получения|
|**Primary content**|Основной текст уведомления|
|**Large icon**|Опциональная большая иконка (например, аватар)|
|**Actions**|До 3 кнопок действий|

#### Notification Templates

|Template|Применение|Особенности|
|---|---|---|
|**Standard**|Большинство уведомлений|Краткий текст, large icon, actions|
|**Big Text**|Длинный текст|Расширяемый preview|
|**Big Picture**|Изображения|Thumbnail → full preview|
|**Progress**|Длительные операции|Progress bar, cancel action|
|**Media**|Медиа-плеер|До 5 actions, playback controls|
|**MessagingStyle**|Чаты|История сообщений, inline reply|
|**CallStyle**|Звонки|Incoming/outgoing call UI|
|**Live Updates**|Отслеживание прогресса|Delivery, navigation, sports|

#### Notification Principles

- **Timely** — отправляйте, когда информация актуальна
- **Relevant** — только важный для пользователя контент
- **Actionable** — давайте возможность действовать
- **Brief** — краткие сообщения

**Рекомендации:**

- ✅ Используйте Notification Channels для категоризации
- ✅ Поддерживайте inline reply для messaging apps
- ✅ Не злоупотребляйте уведомлениями
- ❌ Не используйте уведомления для рекламы

### 5.2 Widgets

#### Widget Sizing

**Рекомендуемые размеры (в grid cells):**

|Размер|Cells (Phone)|Cells (Tablet)|Применение|
|---|---|---|---|
|Small|2×2|3×3|Quick actions, status|
|Medium|4×2|4×3|Lists, info display|
|Large|4×4|6×4|Rich content, detailed info|

**Атрибуты:**

```xml
targetCellWidth / targetCellHeight — для widget picker
minWidth / minHeight — минимальные размеры
minResizeWidth / minResizeHeight — для resizable widgets
```

#### Widget Design Principles

|Принцип|Описание|
|---|---|
|**Edge-to-edge**|Container растягивается до краёв grid|
|**System corner radius**|Используйте системное скругление|
|**Breakpoints**|Адаптируйте layout при изменении размера|
|**Responsive**|Rectangular containers, не fixed squares|

#### Widget Theming

- ✅ Поддерживайте Light и Dark themes
- ✅ Используйте Dynamic Color (Android 12+)
- ✅ Применяйте Material color tokens
- ✅ Corner radius: системное значение (для consistency)

#### Widget Layouts

|Layout|Применение|
|---|---|
|**Text-focused**|Status, titles, descriptions|
|**List**|Scrollable items|
|**Grid**|Image galleries|
|**Toolbar**|Quick actions|
|**Search**|Search bar + quick actions|

### 5.3 Quick Settings Tiles

|Свойство|Значение|
|---|---|
|**Позиция**|Quick Settings panel (notification shade pulldown)|
|**Назначение**|Быстрые toggles и shortcuts|
|**Примеры**|WiFi, Bluetooth, Flashlight, custom app actions|

---

## 6. Immersive Content

### 6.1 Immersive Mode

**Immersive Mode** скрывает system bars для полноэкранного опыта.

#### Use Cases

|Сценарий|Рекомендация|
|---|---|
|**Video playback**|Скрывайте bars, tap to reveal|
|**Games**|Избегайте случайных выходов|
|**Reading (books)**|Full engagement|
|**Presentations**|Full-screen focus|

#### Правила Immersive Mode

- ✅ Предоставьте интуитивный способ показать UI (tap)
- ✅ Добавьте overlay/scrim для текста и controls
- ✅ Поддерживайте PiP и Chromecast
- ❌ Никогда не скрывайте system bars навсегда на личных устройствах
- ❌ Не используйте для всего контента (только для специфичных случаев)

### 6.2 Picture-in-Picture (PiP)

|Свойство|Описание|
|---|---|
|**Позиция**|Topmost layer, в углу экрана|
|**Размер**|Small window|
|**Controls**|Close, fullscreen, settings, playback|

**Use Cases:**

- Video playback при навигации
- Video call во время работы с контентом
- Продолжение контента при выборе нового

**Рекомендации:**

- ✅ `setAutoEnterEnabled(true)` для smooth transitions (Android 12+)
- ✅ Скрывайте UI elements в PiP mode
- ✅ Продолжайте playback
- ✅ Поддерживайте basic controls

---

## 7. Adaptive Design — Адаптивный дизайн

### 7.1 Canonical Layouts

**Canonical Layouts** — готовые композиции для адаптивных layouts.

|Layout|Применение|Window Size|
|---|---|---|
|**List-Detail**|Master-detail navigation|Medium, Expanded|
|**Feed**|Scrollable content|All sizes|
|**Supporting Pane**|Main content + side panel|Expanded|

### 7.2 Adaptive Navigation

|Window Size|Primary Nav|Behavior|
|---|---|---|
|**Compact**|Navigation Bar|Bottom, 3-5 items|
|**Medium**|Navigation Rail|Side, 3-7 items + FAB|
|**Expanded**|Navigation Drawer|Persistent, unlimited items|

**Правило:** Navigation Rail и Navigation Drawer не должны конфликтовать с system bars при edge-to-edge.

### 7.3 Multi-Window & Foldables

**Multi-window modes:**

- Split-screen
- Freeform windows
- Desktop windowing

**Foldable considerations:**

- Hinge awareness
- Tabletop posture (half-folded)
- Book posture

**Рекомендации:**

- ✅ Тестируйте на разных window sizes
- ✅ Используйте WindowInsets для safe areas
- ✅ Поддерживайте landscape и portrait
- ✅ Адаптируйте layout для foldable postures

---

## 8. Components — Компоненты

### 8.1 Categories

Material Design 3 компоненты делятся на **5 категорий**:

|Категория|Компоненты|
|---|---|
|**Action**|Buttons, FAB, Icon buttons, Segmented buttons|
|**Containment**|Cards, Dialogs, Bottom sheets, Side sheets|
|**Navigation**|Navigation bar, Navigation rail, Navigation drawer, Tabs, Top app bar|
|**Selection**|Checkbox, Radio, Switch, Chip, Slider, Date/Time pickers|
|**Text Input**|Text fields|

### 8.2 Key Component Specs (Quick Reference)

|Компонент|Высота|Touch Target|Corner Radius|
|---|---|---|---|
|**Button**|40dp|≥48dp|20dp (pill)|
|**FAB**|56dp|56dp|16dp|
|**Small FAB**|40dp|40dp|12dp|
|**Large FAB**|96dp|96dp|28dp|
|**Navigation Bar**|80dp|—|—|
|**Top App Bar**|64dp|—|—|
|**Chip**|32dp|≥48dp|8dp|
|**Text Field**|56dp|—|4dp|
|**Switch Track**|32dp|≥48dp|16dp (full)|
|**Checkbox**|18dp|≥48dp|2dp|
|**Card**|Variable|—|12dp|
|**Dialog**|Variable|—|28dp|

---

## 9. Checklist — Чек-лист для проверки макетов

### Критические требования

|#|Критерий|Требование|
|---|---|---|
|1|Touch targets|**≥48×48dp**|
|2|Touch target spacing|**≥8dp**|
|3|Text contrast (normal)|**≥4.5:1**|
|4|Text contrast (large)|**≥3:1**|
|5|Non-text contrast|**≥3:1**|
|6|Baseline grid|Кратно **8dp** (4dp для мелких элементов)|
|7|Font sizes|В **sp**, не px или dp|
|8|Margins (Compact)|**16dp**|
|9|System bars|**Transparent** или **translucent**|
|10|Edge-to-edge|Контент под system bars|

### Layout & Navigation

|#|Критерий|Compact|Medium|Expanded|
|---|---|---|---|---|
|11|Columns|4|8|12|
|12|Primary nav|Nav Bar|Nav Rail|Nav Drawer|
|13|Nav destinations|3-5|3-7|5+|

### Components

|#|Критерий|Требование|
|---|---|---|
|14|Button height|40dp|
|15|FAB size|56×56dp|
|16|Navigation Bar height|80dp|
|17|Top App Bar height|64dp|
|18|Chip height|32dp|
|19|Text field height|56dp|
|20|Card corner radius|12dp|
|21|Dialog corner radius|28dp|

### Themes & Color

|#|Критерий|Требование|
|---|---|---|
|22|Light theme|Поддерживается|
|23|Dark theme|Поддерживается|
|24|Dynamic Color|Поддерживается (Android 12+)|
|25|Color tokens|Используются вместо hardcoded values|

### Accessibility

|#|Критерий|Требование|
|---|---|---|
|26|Content descriptions|Для иконок и изображений|
|27|Scalable fonts|sp units|
|28|Gesture alternatives|Actions для всех жестов|
|29|Focus states|Для всех interactive elements|

---

## 10. Темы для дополнительного изучения

Следующие темы требуют отдельного глубокого исследования для полной картины:

1. **Wear OS Design** — дизайн для умных часов
2. **Android TV Design** — дизайн для телевизоров
3. **Android Automotive Design** — дизайн для автомобилей
4. **Android XR Design** — дизайн для VR/AR
5. **Compose-specific patterns** — паттерны для Jetpack Compose
6. **Animation & Motion specs** — детальные спецификации анимаций
7. **Accessibility testing** — методы тестирования доступности
8. **Localization** — адаптация для разных языков и регионов

---

_Источники: Официальная документация Android Developers (developer.android.com/design)_