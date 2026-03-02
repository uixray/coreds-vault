---
title: "A1 Basic Utilities Specifications"
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
description: "Specifications for A1 tier basic utility components"
---

# A1. Базовые утилиты — Технические задания

> **Автор:** Ray (@uixray) **Дата:** 2026-02-14 **Категория:** Figma-плагины без AI, уровень 1

---

# A1.1 — Pixel Audit

## Цель

Плагин для поиска нод с дробными (fractional) координатами и размерами. Помогает поддерживать pixel-perfect макеты, находя элементы вроде `x: 120.5`, `width: 1080.33` и предлагая авто-округление.

## Почему первый

Минимальный набор API (`node.x`, `node.y`, `width`, `height`), нет сетевых запросов, простой UI. Идеальный стартовый проект для освоения Figma Plugin API и настройки boilerplate.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Bono Auditor**|Красивый UI, множество проверок|Закрытый, не расширяемый, платный функционал|
|**Pixel Perfect**|Простой, бесплатный|Только показывает, не фиксит|
|**Design Lint** (разные авторы)|Комплексная проверка|Перегружен, медленный на больших файлах|

**Конкурентное преимущество:** Фокус на одной задаче + авто-фикс + экспорт отчёта. Станет модулем для будущего Design Lint (A2.2).

## Функциональные требования

### FR-01: Сканирование

- Область сканирования: выделение (selection) или вся текущая страница
- Проверяемые свойства: `x`, `y`, `width`, `height`
- Нода считается "проблемной" если любое из свойств не является целым числом
- Исключения: ноды внутри компонентов (опционально, чекбокс)
- Рекурсивный обход дерева — проверять children фреймов и групп

### FR-02: Отображение результатов

- Список карточек с ошибками, сгруппированных по типу (координаты / размеры)
- Каждая карточка: имя ноды, тип, проблемное свойство, текущее значение → округлённое
- Клик по карточке → `figma.viewport.scrollAndZoomIntoView([node])` — фокус на ноде
- Сводка вверху: "Найдено N проблем" с прогресс-баром при сканировании

### FR-03: Авто-фикс

- Кнопка "Fix All" — округление всех проблемных значений
- Кнопка "Fix" на каждой карточке — индивидуальное исправление
- Стратегия округления (настройка): Math.round / Math.floor / Math.ceil
- Preview: показать "было → будет" перед применением
- Лог изменений после фикса

### FR-04: Настройки

- Чекбокс: включить/выключить проверку вложенных нод компонентов
- Чекбокс: проверять только видимые слои (visible: true)
- Выбор стратегии округления
- Сохранение настроек в `figma.clientStorage`

## Нефункциональные требования

- Производительность: сканирование страницы до 5000 нод < 3 секунд
- UI: поддержка тёмной/светлой темы Figma (`themeColors: true`)
- Закрытие: ESC закрывает плагин (кроме случаев фокуса в input)

## Архитектура

```
pixel-audit/
├── manifest.json
├── code.ts          ← Логика сканирования и фикса
├── ui.html          ← Интерфейс с результатами
├── tsconfig.json
└── package.json
```

### Потоки данных

```
[UI] Кнопка "Scan" 
  → postMessage({ type: "scan", options })
  → [Code] рекурсивный обход figma.currentPage.children
  → фильтрация нод с дробными значениями
  → postMessage({ type: "scan-results", data: [...] })
  → [UI] отрисовка списка карточек

[UI] Кнопка "Fix" 
  → postMessage({ type: "fix", nodeId, strategy })
  → [Code] node.x = Math.round(node.x) и т.д.
  → postMessage({ type: "fix-done", nodeId })
  → [UI] обновление карточки (зелёная галочка)
```

### manifest.json

```json
{
  "name": "Pixel Audit",
  "id": "000000000000000001",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["none"]
  }
}
```

### Ключевая логика (code.ts)

```typescript
// Рекурсивный поиск проблемных нод
interface AuditIssue {
  nodeId: string;
  nodeName: string;
  nodeType: string;
  property: 'x' | 'y' | 'width' | 'height';
  currentValue: number;
  fixedValue: number;
}

function isFractional(value: number): boolean {
  return value !== Math.round(value);
}

function auditNode(node: SceneNode, options: AuditOptions): AuditIssue[] {
  const issues: AuditIssue[] = [];
  
  // Проверяем свойства
  for (const prop of ['x', 'y', 'width', 'height'] as const) {
    if (prop in node && isFractional(node[prop])) {
      issues.push({
        nodeId: node.id,
        nodeName: node.name,
        nodeType: node.type,
        property: prop,
        currentValue: node[prop],
        fixedValue: roundByStrategy(node[prop], options.strategy),
      });
    }
  }
  
  // Рекурсия
  if ('children' in node && options.includeChildren) {
    for (const child of node.children) {
      issues.push(...auditNode(child, options));
    }
  }
  
  return issues;
}
```

## UI (макет)

