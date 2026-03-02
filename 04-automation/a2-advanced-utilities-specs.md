---
title: "A2 Advanced Utilities Specifications"
type: "meta"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/meta"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Specifications for A2 tier advanced utility components"
---

# A2. Продвинутые утилиты — Технические задания

> **Автор:** Ray (@uixray)  
> **Дата:** 2026-02-16  
> **Категория:** Figma-плагины без AI, уровень 2  
> **Зависимости:** Boilerplate E1, UI Kit E2, знание Variables API

---

# A2.1 — Typograph

## Цель

Типографический процессор для русского и английского текста внутри Figma. Автозамена кавычек на «ёлочки», дефисов на тире, вставка неразрывных пробелов перед короткими предлогами, исправление распространённых типографических ошибок. Доработка и расширение существующей базы.

## Проблема

Дизайнеры вставляют текст из копирайтеров/менеджеров с "программистскими" кавычками, дефисами вместо тире, двойными пробелами. Ручная правка занимает часы на больших проектах. Существующие плагины либо не поддерживают русскую типографику полноценно, либо не обрабатывают вложенные кавычки.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Typographer** (Figma Community)|Базовые замены|Нет русских кавычек-ёлочек, нет вложенных кавычек|
|**RuTypograph**|Русская типографика|Заброшен, не обновляется, нет batch-обработки|
|**Типограф Лебедева** (web)|Эталонный алгоритм|Веб-сервис, нужно копировать вручную|
|**Реформатор**|Несколько языков|Не обрабатывает вложенные кавычки, нет preview|

