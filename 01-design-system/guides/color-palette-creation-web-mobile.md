---
title: "Color Palette Creation for Web and Mobile"
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
description: "Guide for creating color palettes for web and mobile applications"
---


> Проведи исследование по способам создания цветовых палитр для сайтов и мобильных приложений. Изучи различные подходы, включающие создание темной и светлой темы, использования RGB/ocluch/hex, проблемы перенасыщенного желтого цвета, использование семантической структуры цветов

Проведу комплексное исследование современных подходов к созданию цветовых палитр. Это важно для твоего плагина автоматизации дизайн-процессов.# 🎨 Комплексное исследование: Создание цветовых палитр для веб и мобильных приложений

Привет, Ray! Провел подробное исследование современных подходов к созданию цветовых систем. Разбил результаты на ключевые категории с практическими выводами для твоего плагина.

---

## 1️⃣ Светлая и темная тема (Light/Dark Mode)

### 🔑 Ключевые принципы

**Фундаментальное правило:** НЕ просто инвертировать цвета

Dark mode палитра создается отдельно для каждого light mode аналога - хотя больше цветов, но маппинг становится проще и прямолинейнее. Каждый "насыщенный и темный" light mode цвет имеет соответствующий "ненасыщенный и светлый" dark mode цвет

### 📐 Структурные подходы

**1. Отдельные палитры vs. Общая палитра**

Два основных метода:

- **Метод 1:** Одна палитра, где light использует тона 600-1000, dark использует 100-400
    - ❌ Сложно масштабировать
    - ❌ Нарушается логика при большом количестве цветов
- **Метод 2 (рекомендуемый):** Создать эквивалентную dark mode палитру для каждого color swatch. Light mode 1000 соответствует dark mode 1000 - маппинг почти 1:1
    - ✅ Проще управлять
    - ✅ Легче масштабировать
    - ⚠️ Иногда нужны отклонения ±1-2 позиции

**2. Базовые цвета для темной темы**