```
┌─────────────────────────────────────┐
│ Pixel Audit                    [×]  │
├─────────────────────────────────────┤
│ Область: [● Selection ○ Page]       │
│ Округление: [● round ○ floor ○ ceil]│
│ ☑ Проверять вложенные              │
│ ☑ Только видимые                    │
│                                     │
│ [🔍 Сканировать]                    │
├─────────────────────────────────────┤
│ ✕ Найдено 12 проблем               │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ⬜ Frame "Header"               │ │
│ │   x: 120.5 → 121               │ │
│ │   width: 1080.33 → 1080        │ │
│ │                     [Fix] [👁]  │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ ⬜ Rectangle "Card BG"          │ │
│ │   y: 340.7 → 341               │ │
│ │                     [Fix] [👁]  │ │
│ └─────────────────────────────────┘ │
│ ...                                 │
├─────────────────────────────────────┤
│ [✓ Fix All (12)]                    │
└─────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Scaffold проекта, manifest, базовый UI|2 ч|
|2|Логика сканирования (рекурсия, фильтрация)|3 ч|
|3|Отображение результатов в UI, навигация к ноде|3 ч|
|4|Авто-фикс (individual + batch)|2 ч|
|5|Настройки, clientStorage, тема|2 ч|
|6|Тестирование, edge cases, polish|2 ч|
|**Итого**||**~14 ч (2 дня)**|

## Метрики успеха

- Сканирование 1000 нод < 1 секунды
- Фикс не ломает Auto Layout и constraints
- 0 ложных срабатываний на стандартных файлах

---

# A1.2 — Snapshotter

## Цель

Плагин для создания скриншотов фреймов с подписями и возможностью обновления. Незаменим для документирования user flow, презентаций и changelog-визуализации.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Pitchdeck**|Красивые превью|Ориентирован на презентации, не на документирование|
|**Autoflow**|Стрелки между экранами|Нет скриншотов, только стрелки|
|Ручной экспорт + вставка|Контроль|Долго, нет связи с оригиналом, нет обновления|

**Конкурентное преимущество:** Автоматическая связь snapshot ↔ оригинал через `pluginData`, обновление в один клик, batch-режим.

## Функциональные требования

### FR-01: Создание снапшота

- Выделить фрейм(ы) → "Создать снапшот"
- Плагин экспортирует фрейм как PNG (через `node.exportAsync`)
- Создаёт новый Frame рядом с оригиналом:
    - Image fill с полученным PNG
    - Подпись под изображением: имя фрейма, дата создания
    - Размер миниатюры: пропорциональное уменьшение до заданной ширины (по умолчанию 300px)
- Сохраняет связь в `pluginData`:
    - На оригинале: `snapshot-id` → ID снапшота
    - На снапшоте: `source-id` → ID оригинала, `snapshot-date` → timestamp

### FR-02: Обновление снапшотов

- Кнопка "Обновить все снапшоты" на текущей странице
- Плагин ищет все ноды с `pluginData("source-id")`
- Для каждой: находит оригинал по ID → повторный экспорт → замена Image fill
- Обновляет дату в подписи
- Если оригинал удалён: помечает снапшот красной рамкой + предупреждение "Source deleted"

### FR-03: Batch-режим

- Выделить несколько фреймов → создать снапшоты всех
- Автоматическое размещение в сетку с настраиваемыми параметрами:
    - Количество колонок
    - Отступы между снапшотами
    - Направление: горизонтально / вертикально

### FR-04: Настройки

- Ширина миниатюры (px): 200 / 300 / 400 / кастомная
- Формат экспорта: PNG (default), JPG
- Scale factor: 1x / 2x
- Включать подпись: да/нет
- Формат подписи: шаблон с переменными (`{name}`, `{date}`, `{page}`)
- Стиль подписи: размер, цвет, шрифт
- Сохранение в `figma.clientStorage`

### FR-05: Relaunch Button

- При создании снапшота устанавливается relaunch button на оригинале: "Обновить снапшот"
- При нажатии — мгновенное обновление без открытия полного UI

## Архитектура

```
snapshotter/
├── manifest.json
├── code.ts          ← Экспорт, создание фреймов, обновление
├── ui.html          ← Настройки, список снапшотов, batch UI
├── tsconfig.json
└── package.json
```

### Ключевые операции

```typescript
// Экспорт фрейма в PNG bytes
async function exportFrame(node: SceneNode, scale: number): Promise<Uint8Array> {
  return await node.exportAsync({
    format: 'PNG',
    constraint: { type: 'SCALE', value: scale },
  });
}