**Конкурентное преимущество:** Полная русская типографика (включая вложенные кавычки «„ "»), batch-обработка всего файла, preview изменений, модульная система правил с включением/отключением.

## Функциональные требования

### FR-01: Правила типографики

Каждое правило — отдельный модуль, который можно включить/выключить.

**Кавычки (Quotes):**

- `"текст"` → `«текст»` (русский контекст)
- Вложенные: `«внешние „внутренние" кавычки»`
- Английский контекст: `"text"` → `"text"` (парные, curly quotes)
- Одинарные: `'text'` → `'text'`
- Автодетект языка по содержимому (кириллица → русские правила)

**Тире и дефисы (Dashes):**

- `-` (пробел-дефис-пробел) → `—` (длинное тире, em dash)
- `число–число` → `число–число` (диапазон, en dash): `10-20` → `10–20`
- Сохранять дефис в составных словах: `веб-дизайн`, `кое-что`

**Пробелы (Spaces):**

- Двойные/тройные пробелы → одинарный
- Неразрывный пробел (nbsp, `\u00A0`) перед:
    - Короткие предлоги и союзы: и, в, на, не, но, по, за, из, от, до, с, к, о, а, у
    - Частицы: бы, ли, же
    - Инициалы: `А. С.` → `А.\u00A0С.`
- Неразрывный пробел после:
    - `№`, `§`, `©`, `®`, `™`
    - Единицы измерения при числе: `100 кг` → `100\u00A0кг`
- Удаление пробелов в начале/конце строки (trim)

**Спецсимволы (Special characters):**

- `(c)` → `©`, `(r)` → `®`, `(tm)` → `™`
- `...` → `…` (многоточие, ellipsis)
- `+-` → `±`
- `!=` → `≠`
- `<=` → `≤`, `>=` → `≥`
- `->` → `→`, `<-` → `←`
- `x` между числами → `×` (знак умножения): `1920x1080` → `1920×1080`

**Числа (Numbers):**

- Разделение тысяч тонким пробелом: `1000000` → `1 000 000` (опционально, thin space `\u2009`)
- Знак рубля: `руб.` → `₽` (опционально)
- Знак градуса: `20C` → `20 °C`

### FR-02: Область применения

- **Selection** — только выделенные ноды
- **Page** — все текстовые ноды текущей страницы
- **Document** — все страницы (с предупреждением о длительности)
- Рекурсивный обход: ищем все TextNode внутри выделенных фреймов/групп

### FR-03: Preview изменений

- Перед применением: список всех предлагаемых изменений
- Для каждого: имя ноды, фрагмент "было → стало" с подсветкой изменённых символов
- Чекбоксы: можно исключить отдельные изменения
- Счётчик: "Будет изменено: 47 замен в 12 нодах"

### FR-04: Применение

- Кнопка "Apply All" — применить все preview-изменения
- Кнопка "Apply" на каждой ноде — индивидуально
- **Загрузка шрифтов:** перед изменением текста обязательно `figma.loadFontAsync()` для шрифта каждой ноды
- **Mixed fonts:** если TextNode содержит разные шрифты (segments), загружать все уникальные шрифты

### FR-05: Настройки

- Чекбоксы для каждой группы правил (кавычки, тире, пробелы, спецсимволы, числа)
- Язык по умолчанию: Русский / Английский / Автоопределение
- Сохранение профиля настроек в `clientStorage`
- "Строгий режим" — дополнительные проверки (например, минус вместо тире в ценах)

## Архитектура

```
typograph/
├── manifest.json
├── code.ts              ← Сбор текстовых нод, применение изменений
├── ui.html              ← Preview, настройки, список изменений
├── rules/
│   ├── quotes.ts        ← Модуль кавычек
│   ├── dashes.ts        ← Модуль тире
│   ├── spaces.ts        ← Модуль пробелов
│   ├── specials.ts      ← Модуль спецсимволов
│   └── numbers.ts       ← Модуль чисел
├── tsconfig.json
└── package.json
```

> **Примечание по сборке:** Так как ui.html — единственный файл, все модули правил компилируются в один `code.js` через bundler (esbuild/webpack). Модули правил — для организации кода, а не для динамической загрузки.

### Ключевая логика

```typescript
// Интерфейс правила типографики
interface TypographRule {
  id: string;
  name: string;
  group: 'quotes' | 'dashes' | 'spaces' | 'specials' | 'numbers';
  description: string;
  apply(text: string, lang: 'ru' | 'en' | 'auto'): TypographChange[];
}

interface TypographChange {
  ruleId: string;
  startIndex: number;
  endIndex: number;
  original: string;
  replacement: string;
}

// Пример: модуль кавычек
const quotesRule: TypographRule = {
  id: 'quotes-ru',
  name: 'Русские кавычки',
  group: 'quotes',
  description: '"текст" → «текст»',
  apply(text: string, lang: string): TypographChange[] {
    const changes: TypographChange[] = [];
    if (lang !== 'ru' && lang !== 'auto') return changes;

    // Простые парные кавычки → ёлочки
    // Регулярка находит пары "..." и заменяет на «...»
    const regex = /"([^"]*?)"/g;
    let match;
    while ((match = regex.exec(text)) !== null) {
      changes.push({
        ruleId: 'quotes-ru',
        startIndex: match.index,
        endIndex: match.index + match[0].length,
        original: match[0],
        replacement: `«${match[1]}»`,
      });
    }
    return changes;
  }
};

// Автоопределение языка
function detectLanguage(text: string): 'ru' | 'en' {
  const cyrillicCount = (text.match(/[а-яёА-ЯЁ]/g) || []).length;
  const latinCount = (text.match(/[a-zA-Z]/g) || []).length;
  return cyrillicCount >= latinCount ? 'ru' : 'en';
}

// Применение изменений к TextNode
async function applyChanges(node: TextNode, changes: TypographChange[]): Promise<void> {
  // Загружаем все шрифты ноды
  const segments = node.getStyledTextSegments(['fontName']);
  for (const seg of segments) {
    await figma.loadFontAsync(seg.fontName as FontName);
  }

  // Применяем замены с конца, чтобы не сбить индексы
  let text = node.characters;
  const sorted = [...changes].sort((a, b) => b.startIndex - a.startIndex);
  for (const change of sorted) {
    text = text.slice(0, change.startIndex) + change.replacement + text.slice(change.endIndex);
  }
  node.characters = text;
}
```

### manifest.json

```json
{
  "name": "Typograph",
  "id": "000000000000000010",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": { "allowedDomains": ["none"] },
  "menu": [
    { "name": "Открыть Typograph", "command": "open" },
    { "separator": true },
    { "name": "Quick Fix (selection)", "command": "quick-fix" }
  ]
}
```

## UI (макет)

```
┌───────────────────────────────────────┐
│ ✏️ Typograph                     [×]  │
├───────────────────────────────────────┤
│ Область: [● Selection ○ Page ○ All]   │
│ Язык: [● Авто  ○ RU  ○ EN]           │
├───────────────────────────────────────┤
│ Правила:                              │
│ ☑ Кавычки «ёлочки»                   │
│ ☑ Тире и дефисы                       │
│ ☑ Неразрывные пробелы                 │
│ ☑ Спецсимволы (©, ™, →)              │
│ ☐ Числа (разделение тысяч)            │
│                                       │
│ [🔍 Сканировать]                      │
├───────────────────────────────────────┤
│ Найдено: 47 замен в 12 нодах          │
│                                       │
│ ☑ "Header Title" (TextNode)           │
│   "Купить сейчас" → «Купить сейчас»  │
│   100x200 → 100×200                   │
│                                       │
│ ☑ "Body Text" (TextNode)              │
│   предлог "в " → "в\u00A0"           │
│   " - " → " — "                       │
│ ...                                   │
├───────────────────────────────────────┤
│ [✓ Apply All (47)]  [Отмена]          │
└───────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Модуль кавычек (включая вложенные)|4 ч|
|2|Модуль тире/дефисов + пробелов + неразрывных|3 ч|
|3|Модуль спецсимволов + чисел|2 ч|
|4|Сбор TextNode, загрузка шрифтов, применение|3 ч|
|5|UI: preview, чекбоксы правил, настройки|4 ч|
|6|Quick Fix (без UI), batch по всему документу|2 ч|
|7|Тестирование edge cases, mixed fonts, вложенные кавычки|3 ч|
|**Итого**||**~21 ч (3–4 дня)**|

## Технические сложности

- **Вложенные кавычки:** `«внешние „внутренние" кавычки»` — нужен стековый парсер, а не простая регулярка
- **Mixed fonts:** один TextNode может содержать несколько шрифтов/стилей → нужно загрузить все через `getStyledTextSegments`
- **Индексация замен:** при множественных заменах в одном тексте индексы сдвигаются → применять с конца строки
- **Контекстные правила:** тире `–` vs дефис `-` зависит от контекста (число–число vs пробел–тире–пробел)

---

# A2.2 — Design Lint

## Цель

Модульный аудит макетов: проверка привязки к токенам, стилей текста, спейсинга, пиксельной сетки, оверрайдов в инстансах и других аспектов "чистоты" дизайн-файла. Расширяемая архитектура правил.

## Проблема

Дизайн-файлы "загрязняются" со временем: хардкод цветов вместо токенов, нестандартные размеры шрифтов, дробные координаты, неиспользуемые стили. Ручная проверка невозможна в файлах с сотнями экранов.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Design Lint** (deslint.com)|Open source, хороший набор проверок|Медленный на больших файлах, UI устарел, не расширяемый|
|**Bono Auditor**|Красивый UI, множество проверок|Закрытый, платный, не кастомизируемый|
|**Figma's built-in lint**|Нативный|Очень ограниченный набор проверок|
|**Roller**|Проверка consistency|Только цвета и шрифты|

**Конкурентное преимущество:** Модульная архитектура (плагины правил), интеграция с Variables/Tokens, кастомные правила, поэтапная проверка, возможность подключения к CI.

## Функциональные требования

### FR-01: Модули проверок (Lint Rules)

Каждый модуль — независимый чекер с настройками.

**Модуль: Pixel Grid**

- Проверка дробных координат и размеров (как Pixel Audit A1.1)
- Настройка: шаг сетки (1px, 4px, 8px)
- Severity: warning (если дробные) или error (если не кратно шагу)

**Модуль: Color Tokens**

- Поиск hardcoded цветов (fills/strokes не привязаны к Variable или Style)
- Показать: "этот цвет похож на token `color/primary/500` (distance: 3%)"
- Настройка: допустимое отклонение (color distance threshold)

**Модуль: Text Styles**

- Поиск текстовых нод без привязки к TextStyle
- Поиск нестандартных размеров шрифтов (не из шкалы: 12, 14, 16, 18, 20, 24, 32, 40, 48, 64)
- Настройка: кастомная шкала размеров
- Проверка lineHeight: должен быть явно задан (не "Auto" для body-текста)

**Модуль: Spacing**

- Проверка Auto Layout: itemSpacing и padding кратны базовому шагу (4px или 8px)
- Проверка ручного позиционирования: расстояния между нодами соответствуют шкале спейсинга
- Настройка: базовый шаг, допустимые значения

**Модуль: Instance Overrides**

- Поиск инстансов с стилевыми оверрайдами (как Instance Reset A1.4)
- Показать: какие свойства переопределены
- Severity: info (текстовые оверрайды) / warning (стилевые)

**Модуль: Naming Conventions**

- Проверка имён слоёв на соответствие паттерну
- Поиск дефолтных имён: "Frame 1", "Rectangle 5", "Group 3"
- Настройка: regex или список разрешённых паттернов

**Модуль: Accessibility**

- Контрастность текст/фон: WCAG AA (4.5:1 для обычного, 3:1 для крупного текста)
- Минимальный размер шрифта: 12px (настраиваемый)
- Touch target: минимум 44×44 для интерактивных элементов (мобильные)
- Отсутствие alt text (через pluginData или description)

**Модуль: Detached Instances**

- Поиск фреймов, которые ранее были инстансами (по имени или pluginData)
- Предупреждение о потенциально случайном detach

**Модуль: Hidden Layers**

- Поиск невидимых нод (visible: false)
- Отдельно: ноды с opacity: 0

### FR-02: Уровни серьёзности (Severity)

```
🔴 Error   — нарушение, требующее исправления
🟡 Warning — потенциальная проблема
🔵 Info    — информационное замечание
```

Каждое правило имеет дефолтный severity, который можно переопределить в настройках.

### FR-03: Область сканирования

- Selection / Page / Document
- Исключения: ноды с pluginData `lint-ignore: true` (можно пометить)
- Фильтрация по типу нод

### FR-04: Отчёт

- Группировка: по модулю / по ноде / по severity
- Навигация: клик по issue → `scrollAndZoomIntoView`
- Сводка: "5 errors, 12 warnings, 8 info" с прогресс-баром
- Экспорт отчёта: JSON / Markdown (для документации)

### FR-05: Авто-фикс

- Некоторые правила поддерживают auto-fix:
    - Pixel Grid → округление
    - Hidden Layers → удаление
    - Default Names → предложить имя по типу и контексту
- Кнопка "Fix" рядом с каждым fixable issue

### FR-06: Конфигурация

- Профили настроек: "Strict", "Normal", "Relaxed"
- Импорт/экспорт конфигурации (JSON)
- Настройки по модулям: включение/отключение, severity, параметры
- Хранение: `figma.clientStorage` для локальных, `figma.root.setPluginData` для shared

## Архитектура

```
design-lint/
├── manifest.json
├── code.ts              ← Оркестратор: запуск модулей, сбор результатов
├── ui.html              ← Отчёт, настройки, навигация
├── rules/
│   ├── base.ts          ← Интерфейс LintRule, типы
│   ├── pixel-grid.ts
│   ├── color-tokens.ts
│   ├── text-styles.ts
│   ├── spacing.ts
│   ├── overrides.ts
│   ├── naming.ts
│   ├── accessibility.ts
│   ├── detached.ts
│   └── hidden.ts
├── tsconfig.json
└── package.json
```

### Интерфейс модуля

```typescript
interface LintRule {
  id: string;
  name: string;
  description: string;
  defaultSeverity: 'error' | 'warning' | 'info';
  defaultEnabled: boolean;
  configSchema?: Record<string, any>;  // JSON Schema для настроек

  // Основной метод — проверяет ноду и возвращает список issues
  check(node: SceneNode, config: any): LintIssue[];

  // Опциональный авто-фикс
  fix?(node: SceneNode, issue: LintIssue): void;
}

interface LintIssue {
  ruleId: string;
  nodeId: string;
  nodeName: string;
  nodePath: string;      // "Page/Frame/Button"
  severity: 'error' | 'warning' | 'info';
  message: string;
  details?: string;
  fixable: boolean;
  suggestion?: string;   // "Похож на token color/primary/500"
}

// Реестр всех правил
const ruleRegistry: LintRule[] = [
  pixelGridRule,
  colorTokensRule,
  textStylesRule,
  spacingRule,
  overridesRule,
  namingRule,
  accessibilityRule,
  detachedRule,
  hiddenRule,
];
```

### Оркестратор

```typescript
async function runLint(scope: SceneNode[], config: LintConfig): Promise<LintReport> {
  const issues: LintIssue[] = [];
  const enabledRules = ruleRegistry.filter(r => config.rules[r.id]?.enabled !== false);

  for (const node of scope) {
    for (const rule of enabledRules) {
      const ruleConfig = config.rules[rule.id] || {};
      const nodeIssues = rule.check(node, ruleConfig);
      issues.push(...nodeIssues);
    }

    // Рекурсия
    if ('children' in node) {
      const childReport = await runLint([...node.children], config);
      issues.push(...childReport.issues);
    }
  }

  return {
    issues,
    summary: {
      errors: issues.filter(i => i.severity === 'error').length,
      warnings: issues.filter(i => i.severity === 'warning').length,
      info: issues.filter(i => i.severity === 'info').length,
      nodesScanned: scope.length,
    }
  };
}
```

## UI (макет)

```
┌───────────────────────────────────────────┐
│ 🔍 Design Lint                       [×]  │
├───────────────────────────────────────────┤
│ Область: [● Selection ○ Page]             │
│ Профиль: [Normal ▾]  [⚙ Настройки]       │
│                                           │
│ [🔍 Запустить проверку]                   │
├───────────────────────────────────────────┤
│ 🔴 5  🟡 12  🔵 8    Всего: 25 issues    │
│                                           │
│ ─── Группировка: [● Модуль ○ Severity] ──│
│                                           │
│ ▼ 🎨 Color Tokens (7)                    │
│  🔴 "Card BG" fill #3366CC not a token   │
│     → Похож на primary/500     [Fix] [👁] │
│  🟡 "Header" fill #F5F5F5 not a token    │
│     → Похож на neutral/100     [Fix] [👁] │
│  ...                                      │
│                                           │
│ ▼ 📐 Pixel Grid (5)                      │
│  🟡 "Icon" x: 12.5 → 13           [Fix]  │
│  🟡 "Frame" width: 1080.3 → 1080  [Fix]  │
│  ...                                      │
│                                           │
│ ▼ ✏️ Text Styles (4)                     │
│  🔴 "Body" font-size 15px not in scale   │
│     → Ближайший: 14px или 16px    [👁]   │
│  ...                                      │
├───────────────────────────────────────────┤
│ [✓ Fix All Fixable (9)]  [📋 Export]     │
└───────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Архитектура: интерфейс LintRule, оркестратор, рекурсивный обход|4 ч|
|2|Модуль Pixel Grid (переиспользуем код Pixel Audit)|2 ч|
|3|Модуль Color Tokens (поиск hardcoded, distance matching)|4 ч|
|4|Модуль Text Styles (шкала, lineHeight, style binding)|3 ч|
|5|Модуль Spacing (Auto Layout params, grid step)|3 ч|
|6|Модули: Overrides, Naming, Hidden, Detached|4 ч|
|7|Модуль Accessibility (контраст, touch targets)|4 ч|
|8|UI: отчёт, группировка, навигация, фильтры|5 ч|
|9|Auto-fix для fixable правил|3 ч|
|10|Конфигурация: профили, import/export, clientStorage|3 ч|
|11|Экспорт отчёта (JSON, Markdown)|2 ч|
|12|Тестирование, производительность на больших файлах|3 ч|
|**Итого**||**~40 ч (1–1.5 недели)**|

## Связи с другими плагинами

- **Pixel Audit (A1.1):** модуль Pixel Grid переиспользует ту же логику
- **Instance Reset (A1.4):** модуль Overrides переиспользует анализ оверрайдов
- **Palette Lab (A1.6):** модуль Color Tokens использует Variables API для поиска ближайшего токена
- **Design Checklist (A2.9):** результаты lint могут проверяться чеклистом

---

# A2.3 — Typo Spec

## Цель

Плагин для создания TextStyles и привязки их свойств к Variables на основе спецификации из таблицы (CSV/JSON). Автоматизирует рутинную работу по настройке типографической системы дизайн-файла.

## Проблема

При создании дизайн-системы настройка TextStyles — одна из самых нудных задач. Нужно вручную создать десятки стилей (heading-1, body-lg, caption-sm...), задать для каждого fontFamily, fontSize, lineHeight, fontWeight, letterSpacing. Ещё хуже — привязать каждое свойство к Variable для поддержки тем и responsive. Для 20 стилей это ~100 ручных операций.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Tokens Studio**|Полное управление токенами|Тяжёлый, платный Pro, сложный UI|
|**Batch Styler**|Пакетное изменение стилей|Нет создания, нет Variables binding|
|**Style Organizer**|Организация стилей|Нет импорта из CSV/JSON|

**Конкурентное преимущество:** Импорт спецификации из CSV/JSON → автосоздание TextStyles → привязка к Variables. Весь процесс за секунды вместо часов.

## Функциональные требования

### FR-01: Импорт спецификации

**Формат CSV:**

```csv
name,fontFamily,fontWeight,fontSize,lineHeight,letterSpacing,paragraphSpacing
heading-1,Inter,700,48,56,0,0
heading-2,Inter,700,36,44,-0.2,0
heading-3,Inter,600,28,36,-0.1,0
body-lg,Inter,400,18,28,0,16
body-md,Inter,400,16,24,0,12
body-sm,Inter,400,14,20,0.1,8
caption,Inter,400,12,16,0.2,0
label,Inter,500,14,20,0.1,0
```

**Формат JSON:**

```json
{
  "styles": [
    {
      "name": "heading-1",
      "fontFamily": "Inter",
      "fontWeight": 700,
      "fontSize": 48,
      "lineHeight": { "value": 56, "unit": "PIXELS" },
      "letterSpacing": { "value": 0, "unit": "PIXELS" }
    }
  ]
}
```

- Загрузка файла через drag-n-drop или file picker в UI
- Ручной ввод/редактирование таблицы в UI
- Валидация: проверка обязательных полей, корректность значений

### FR-02: Создание TextStyles

- Для каждой строки спецификации:
    1. Загрузить шрифт: `await figma.loadFontAsync({ family, style })`
    2. Создать `figma.createTextStyle()`
    3. Установить свойства: `fontName`, `fontSize`, `lineHeight`, `letterSpacing`, `paragraphSpacing`
    4. Задать имя стиля (с поддержкой `группа/имя` для категоризации)
- Если стиль с таким именем существует — режимы: обновить / пропустить / переименовать
- Preview: список стилей, которые будут созданы

### FR-03: Привязка к Variables

- Опционально: создать VariableCollection `"Typography"` с режимами
- Для каждого свойства стиля создать Variable:
    - `typo/heading-1/fontSize` → FLOAT = 48
    - `typo/heading-1/fontWeight` → FLOAT = 700
    - `typo/heading-1/lineHeight` → FLOAT = 56
    - `typo/heading-1/fontFamily` → STRING = "Inter"
- Привязать Variable к TextStyle через `textStyle.setBoundVariable(field, variable)`
- Если Variables уже существуют — привязать к существующим

### FR-04: Responsive режимы

- Поддержка нескольких режимов (modes) в одной коллекции:
    - Desktop / Tablet / Mobile
    - Разные размеры шрифтов для каждого режима
- Расширенный CSV:
    
    ```csv
    name,fontFamily,fontWeight,fontSize_desktop,fontSize_tablet,fontSize_mobile,lineHeight_desktop,lineHeight_tablet,lineHeight_mobileheading-1,Inter,700,48,40,32,56,48,40
    ```
    

### FR-05: Экспорт существующих стилей

- Обратная операция: TextStyles файла → CSV/JSON
- Полезно для аудита, миграции, бэкапа
- Включает информацию о привязках к Variables

### FR-06: Preview & Apply

- Таблица в UI с preview всех стилей
- Колонки: Name, Font, Weight, Size, Line Height, Letter Spacing
- Редактирование значений прямо в таблице
- "Apply" → создание стилей + (опционально) Variables

## Архитектура

### Ключевая логика

```typescript
interface TypoSpecEntry {
  name: string;
  fontFamily: string;
  fontStyle?: string;   // "Regular", "Bold" — маппится из fontWeight
  fontWeight: number;
  fontSize: number;
  lineHeight: number;
  lineHeightUnit: 'PIXELS' | 'PERCENT' | 'AUTO';
  letterSpacing: number;
  letterSpacingUnit: 'PIXELS' | 'PERCENT';
  paragraphSpacing?: number;
}

// Маппинг fontWeight → fontStyle name
const WEIGHT_TO_STYLE: Record<number, string> = {
  100: 'Thin', 200: 'Extra Light', 300: 'Light',
  400: 'Regular', 500: 'Medium', 600: 'Semi Bold',
  700: 'Bold', 800: 'Extra Bold', 900: 'Black',
};

async function createTextStyleFromSpec(spec: TypoSpecEntry): Promise<TextStyle> {
  const styleName = WEIGHT_TO_STYLE[spec.fontWeight] || 'Regular';
  await figma.loadFontAsync({ family: spec.fontFamily, style: styleName });

  const textStyle = figma.createTextStyle();
  textStyle.name = spec.name;
  textStyle.fontName = { family: spec.fontFamily, style: styleName };
  textStyle.fontSize = spec.fontSize;
  textStyle.lineHeight = { value: spec.lineHeight, unit: spec.lineHeightUnit || 'PIXELS' };
  textStyle.letterSpacing = { value: spec.letterSpacing, unit: spec.letterSpacingUnit || 'PIXELS' };
  if (spec.paragraphSpacing !== undefined) {
    textStyle.paragraphSpacing = spec.paragraphSpacing;
  }

  return textStyle;
}

async function bindTypoVariables(
  textStyle: TextStyle,
  spec: TypoSpecEntry,
  collection: VariableCollection,
  modeId: string
): Promise<void> {
  // fontSize Variable
  const fontSizeVar = figma.variables.createVariable(
    `typo/${spec.name}/fontSize`, collection, 'FLOAT'
  );
  fontSizeVar.setValueForMode(modeId, spec.fontSize);
  fontSizeVar.scopes = ['FONT_SIZE'];
  textStyle.setBoundVariable('fontSize', fontSizeVar);

  // fontWeight Variable
  const fontWeightVar = figma.variables.createVariable(
    `typo/${spec.name}/fontWeight`, collection, 'FLOAT'
  );
  fontWeightVar.setValueForMode(modeId, spec.fontWeight);
  fontWeightVar.scopes = ['FONT_WEIGHT'];
  textStyle.setBoundVariable('fontWeight', fontWeightVar);

  // lineHeight Variable
  const lineHeightVar = figma.variables.createVariable(
    `typo/${spec.name}/lineHeight`, collection, 'FLOAT'
  );
  lineHeightVar.setValueForMode(modeId, spec.lineHeight);
  lineHeightVar.scopes = ['LINE_HEIGHT'];
  textStyle.setBoundVariable('lineHeight', lineHeightVar);

  // fontFamily Variable
  const fontFamilyVar = figma.variables.createVariable(
    `typo/${spec.name}/fontFamily`, collection, 'STRING'
  );
  fontFamilyVar.setValueForMode(modeId, spec.fontFamily);
  fontFamilyVar.scopes = ['FONT_FAMILY'];
  textStyle.setBoundVariable('fontFamily', fontFamilyVar);
}
```

## UI (макет)

```
┌─────────────────────────────────────────────────────┐
│ 🔤 Typo Spec                                  [×]  │
├─────────────────────────────────────────────────────┤
│ Режим: [● Импорт ○ Экспорт]                        │
│                                                     │
│ [📁 Загрузить CSV/JSON]  или  [Ввести вручную]     │
├─────────────────────────────────────────────────────┤
│ Name        │ Font  │ W  │ Size │ LH  │ LS  │ PS   │
│─────────────┼───────┼────┼──────┼─────┼─────┼──────│
│ heading-1   │ Inter │700 │ 48   │ 56  │ 0   │ 0    │
│ heading-2   │ Inter │700 │ 36   │ 44  │-0.2 │ 0    │
│ body-lg     │ Inter │400 │ 18   │ 28  │ 0   │ 16   │
│ body-md     │ Inter │400 │ 16   │ 24  │ 0   │ 12   │
│ caption     │ Inter │400 │ 12   │ 16  │ 0.2 │ 0    │
│ [+ Добавить строку]                                 │
├─────────────────────────────────────────────────────┤
│ ☑ Создать TextStyles                                │
│ ☑ Создать Variables (коллекция: "Typography")       │
│ ☑ Привязать Variables к стилям                      │
│                                                     │
│ Конфликты: [● Обновить ○ Пропустить ○ Переименовать]│
├─────────────────────────────────────────────────────┤
│ [✓ Apply]  [Preview]                                │
└─────────────────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Парсер CSV/JSON, валидация, нормализация|3 ч|
|2|Создание TextStyles из спецификации|3 ч|
|3|Создание VariableCollection + привязка к стилям|4 ч|
|4|Responsive modes (multi-column CSV)|3 ч|
|5|UI: таблица, drag-n-drop, inline редактирование|5 ч|
|6|Экспорт существующих стилей в CSV/JSON|2 ч|
|7|Обработка конфликтов, preview|2 ч|
|8|Тестирование, edge cases (missing fonts, etc.)|2 ч|
|**Итого**||**~24 ч (3–4 дня)**|

---

# A2.4 — Wireframe Kit

## Цель

Библиотека lo-fi (low-fidelity) блоков для быстрого прототипирования варфреймов и создания карт сайта (sitemap) прямо в Figma. Вставка готовых паттернов через плагин, без необходимости подключать внешнюю библиотеку.

## Проблема

При старте проекта дизайнер тратит время на рисование lo-fi блоков с нуля или ищет Figma Community файлы, которые нужно скопировать вручную. Нет единого стандартного набора с вставкой из плагина.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Wireframe Designer** (Community)|Хороший набор блоков|Нужно вручную копировать, нет плагина|
|**Autoflow**|Стрелки между экранами|Нет wireframe блоков|
|**Sitemap** плагины|Генерация sitemap|Примитивные, нет wireframe паттернов|
|**Balsamiq**|Классический wireframe-инструмент|Отдельное приложение, не Figma|

**Конкурентное преимущество:** Плагин с каталогом блоков, вставка в один клик, кастомизация цвета/размера, auto layout, интеграция с Navigator.

## Функциональные требования

### FR-01: Каталог блоков

Категории и блоки (каждый — Auto Layout Frame):

**Navigation:**

- Navbar (desktop): лого + меню + CTA
- Navbar (mobile): бургер + лого + иконки
- Sidebar: вертикальное меню с иконками
- Tab Bar (mobile): 3–5 вкладок
- Breadcrumbs
- Pagination

**Hero / Header:**

- Hero с заголовком + кнопкой
- Hero с изображением (placeholder)
- Hero Split (текст слева, изображение справа)
- Banner / Alert

**Content:**

- Text Block (заголовок + абзац)
- Image Placeholder (с иконкой "горы")
- Video Placeholder (с иконкой "play")
- Quote / Testimonial
- Stats / Metrics (числа в ряд)

**Cards:**

- Product Card (image + title + price + button)
- Article Card (image + title + excerpt + date)
- Profile Card (avatar + name + role)
- Pricing Card (plan + price + features + CTA)

**Forms:**

- Input Field (label + input)
- Textarea
- Select / Dropdown
- Checkbox / Radio
- Toggle
- Button (primary / secondary / text)
- Form Group (login / signup / contact)

**Lists:**

- Simple List
- List with Icons
- Table (header + rows)
- Accordion

**Modals / Overlays:**

- Modal (title + body + actions)
- Toast / Snackbar
- Tooltip
- Bottom Sheet (mobile)

**Sitemap:**

- Page Node (box с заголовком)
- Connector Line (горизонтальная/вертикальная)
- Sitemap Template (главная + подстраницы)

### FR-02: Вставка блоков

- Клик по блоку в каталоге → вставка в центр viewport
- Или drag-n-drop на канвас (если возможно в API)
- Авторазмер: блок адаптируется к заданной ширине (desktop: 1440px, tablet: 768px, mobile: 375px)
- Device preset: переключатель размера перед вставкой

### FR-03: Кастомизация

- Цвет wireframe: серый (default), синий (blueprint), чёрно-белый
- Стиль: чистый (линии) / sketchy (имитация руки)
- Уровень детализации: minimal / standard / detailed
- Настройки применяются до вставки и сохраняются

### FR-04: Генерация SVG на лету

Блоки НЕ хранятся как Figma-компоненты (это потребовало бы библиотеки). Вместо этого каждый блок — функция, генерирующая набор нод:

```typescript
// Пример: функция генерации Navbar
function createNavbar(options: WireframeOptions): FrameNode {
  const frame = figma.createFrame();
  frame.name = 'Navbar';
  frame.layoutMode = 'HORIZONTAL';
  frame.primaryAxisAlignItems = 'SPACE_BETWEEN';
  frame.counterAxisAlignItems = 'CENTER';
  frame.paddingLeft = 24;
  frame.paddingRight = 24;
  frame.resize(options.width, 64);
  frame.fills = [{ type: 'SOLID', color: hexToRGB(options.bgColor) }];

  // Logo placeholder
  const logo = figma.createRectangle();
  logo.resize(100, 32);
  logo.fills = [{ type: 'SOLID', color: hexToRGB(options.accentColor) }];
  logo.cornerRadius = 4;
  frame.appendChild(logo);

  // Menu items
  // ... создание текстовых нод для пунктов меню
  
  return frame;
}
```

### FR-05: Композиции (Page Templates)

- Готовые композиции из нескольких блоков:
    - Landing Page: Navbar + Hero + Features + Testimonials + CTA + Footer
    - Dashboard: Sidebar + Header + Cards Grid + Table
    - Blog: Navbar + Article Cards Grid + Sidebar + Footer
    - Mobile App Screen: Status Bar + Navbar + Content + Tab Bar
- Вставка: одна кнопка → готовый wireframe страницы

## Архитектура

```
wireframe-kit/
├── manifest.json
├── code.ts              ← Генерация нод, вставка
├── ui.html              ← Каталог, preview, настройки
├── blocks/
│   ├── navigation.ts    ← Navbar, Sidebar, TabBar...
│   ├── hero.ts          ← Hero variants
│   ├── content.ts       ← Text, Image, Video...
│   ├── cards.ts         ← Product, Article, Profile...
│   ├── forms.ts         ← Input, Button, Form Group...
│   ├── lists.ts         ← List, Table, Accordion...
│   ├── overlays.ts      ← Modal, Toast, Tooltip...
│   └── sitemap.ts       ← Page Node, Connector...
├── templates/
│   ├── landing.ts       ← Композиция Landing Page
│   ├── dashboard.ts
│   ├── blog.ts
│   └── mobile-app.ts
├── tsconfig.json
└── package.json
```

## UI (макет)

```
┌─────────────────────────────────────────┐
│ 📐 Wireframe Kit                   [×]  │
├─────────────────────────────────────────┤
│ Device: [● Desktop ○ Tablet ○ Mobile]   │
│ Style:  [● Clean ○ Blueprint ○ Sketch]  │
├─────────────────────────────────────────┤
│ [🔍 Поиск блока...]                    │
├─────────────────────────────────────────┤
│ ▼ Navigation                            │
│   [Navbar] [Sidebar] [TabBar]           │
│   [Breadcrumbs] [Pagination]            │
│                                         │
│ ▼ Hero / Header                         │
│   [Hero Basic] [Hero Image] [Hero Split]│
│                                         │
│ ▼ Content                               │
│   [Text Block] [Image] [Video] [Quote]  │
│                                         │
│ ▼ Cards                                 │
│   [Product] [Article] [Profile] [Pricing│
│                                         │
│ ▼ Forms                                 │
│   [Input] [Textarea] [Select] [Button]  │
│   [Login Form] [Signup Form]            │
│                                         │
│ ... (expandable categories)             │
├─────────────────────────────────────────┤
│ ── Templates ──                         │
│ [📄 Landing] [📊 Dashboard]             │
│ [📝 Blog] [📱 Mobile App]              │
└─────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Архитектура: интерфейс блока, генератор, options|3 ч|
|2|Блоки Navigation (5 штук)|4 ч|
|3|Блоки Hero + Content (8 штук)|4 ч|
|4|Блоки Cards + Forms (12 штук)|6 ч|
|5|Блоки Lists + Overlays + Sitemap (10 штук)|5 ч|
|6|Templates (4 композиции)|4 ч|
|7|UI: каталог с категориями, поиск, preview|4 ч|
|8|Настройки: device, style, color theme|2 ч|
|9|Тестирование, polish, Auto Layout проверки|3 ч|
|**Итого**||**~35 ч (1 неделя)**|

## Технические сложности

- **Загрузка шрифтов:** каждый блок с текстом требует `loadFontAsync` — нужна предзагрузка стандартного wireframe-шрифта (Inter или SF Mono)
- **Auto Layout:** все блоки должны быть валидным Auto Layout для корректного resize
- **Sketchy стиль:** для имитации рисования от руки можно использовать `figma.createNodeFromSVG()` с slighly jittered paths
- **Объём кода:** ~40 блоков × ~30 строк каждый = ~1200 строк в block-генераторах — нужна хорошая абстракция

---

# A2.5 — Icon Finder

## Цель

Поиск иконок среди библиотек команды и через Iconify API с превью и вставкой прямо в Figma. Единая точка поиска вместо переключения между библиотеками и вкладками браузера.

## Проблема

Дизайнеры ищут иконки в нескольких местах: Assets Panel (библиотеки команды), Figma Community, Iconify.design, отдельные сайты (Heroicons, Phosphor, Lucide). Переключение контекста снижает продуктивность.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Iconify** (плагин)|Огромная база (200k+ иконок)|Медленный, нет поиска по библиотекам команды|
|**Icons8** (плагин)|Красивый UI, стили|Платный, нет team libraries|
|**Feather Icons** (плагин)|Быстрый, бесплатный|Только один набор иконок|
|**Assets Panel** (встроенный)|Библиотеки команды|Слабый поиск, нет внешних иконок|

**Конкурентное преимущество:** Единый поиск по team libraries + Iconify API, предпросмотр с фильтрацией по стилю/размеру, вставка как Component Instance (из библиотеки) или SVG (из Iconify).

## Функциональные требования

### FR-01: Поиск по библиотекам команды

- Используем `figma.teamLibrary` API
- Поиск компонентов по имени среди всех подключённых библиотек
- Фильтрация: только компоненты с тегом/именем, содержащим "icon" (или кастомный паттерн)
- Результаты: thumbnail + имя + библиотека
- Вставка: `figma.importComponentByKeyAsync(key)` → `component.createInstance()`

### FR-02: Поиск через Iconify API

- Публичный API: `https://api.iconify.design/`
    - `GET /search?query=arrow&limit=64` → список иконок
    - `GET /{prefix}/{name}.svg` → SVG-код иконки
- Поддерживаемые наборы: Material Icons, Lucide, Phosphor, Heroicons, Tabler, Bootstrap Icons и 150+ других
- Фильтрация по набору (prefix): `mdi`, `lucide`, `ph`, `heroicons`
- Фильтрация по стилю: outline / filled / duotone

### FR-03: Вставка иконки

**Из библиотеки команды:**

- Вставляется как Instance (сохраняет связь с мастером)
- Позиция: центр viewport или рядом с выделением

**Из Iconify:**

- Загружаем SVG через fetch в UI → передаём в code.ts
- `figma.createNodeFromSVG(svgString)` → вставляем на канвас
- Опция: вставить как Vector или обернуть в Component
- Настройка размера: 16, 20, 24, 32, 48 (или кастом)
- Настройка цвета: currentColor → заданный цвет (замена fill/stroke в SVG)

### FR-04: Избранное / Недавние

- Список недавно использованных иконок (clientStorage)
- Возможность добавить в избранное
- Быстрый доступ к часто используемым

### FR-05: Предпросмотр

- Grid-view с thumbnail иконок
- При наведении: увеличенный preview + имя + набор
- Переключение: grid / list view

### FR-06: Настройки

- Размер иконки по умолчанию
- Цвет по умолчанию
- Приоритетные наборы (отображаются первыми)
- Паттерн для поиска в team libraries

## Архитектура

### manifest.json

```json
{
  "name": "Icon Finder",
  "id": "000000000000000014",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": [
      "api.iconify.design"
    ]
  },
  "permissions": ["teamlibrary"]
}
```

### Потоки данных

```
[UI] Поиск "arrow"
  → fetch("https://api.iconify.design/search?query=arrow&limit=64")
  → Отображение результатов в grid

[UI] Клик на иконку из Iconify
  → fetch("https://api.iconify.design/lucide/arrow-right.svg")
  → Получаем SVG string
  → postMessage({ type: "insert-svg", svg, size, color })

[Code] Вставка SVG
  → const node = figma.createNodeFromSvg(svgString)
  → Resize, position, color adjustments
  → figma.currentPage.appendChild(node)

[UI] Клик на иконку из Team Library
  → postMessage({ type: "insert-component", key: componentKey })

[Code] Вставка Component
  → const comp = await figma.importComponentByKeyAsync(key)
  → const instance = comp.createInstance()
  → position, resize
```

## UI (макет)

```
┌─────────────────────────────────────────┐
│ 🔍 Icon Finder                     [×]  │
├─────────────────────────────────────────┤
│ [🔍 Search icons...              ]      │
│ Источник: [● Все ○ Team ○ Iconify]     │
│ Набор: [All ▾]  Стиль: [All ▾]        │
│ Размер: [24] px   Цвет: [■ #1A1A1A]   │
├─────────────────────────────────────────┤
│ ⭐ Недавние                             │
│ [→] [←] [✓] [✕] [⚙] [👤] [📁] [🔔]  │
├─────────────────────────────────────────┤
│ 🏢 Team Libraries (12 results)         │
│ ┌────┐ ┌────┐ ┌────┐ ┌────┐            │
│ │ →  │ │ ←  │ │ ↑  │ │ ↓  │            │
│ │arr…│ │arr…│ │arr…│ │arr…│            │
│ └────┘ └────┘ └────┘ └────┘            │
│                                         │
│ 🌐 Iconify (64 results)                │
│ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐    │
│ │ →  │ │ ←  │ │ ↗  │ │ ↙  │ │ ⤴  │    │
│ └────┘ └────┘ └────┘ └────┘ └────┘    │
│ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐    │
│ │    │ │    │ │    │ │    │ │    │    │
│ └────┘ └────┘ └────┘ └────┘ └────┘    │
│ ...                                     │
└─────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Iconify API: поиск, загрузка SVG, фильтрация|3 ч|
|2|Team Library: поиск компонентов, фильтрация по "icon"|3 ч|
|3|Вставка: SVG → figma.createNodeFromSvg, resize, color|3 ч|
|4|Вставка: Component Instance из библиотеки|2 ч|
|5|UI: search, grid view, preview при наведении|4 ч|
|6|Недавние + избранное (clientStorage)|2 ч|
|7|Настройки: размер, цвет, приоритетные наборы|2 ч|
|8|Тестирование, edge cases (network errors, missing fonts)|2 ч|
|**Итого**||**~21 ч (3–4 дня)**|

## Технические сложности

- **Team Library API:** `figma.teamLibrary` не позволяет получить thumbnails компонентов из библиотеки. Нужно импортировать компонент для получения визуала.
- **SVG color replacement:** при вставке из Iconify нужно заменить `currentColor` / `fill` / `stroke` в SVG на заданный цвет до вставки через `createNodeFromSvg`
- **Rate limits Iconify:** API бесплатный, но нужен debounce при поиске (300ms)
- **Сетевые запросы:** все fetch-запросы из UI, данные передаются в code.ts через postMessage

# A2. Продвинутые утилиты — Технические задания (часть 2)

---

# A2.6 — Component Pocket

## Цель

Плагин для сохранения компонентов "в карман" — локальное хранилище избранных компонентов, которые можно вставить в любой файл Figma без подключённой библиотеки. Решает проблему переноса часто используемых элементов между файлами.

## Проблема

Дизайнер работает с несколькими файлами. В одном файле есть нужный компонент, но в другом его нет, а библиотека не подключена (или это личный проект). Сейчас приходится: открыть файл → скопировать → переключиться → вставить. При частом использовании — огромная потеря времени.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Figma clipboard** (Ctrl+C/V)|Нативный, быстрый|Работает только между двумя открытыми вкладками, нет сохранения|
|**Component Clipboard** плагины|Базовый функционал|Не сохраняют между сессиями, нет категоризации|
|**Figma Community libraries**|Общий доступ|Нужна публикация, нет приватного "кармана"|
|**Eagle.cool**|Хранение ассетов|Внешнее приложение, нет прямой вставки в Figma|

**Конкурентное преимущество:** Персистентное хранилище (clientStorage), категоризация, preview, вставка в один клик без открытия исходного файла.

## Функциональные требования

### FR-01: Сохранение в карман

- Выделить компонент(ы) / фрейм(ы) / группу → "Сохранить в карман"
- Плагин сериализует ноду:
    - Экспорт как PNG (preview thumbnail)
    - Сохранение JSON-представления структуры (через `node.exportAsync` для изображения + метаданные)
    - Альтернатива: экспорт в SVG для vector-нод
- Данные: имя, категория (тег), preview (thumbnail bytes), дата, тип ноды
- Хранение в `figma.clientStorage` (лимит 5 MB — нужно контролировать объём)

### FR-02: Вставка из кармана

- Открыть плагин → выбрать элемент → "Insert"
- Механизм вставки: так как `clientStorage` хранит данные локально, нужен способ воссоздать ноду:
    - **Вариант A:** Хранить SVG строку → `figma.createNodeFromSvg()` (работает для vector)
    - **Вариант B:** Хранить serialized JSON → рекурсивно воссоздавать ноды (сложно, но гибко)
    - **Вариант C:** Хранить PNG/JPG bytes → вставить как Image fill (потеря векторности)
    - **Рекомендуемый подход:** SVG для vector-элементов, PNG для сложных фреймов с эффектами
- Позиционирование: центр viewport

### FR-03: Организация

- Категории/теги: пользователь может присвоить тег при сохранении
- Предустановленные категории: Buttons, Icons, Cards, Navigation, Forms, Other
- Кастомные категории
- Поиск по имени и тегу
- Drag-and-drop для сортировки (или ручной порядок)

### FR-04: Управление хранилищем

- Показать занятый объём из 5 MB
- Удаление отдельных элементов
- Очистка всего кармана
- Экспорт/импорт кармана (JSON blob) — для переноса между машинами

### FR-05: Preview

- Grid-view с thumbnails
- Клик → увеличенный preview + метаданные (имя, дата, тип, размер)
- Info: "Original size: 200×100, Type: Frame, Saved: 2 дня назад"

## Архитектура

### Модель данных

```typescript
interface PocketItem {
  id: string;                // UUID
  name: string;
  category: string;
  nodeType: string;          // "FRAME", "COMPONENT", "GROUP", "VECTOR"
  originalWidth: number;
  originalHeight: number;
  savedAt: string;           // ISO date
  thumbnailBase64: string;   // PNG thumbnail (small)
  svgData?: string;          // SVG string (для vector-нод)
  imageBytes?: number[];     // PNG bytes (для complex frames)
  insertMode: 'svg' | 'image';
}

// Storage management
class PocketStorage {
  private static KEY = 'component-pocket-items';
  private static MAX_SIZE = 4 * 1024 * 1024; // 4MB (оставляем запас)

  static async getAll(): Promise<PocketItem[]> {
    return await figma.clientStorage.getAsync(this.KEY) || [];
  }

  static async add(item: PocketItem): Promise<boolean> {
    const items = await this.getAll();
    const serialized = JSON.stringify([...items, item]);
    if (new Blob([serialized]).size > this.MAX_SIZE) {
      return false; // Нет места
    }
    items.push(item);
    await figma.clientStorage.setAsync(this.KEY, items);
    return true;
  }

  static async remove(id: string): Promise<void> {
    const items = await this.getAll();
    const filtered = items.filter(i => i.id !== id);
    await figma.clientStorage.setAsync(this.KEY, filtered);
  }

  static async getUsedSpace(): Promise<number> {
    const items = await this.getAll();
    return new Blob([JSON.stringify(items)]).size;
  }
}
```

### Сериализация ноды

```typescript
async function saveNodeToPocket(node: SceneNode, category: string): Promise<PocketItem> {
  // Thumbnail (маленький PNG для preview)
  const thumbnailBytes = await node.exportAsync({
    format: 'PNG',
    constraint: { type: 'WIDTH', value: 200 },
  });
  const thumbnailBase64 = figma.base64Encode(thumbnailBytes);

  let svgData: string | undefined;
  let imageBytes: number[] | undefined;
  let insertMode: 'svg' | 'image' = 'image';

  // Попробовать экспортировать как SVG
  try {
    const svgBytes = await node.exportAsync({ format: 'SVG' });
    svgData = String.fromCharCode(...svgBytes);
    insertMode = 'svg';
  } catch {
    // Fallback: PNG
    const pngBytes = await node.exportAsync({
      format: 'PNG',
      constraint: { type: 'SCALE', value: 2 },
    });
    imageBytes = Array.from(pngBytes);
    insertMode = 'image';
  }

  return {
    id: generateUUID(),
    name: node.name,
    category,
    nodeType: node.type,
    originalWidth: node.width,
    originalHeight: node.height,
    savedAt: new Date().toISOString(),
    thumbnailBase64,
    svgData,
    imageBytes,
    insertMode,
  };
}
```

## UI (макет)

```
┌─────────────────────────────────────────┐
│ 🎒 Component Pocket                [×]  │
├─────────────────────────────────────────┤
│ [🔍 Поиск...]                          │
│ Категория: [All ▾]                      │
├─────────────────────────────────────────┤
│ ▼ Buttons (3)                           │
│ ┌──────┐ ┌──────┐ ┌──────┐             │
│ │ [==] │ │ [==] │ │ [==] │             │
│ │ Prim │ │ Sec  │ │ Ghost│             │
│ └──────┘ └──────┘ └──────┘             │
│                                         │
│ ▼ Cards (2)                             │
│ ┌──────┐ ┌──────┐                       │
│ │ [==] │ │ [==] │                       │
│ │ Prod │ │ Prof │                       │
│ └──────┘ └──────┘                       │
│                                         │
│ ▼ Icons (5)                             │
│ [→] [←] [✓] [✕] [⚙]                   │
├─────────────────────────────────────────┤
│ Storage: 1.2 MB / 4 MB ████░░░ 30%     │
│                                         │
│ [📌 Save Selection]  [🗑 Clear All]     │
└─────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Сериализация: экспорт SVG/PNG, thumbnail|3 ч|
|2|Storage: сохранение/получение/удаление в clientStorage|3 ч|
|3|Вставка: createNodeFromSvg / Image fill|3 ч|
|4|UI: каталог, категории, grid view|4 ч|
|5|Управление хранилищем, контроль объёма|2 ч|
|6|Экспорт/импорт кармана (JSON)|2 ч|
|7|Тестирование, edge cases|2 ч|
|**Итого**||**~19 ч (3 дня)**|

## Технические сложности

- **clientStorage лимит 5 MB:** PNG-изображения быстро расходуют бюджет. SVG компактнее, но не все ноды экспортируются в SVG корректно (эффекты, маски, blend modes).
- **Качество SVG:** `exportAsync({ format: 'SVG' })` может создавать большие файлы или терять некоторые эффекты. Нужна проверка и fallback на PNG.
- **Воссоздание из SVG:** `createNodeFromSvg` создаёт Group с вложенными Vector-нодами. Не сохраняется Auto Layout, текстовые ноды, Component structure.
- **Альтернатива хранению:** вместо clientStorage можно использовать отдельную Figma-страницу "Pocket" как хранилище (тогда лимита нет, но только в одном файле).

---

# A2.7 — Proto Flow

## Цель

Визуализация прототипных связей (prototype interactions) на канвасе: создание видимых меток, стрелок и аннотаций, показывающих куда ведёт каждый интерактивный элемент и с какой анимацией.

## Проблема

Прототипные связи в Figma видны только в режиме Prototype, и выглядят как синие стрелки. При работе в Design-режиме или при скриншоте макета связи не видны. Для документации, handoff и презентаций нужна визуализация flow прямо на канвасе.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Autoflow**|Хорошие стрелки между фреймами|Ручной, не привязан к prototype interactions|
|**User Flow Kit** (Community)|Красивые стрелки|Ручной набор, нет автогенерации|
|**FigJam connectors**|Нативные стрелки|Отдельный файл, не Design Mode|

**Конкурентное преимущество:** Автоматическое чтение prototype interactions + генерация визуальных аннотаций на канвасе с информацией об анимации и триггере.

## Функциональные требования

### FR-01: Чтение прототипных связей

- Каждая нода с `reactions` содержит прототипные связи:
    
    ```typescript
    node.reactions // Reaction[]// Reaction: { trigger, actions[] }// Action: { type, destinationId, navigation, transition, ... }
    ```
    
- Собрать все связи: source node → destination node + trigger type + animation

### FR-02: Генерация визуальных меток

Для каждой прототипной связи создаём на канвасе:

**Метка на source-ноде:**

- Маленький badge в углу: номер связи или иконка trigger type
- Цвет по типу: tap = синий, hover = зелёный, drag = оранжевый

**Стрелка-коннектор:**

- Линия от source к destination
- Реализация: Frame с Line node или SVG path
- Стиль: пунктирная или сплошная, цвет по trigger type
- Метка на стрелке: тип анимации ("Smart Animate, 300ms")

**Аннотация (опционально):**

- Текстовый блок рядом со стрелкой:
    - Trigger: "On Click"
    - Action: "Navigate to"
    - Destination: "Screen — Product Detail"
    - Animation: "Smart Animate, Ease Out, 300ms"

### FR-03: Режимы отображения

- **Minimal:** только стрелки между фреймами
- **Standard:** стрелки + trigger badges + animation labels
- **Detailed:** стрелки + полные аннотации для документирования

### FR-04: Обновление

- Кнопка "Refresh" — перечитать все prototype interactions и обновить метки
- Автоудаление: если прототипная связь удалена, убрать соответствующие метки
- Метки сохраняют связь через `pluginData`: `proto-flow-source`, `proto-flow-dest`

### FR-05: Группировка

- Все сгенерированные метки группируются в Frame "Proto Flow Annotations"
- Можно скрыть/показать весь Frame (visible toggle)
- Lock layer: заблокировать от случайного перемещения

### FR-06: Стилизация

- Цветовая схема: кастомизируемые цвета для каждого trigger type
- Толщина линий, размер шрифта аннотаций
- Opacity: полупрозрачные стрелки, чтобы не мешать основному дизайну

## Архитектура

### Чтение prototype reactions

```typescript
interface ProtoConnection {
  sourceNodeId: string;
  sourceNodeName: string;
  destinationNodeId: string;
  destinationNodeName: string;
  triggerType: string;     // "ON_CLICK", "ON_HOVER", "ON_DRAG", "MOUSE_ENTER", etc.
  actionType: string;      // "NAVIGATE", "BACK", "CLOSE", "OPEN_URL", "SWAP"
  transitionType?: string; // "SMART_ANIMATE", "DISSOLVE", "MOVE_IN", etc.
  duration?: number;       // ms
  easing?: string;         // "EASE_OUT", "EASE_IN_OUT", etc.
}

async function collectPrototypeConnections(scope: SceneNode[]): Promise<ProtoConnection[]> {
  const connections: ProtoConnection[] = [];

  function traverse(node: SceneNode) {
    // reactions доступны на нодах с prototype interactions
    if ('reactions' in node && node.reactions.length > 0) {
      for (const reaction of node.reactions) {
        for (const action of reaction.actions) {
          if (action.type === 'NODE' && action.destinationId) {
            connections.push({
              sourceNodeId: node.id,
              sourceNodeName: node.name,
              destinationNodeId: action.destinationId,
              destinationNodeName: '', // заполним позже через getNodeByIdAsync
              triggerType: reaction.trigger.type,
              actionType: action.navigation || 'NAVIGATE',
              transitionType: action.transition?.type,
              duration: action.transition?.duration,
              easing: action.transition?.easing?.type,
            });
          }
        }
      }
    }
    if ('children' in node) {
      for (const child of node.children) traverse(child);
    }
  }

  for (const node of scope) traverse(node);
  return connections;
}
```

### Генерация стрелки

```typescript
async function createArrow(
  source: SceneNode,
  dest: SceneNode,
  conn: ProtoConnection,
  style: FlowStyle
): Promise<FrameNode> {
  // Вычисляем точки соединения (центр source → центр dest)
  const sx = source.absoluteTransform[0][2] + source.width / 2;
  const sy = source.absoluteTransform[1][2] + source.height / 2;
  const dx = dest.absoluteTransform[0][2] + dest.width / 2;
  const dy = dest.absoluteTransform[1][2] + dest.height / 2;

  // Создаём SVG path для стрелки
  const svgPath = generateArrowSVG(sx, sy, dx, dy, style);
  const arrowNode = figma.createNodeFromSvg(svgPath);
  arrowNode.name = `Flow: ${source.name} → ${dest.name}`;

  // Метка с анимацией
  if (style.showLabels) {
    await figma.loadFontAsync({ family: 'Inter', style: 'Regular' });
    const label = figma.createText();
    label.characters = formatConnectionLabel(conn);
    label.fontSize = 10;
    // Позиционируем на середине стрелки
    label.x = (sx + dx) / 2;
    label.y = (sy + dy) / 2 - 16;
  }

  // pluginData для обновления
  arrowNode.setPluginData('proto-flow-source', source.id);
  arrowNode.setPluginData('proto-flow-dest', dest.id);

  return arrowNode as FrameNode;
}
```

## UI (макет)

```
┌─────────────────────────────────────────┐
│ 🔗 Proto Flow                      [×]  │
├─────────────────────────────────────────┤
│ Область: [● Selection ○ Page]           │
│ Режим: [● Standard ○ Minimal ○ Detail]  │
├─────────────────────────────────────────┤
│ Найдено связей: 18                      │
│                                         │
│ ▼ Screen: Home (5 связей)              │
│   → Product Detail (On Click, Smart)    │
│   → Cart (On Click, Dissolve)           │
│   → Profile (On Click, Move In)         │
│   → Search (On Click, Overlay)          │
│   → Menu (On Hover, Smart)              │
│                                         │
│ ▼ Screen: Product Detail (3 связи)     │
│   → Cart (On Click, Smart)              │
│   ← Back (On Click, Move Out)           │
│   → Image Gallery (On Click, Overlay)   │
│                                         │
│ ... (scrollable list)                   │
├─────────────────────────────────────────┤
│ Стрелки: Цвет [■ #0066CC] Толщина [2]  │
│ Аннотации: Размер [10] px              │
│ ☑ Показывать анимацию                   │
│ ☑ Показывать trigger type               │
├─────────────────────────────────────────┤
│ [🔗 Сгенерировать]  [🔄 Обновить]      │
│ [🗑 Удалить все метки]                  │
└─────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Чтение prototype reactions, сбор связей|3 ч|
|2|Генерация стрелок (SVG paths)|4 ч|
|3|Аннотации: labels с trigger/animation info|3 ч|
|4|Режимы отображения (minimal/standard/detailed)|2 ч|
|5|Обновление: diff существующих меток vs текущих связей|3 ч|
|6|UI: список связей, настройки стилей|3 ч|
|7|Группировка, lock, pluginData|2 ч|
|8|Тестирование, edge cases (overlay, back navigation)|2 ч|
|**Итого**||**~22 ч (3–4 дня)**|

## Технические сложности

- **Routing стрелок:** простая прямая линия пересекает фреймы. Нужен алгоритм обхода препятствий (или хотя бы bezier curve с обходом).
- **absoluteTransform:** координаты в глобальном пространстве, нужно учитывать при генерации SVG.
- **Overlay actions:** некоторые actions создают overlay поверх текущего экрана — стрелки для них стилистически другие.
- **Scroll-to actions:** навигация внутри одного фрейма — не "стрелка между фреймами", а "маркер на фрейме".
- **Reactions API:** структура `Reaction` может быть сложной с вложенными условиями и несколькими actions.

---

# A2.8 — Token Studio Free

## Цель

Бесплатная альтернатива Tokens Studio для управления design tokens (Variables) в Figma с синхронизацией через JSON/GitHub и трансформацией в CSS, Tailwind, Swift. Полноценная работа с Figma Variables API без подписки.

## Проблема

Tokens Studio (ex-Figma Tokens) — де-факто стандарт для design tokens, но Pro-версия платная, а бесплатная сильно ограничена. Многие команды не могут оправдать $10–50/мес за каждого дизайнера. При этом Figma Variables API позволяет реализовать большинство функций нативно.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Tokens Studio Pro**|Полнофункциональный, GitHub sync, multi-file|Платный ($10-50/мес), тяжёлый, сложный UI|
|**Tokens Studio Free**|Базовое управление|Очень ограниченный без Pro, нет sync|
|**Figma Variables** (встроенные)|Нативные, бесплатные|Нет sync с GitHub, нет трансформации, ручное управление|
|**Style Dictionary** (Amazon)|Мощная трансформация|CLI-инструмент, не интегрирован с Figma|

**Конкурентное преимущество:** 100% бесплатный, полная работа с Figma Variables, синхронизация с JSON файлами, трансформация в CSS/Tailwind/Swift, импорт/экспорт, multi-file support.

> ⚠️ **Внимание:** Это самый сложный плагин в категории A2 (⭐⭐⭐⭐⭐). Рекомендуется итеративная разработка: MVP → расширение.

## Функциональные требования

### FR-01: Просмотр и редактирование токенов (Core)

**Дерево токенов:**

- Отображение всех VariableCollections как "группы токенов"
- Внутри: переменные, сгруппированные по `name` (через `/` separator → дерево)
- Пример: `color/primary/500` → color → primary → 500
- Для каждой переменной: значение для каждого mode, тип, scopes

**Редактирование:**

- Inline-редактирование значений
- Создание новых переменных / коллекций / режимов
- Удаление (с предупреждением, если используется)
- Переименование (batch rename через find-replace)
- Drag-n-drop для реорганизации (перемещение между коллекциями)

**Алиасы:**

- Визуализация alias-связей (переменная → другая переменная)
- Создание алиасов через UI (выбрать source variable)
- Показать resolved value (итоговое значение после разрешения алиасов)

### FR-02: Импорт / Экспорт JSON

**Формат:** W3C Design Tokens Community Group (DTCG) draft

```json
{
  "$name": "My Design Tokens",
  "color": {
    "primary": {
      "50": { "$value": "#EBF5FF", "$type": "color" },
      "100": { "$value": "#D6EBFF", "$type": "color" },
      "500": { "$value": "#2563EB", "$type": "color" }
    },
    "bg": {
      "primary": {
        "$value": "{color.primary.50}",
        "$type": "color",
        "$description": "Main background"
      }
    }
  },
  "spacing": {
    "sm": { "$value": "8px", "$type": "dimension" },
    "md": { "$value": "16px", "$type": "dimension" }
  },
  "font": {
    "family": {
      "primary": { "$value": "Inter", "$type": "fontFamily" }
    },
    "size": {
      "body": { "$value": "16px", "$type": "dimension" }
    }
  }
}
```

**Импорт:**

- Загрузить JSON → парсинг → создание VariableCollections, Variables, Modes
- Маппинг DTCG типов → Figma типов: `color` → COLOR, `dimension` → FLOAT, `fontFamily` → STRING
- Алиасы (`{color.primary.50}`) → `VARIABLE_ALIAS`
- Режим конфликтов: merge / overwrite / skip

**Экспорт:**

- Все Variables файла → JSON в формате DTCG
- Фильтр по коллекциям (экспортировать выбранные)
- Алиасы → `{path.to.variable}` format

### FR-03: Синхронизация с GitHub (Advanced)

- Push: JSON → GitHub repository (через GitHub API)
- Pull: GitHub → JSON → Variables
- Механизм: файл JSON в репозитории, версионирование через commits
- Авторизация: Personal Access Token (PAT), хранение в clientStorage
- Конфликты: показать diff, позволить выбрать версию

> **Реализация:** Сетевые запросы к GitHub API из UI iframe. Требует `networkAccess: ["api.github.com"]`.

### FR-04: Трансформация (Code Generation)

**CSS Custom Properties:**

```css
:root {
  --color-primary-50: #EBF5FF;
  --color-primary-500: #2563EB;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --font-family-primary: "Inter";
}

[data-theme="dark"] {
  --color-primary-50: #0A1929;
  --color-primary-500: #60A5FA;
}
```

**Tailwind Config:**

```js
module.exports = {
  theme: {
    colors: {
      primary: {
        50: 'var(--color-primary-50)',
        500: 'var(--color-primary-500)',
      }
    },
    spacing: {
      sm: 'var(--spacing-sm)',
      md: 'var(--spacing-md)',
    }
  }
}
```

**Swift (iOS):**

```swift
extension Color {
  static let primaryColor50 = Color("primary50")
  static let primaryColor500 = Color("primary500")
}
```

**Kotlin (Android Compose):**

```kotlin
object DesignTokens {
  val colorPrimary50 = Color(0xFFEBF5FF)
  val spacingSm = 8.dp
}
```

- Копировать в буфер или скачать как файл (через UI + Blob)
- Выбор формата из выпадающего списка

### FR-05: Multi-file support

- Несколько JSON-файлов как источники токенов
- Порядок приоритета: local → brand → global (cascade)
- Пример: `global.json` → базовые цвета, `brand-a.json` → override для бренда

### FR-06: Diff & Changelog

- При импорте: показать что добавлено / изменено / удалено
- Лог изменений в clientStorage: "2026-02-16: Added 5 colors, Updated 3 spacing tokens"

## Архитектура

```
token-studio-free/
├── manifest.json
├── code.ts              ← Variables API: CRUD, binding
├── ui.html              ← Дерево токенов, редактор, настройки
├── core/
│   ├── parser.ts        ← Парсинг DTCG JSON
│   ├── transformer.ts   ← Генерация CSS/Tailwind/Swift
│   ├── sync.ts          ← GitHub API клиент
│   ├── diff.ts          ← Сравнение версий
│   └── mapper.ts        ← DTCG type ↔ Figma Variable type
├── tsconfig.json
└── package.json
```

### manifest.json

```json
{
  "name": "Token Studio Free",
  "id": "000000000000000017",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": [
      "api.github.com",
      "raw.githubusercontent.com"
    ]
  },
  "permissions": ["teamlibrary"]
}
```

### Маппинг типов DTCG ↔ Figma

```typescript
const TYPE_MAP: Record<string, VariableResolvedDataType> = {
  'color': 'COLOR',
  'dimension': 'FLOAT',
  'number': 'FLOAT',
  'fontFamily': 'STRING',
  'fontWeight': 'FLOAT',
  'string': 'STRING',
  'boolean': 'BOOLEAN',
};