Google Material Design рекомендует использовать темно-серый (#121212) как цвет поверхности dark theme для выражения elevation и пространства. Многие дизайнеры рекомендуют добавлять тонкий темно-синий оттенок к темно-серым

🎯 **Не используй чистый черный (#000000):**

- Создает жесткий контраст
- Вызывает halation эффект (особенно для людей с астигматизмом)
- Усиливает motion blur на OLED экранах

**Рекомендуемые базовые цвета:**

- `#121212` - Material Design стандарт
- `#181A1B`, `#23272F`, `#14213D` - альтернативы с синим оттенком

### 🎨 Десатурация цветов в Dark Mode

Десатурируй цвета чтобы они были легче для глаз с достаточным контрастом против темной поверхности. В среднем, твои цвета должны иметь примерно на 20 пунктов меньше saturation в dark mode чем в light mode

**Практический пример от Material 3:**

- Light mode: высокая saturation
- Dark mode: -20 пунктов saturation
- Причина: яркие цвета на темном фоне режут глаза

### 🌓 Elevation через цвет (вместо теней)

В light mode мы используем тени для передачи глубины. В dark mode используем ту же теорию "источника света" и применяем ее к цвету поверхности. Вместо изменения только размера тени, делаем поверхность светлее чем выше она находится

**Система elevation:**

- Поверхность выше = светлее оттенок серого
- Теория: источник света ближе → поверхность ярче
- ❌ Тени в dark mode не работают / создают путаницу

### ♿ Контраст и доступность

По гайдлайнам Material Design, темные поверхности с 100% белым текстом должны поддерживать contrast ratio минимум 15.8:1. Это потому что elevated поверхности в dark mode становятся светлее

**Важные моменты:**

- Белый текст не чисто белый: используй `#F0F0F0` или похожие оттенки
- Яркий белый может слишком сильно светиться в темном UI, создавая резкий эффект. Используй чуть более темный оттенок белого

### ✅ Checklist для Dark Mode

```
□ Базовый фон: темно-серый (#121212), не черный
□ Десатурация цветов: -20 пунктов saturation
□ Elevation через lightness, не через shadows
□ Контраст текста минимум 15.8:1 для белого на темном
□ Текст: off-white (#F0F0F0), не чистый белый
□ Тестирование на OLED экранах для motion blur
□ Опция переключения для пользователей с астигматизмом
```

---

## 2️⃣ RGB vs OKLCH vs Hex: Форматы цветов

### 🔬 Фундаментальная проблема RGB/HSL/Hex

RGB, HSL и hex форматы не учитывают что разные оттенки воспринимаются как разные уровни яркости человеческим глазом - при одинаковом математическом lightness, желтый кажется светлее чем синий

**Визуальное доказательство:**

```
HSL(hue, 50%, 50%) для всех оттенков:
🟡 Желтый - кажется очень светлым
🟢 Зеленый - кажется светлым
🔵 Синий - кажется очень темным
🟣 Фиолетовый - кажется темным
```

HSL lightness не консистентен между осями hue. В результате, HSL-деформированное цветовое пространство нельзя использовать для правильной модификации цвета - компонент L (lightness) не точен

### 🎯 OKLCH - современный стандарт

**Что такое OKLCH:** OKLCH использует Lightness, Chroma и Hue как HSL использует Lightness, Saturation и Hue, но с одним критичным отличием: OKLCH перцептивно uniform (perceptually uniform)

**Структура:**

```
oklch(L C H / alpha)
  L = Lightness (0-1 или 0%-100%) - воспринимаемая яркость
  C = Chroma (0-0.37) - насыщенность/интенсивность
  H = Hue (0-360°) - оттенок
```

### ⚡ Преимущества OKLCH

**1. Perceptual Uniformity (Перцептивная однородность)**

В OKLCH равные числовые шаги в Lightness, Chroma или Hue обычно производят визуально равные изменения для большинства цветов - огромное улучшение над HSL или RGB

**Практическое применение:**

- ✅ Predictable ramps - меняй lightness без искажения hue/saturation
- ✅ Consistent theming - палитры ведут себя надежно в light/dark режимах
- ✅ Easier accessibility - поддерживать контраст проще когда изменения цвета визуально равномерны

**2. Wide Gamut Support (Display P3)**

OKLCH поддерживает P3 и далее, а также любой цвет видимый человеческому глазу. Это дополнительные 30% цветов которые могут быть очень полезны: некоторые из этих новых цветов более насыщенные

**Сравнение гамм:**

- sRGB: стандартный веб (100%)
- Display P3: +30% цветов (Apple устройства, современные мониторы)
- Rec2020: еще шире (будущее)

**3. Предсказуемая модификация цвета**

Использование perceptual lightness решает проблемы HSL, предотвращая неожиданные hue shifts или brightness провалы при модификации цвета, как при использовании функций типа darken() в препроцессорах

**Пример в CSS:**

```css
/* Создание светлого варианта - просто увеличь L */
--primary: oklch(0.6 0.2 250);
--primary-light: oklch(0.8 0.2 250);
--primary-dark: oklch(0.4 0.2 250);

/* Комплементарный - добавь 180 к hue */
--secondary: oklch(0.6 0.2 70);
```

### ⚠️ Ограничения OKLCH

Некоторые не-uniformity остаются, особенно в high-chroma синих и фиолетовых и на краю sRGB гаммы

**Практические рекомендации:**

1. Используй color picker для проверки out-of-gamut цветов
2. Браузеры автоматически найдут ближайший поддерживаемый цвет
3. Для старых браузеров предоставляй RGB/Hex fallback

### 🔄 Workflow с OKLCH

RGB и HEX остаются необходимыми для технической реализации и browser/device совместимости. Думай об OKLCH как об инструменте для дизайна, редактирования и планирования цветовых палитр - затем конвертируй в RGB/HEX для экспорта

**Рекомендуемый процесс:**

1. Дизайн палитры в OKLCH (Figma плагины: OKLCH Color Picker, AVA Palettes)
2. Генерация ramps с равномерным lightness
3. Проверка accessibility (контраст легче предсказывать)
4. Экспорт в RGB/Hex для production
5. CSS: использовать oklch() с fallback

**Поддержка браузерами (2025):** По данным MDN, на Сентябрь 2025, oklch() доступен во всех последних устройствах и версиях браузеров

### 📊 Сравнительная таблица

|Параметр|RGB/Hex|HSL|OKLCH|
|---|---|---|---|
|Perceptual uniformity|❌|❌|✅|
|Wide gamut (P3)|❌|❌|✅|
|Интуитивность|❌|✅|✅|
|Accessibility|⚠️|⚠️|✅|
|Браузерная поддержка|✅|✅|✅ (современные)|
|Predictable color modification|❌|❌|✅|

---

## 3️⃣ Проблема перенасыщенного желтого (Dark Yellow Problem)

### 🟡 Суть проблемы

Проблема темного желтого: попытка создать оттенок желтого чтобы сделать его accessible и выровнять с другими цветами в палитре. Но просто не существует такой вещи как "dark yellow". Желтый по определению должен оставаться светлым

**Физика цвета:**

- Желтый = высокая luminance (яркость) по природе
- Затемнение желтого = коричневый цвет
- Нарушает ментальную модель пользователей (traffic light system)

### 📉 Технические причины

Одна из ловушек perceptually uniform color моделей - существуют невозможные цвета. Не существует "very colorful dark yellow" или "vibrant light royal blue"

**Relative Luminance - проблема выравнивания:**

Пример: Попытка сделать все status colors с одинаковой relative luminance ~0.15

- 🔴 Red 0.15 - ✅ работает
- 🔵 Blue 0.15 - ✅ работает
- 🟢 Green 0.15 - ✅ работает
- 🟡 Yellow 0.15 - ❌ становится коричневым!

### 💡 Решения проблемы

**1. UI Governance (Рекомендуемый подход)**

Нельзя изменить сам желтый, поэтому фокус на регулировании как желтые могут использоваться. UI governance - критичный аспект функциональной design system, включая использование цветов

**Правила использования желтого:**

```
✅ Желтый как background цвет
   - С темным текстом (black, dark blue, dark gray)
   - Для warning сообщений, highlights

❌ Желтый как foreground цвет
   - НЕ используй для текста на светлом фоне
   - НЕ используй для иконок требующих высокого контраста

⚠️ Желтый для interactive элементов
   - Только в комбинации с другими visual cues
   - Не полагайся только на цвет для коммуникации
```

**2. Альтернативные палитры для warning состояний**

Можно создать WCAG-совместимые доступные цветовые палитры на основе желтой и фиолетовой цветовой схемы. Каждая палитра работает в light и dark режимах

**Стратегии:**

- Orange вместо yellow для warning (более темный, но все еще воспринимается как предупреждение)
- Amber с повышенной saturation
- Gold оттенки (между yellow и orange)

**3. Специальная обработка текста**

При дизайне с желтым background, самый важный шаг - выбрать цвет который четко контрастирует. Сильные contrast pairings: Black (наивысший контраст), Dark blue, Dark gray

**WCAG требования для желтого:**

- Normal text: 4.5:1 contrast ratio
- Large text: 3:1 contrast ratio
- ❌ Избегай: white, pale gray, ivory на желтом

**4. Perceptually Uniform подход**

Желтые оттенки обычно требуют минимальной корректировки; желтый остается perceptually стабильным. С этим знанием делаем тонкие корректировки hues в каждой color scale

### 🎯 Практический workflow для желтого

```
1. Определи use case:
   □ Background для warning? → Светлый yellow (#FFF838, #FEDC2A)
   □ Icon для attention? → Amber/Orange (#FFA500)
   □ Text? → ❌ Избегай или используй очень темный контекст

2. Тестируй контраст:
   □ Используй contrast checker (WebAIM, Stark)
   □ Проверь против WCAG AA (минимум 4.5:1)
   □ Тестируй в обоих light/dark режимах

3. Комбинируй с дополнительными cues:
   □ Icons + Color (не только color)
   □ Text labels + Color
   □ Patterns/borders для дополнительной дифференциации

4. Документируй правила использования:
   □ "Yellow только для backgrounds"
   □ "Warning состояние = Yellow bg + Black text"
   □ "Icons используют Amber, не pure yellow"
```

---

## 4️⃣ Семантическая структура цветов (Design Tokens)

### 🏗️ Трехуровневая система токенов

Token-based система для semantic colors - самый популярный подход. Определяешь naming структуру токенов на основе их свойств, роли, тона и состояния

**Иерархия токенов:**

```
┌─────────────────────────────────────────────┐
│ 1. PRIMITIVE (Core/Global) Tokens          │
│    Сырые значения - фундамент системы       │
│    color-blue-500: #0066CC                  │
│    space-md: 16px                           │
│    font-size-lg: 20px                       │
└─────────────────────────────────────────────┘
              ↓ references
┌─────────────────────────────────────────────┐
│ 2. SEMANTIC Tokens                          │
│    Purpose-based - применимы в дизайне      │
│    color-action-primary: color-blue-500     │
│    color-text-error: color-red-600          │
│    spacing-component-gap: space-md          │
└─────────────────────────────────────────────┘
              ↓ references
┌─────────────────────────────────────────────┐
│ 3. COMPONENT Tokens (опционально)           │
│    Специфичны для компонентов               │
│    button-primary-background-default        │
│    input-border-focus                       │
│    card-shadow-elevated                     │
└─────────────────────────────────────────────┘
```

### 📋 Primitive Tokens (Базовый уровень)

Primitive tokens говорят нам какие свойства и значения существуют в дизайнах. Иногда известны как global tokens, они определяют значения в системе. Primitive tokens только для reference - предоставляют фундамент для других токенов

**Примеры структуры:**

```
color-blue-100: #E3F2FD
color-blue-200: #BBDEFB
color-blue-300: #90CAF9
...
color-blue-900: #0D47A1

space-xs: 4px
space-sm: 8px
space-md: 16px
space-lg: 24px
space-xl: 32px
```

**Naming conventions для primitive:**

- Цвета: `color-{hue}-{scale}` (100-900 или 1-10)
- Spacing: `space-{size}` (xs, sm, md, lg, xl или 1-10)
- Typography: `font-size-{scale}`, `font-weight-{name}`

### 🎯 Semantic Tokens (Смысловой уровень)

Semantic tokens дают нам контекст как токен должен использоваться. Assets с semantic именами передают meaning, purpose и как и где asset должен использоваться

**Категории semantic tokens:**

**1. Background (Surfaces)** Background токены разделяю на bg/base и bg/surface для серых цветов. Есть 3 типа: default (с default surface цветом обычно темным), weak (для светлых поверхностей), weakest (еще светлее чем weak)

```
bg-base-primary         // Основной фон страницы
bg-base-secondary       // Вторичный фон (cards, panels)

bg-surface-default      // Стандартная поверхность компонентов
bg-surface-weak         // Светлая поверхность
bg-surface-weakest      // Самая светлая

bg-brand-default        // Брендовый фон
bg-brand-hover          // Hover состояние
bg-brand-pressed        // Pressed состояние

bg-positive / bg-danger / bg-warning / bg-info
```

**2. Foreground (Text & Icons)** Для text и icon хочу primary, secondary и tertiary цвета с varying shades of grey где primary самый темный и tertiary самый светлый в этой иерархической спектре

```
text-primary            // Основной текст
text-secondary          // Вторичный текст (меньше emphasis)
text-tertiary           // Третичный (hints, placeholders)
text-disabled           // Неактивный текст

text-brand / text-positive / text-danger / text-warning

icon-primary / icon-secondary / icon-tertiary
icon-brand / icon-positive / icon-danger
```

**3. Border**

```
border-primary          // Основные границы
border-secondary        // Вторичные границы
border-tertiary         // Едва заметные границы
border-focus            // Focus состояние (обычно brand color)

border-input-default / border-input-hover / border-input-focus
```

**4. Interactive States**

```
action-primary-default
action-primary-hover
action-primary-pressed
action-primary-disabled

action-secondary-default
action-secondary-hover
...
```

### 🧩 Component Tokens (Уровень компонентов)

Component-specific tokens говорят где токен может использоваться. Они детальные и чаще используются большими enterprise-level системами. Может не быть необходимым для всех

**Структура именования:**

```
{component}-{element}-{property}-{state}

button-primary-background-default
button-primary-background-hover
button-primary-background-pressed
button-primary-text-default
button-primary-border-focus

input-field-background-default
input-field-border-error
input-field-text-placeholder

card-background-default
card-shadow-elevated
```

### 📝 Best Practices для именования

Be Semantic, Not Presentational. Используй имена описывающие purpose, не appearance. Например, предпочитай button-primary-background вместо blue-button

**Правила:**

**1. Иерархическая структура**

```
✅ color.action.primary.background
✅ typography.heading.large
✅ spacing.component.gap

❌ blue-button
❌ big-text
❌ 16px-spacing
```

**2. Избегай ценностных имен** Избегай value-based names. Labels типа blue-100 или dark-red не передают purpose цвета. Вместо этого используй имена типа color-error-text или color-success-bg которые четко коммуницируют intent

**3. Последовательность префиксов** Front matter занимает все real estate в viewing experience наших token names! Когда спросили дизайнеров почему они так пишут имена, ответили "мне сказали делать так инженеры", "видели в статье", "эта компания делает так"

**Проблема длинных префиксов:**

```
❌ M3/sys/dark/tertiary-fixed-...
   Truncated в Figma, сложно найти

✅ Краткий префикс или без префикса:
   action-primary-bg
   text-error
   surface-brand
```

### 🎨 Naming Patterns в индустрии

**Material Design 3:**

```
md.sys.color.primary
md.sys.color.on-primary
md.sys.color.surface-variant
```

**Tailwind CSS:**

```
bg-blue-500
text-gray-900
border-red-400
```

**Custom semantic (рекомендуемый):**

```
surface/brand/default
text/primary
action/primary/hover
border/input/focus
```

### 🔄 Multi-mode support (Dark/Light)

Semantic token типа background-surface может маппиться на white в light mode и dark gray в dark mode, устраняя redundant code

**Структура в Figma Variables:**

```
Collection: "Semantic Colors"
├── Mode: Light
│   ├── bg-primary: #FFFFFF
│   ├── text-primary: #000000
│   └── action-primary: #0066CC
└── Mode: Dark
    ├── bg-primary: #121212
    ├── text-primary: #FFFFFF
    └── action-primary: #4D9FFF (desaturated)
```

### ✅ Checklist для semantic color system

```
Structure:
□ 3-tier система: Primitive → Semantic → (Component)
□ Clear naming convention без технического жаргона
□ Prefix structure: минимальный, консистентный

Semantic categories:
□ Background (base, surface, brand, status)
□ Foreground (text, icon - primary/secondary/tertiary)
□ Border (primary/secondary/tertiary, focus)
□ Interactive states (default, hover, pressed, disabled)

Multi-mode support:
□ Light/Dark modes через Figma Variables/modes
□ Каждый semantic token имеет значение для каждого mode
□ Desaturation применена к dark mode (-20 points)

Documentation:
□ Когда использовать каждый token
□ Accessibility guidelines (минимальные контрасты)
□ Примеры использования для каждого токена
```

---

## 🎯 Практические рекомендации для плагина

### Функции которые стоит реализовать:

**1. OKLCH Color Generator**

- Генерация color ramps с perceptual uniformity
- Автоматическая десатурация для dark mode (-20 points)
- Validation для out-of-gamut цветов
- Export в RGB/Hex с OKLCH кодом как комментарий

**2. Dark/Light Mode Converter**

- Автоматическое создание dark палитры из light
- Adjustable desaturation level (default -20)
- Elevation mapping (lightness для surfaces)
- Contrast validation (минимум 15.8:1)

**3. Yellow Problem Solver**

- Detect yellow hues (45°-65° в OKLCH)
- Warning при попытке затемнить yellow
- Suggest альтернативы: amber, orange, gold
- UI governance rules для yellow usage

**4. Semantic Token Generator**

- Template-based creation (Material, Tailwind, Custom)
- 3-tier structure setup (Primitive → Semantic → Component)
- Auto-naming по best practices
- Figma Variables creation с modes

**5. Accessibility Checker**

- WCAG AA/AAA contrast validation
- Color blindness simulation
- Suggest fixes для failing combinations

---

## 📚 Источники и инструменты

**Инструменты для работы с OKLCH:**

- [oklch.com](https://oklch.com/) - Color picker
- AVA Palettes (Figma plugin) - OKLCH в Figma
- [colorbox.io](https://colorbox.io/) - Palette generator

**Design Token системы:**

- Material Design 3 Token structure
- Salesforce Lightning Design System
- Adobe Spectrum

**Accessibility:**

- WebAIM Contrast Checker
- Stark (Figma plugin)
- Who Can Use

---

Готов обсудить конкретную реализацию любого из этих направлений для твоего плагина! 🚀