// Создание снапшот-фрейма
async function createSnapshot(source: SceneNode, options: SnapshotOptions): Promise<FrameNode> {
  const bytes = await exportFrame(source, options.scale);
  const imageHash = figma.createImage(bytes).hash;

  // Вычисляем размеры миниатюры
  const ratio = source.height / source.width;
  const thumbWidth = options.thumbnailWidth;
  const thumbHeight = Math.round(thumbWidth * ratio);

  // Контейнер
  const container = figma.createFrame();
  container.name = `📸 ${source.name}`;
  container.layoutMode = 'VERTICAL';
  container.itemSpacing = 8;
  container.paddingBottom = 12;
  container.paddingLeft = 0;
  container.paddingRight = 0;
  container.paddingTop = 0;
  container.primaryAxisSizingMode = 'AUTO';
  container.counterAxisSizingMode = 'FIXED';
  container.resize(thumbWidth, thumbHeight + 40);

  // Изображение
  const imageFrame = figma.createRectangle();
  imageFrame.resize(thumbWidth, thumbHeight);
  imageFrame.fills = [{
    type: 'IMAGE',
    scaleMode: 'FILL',
    imageHash: imageHash,
  }];
  container.appendChild(imageFrame);

  // Подпись
  await figma.loadFontAsync({ family: 'Inter', style: 'Regular' });
  const label = figma.createText();
  label.characters = formatLabel(options.labelTemplate, source.name);
  label.fontSize = 12;
  container.appendChild(label);

  // Связь через pluginData
  container.setPluginData('source-id', source.id);
  container.setPluginData('snapshot-date', new Date().toISOString());
  source.setPluginData('snapshot-id', container.id);

  // Позиционирование рядом с оригиналом
  container.x = source.x + source.width + 40;
  container.y = source.y;

  figma.currentPage.appendChild(container);
  return container;
}
```

### manifest.json

```json
{
  "name": "Snapshotter",
  "id": "000000000000000002",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["none"]
  },
  "relaunchButtons": [
    { "command": "update-snapshot", "name": "Update Snapshot", "multipleSelection": false }
  ]
}
```

## UI (макет)

```
┌─────────────────────────────────────┐
│ 📸 Snapshotter                 [×]  │
├─────────────────────────────────────┤
│ Режим: [● Создать ○ Обновить]       │
│                                     │
│ ── Создать ──                       │
│ Выделено: 3 фрейм(а)               │
│ Ширина: [300] px  Scale: [1x ▾]    │
│ Подпись: [{name} — {date}]          │
│                                     │
│ Сетка: [3] колонки  Отступ: [20] px │
│                                     │
│ [📸 Создать снапшоты]               │
│                                     │
│ ── Обновить ──                      │
│ Найдено снапшотов: 8                │
│ Устаревших: 3                       │
│ Потерянных источников: 1 ⚠️         │
│                                     │
│ [🔄 Обновить все]                   │
└─────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Экспорт фрейма в PNG + создание snapshot frame|3 ч|
|2|Подпись (загрузка шрифта, форматирование)|2 ч|
|3|pluginData связь + обновление снапшотов|3 ч|
|4|Batch-режим + размещение в сетку|3 ч|
|5|UI: настройки, список, preview|3 ч|
|6|Relaunch buttons, edge cases|2 ч|
|**Итого**||**~16 ч (2–3 дня)**|

## Будущие расширения

- Интеграция с Navigator (A1.3): снапшоты как элементы карты файла
- Экспорт коллекции снапшотов как PDF / набор PNG
- Сравнение "до/после" — два снапшота одного фрейма рядом

---

# A1.3 — Navigator

## Цель

Плагин для расстановки якорных ссылок по макету и автоматической генерации страницы-навигации (карты файла). Решает проблему ориентации в больших файлах с десятками экранов.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Figma Sections** (встроенные)|Нативная навигация|Нет карты, нет скриншотов, ограниченная организация|
|**Page Jumper**|Быстрый переход между страницами|Нет навигации внутри страницы, нет визуализации|
|**Sitemap** плагины|Визуализация структуры|Ориентированы на sitemap сайта, не на навигацию по файлу|

**Конкурентное преимущество:** Визуальная карта файла со снапшотами, клик → переход к секции, автообновление, интеграция со Snapshotter.

## Функциональные требования

### FR-01: Расстановка якорей

- Выделить фрейм/секцию → "Добавить якорь"
- Плагин сохраняет в `pluginData` на ноде: `anchor: true`, `anchor-label: "..."`, `anchor-order: N`
- Визуальный маркер на ноде: маленький badge в углу (опционально)
- Пользователь может задать кастомное название якоря или использовать имя ноды
- Relaunch button на помеченных нодах: "Перейти в навигатор"

### FR-02: Генерация карты файла

- Кнопка "Сгенерировать карту" создаёт новую страницу "📍 Navigation Map"
- Содержимое страницы:
    - Заголовок: название файла, дата генерации
    - Секции по страницам документа
    - Для каждого якоря: миниатюра (через Snapshotter) + название + клик-зона
- Размещение: сетка или список, настраиваемый layout

### FR-03: Навигация

- В UI плагина: список всех якорей с фильтрацией
- Клик по якорю → `figma.viewport.scrollAndZoomIntoView([node])`
- Поиск: текстовое поле для быстрого поиска якоря по имени
- Сортировка: по порядку (order), по странице, по имени

### FR-04: Обновление карты

- При изменении якорей → "Обновить карту"
- Обновляет миниатюры, добавляет новые, удаляет удалённые
- Не пересоздаёт страницу, а обновляет содержимое

### FR-05: Quick Navigation (без UI)

- Режим без полного UI: команда в меню → выпадающий список якорей → выбор → переход
- Работает через `figma.parameters` или упрощённый inline UI

## Архитектура

```
navigator/
├── manifest.json
├── code.ts          ← Логика якорей, генерация карты, навигация
├── ui.html          ← Список якорей, настройки, превью карты
├── tsconfig.json
└── package.json
```

### manifest.json