// Парсинг значения DTCG → Figma value
function parseDTCGValue(value: any, type: string): any {
  switch (type) {
    case 'color':
      return hexToRGBA(value); // "#FF0000" → { r: 1, g: 0, b: 0, a: 1 }
    case 'dimension':
      return parseFloat(value); // "16px" → 16
    case 'fontFamily':
      return value; // "Inter"
    case 'number':
      return Number(value);
    case 'boolean':
      return Boolean(value);
    default:
      return String(value);
  }
}

// Детект алиаса: "{color.primary.500}" → VARIABLE_ALIAS
function isAlias(value: string): boolean {
  return typeof value === 'string' && /^\{.+\}$/.test(value);
}

function resolveAliasPath(value: string): string {
  return value.replace(/^\{(.+)\}$/, '$1'); // "color.primary.500"
}
```

## UI (макет)

```
┌───────────────────────────────────────────────────┐
│ 🎨 Token Studio Free                        [×]  │
├──────────────────┬────────────────────────────────┤
│ ▼ Collections    │  Collection: Semantic Colors   │
│   Primitive      │  Modes: [light] [dark] [+]     │
│ ● Semantic       │                                 │
│   Typography     │  ▼ color                        │
│                  │    ▼ primary                     │
│ [+ Collection]   │      50   #EBF5FF  #0A1929     │
│                  │      100  #D6EBFF  #0F2744     │
│ ── Actions ──    │      500  #2563EB  #60A5FA     │
│ [📥 Import]      │    ▼ bg                         │
│ [📤 Export]      │      primary → {color.prim/50} │
│ [🔄 Sync]       │      secondary → {color.neu/50}│
│ [📋 CSS]        │                                 │
│ [📋 Tailwind]   │  ▼ spacing                      │
│ [📋 Swift]      │    sm    8         8            │
│                  │    md    16        16           │
│ ── Sync ──       │    lg    24        24           │
│ Repo: uixray/    │                                 │
│  design-tokens   │  [+ Add Token]  [Batch Edit]   │
│ Status: ✅ Synced│                                 │
│ [Push] [Pull]    │  Last sync: 2 min ago          │
├──────────────────┴────────────────────────────────┤
│ Changes: +5 added, ~3 modified, -1 removed        │
│ [Review Changes]  [Apply All]                     │
└───────────────────────────────────────────────────┘
```

## Этапы реализации (итеративно)

### MVP (Phase 1): Просмотр + Экспорт

|Этап|Задача|Срок|
|---|---|---|
|1|Чтение всех Variables/Collections, формирование дерева|4 ч|
|2|UI: дерево токенов с режимами, значениями|6 ч|
|3|Экспорт в JSON (DTCG формат)|3 ч|
|4|Генерация CSS Custom Properties|3 ч|
|5|Генерация Tailwind config|2 ч|
|**MVP Итого**||**~18 ч (3 дня)**|

### Phase 2: Импорт + Редактирование

|Этап|Задача|Срок|
|---|---|---|
|6|Парсинг DTCG JSON → создание Variables|4 ч|
|7|Обработка алиасов при импорте|3 ч|
|8|Inline-редактирование значений в UI|4 ч|
|9|CRUD: создание / удаление переменных и коллекций|3 ч|
|10|Diff при импорте: что добавлено/изменено/удалено|3 ч|
|**Phase 2 Итого**||**~17 ч (3 дня)**|

### Phase 3: GitHub Sync + Advanced

|Этап|Задача|Срок|
|---|---|---|
|11|GitHub API: авторизация, push file, pull file|5 ч|
|12|Конфликтов: diff между local и remote|3 ч|
|13|Multi-file support (cascade)|4 ч|
|14|Генерация Swift, Kotlin|3 ч|
|15|Changelog, undo, batch operations|3 ч|
|16|Тестирование, edge cases, производительность|4 ч|
|**Phase 3 Итого**||**~22 ч (4 дня)**|

### **Общий итог: ~57 ч (2+ недели)**

---

# A2.9 — Design Checklist

## Цель

Плагин с предустановленными чеклистами и гайдами для дизайнеров. Помогает не забыть критические аспекты на каждом этапе проекта: от discovery до handoff. Прогресс привязан к конкретному файлу через pluginData.

## Проблема

Дизайнеры (особенно начинающие) забывают проверить: accessibility, edge cases компонентов, error states, empty states, responsive варианты. Чеклисты в Notion/Google Docs оторваны от рабочего контекста в Figma.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Design Checklist** (designchecklist.co)|Хороший список|Веб-сайт, не интегрирован с Figma|
|**A11y Checklist** плагины|Фокус на accessibility|Только a11y, нет других аспектов|
|**Notion templates**|Гибкие, настраиваемые|Не в Figma, нет привязки к файлу|
|**Figma Comments**|В контексте файла|Нет структуры, нет прогресса|

**Конкурентное преимущество:** Прямо в Figma, привязка к файлу, множество предустановленных чеклистов по этапам, встроенные гайды с ссылками на материалы, прогресс-бар, кастомные чеклисты.

## Функциональные требования

### FR-01: Предустановленные чеклисты

**Создание дизайн-системы:**

- [ ] Определены primitive tokens (colors, spacing, typography, elevation)
- [ ] Определены semantic tokens (bg, text, border, interactive)
- [ ] Создана палитра с light/dark modes
- [ ] Типографическая шкала (heading 1-6, body, caption, overline)
- [ ] Шкала spacing (4, 8, 12, 16, 24, 32, 48, 64)
- [ ] Радиусы скругления определены и токенизированы
- [ ] Shadows / Elevation определены
- [ ] Grid system определён (колонки, gutters, margins)
- [ ] Базовые компоненты: Button, Input, Checkbox, Radio, Toggle, Select
- [ ] Документация компонентов: описание, props, variants, do/don't
- ... (~30 пунктов)

**Этапы работы (Discovery → Support):**

_Discovery:_

- [ ] Бриф от клиента получен и проанализирован
- [ ] Конкуренты исследованы (3-5 прямых, 3-5 непрямых)
- [ ] Целевая аудитория описана (персоны)
- [ ] Business requirements задокументированы

_Research:_

- [ ] User interviews проведены (минимум 5)
- [ ] User Journey Map создана
- [ ] Information Architecture определена
- [ ] Sitemap создана

_Design:_

- [ ] Wireframes утверждены
- [ ] UI Kit / Design System подключён
- [ ] Все экраны покрыты для всех breakpoints
- [ ] Empty states проработаны
- [ ] Error states проработаны
- [ ] Loading states проработаны
- [ ] Edge cases обработаны (длинный текст, отсутствие данных)

_Testing:_

- [ ] Usability testing проведено
- [ ] A/B тест гипотезы сформулированы
- [ ] Accessibility audit пройден

_Handoff:_

- [ ] Спецификации для разработки готовы
- [ ] Все ассеты экспортированы
- [ ] Анимации описаны / прототипированы
- [ ] Edge cases задокументированы

**Создание компонентов:**

- [ ] Все состояния: default, hover, active, focus, disabled
- [ ] Accessibility: contrast ratios, focus indicators, aria labels
- [ ] Responsive: адаптация к размерам контейнера
- [ ] Content edge cases: min/max text, truncation, wrapping
- [ ] RTL support (если требуется)
- [ ] Dark mode вариант
- [ ] Auto Layout настроен корректно
- [ ] Naming convention соблюдён

**Популярные паттерны:**

- Авторизация: login, signup, forgot password, 2FA, social auth, error messages
- Каталог: фильтры, сортировка, pagination, empty results, loading skeleton
- Профиль: avatar, edit mode, settings, privacy, notifications preferences
- Онбординг: welcome screens, tutorial steps, permissions, skip option

**Тёмная тема:**

- [ ] Отдельные semantic tokens для dark mode (не инверсия)
- [ ] Elevation через lighter surfaces (не shadows)
- [ ] Цвета проверены на контраст в dark mode
- [ ] Иконки и иллюстрации адаптированы
- [ ] Тестирование в реальных условиях (OLED, LCD)

### FR-02: Встроенные гайды

Каждый пункт чеклиста может иметь attached guide — короткую справку со ссылками:

**Material Design 3 (ключевые разделы):**

- Color system: primary, secondary, tertiary, neutral, error
- Typography: Display, Headline, Title, Body, Label
- Elevation & Shadows
- Component guidelines (Button, FAB, Card, Navigation...)
- Ссылки: material.io/design

**iOS Human Interface Guidelines:**

- Navigation patterns: TabBar, NavigationBar, Sidebar
- Typography: SF Pro, Dynamic Type
- Safe Area, notch, Dynamic Island
- Ссылки: developer.apple.com/design

**Web Best Practices:**

- Responsive breakpoints
- Touch targets (44px minimum)
- Contrast ratios (WCAG 2.1)
- Loading performance considerations

**Эвристики Нильсена (10 heuristics):**

- Visibility of system status
- Match between system and real world
- User control and freedom
- Consistency and standards
- Error prevention
- Recognition rather than recall
- Flexibility and efficiency of use
- Aesthetic and minimalist design
- Help users recognize, diagnose, and recover from errors
- Help and documentation
- Для каждой: описание + примеры + ссылки

### FR-03: Прогресс и привязка к файлу

- Прогресс каждого чеклиста хранится в `figma.root.setPluginData()`
- Формат: `{ checklistId: { itemId: boolean, ... }, lastUpdated: timestamp }`
- Прогресс-бар: "Component Checklist: 12/20 (60%)"
- Привязка к файлу: при открытии в другом файле — чистый прогресс
- Шаринг: прогресс синхронизируется между пользователями файла (через pluginData)

### FR-04: Кастомные чеклисты

- Загрузка пользовательского чеклиста из JSON или Markdown:

**JSON формат:**

```json
{
  "name": "My Project Checklist",
  "items": [
    { "id": "item-1", "text": "Logo approved", "group": "Branding" },
    { "id": "item-2", "text": "Color palette defined", "group": "Branding" },
    { "id": "item-3", "text": "Navigation structure", "group": "UX" }
  ]
}
```

**Markdown формат:**

```markdown
# My Project Checklist