```json
{
  "name": "Navigator",
  "id": "000000000000000003",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["none"]
  },
  "menu": [
    { "name": "Открыть навигатор", "command": "open-navigator" },
    { "separator": true },
    { "name": "Добавить якорь", "command": "add-anchor" },
    { "name": "Сгенерировать карту", "command": "generate-map" },
    { "name": "Обновить карту", "command": "update-map" }
  ],
  "relaunchButtons": [
    { "command": "jump-to", "name": "Jump to in Navigator" }
  ]
}
```

### Структура данных якоря

```typescript
interface Anchor {
  nodeId: string;
  label: string;
  order: number;
  pageId: string;
  pageName: string;
  createdAt: string;
}

// Хранение: pluginData на каждой помеченной ноде
// Индекс всех якорей: pluginData на documentNode (figma.root)
// figma.root.setPluginData('anchors-index', JSON.stringify(anchors))
```

## UI (макет)

```
┌─────────────────────────────────────┐
│ 📍 Navigator                   [×]  │
├─────────────────────────────────────┤
│ [🔍 Поиск якоря...]                │
├─────────────────────────────────────┤
│ 📄 Page: Main Screens              │
│ ┌─────────────────────────────────┐ │
│ │ [🖼] Header Section      → [👁] │ │
│ │ [🖼] Hero Block          → [👁] │ │
│ │ [🖼] Product Cards       → [👁] │ │
│ └─────────────────────────────────┘ │
│                                     │
│ 📄 Page: Components                │
│ ┌─────────────────────────────────┐ │
│ │ [🖼] Button variants     → [👁] │ │
│ │ [🖼] Input Fields        → [👁] │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ [📌 Добавить якорь]                 │
│ [🗺 Сгенерировать карту]            │
│ [🔄 Обновить карту]                 │
└─────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|pluginData система якорей + добавление/удаление|3 ч|
|2|UI: список якорей с поиском и навигацией|3 ч|
|3|Генерация страницы-карты (layout + подписи)|4 ч|
|4|Интеграция со Snapshotter (миниатюры на карте)|3 ч|
|5|Обновление карты, синхронизация с якорями|3 ч|
|6|Меню команд, relaunch buttons, polish|2 ч|
|**Итого**||**~18 ч (3 дня)**|

---

# A1.4 — Instance Reset

## Цель

Плагин для сброса стилевых оверрайдов (overrides) в инстансах компонентов с сохранением текстовых надписей и подменённых иконок. Решает частую боль: инстанс "загрязнён" кастомными стилями, но контент нужно сохранить.

## Проблема

Когда дизайнер работает с инстансами, он часто случайно меняет fills, strokes, effects, размеры. Встроенная функция "Reset all overrides" в Figma сбрасывает ВСЁ, включая текст и иконки. Нужен умный сброс: стили — назад, контент — оставить.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Reset all overrides** (встроенное)|Нативный, быстрый|Сбрасывает ВСЁ, включая текст|
|**Component Utilities** плагины|Разные утилиты|Нет гранулярного контроля над тем, что сбрасывать|

**Конкурентное преимущество:** Гранулярный выбор, что сбрасывать, preview перед применением.

## Функциональные требования

### FR-01: Анализ оверрайдов

- Выделить инстанс(ы) → плагин показывает список всех оверрайдов
- Категории оверрайдов:
    - **Стилевые** (сброс по умолчанию): fills, strokes, effects, opacity, cornerRadius, blendMode
    - **Размерные** (опциональный сброс): width, height, constraints, layoutAlign
    - **Контентные** (сохранение по умолчанию): characters (текст), подменённые компоненты (nested instances / иконки)
- Для каждого оверрайда: показать "текущее значение" vs "значение в мастере"

### FR-02: Гранулярный сброс

- Чекбоксы по категориям: стили / размеры / контент
- Чекбокс на каждый отдельный оверрайд
- Кнопка "Reset Selected" — сброс только выбранных
- Кнопка "Smart Reset" — сброс стилей, сохранение контента (default behavior)

### FR-03: Batch-режим

- Выделить несколько инстансов → сбросить все
- Сводка: "5 инстансов, 23 стилевых оверрайда будет сброшено"

### FR-04: Предупреждения

- Если инстанс detached от компонента — предупредить, что сброс невозможен
- Если мастер-компонент удалён или в другом файле — предупредить

## Архитектура

### Ключевая логика

```typescript
interface Override {
  nodeId: string;          // ID вложенной ноды внутри инстанса
  nodePath: string;        // Путь: "Frame/Button/Label"
  property: string;        // Имя свойства: "fills", "characters" и т.д.
  category: 'style' | 'size' | 'content';
  currentValue: any;
  masterValue: any;
}

async function analyzeInstance(instance: InstanceNode): Promise<Override[]> {
  const overrides: Override[] = [];
  const mainComponent = await instance.getMainComponentAsync();
  if (!mainComponent) return overrides;

  // Рекурсивное сравнение instance children vs mainComponent children
  compareNodes(instance, mainComponent, '', overrides);
  return overrides;
}

function resetOverride(instance: InstanceNode, override: Override): void {
  const node = findNodeByPath(instance, override.nodePath);
  if (!node) return;

  // Получаем значение мастера и применяем
  switch (override.property) {
    case 'fills':
      (node as GeometryMixin).fills = override.masterValue;
      break;
    case 'strokes':
      (node as GeometryMixin).strokes = override.masterValue;
      break;
    case 'effects':
      (node as BlendMixin).effects = override.masterValue;
      break;
    case 'opacity':
      (node as BlendMixin).opacity = override.masterValue;
      break;
    // ... и т.д.
  }
}
```

## UI (макет)

```
┌─────────────────────────────────────┐
│ 🧹 Instance Reset              [×] │
├─────────────────────────────────────┤
│ Выделено: Button / Primary          │
│ Component: ✅ Подключён             │
├─────────────────────────────────────┤
│ Сбросить:                           │
│ ☑ Стили (fills, strokes, effects)   │
│ ☐ Размеры (width, height)           │
│ ☐ Контент (текст, иконки)           │
├─────────────────────────────────────┤
│ Оверрайды (7):                      │
│ ☑ Button BG → fills: #FF0000       │
│     Master: #0066CC                 │
│ ☑ Button BG → cornerRadius: 16     │
│     Master: 8                       │
│ ☑ Button BG → effects: drop-shadow │
│     Master: none                    │
│ ☐ Label → characters: "Купить"     │
│     Master: "Button"                │
│ ☐ Icon → swap: cart-icon           │
│     Master: arrow-right             │
├─────────────────────────────────────┤
│ [🧹 Smart Reset]  [Reset Selected] │
└─────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Анализ: получение mainComponent, рекурсивное сравнение|4 ч|
|2|Категоризация оверрайдов (стили / размеры / контент)|2 ч|
|3|Логика сброса по категориям и индивидуально|3 ч|
|4|UI: список оверрайдов, чекбоксы, preview|3 ч|
|5|Batch-режим для нескольких инстансов|2 ч|
|6|Edge cases: detached, missing master, nested instances|2 ч|
|**Итого**||**~16 ч (2–3 дня)**|

## Технические сложности

- **Рекурсивное сравнение:** инстанс и мастер имеют разную структуру ID дочерних нод. Нужно маппить по индексу/имени, а не по ID.
- **Nested instances:** если внутри инстанса есть другие инстансы (иконки), их оверрайды нужно обрабатывать отдельно.
- **figma.mixed:** некоторые свойства могут возвращать `figma.mixed`, нужно обрабатывать этот кейс.

---

# A1.5 — Shadow Forge

## Цель

Генератор многослойных гладких теней с визуальным контролем "источника света". Создаёт стек из 3–8 слоёв Drop Shadow с экспоненциально возрастающим blur и убывающей opacity, что даёт эффект реалистичного освещения.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Beautiful Shadows**|Хороший алгоритм|Мало настроек, нет пресетов|
|**Shadow Picker**|UI удобный|Только один слой тени|
|**Smooth Shadow** (CSS)|Браузерный инструмент|Не интегрирован с Figma|
|**shadows.brumm.af**|Отличный алгоритм, CSS-экспорт|Веб-инструмент, нужно копировать вручную|

**Конкурентное преимущество:** Пресеты (Material, Apple, Soft), визуальный контроль источника света, экспорт CSS, применение прямо к ноде.

## Функциональные требования

### FR-01: Генерация теней

- Параметры:
    - Угол источника света (0–360°)
    - Расстояние (distance): 0–100 px
    - Интенсивность (intensity): 0–100%
    - Количество слоёв: 3–8
    - Цвет тени (по умолчанию: чёрный)
    - Spread: 0–20 px (опционально)
- Алгоритм: для каждого слоя i из N:
    - `blur[i] = maxBlur * (i / N)^2` — экспоненциальный рост
    - `opacity[i] = maxOpacity * (1 - i / N)^1.5` — нелинейное затухание
    - `offset_x[i] = distance * (i / N) * cos(angle)`
    - `offset_y[i] = distance * (i / N) * sin(angle)`

### FR-02: Пресеты

|Пресет|Слоёв|Blur range|Opacity range|Характер|
|---|---|---|---|---|
|**Material**|3|2–16|0.12–0.04|Key light + ambient|
|**Apple**|5|1–40|0.08–0.02|Мягкая, рассеянная|
|**Soft**|6|2–60|0.06–0.01|Очень мягкая, едва заметная|
|**Sharp**|3|1–8|0.20–0.05|Контрастная, чёткая|
|**Layered**|8|1–80|0.04–0.005|Ultra-smooth, layered|

- Пользовательские пресеты: сохранение / загрузка из `clientStorage`

### FR-03: Визуальный контроль

- Интерактивный контрол "источник света": круг с точкой, которую можно перетаскивать
    - Расстояние от центра = distance
    - Угол = angle
- Live preview: при изменении параметров тень обновляется на ноде в реальном времени (или при отпускании ползунка)

### FR-04: Применение и экспорт

- "Apply" → записывает массив effects на выделенную ноду
- "CSS Export" → генерирует строку `box-shadow` и копирует в буфер:
    
    ```css
    box-shadow:  0px 1px 2px rgba(0,0,0,0.12),  0px 4px 8px rgba(0,0,0,0.08),  0px 12px 24px rgba(0,0,0,0.04);
    ```
    
- "iOS Export" → `shadowColor`, `shadowOffset`, `shadowRadius`, `shadowOpacity`