## Branding
- [ ] Logo approved
- [ ] Color palette defined

## UX
- [ ] Navigation structure
- [ ] User flows documented
```

- Парсинг Markdown: чекбоксы (`- [ ]` / `- [x]`), заголовки (`## Group`)
- Хранение: clientStorage (личные) или pluginData на root (shared)

### FR-05: Навигация к нодам

- Опционально: привязать пункт чеклиста к ноде
- "Link to node" → выделить ноду → пункт чеклиста получает nodeId
- Клик по привязанному пункту → scrollAndZoomIntoView

## Архитектура

```
design-checklist/
├── manifest.json
├── code.ts              ← pluginData CRUD, навигация
├── ui.html              ← Чеклисты, гайды, прогресс
├── checklists/
│   ├── design-system.json
│   ├── workflow-stages.json
│   ├── component-creation.json
│   ├── patterns/
│   │   ├── auth.json
│   │   ├── catalog.json
│   │   ├── profile.json
│   │   └── onboarding.json
│   └── dark-theme.json
├── guides/
│   ├── material-design.json
│   ├── ios-hig.json
│   ├── web-practices.json
│   └── nielsen-heuristics.json
├── tsconfig.json
└── package.json
```

> **Примечание:** Все JSON инлайнятся при сборке в code.js / ui.html. Структура папок — для организации исходников.

### Модель данных

```typescript
interface Checklist {
  id: string;
  name: string;
  description: string;
  icon: string;         // emoji
  groups: ChecklistGroup[];
}

interface ChecklistGroup {
  name: string;
  items: ChecklistItem[];
}

interface ChecklistItem {
  id: string;
  text: string;
  description?: string;
  guideId?: string;      // ссылка на встроенный гайд
  links?: { title: string; url: string }[];
  linkedNodeId?: string; // привязка к ноде
}

interface ChecklistProgress {
  checklistId: string;
  completed: Record<string, boolean>; // itemId → done
  lastUpdated: string;
}

// Хранение прогресса
async function saveProgress(progress: ChecklistProgress): Promise<void> {
  const key = `checklist-progress:${progress.checklistId}`;
  figma.root.setPluginData(key, JSON.stringify(progress));
}

async function loadProgress(checklistId: string): Promise<ChecklistProgress | null> {
  const key = `checklist-progress:${checklistId}`;
  const raw = figma.root.getPluginData(key);
  return raw ? JSON.parse(raw) : null;
}
```

## UI (макет)

```
┌───────────────────────────────────────────┐
│ ✅ Design Checklist                  [×]  │
├───────────────────────────────────────────┤
│ 📋 Выбрать чеклист:                      │
│ ┌─────────────────────────────────────┐   │
│ │ 🎨 Дизайн-система         12/30 ▰▰▱│   │
│ │ 📐 Этапы работы            8/24 ▰▱▱│   │
│ │ 🧩 Создание компонентов    0/20 ▱▱▱│   │
│ │ 🔐 Авторизация             5/12 ▰▰▱│   │
│ │ 🌙 Тёмная тема             0/10 ▱▱▱│   │
│ │ 📁 Мой чеклист (custom)    3/8  ▰▱▱│   │
│ └─────────────────────────────────────┘   │
│ [📥 Import Checklist]                     │
├───────────────────────────────────────────┤
│ 🎨 Дизайн-система           12/30 (40%)  │
│ ████████░░░░░░░░░░░░                      │
│                                           │
│ ▼ Tokens                                  │
│ ☑ Primitive tokens определены         ℹ️  │
│ ☑ Semantic tokens определены          ℹ️  │
│ ☐ Палитра light/dark modes            ℹ️  │
│   💡 Guide: Для dark mode нужны          │
│      отдельные значения, не инверсия.     │
│      📖 Material Design Color System     │
│ ☐ Типографическая шкала               ℹ️  │
│                                           │
│ ▼ Components                              │
│ ☑ Button (все состояния)         [🔗 →]  │
│ ☐ Input Field                             │
│ ☐ Checkbox / Radio / Toggle               │
│ ...                                       │
├───────────────────────────────────────────┤
│ [🔗 Link selected node to item]           │
└───────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Модель данных: Checklist, Progress, pluginData|3 ч|
|2|Контент: написание чеклиста "Дизайн-система" (30 пунктов)|3 ч|
|3|Контент: чеклист "Этапы работы" (24 пункта)|2 ч|
|4|Контент: чеклисты паттернов (auth, catalog, profile, onboarding)|4 ч|
|5|Контент: гайды (Material, iOS, Web, Nielsen)|4 ч|
|6|UI: выбор чеклиста, группы, чекбоксы, прогресс-бар|5 ч|
|7|pluginData: сохранение/загрузка прогресса, sync между пользователями|3 ч|
|8|Кастомные чеклисты: импорт JSON/Markdown, парсинг|3 ч|
|9|Привязка к нодам: link, navigate|2 ч|
|10|Гайды: inline-подсказки, ссылки на материалы|3 ч|
|11|Тестирование, polish|2 ч|
|**Итого**||**~34 ч (1 неделя)**|

## Будущие расширения

- **AI-ассистент:** проверка выбранного макета на соответствие пунктам чеклиста (A3 категория)
- **Integration с Design Lint:** автоматическая отметка пунктов, которые подтверждены проверкой lint
- **Templates:** экспорт прогресса как отчёт (Markdown/PDF)
- **Team dashboard:** общий прогресс команды (потребует серверной части)

---

# Общая сводка по категории A2

|Плагин|Оценка трудозатрат|API-сложность|UI-сложность|Приоритет|
|---|---|---|---|---|
|A2.1 Typograph|~21 ч (3–4 дня)|Средняя (TextNode, fonts)|Средняя|Высокий (есть база)|
|A2.2 Design Lint|~40 ч (1–1.5 нед)|Высокая (Variables, Styles, all nodes)|Высокая|Высокий (killer feature)|
|A2.3 Typo Spec|~24 ч (3–4 дня)|Средняя (TextStyles, Variables)|Средняя|Средний|
|A2.4 Wireframe Kit|~35 ч (1 нед)|Средняя (создание нод, Auto Layout)|Средняя|Средний|
|A2.5 Icon Finder|~21 ч (3–4 дня)|Средняя (teamLibrary, SVG)|Средняя|Высокий (daily use)|
|A2.6 Component Pocket|~19 ч (3 дня)|Средняя (export, SVG, storage)|Средняя|Средний|
|A2.7 Proto Flow|~22 ч (3–4 дня)|Высокая (reactions, coordinates)|Средняя|Низкий (нишевый)|
|A2.8 Token Studio Free|~57 ч (2+ нед)|Очень высокая (полный Variables API)|Очень высокая|Высокий (стратегический)|
|A2.9 Design Checklist|~34 ч (1 нед)|Низкая (pluginData)|Средняя (контент!)|Высокий (вход в рынок)|
|**Итого A2**|**~273 ч (~8–10 недель)**||||

## Рекомендуемый порядок внутри A2

```
Фаза 1 — Quick wins (месяц 2):
  1. Typograph (A2.1)     — доработка существующего, быстрый релиз
  2. Design Lint (A2.2)   — killer feature, использует код A1.1 и A1.4