## Архитектура

### Ключевая логика

```typescript
interface ShadowLayer {
  type: 'DROP_SHADOW';
  color: RGBA;
  offset: { x: number; y: number };
  radius: number;    // blur
  spread: number;
  visible: true;
  blendMode: 'NORMAL';
}

interface ShadowConfig {
  angle: number;       // градусы (0 = сверху)
  distance: number;    // px
  intensity: number;   // 0–1
  layers: number;      // 3–8
  color: RGB;
  spread: number;
}

function generateShadowStack(config: ShadowConfig): ShadowLayer[] {
  const shadows: ShadowLayer[] = [];
  const angleRad = (config.angle * Math.PI) / 180;

  for (let i = 0; i < config.layers; i++) {
    const progress = (i + 1) / config.layers;

    // Экспоненциальный рост blur
    const maxBlur = config.distance * 2;
    const blur = maxBlur * Math.pow(progress, 2);

    // Нелинейное затухание opacity
    const maxOpacity = config.intensity * 0.15;
    const opacity = maxOpacity * Math.pow(1 - progress, 1.5);

    // Смещение пропорционально прогрессу
    const offsetX = config.distance * progress * Math.sin(angleRad);
    const offsetY = config.distance * progress * Math.cos(angleRad);

    shadows.push({
      type: 'DROP_SHADOW',
      color: { ...config.color, a: opacity },
      offset: { x: Math.round(offsetX * 10) / 10, y: Math.round(offsetY * 10) / 10 },
      radius: Math.round(blur * 10) / 10,
      spread: config.spread * progress,
      visible: true,
      blendMode: 'NORMAL',
    });
  }

  return shadows;
}

// Применение к ноде
function applyShadows(node: SceneNode, shadows: ShadowLayer[]): void {
  if ('effects' in node) {
    // Сохраняем не-shadow эффекты (blur и т.д.)
    const otherEffects = node.effects.filter(e => e.type !== 'DROP_SHADOW');
    node.effects = [...otherEffects, ...shadows];
  }
}
```

## UI (макет)

```
┌─────────────────────────────────────┐
│ ✨ Shadow Forge                [×]  │
├─────────────────────────────────────┤
│ Пресет: [Material ▾]               │
│                                     │
│        ┌───────────┐               │
│        │     •     │  ← источник   │
│        │   ╱       │    света      │
│        │  ╱        │  (drag to     │
│        │ ○         │   move)       │
│        └───────────┘               │
│ Угол: [135°]  Дистанция: [24] px   │
│                                     │
│ Интенсивность: ─────●───── 70%     │
│ Слоёв: ───●───────────── 5         │
│ Spread: ●──────────────── 0 px     │
│                                     │
│ Цвет: [■ #000000]                  │
│                                     │
│ Превью слоёв:                       │
│  1: blur 1.2, opacity 0.12, y 2.4  │
│  2: blur 4.8, opacity 0.08, y 9.6  │
│  3: blur 10.8, opacity 0.05, y 14  │
│  4: blur 19.2, opacity 0.02, y 19  │
│  5: blur 48.0, opacity 0.01, y 24  │
│                                     │
│ [✓ Apply]  [📋 Copy CSS]           │
│                                     │
│ [Сохранить пресет...]               │
└─────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Математика: алгоритм генерации shadow stack|2 ч|
|2|Применение effects к ноде, сохранение не-shadow эффектов|2 ч|
|3|UI: ползунки, настройки|3 ч|
|4|Визуальный контрол источника света (drag)|3 ч|
|5|Пресеты: встроенные + пользовательские (clientStorage)|2 ч|
|6|CSS/iOS экспорт, копирование в буфер|2 ч|
|7|Live preview, polish|2 ч|
|**Итого**||**~16 ч (2–3 дня)**|

---

# A1.6 — Palette Lab

## Цель

Генератор цветовых палитр из базового цвета с автоматическим созданием VariableCollection в Figma. Поддержка light/dark тем, экспорт в CSS/Tailwind.

## Аналоги

|Аналог|Сильные стороны|Слабые стороны|
|---|---|---|
|**Realtime Colors**|Красивый web-инструмент|Не интегрирован с Figma Variables|
|**Color Shades** плагины|Быстрая генерация|Нет создания Variables, нет dark theme|
|**Palette** плагин|Хороший UI|Нет OKLCH, нет автосоздания Variables|
|**Tailwind CSS palette generators** (web)|Проверенные алгоритмы|Нужно копировать в Figma вручную|

**Конкурентное преимущество:** OKLCH для perceptual uniformity, автосоздание Variables с light/dark modes, экспорт в CSS/Tailwind/Swift.

## Функциональные требования

### FR-01: Генерация палитры

- Ввод: базовый цвет (hex, picker, или из существующей переменной)
- Выход: шкала оттенков по типу Tailwind (50, 100, 200, ..., 900, 950)
- Алгоритмы генерации (переключаемые):
    - **HSL interpolation** — простой, но проблемы с жёлтым
    - **OKLCH interpolation** — perceptually uniform, рекомендуемый
    - **LCH interpolation** — альтернатива OKLCH
- Базовый цвет закрепляется на ступени 500 (или пользователь выбирает)
- Lightness / Chroma кривые — настраиваемые

### FR-02: Мультипалитра

- Генерация нескольких палитр одновременно:
    - Primary, Secondary, Accent, Neutral, Error, Warning, Success, Info
- Для каждой — отдельный базовый цвет
- Нейтральная палитра (Neutral/Gray) — с десатурацией от Primary
- Preview всех палитр в сетке

### FR-03: Dark/Light режимы

- Автогенерация dark-палитры:
    - Не простая инверсия, а отдельный рассчёт с учётом контрастности
    - Dark background: 900–950 ступени
    - Dark text: 50–100 ступени
    - Semantic mapping: bg-primary (light: 50, dark: 900), text-primary (light: 900, dark: 50)
- Preview: переключатель light/dark в UI

### FR-04: Создание Variables

- Кнопка "Create Variables" → автоматическое создание:
    - VariableCollection с именем палитры
    - Два режима: "light", "dark"
    - Переменная для каждого оттенка: `color/{palette}/{step}` (например `color/primary/500`)
    - Семантические алиасы: `color/bg/primary` → alias на `color/primary/50` (light) / `color/primary/900` (dark)
- Опция: обновить существующую коллекцию или создать новую
- Scopes: `FRAME_FILL`, `SHAPE_FILL`, `TEXT_FILL` по умолчанию

### FR-05: Экспорт

- **CSS Custom Properties:**
    
    ```css
    :root {  --color-primary-50: #EBF5FF;  --color-primary-100: #D6EBFF;  /* ... */}[data-theme="dark"] {  --color-primary-50: #0A1929;  /* ... */}
    ```
    
- **Tailwind config:**
    
    ```js
    colors: {  primary: { 50: '#EBF5FF', 100: '#D6EBFF', /* ... */ }}
    ```
    
- **Swift:** `Color("primary500")`
- Копирование в буфер обмена

### FR-06: Проверка контрастности

- WCAG AA/AAA проверка для пар text/background
- Автоподсказка: "text-primary на bg-primary: AAA ✅ (14.3:1)"
- Визуальная матрица контрастности

## Архитектура

### OKLCH-алгоритм

```typescript
// Конвертация HEX → OKLCH
// OKLCH: L (lightness 0–1), C (chroma 0–0.4), H (hue 0–360)

interface OklchColor {
  l: number;  // lightness 0–1
  c: number;  // chroma 0–0.4
  h: number;  // hue 0–360
}

function generatePalette(baseHex: string, steps: number[]): Map<number, string> {
  const base = hexToOklch(baseHex);
  const palette = new Map<number, string>();

  // Кривая lightness для Tailwind-стиля
  const lightnessMap: Record<number, number> = {
    50: 0.97, 100: 0.93, 200: 0.87, 300: 0.78,
    400: 0.66, 500: 0.55, 600: 0.45, 700: 0.37,
    800: 0.29, 900: 0.21, 950: 0.14,
  };

  // Кривая chroma: максимум в середине, убывает к краям
  const chromaScale = (targetL: number): number => {
    const midL = base.l;
    const dist = Math.abs(targetL - midL);
    return base.c * Math.max(0.2, 1 - dist * 1.5);
  };

  for (const step of steps) {
    const targetL = lightnessMap[step];
    const c = chromaScale(targetL);
    const color: OklchColor = { l: targetL, c, h: base.h };
    palette.set(step, oklchToHex(color));
  }

  return palette;
}

// Проблема oversaturated yellow: при H ≈ 90–100 (жёлтый) chroma нужно снижать
function adjustForYellow(color: OklchColor): OklchColor {
  if (color.h > 70 && color.h < 110) {
    // Жёлтый диапазон: ограничиваем chroma
    return { ...color, c: Math.min(color.c, 0.15) };
  }
  return color;
}
```

### Создание Variables

```typescript
async function createVariableCollection(
  name: string,
  palettes: Map<string, Map<number, string>>,  // "primary" → { 50: "#...", ... }
  darkPalettes: Map<string, Map<number, string>>
): Promise<VariableCollection> {
  const collection = figma.variables.createVariableCollection(name);
  const lightId = collection.modes[0].modeId;
  collection.renameMode(lightId, 'light');
  const darkId = collection.addMode('dark');

  for (const [paletteName, lightColors] of palettes) {
    const darkColors = darkPalettes.get(paletteName)!;

    for (const [step, lightHex] of lightColors) {
      const varName = `color/${paletteName}/${step}`;
      const variable = figma.variables.createVariable(varName, collection, 'COLOR');
      variable.setValueForMode(lightId, hexToRGBA(lightHex));
      variable.setValueForMode(darkId, hexToRGBA(darkColors.get(step)!));
      variable.scopes = ['FRAME_FILL', 'SHAPE_FILL', 'TEXT_FILL', 'STROKE_COLOR'];
    }
  }

  return collection;
}
```

## UI (макет)

```
┌───────────────────────────────────────────┐
│ 🎨 Palette Lab                       [×] │
├───────────────────────────────────────────┤
│ Алгоритм: [● OKLCH  ○ HSL  ○ LCH]       │
│ Тема: [● Light  ○ Dark]  preview toggle  │
├───────────────────────────────────────────┤
│ Primary:   [■ #2563EB] [Имя: primary]    │
│  50  100  200  300  400  500  600 ... 950 │
│  ■    ■    ■    ■    ■    ●    ■  ...  ■  │
│                                           │
│ Secondary: [■ #7C3AED] [Имя: secondary]  │
│  ■    ■    ■    ■    ■    ●    ■  ...  ■  │
│                                           │
│ Neutral:   [■ auto from primary]          │
│  ■    ■    ■    ■    ■    ●    ■  ...  ■  │
│                                           │
│ [+ Добавить палитру]                      │
├───────────────────────────────────────────┤
│ Контрастность:                            │
│  text/900 на bg/50:  AAA ✅ 14.3:1       │
│  text/50 на bg/900:  AAA ✅ 13.8:1       │
│  text/600 на bg/100: AA ✅ 5.2:1         │
├───────────────────────────────────────────┤
│ [🎯 Create Variables]  [📋 Export CSS]   │
│ [Tailwind]  [Swift]                       │
└───────────────────────────────────────────┘
```

## Этапы реализации

|Этап|Задача|Срок|
|---|---|---|
|1|Математика: цветовые пространства, HSL ↔ OKLCH ↔ HEX конвертеры|4 ч|
|2|Алгоритм генерации палитры (lightness/chroma кривые)|3 ч|
|3|Dark theme генерация + semantic mapping|3 ч|
|4|UI: color pickers, палитра-preview, переключатель light/dark|4 ч|
|5|Создание VariableCollection с modes и переменными|4 ч|
|6|Проверка контрастности WCAG|2 ч|
|7|Экспорт: CSS, Tailwind, Swift|2 ч|
|8|Мультипалитра, пользовательские настройки|3 ч|
|9|Коррекция жёлтого (yellow fix), тестирование edge cases|2 ч|
|**Итого**||**~27 ч (4–5 дней)**|

## Технические сложности

- **OKLCH конвертация:** нативной поддержки в JS нет, нужны библиотеки (culori) или собственная реализация. Библиотеки нужно инлайнить в ui.html.
- **Yellow oversaturation:** OKLCH решает проблему лучше HSL, но всё равно нужна специальная обработка диапазона H 70–110.
- **Variables API:** создание коллекций и переменных относительно простое, но привязка alias'ов требует аккуратности (ID переменных).
- **Dark palette:** не инверсия lightness, а отдельный расчёт с учётом perceived contrast.

---

# Общая сводка по категории A1

|Плагин|Оценка трудозатрат|API-сложность|UI-сложность|
|---|---|---|---|
|A1.1 Pixel Audit|~14 ч (2 дня)|Низкая|Низкая|
|A1.2 Snapshotter|~16 ч (2–3 дня)|Средняя (exportAsync, Image fill)|Средняя|
|A1.3 Navigator|~18 ч (3 дня)|Средняя (pluginData, pages, viewport)|Средняя|
|A1.4 Instance Reset|~16 ч (2–3 дня)|Высокая (overrides, instance internals)|Средняя|
|A1.5 Shadow Forge|~16 ч (2–3 дня)|Низкая (effects)|Высокая (drag UI)|
|A1.6 Palette Lab|~27 ч (4–5 дней)|Средняя (Variables API)|Высокая (цвета, preview)|
|**Итого**|**~107 ч (~3–4 недели)**|||

## Рекомендуемый порядок внутри A1

```
1. Pixel Audit (A1.1)   — прокачка навыка, настройка boilerplate
2. Snapshotter (A1.2)   — нужен как модуль для Navigator
3. Instance Reset (A1.4) — быстрый и полезный, углубляет знание API
4. Shadow Forge (A1.5)   — визуально впечатляющий, хорош для портфолио
5. Navigator (A1.3)      — использует Snapshotter, логичный 3-й шаг
6. Palette Lab (A1.6)    — самый сложный, осваивает Variables API
```

## Общие технические решения для всех плагинов

### Единый boilerplate (E1)

Все 6 плагинов используют общую структуру:

```typescript
// shared/storage.ts — обёртка для clientStorage
class Storage {
  static PREFIX: string;
  static async get<T>(key: string, fallback: T): Promise<T>;
  static async set(key: string, value: any): Promise<void>;
  static async delete(key: string): Promise<void>;
}

// shared/utils.ts — общие утилиты
function sendToUI(type: string, data?: any): void;
function handleMessage(handlers: Record<string, Function>): void;

// shared/selection.ts — работа с выделением
function getSelection(): SceneNode[];
function requireSelection(minCount?: number): SceneNode[] | null;
```

### Единый стиль UI (E2)

```css
/* shared/theme.css — CSS-переменные для всех плагинов */
:root {
  --ray-bg: var(--figma-color-bg, #ffffff);
  --ray-text: var(--figma-color-text, #1a1a1a);
  --ray-text-secondary: var(--figma-color-text-secondary, #666);
  --ray-accent: var(--figma-color-ui, #0c99e4);
  --ray-border: var(--figma-color-border, #e0e0e0);
  --ray-error: #e53935;
  --ray-success: #43a047;
  --ray-warning: #ff9800;
  --ray-radius: 6px;
  --ray-spacing: 8px;
}
```