Фаза 2 — Повседневные инструменты (месяц 3):
  3. Icon Finder (A2.5)   — daily use, привлечение аудитории
  4. Typo Spec (A2.3)     — углубление в Variables API, подготовка к Token Studio
  
Фаза 3 — Расширение (месяц 4):
  5. Design Checklist (A2.9) — контентный плагин, хорош для контент-маркетинга
  6. Wireframe Kit (A2.4)    — большой объём блоков, но каждый по отдельности прост

Фаза 4 — Advanced (месяц 5–6):
  7. Component Pocket (A2.6)  — полезный, но техническиsложный (storage limits)
  8. Proto Flow (A2.7)        — нишевый, можно отложить
  9. Token Studio Free (A2.8) — стратегический, начать MVP и итерировать
```

## Связи между плагинами A1 ↔ A2

```
A1.1 Pixel Audit ──────► A2.2 Design Lint (модуль Pixel Grid)
A1.4 Instance Reset ───► A2.2 Design Lint (модуль Overrides)
A1.6 Palette Lab ──────► A2.2 Design Lint (модуль Color Tokens)
A1.6 Palette Lab ──────► A2.8 Token Studio Free (создание токенов)
A2.1 Typograph ────────► A2.2 Design Lint (модуль Text Quality — будущий)
A2.3 Typo Spec ────────► A2.8 Token Studio Free (typography tokens)
A2.5 Icon Finder ──────► A2.4 Wireframe Kit (вставка иконок в блоки)
A2.9 Design Checklist ─► A2.2 Design Lint (авто-отметка по результатам lint)
```