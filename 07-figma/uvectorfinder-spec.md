---
title: "UVectorFinder Technical Specification"
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
description: "Technical specification for the UVectorFinder Figma plugin"
---

# UVectorFinder — Техническое задание

> **Автор:** Ray (@uixray)  
> **Версия ТЗ:** 1.0  
> **Дата:** 2026-02-28  
> **Статус:** Черновик → На согласовании  
> **Категория в экосистеме:** A1 — Базовые утилиты (No AI)  
> **Сложность:** ⭐⭐⭐

---

## 1. Краткое описание (Summary)

**UVectorFinder** — Figma-плагин для поиска геометрически идентичных и визуально похожих векторных нод в файле. Плагин анализирует векторные пути (vector paths) и находит совпадения с настраиваемым уровнем толерантности, независимо от цвета, масштаба или позиции на канвасе.

**Ключевая ценность:** ни один существующий плагин не сравнивает фактическую геометрию (geometry) векторов — все аналоги ограничены поиском по имени слоя, визуальным свойствам (fill, stroke, size) или типу ноды.

---

## 2. Проблема и контекст (Problem Statement)

### 2.1 Проблема

В крупных дизайн-файлах (design files) накапливаются дублирующиеся векторные элементы:

- Иконки, скопированные как отдельные векторы вместо создания компонента (component)
- Импортированные SVG из разных источников, визуально идентичные, но с разными именами слоёв
- Элементы декора и иллюстрации, продублированные вручную
- Дубликаты после flatten/boolean-операций, потерявшие связь с оригиналом

### 2.2 Последствия

- Раздувание размера файла (file bloat)
- Несогласованность при обновлении (один вектор обновили, дубликаты остались старыми)
- Хаос при аудите дизайн-системы (design system audit)
- Невозможность быстро понять, какие элементы уже существуют в файле

### 2.3 Почему не работают существующие решения

| Плагин | Метод сравнения | Почему недостаточно |
|--------|-----------------|---------------------|
| **Duplicates Finder** | Имя слоя (layer name) | Переименованные дубликаты не находит |
| **Find Duplicates** | Имя + тип ноды | Аналогично |
| **Similayer** | Fill, stroke, size, font | Не анализирует векторные пути |
| **Select Similar** | Визуальные свойства | Не анализирует геометрию |
| **Visual Duplicates** | Визуальное сравнение (для библиотек компонентов) | Узкий scope, не для плоских векторов |

**Вывод:** UVectorFinder занимает незанятую нишу — поиск дубликатов по **фактической геометрии путей**.

---

## 3. Целевая аудитория (Target Users)

| Роль | Сценарий использования |
|------|----------------------|
| **UI/UX дизайнер** | Очистка файла от дублей перед хендоффом (handoff) |
| **Дизайн-системщик** | Аудит иконок и элементов для компонентизации |
| **Иллюстратор** | Поиск повторяющихся элементов в сложных макетах |
| **Лид / ревьюер** | Проверка файлов на чистоту и консистентность |

---

## 4. Пользовательские сценарии (User Stories)

### US-1: Поиск от выделенного вектора (Selection-based search)
> Как дизайнер, я хочу выбрать вектор и найти все геометрически идентичные ему ноды, чтобы понять где он используется и принять решение о компонентизации.

### US-2: Полное сканирование (Full scan)
> Как дизайнер, я хочу запустить полное сканирование без выделения и получить группы дубликатов (clusters), чтобы оценить масштаб проблемы и приоритизировать очистку.

### US-3: Быстрое действие без UI (Quick action)
> Как дизайнер, я хочу через меню быстро запустить поиск в конкретном scope (фрейм / секция / страница / файл) без открытия настроек, чтобы сэкономить время.

### US-4: Конвертация в компонент (Component conversion)
> Как дизайн-системщик, я хочу выбрать группу дубликатов и одним действием конвертировать один в компонент, а остальные — в экземпляры (instances), чтобы навести порядок в файле.

---

## 5. Функциональные требования (Functional Requirements)

### 5.1 Режимы запуска

#### 5.1.1 Через меню плагина (Menu Commands)

Плагин предоставляет **шесть команд** в меню:

| Команда | Command ID | Поведение |
|---------|------------|-----------|
| **Открыть настройки** | `open-settings` | Открывает UI с полным набором настроек и панелью результатов |
| ─── разделитель ─── | | |
| **Найти в фрейме** | `search-frame` | Немедленный поиск внутри родительского фрейма (parent frame) выделенной ноды. Если нет выделения — fallback на текущую страницу |
| **Найти в секции** | `search-section` | Немедленный поиск внутри родительской секции (section) выделенной ноды. Если секция не найдена — fallback на фрейм |
| **Найти на странице** | `search-page` | Немедленный поиск на текущей странице (current page) |
| **Найти в файле** | `search-file` | Немедленный поиск по всем страницам документа (all pages) |

При запуске быстрых команд (`search-*`):
- Если есть выделенный вектор — ищет дубликаты **этого вектора** (режим US-1)
- Если ничего не выделено — полное сканирование всех векторов в заданном scope (режим US-2)
- После нахождения результатов — **открывается UI** с панелью результатов и настройками

#### 5.1.2 manifest.json — структура меню

```json
{
  "menu": [
    { "name": "Настройки / Settings", "command": "open-settings" },
    { "separator": true },
    { "name": "🔍 Найти в фрейме", "command": "search-frame" },
    { "name": "🔍 Найти в секции", "command": "search-section" },
    { "name": "🔍 Найти на странице", "command": "search-page" },
    { "name": "🔍 Найти в файле", "command": "search-file" }
  ]
}
```

### 5.2 Область поиска (Search Scope)

| Scope | Описание | Доступность |
|-------|----------|-------------|
| **Frame** | Только внутри ближайшего родительского фрейма (parent frame) | Если вектор внутри фрейма |
| **Section** | Внутри родительской секции (section node) | Если вектор внутри секции |
| **Page** | Текущая страница (current page) | Всегда |
| **File** | Все страницы документа | Всегда (требует `loadAsync()` для каждой страницы) |

**Логика определения scope при быстром запуске:**
```
Выделенная нода
  → поиск ближайшего parent с типом FRAME → scope: Frame
  → поиск ближайшего parent с типом SECTION → scope: Section
  → если не найдено → fallback на Page
```

В UI-настройках scope выбирается вручную через radio-группу (radio group).

### 5.3 Типы анализируемых нод

| Тип ноды | Включён в анализ | Источник геометрии |
|----------|------------------|--------------------|
| `VECTOR` | ✅ | `vectorPaths` или `fillGeometry` |
| `BOOLEAN_OPERATION` | ✅ | `fillGeometry` (результат операции) |
| `RECTANGLE` | ❌ v1.0 | — |
| `ELLIPSE` | ❌ v1.0 | — |
| `STAR` | ❌ v1.0 | — |
| `POLYGON` | ❌ v1.0 | — |
| `LINE` | ❌ v1.0 | — |

> **📝 Заметка для v2.0:** Расширить на примитивы (RECTANGLE, ELLIPSE, STAR, POLYGON) с нормализацией их геометрии в vectorPaths для единого формата сравнения.

### 5.4 Фильтры поиска

| Фильтр | Тип элемента | По умолчанию | Описание |
|--------|--------------|--------------|----------|
| **Включать скрытые** (Include hidden) | Checkbox | ❌ OFF | Учитывать ноды с `visible: false` |
| **Включать заблокированные** (Include locked) | Checkbox | ✅ ON | Учитывать ноды с `locked: true` |

### 5.5 Метод сравнения (Comparison Method)

Пользователь может выбрать метод сравнения через переключатель (toggle / radio):

| Метод | Источник данных | Сильные стороны | Слабые стороны |
|-------|-----------------|-----------------|----------------|
| **vectorPaths** | `node.vectorPaths` | Прямой доступ к данным путей; работает на `VECTOR` нодах | Не учитывает результат булевых операций |
| **fillGeometry** | `node.fillGeometry` | Отображает финальную видимую геометрию; работает после boolean operations | Может быть недоступен на некоторых нодах; read-only |

**Рекомендация в UI:** по умолчанию `fillGeometry` (более надёжный для визуального совпадения). Переключение на `vectorPaths` для случаев, когда нужен анализ исходных путей.

> **📝 Заметка для v2.0:** Реализовать продвинутое хэширование с нормализацией координат вместо `JSON.stringify`. Возможные подходы: каноническая форма SVG path data, нормализация начальной точки пути, устойчивость к перестановке sub-paths.

### 5.6 Толерантность (Tolerance)

Слайдер (slider) с четырьмя предустановками и ручным вводом:

| Уровень | Значение | Описание | Что сравнивается |
|---------|----------|----------|------------------|
| **Exact** | 0 | Побитовое совпадение | Полное совпадение нормализованных path data |
| **Pixel** | 0.5 | Допуск субпиксельных различий | Координаты вершин ± 0.5 |
| **Relaxed** | 2.0 | Визуально идентичные | Координаты ± 2.0, размер ± 5% |
| **Loose** | 5.0 | Похожая форма | Координаты ± 5.0, размер ± 15% |
| **Custom** | 0–10 | Ручной ввод | Произвольное значение через input |

**Алгоритм сравнения с учётом толерантности:**

1. **Нормализация масштаба (Scale normalization):**
   - Привести все пути к единому bounding box (например, 100×100)
   - Это позволяет считать одинаковыми векторы 24×24 и 48×48

2. **Нормализация координат:**
   - Сдвинуть начало координат в (0, 0) — минимальный X, Y пути
   - Если tolerance = 0: побитовое сравнение нормализованных строк
   - Если tolerance > 0: парсинг path data → поточечное сравнение с допуском

3. **Генерация хэша (Fingerprint):**
   - При tolerance = 0: `JSON.stringify(normalizedPaths)` → прямое сравнение строк
   - При tolerance > 0: квантизация координат (rounding to tolerance grid) → хэш квантизированных данных

### 5.7 Обработка масштаба (Scale Handling)

Для корректного определения конгруэнтности (congruence) путей разного масштаба:

```
Вектор A: 24×24, path data: "M 0 12 L 12 0 L 24 12 L 12 24 Z"
Вектор B: 48×48, path data: "M 0 24 L 24 0 L 48 24 L 24 48 Z"

Нормализация к 1×1:
A: "M 0 0.5 L 0.5 0 L 1 0.5 L 0.5 1 Z"
B: "M 0 0.5 L 0.5 0 L 1 0.5 L 0.5 1 Z"

Результат: MATCH ✅
```

---

## 6. Алгоритм работы (Algorithm)

### 6.1 Общий поток (High-Level Flow)

```
┌─────────────┐     ┌──────────────┐     ┌───────────────┐
│  1. Сбор    │────►│  2. Извлечение│────►│ 3. Нормализация│
│  нод        │     │  геометрии   │     │  путей        │
│  (Collect)  │     │  (Extract)   │     │  (Normalize)  │
└─────────────┘     └──────────────┘     └───────┬───────┘
                                                  │
┌─────────────┐     ┌──────────────┐     ┌───────▼───────┐
│  6. Вывод   │◄────│  5. Группи-  │◄────│ 4. Хэширование│
│  результатов│     │  ровка       │     │  / сравнение  │
│  (Output)   │     │  (Cluster)   │     │  (Hash/Match) │
└─────────────┘     └──────────────┘     └───────────────┘
```

### 6.2 Шаг 1: Сбор нод (Collection)

```typescript
// Псевдокод сбора целевых нод
function collectTargetNodes(scope: SearchScope, filters: Filters): SceneNode[] {
  const rootNode = getScopeRoot(scope) // frame | section | page | document

  return rootNode.findAll(node => {
    // Фильтр по типу
    if (node.type !== 'VECTOR' && node.type !== 'BOOLEAN_OPERATION') return false

    // Фильтр скрытых
    if (!filters.includeHidden && !node.visible) return false

    // Фильтр заблокированных
    if (!filters.includeLocked && node.locked) return false

    return true
  })
}
```

### 6.3 Шаг 2: Извлечение геометрии (Extraction)

```typescript
function extractGeometry(node: SceneNode, method: 'vectorPaths' | 'fillGeometry'): PathData[] {
  if (method === 'vectorPaths' && 'vectorPaths' in node) {
    return node.vectorPaths
  }
  if (method === 'fillGeometry' && 'fillGeometry' in node) {
    return node.fillGeometry
  }
  return []
}
```

### 6.4 Шаг 3: Нормализация (Normalization)

```typescript
function normalizePaths(paths: PathData[], boundingBox: Rect): NormalizedPath[] {
  const { width, height } = boundingBox

  return paths.map(path => {
    // Парсинг SVG path data в команды
    const commands = parseSVGPath(path.data)

    // Сдвиг к (0,0)
    const shifted = shiftToOrigin(commands)

    // Масштабирование к единичному размеру (1×1)
    const scaled = scaleToUnit(shifted, width, height)

    return {
      windingRule: path.windingRule,
      commands: scaled,
      data: serializeCommands(scaled)
    }
  })
}
```

### 6.5 Шаг 4: Хэширование и сравнение (Hashing & Matching)

```typescript
function generateFingerprint(
  normalizedPaths: NormalizedPath[],
  tolerance: number
): string {
  if (tolerance === 0) {
    // Побитовое совпадение — строковое сравнение
    return JSON.stringify(normalizedPaths.map(p => p.data).sort())
  }

  // Квантизация: округление координат к сетке толерантности
  const quantized = normalizedPaths.map(p => {
    const quantizedCommands = p.commands.map(cmd =>
      cmd.map(val =>
        typeof val === 'number' ? Math.round(val / tolerance) * tolerance : val
      )
    )
    return serializeCommands(quantizedCommands)
  }).sort()

  return JSON.stringify(quantized)
}
```

### 6.6 Шаг 5: Группировка (Clustering)

```typescript
function clusterByFingerprint(
  nodes: Array<{ node: SceneNode, fingerprint: string }>
): Map<string, SceneNode[]> {
  const clusters = new Map<string, SceneNode[]>()

  for (const { node, fingerprint } of nodes) {
    if (!clusters.has(fingerprint)) {
      clusters.set(fingerprint, [])
    }
    clusters.get(fingerprint)!.push(node)
  }

  // Возвращаем только группы с 2+ элементами (дубликаты)
  for (const [key, group] of clusters) {
    if (group.length < 2) clusters.delete(key)
  }

  return clusters
}
```

### 6.7 Шаг 6: Вывод результатов

Результаты передаются в UI через `postMessage` для отображения.

---

## 7. Интерфейс пользователя (UI Specification)

### 7.1 Общая компоновка

```
┌──────────────────────────────────────────┐
│  UVectorFinder                     [×]   │
├──────────────────────────────────────────┤
│                                          │
│  ── Область поиска (Search Scope) ──     │
│  ○ Фрейм  ○ Секция  ○ Страница  ○ Файл │
│                                          │
│  ── Метод сравнения (Method) ──          │
│  ○ fillGeometry (рекомендуется)          │
│  ○ vectorPaths                           │
│                                          │
│  ── Толерантность (Tolerance) ──         │
│  [Exact] [Pixel] [Relaxed] [Loose]       │
│  ───●─────────────────────── [2.0]       │
│                                          │
│  ── Фильтры ──                           │
│  ☐ Включать скрытые (hidden)             │
│  ☑ Включать заблокированные (locked)     │
│                                          │
│  [ 🔍 Найти дубликаты ]                 │
│                                          │
├──────────────────────────────────────────┤
│  ── Результаты ──                        │
│                                          │
│  Найдено 3 группы (12 дубликатов)        │
│                                          │
│  ▼ Группа 1 — 4 совпадения              │
│    • icon-arrow (Frame: Header) [→]      │
│    • Vector 23 (Frame: Nav)     [→]      │
│    • arrow-copy (Frame: Footer) [→]      │
│    • Vector 8 (Frame: Sidebar)  [→]      │
│    [ Выделить все ] [ → Компонент ]      │
│    [ ⬚ Подсветить ]                      │
│                                          │
│  ▼ Группа 2 — 5 совпадений              │
│    • ...                                 │
│                                          │
│  ▶ Группа 3 — 3 совпадения              │
│                                          │
├──────────────────────────────────────────┤
│  Просканировано: 847 нод за 1.2 сек     │
└──────────────────────────────────────────┘
```

### 7.2 Размеры окна

| Параметр | Значение |
|----------|----------|
| **Ширина** | 360px |
| **Высота (мин)** | 480px |
| **Высота (макс)** | 640px |
| **themeColors** | `true` |

### 7.3 Элементы панели настроек

**Search Scope (radio group):**
- Frame / Секция / Страница / Файл
- При наличии выделенной ноды — подсвечивается определённый scope автоматически
- Недоступные опции (например, Section, если нода не в секции) — disabled с тултипом (tooltip)

**Method (radio group):**
- `fillGeometry` — выбран по умолчанию, tooltip: "Анализирует финальную видимую геометрию. Рекомендуется для большинства случаев."
- `vectorPaths` — tooltip: "Анализирует исходные пути вектора. Полезно для сравнения до применения boolean-операций."

**Tolerance (slider + chip buttons + input):**
- Четыре кнопки-чипа (chip) для быстрого выбора: Exact (0), Pixel (0.5), Relaxed (2.0), Loose (5.0)
- Слайдер от 0 до 10 с шагом 0.1
- Числовой input для точного ввода
- Все три элемента синхронизированы

**Filters (checkboxes):**
- ☐ Include hidden nodes
- ☑ Include locked nodes

**Кнопка поиска:**
- Текст: "🔍 Найти дубликаты" / "🔍 Найти совпадения" (если есть выделение)
- Disabled состояние при пустом файле или невалидных настройках

### 7.4 Элементы панели результатов

**Заголовок результатов:**
- "Найдено N групп (M дубликатов)" или "Совпадений не найдено"
- Статистика: "Просканировано: X нод за Y сек"

**Группа дубликатов (collapsible):**
- Заголовок: "Группа N — K совпадений" (кликабельный для expand/collapse)
- Список элементов в группе:
  - Имя ноды (node name)
  - Родительский контейнер (parent frame/section name) — серым текстом
  - Кнопка `[→]` — zoom to node (навигация к ноде на канвасе)
  - Клик по строке — выделяет ноду на канвасе (select)

**Действия над группой:**

| Действие | Кнопка | Описание |
|----------|--------|----------|
| **Выделить все** (Select all) | `[ Выделить все ]` | Добавляет все ноды группы в `figma.currentPage.selection` |
| **Конвертировать** (To component) | `[ → Компонент ]` | Первый элемент → Component, остальные → Instance. Подробности в п. 8.4 |
| **Подсветить** (Highlight) | `[ ⬚ Подсветить ]` | Создаёт временные рамки (frames) вокруг каждой ноды группы. Подробности в п. 8.3 |

> **📝 Заметка для v2.0:** Добавить миниатюры (thumbnails/previews) для каждой группы дубликатов. Потребует `node.exportAsync({ format: 'PNG', constraint: { type: 'WIDTH', value: 48 } })` и передачу base64 в UI.

### 7.5 Состояния UI

| Состояние | Что показывается |
|-----------|-----------------|
| **Initial** | Панель настроек, кнопка "Найти", пустая панель результатов с текстом "Настройте параметры и запустите поиск" |
| **Searching** | Кнопка заменена на "Поиск..." с прогрессом, настройки disabled |
| **Results** | Панель результатов заполнена группами |
| **No results** | Сообщение "Дубликатов не найдено" с иконкой ✓ |
| **Error** | Сообщение об ошибке (например, "Нет векторных нод в выбранном scope") |

---

## 8. Действия над результатами (Actions)

### 8.1 Выделение (Select)

```typescript
// Выделить одну ноду
function selectNode(nodeId: string) {
  const node = await figma.getNodeByIdAsync(nodeId)
  if (node) {
    figma.currentPage.selection = [node as SceneNode]
    figma.viewport.scrollAndZoomIntoView([node as SceneNode])
  }
}

// Выделить все ноды группы
function selectGroup(nodeIds: string[]) {
  const nodes = await Promise.all(
    nodeIds.map(id => figma.getNodeByIdAsync(id))
  )
  const valid = nodes.filter(Boolean) as SceneNode[]
  figma.currentPage.selection = valid
  figma.viewport.scrollAndZoomIntoView(valid)
}
```

### 8.2 Навигация (Zoom to Node)

```typescript
function zoomToNode(nodeId: string) {
  const node = await figma.getNodeByIdAsync(nodeId)
  if (node) {
    figma.viewport.scrollAndZoomIntoView([node as SceneNode])
    // Не меняем selection — просто показываем на канвасе
  }
}
```

### 8.3 Подсветка (Highlight)

Создаёт временные рамки вокруг каждой ноды для визуального выделения на канвасе.

```typescript
function highlightNodes(nodeIds: string[], groupIndex: number) {
  const HIGHLIGHT_COLORS = [
    { r: 1, g: 0.2, b: 0.2 },    // красный
    { r: 0.2, g: 0.6, b: 1 },    // синий
    { r: 0.2, g: 0.8, b: 0.4 },  // зелёный
    { r: 1, g: 0.6, b: 0 },      // оранжевый
    { r: 0.6, g: 0.2, b: 1 },    // фиолетовый
  ]

  const color = HIGHLIGHT_COLORS[groupIndex % HIGHLIGHT_COLORS.length]

  for (const nodeId of nodeIds) {
    const node = await figma.getNodeByIdAsync(nodeId) as SceneNode
    if (!node) continue

    const highlight = figma.createRectangle()
    highlight.name = `[UVF] Highlight: ${node.name}`

    // Позиция и размер с отступом
    const padding = 4
    highlight.x = node.absoluteTransform[0][2] - padding
    highlight.y = node.absoluteTransform[1][2] - padding
    highlight.resize(node.width + padding * 2, node.height + padding * 2)

    // Стиль: только обводка, без заливки
    highlight.fills = []
    highlight.strokes = [{ type: 'SOLID', color }]
    highlight.strokeWeight = 2
    highlight.dashPattern = [4, 4]
    highlight.cornerRadius = 2

    // Метаданные для последующей очистки
    highlight.setPluginData('uvf-highlight', 'true')
    highlight.setPluginData('uvf-highlight-group', String(groupIndex))

    figma.currentPage.appendChild(highlight)
  }
}

// Очистка всех подсветок
function clearHighlights() {
  const highlights = figma.currentPage.findAll(
    node => node.getPluginData('uvf-highlight') === 'true'
  )
  for (const h of highlights) h.remove()
}
```

**Особенности:**
- Каждая группа дубликатов — свой цвет рамки (из палитры 5 цветов)
- Пунктирная обводка (dashed stroke) для отличия от обычных элементов
- Все highlight-ноды помечаются через `pluginData` для очистки
- Кнопка "Очистить подсветку" (Clear highlights) в UI — всегда видна если есть активные highlights

### 8.4 Конвертация в компонент (Convert to Component)

```typescript
async function convertToComponent(nodeIds: string[]) {
  if (nodeIds.length < 2) return

  // Первый элемент → Component
  const primaryNode = await figma.getNodeByIdAsync(nodeIds[0]) as SceneNode
  const component = figma.createComponentFromNode(primaryNode)
  component.name = primaryNode.name.replace(/\s*\d+$/, '') // убираем trailing number

  // Остальные → Instance
  for (let i = 1; i < nodeIds.length; i++) {
    const dupNode = await figma.getNodeByIdAsync(nodeIds[i]) as SceneNode
    if (!dupNode) continue

    const instance = component.createInstance()

    // Копируем позицию и размер
    instance.x = dupNode.x
    instance.y = dupNode.y
    instance.resize(dupNode.width, dupNode.height)

    // Вставляем в тот же parent
    if (dupNode.parent) {
      const parent = dupNode.parent
      const index = parent.children.indexOf(dupNode)
      parent.insertChild(index, instance)
    }

    // Удаляем оригинал
    dupNode.remove()
  }

  figma.notify(`✓ Создан компонент "${component.name}" с ${nodeIds.length - 1} экземплярами`)
}
```

**Предупреждение перед конвертацией:** UI показывает диалог подтверждения:
> "Будет создан компонент из первого элемента, а остальные N элементов будут заменены экземплярами. Это действие нельзя отменить через плагин (но можно через Ctrl+Z). Продолжить?"

---

## 9. Технические спецификации (Technical Specifications)

### 9.1 Структура проекта

```
u-vector-finder/
├── manifest.json
├── package.json
├── tsconfig.json
├── esbuild.config.js
│
├── src/
│   ├── code.ts                  ← Main thread entry point
│   ├── types.ts                 ← Общие типы и интерфейсы
│   │
│   ├── core/
│   │   ├── collector.ts         ← Сбор целевых нод по scope и фильтрам
│   │   ├── extractor.ts         ← Извлечение геометрии из нод
│   │   ├── normalizer.ts        ← Нормализация путей (масштаб, сдвиг)
│   │   ├── hasher.ts            ← Генерация fingerprint (хэширование)
│   │   ├── comparator.ts        ← Кластеризация и группировка
│   │   └── path-parser.ts       ← Парсер SVG path data
│   │
│   ├── actions/
│   │   ├── select.ts            ← Выделение и навигация
│   │   ├── highlight.ts         ← Подсветка рамками
│   │   └── componentize.ts      ← Конвертация в компонент
│   │
│   ├── utils/
│   │   ├── storage.ts           ← Обёртка над clientStorage
│   │   ├── messaging.ts         ← Типизированные postMessage
│   │   └── scope-resolver.ts    ← Определение scope из контекста
│   │
│   └── ui/
│       └── ui.html              ← Единый HTML файл (инлайн CSS + JS)
│
└── dist/
    ├── code.js                  ← Скомпилированный main thread
    └── ui.html                  ← Копия / собранный UI
```

### 9.2 manifest.json

```json
{
  "name": "UVectorFinder",
  "id": "000000000000000000",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "dist/code.js",
  "ui": "dist/ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["none"]
  },
  "menu": [
    { "name": "Настройки / Settings", "command": "open-settings" },
    { "separator": true },
    { "name": "🔍 Найти в фрейме", "command": "search-frame" },
    { "name": "🔍 Найти в секции", "command": "search-section" },
    { "name": "🔍 Найти на странице", "command": "search-page" },
    { "name": "🔍 Найти в файле", "command": "search-file" }
  ]
}
```

### 9.3 Ключевые типы (types.ts)

```typescript
// ── Настройки поиска ──
export type SearchScope = 'frame' | 'section' | 'page' | 'file'
export type ComparisonMethod = 'vectorPaths' | 'fillGeometry'

export interface SearchConfig {
  scope: SearchScope
  method: ComparisonMethod
  tolerance: number
  includeHidden: boolean
  includeLocked: boolean
}

// ── Результаты ──
export interface NodeInfo {
  id: string
  name: string
  parentName: string       // имя ближайшего parent frame/section
  pageId: string           // ID страницы (для multi-page search)
  pageName: string
  width: number
  height: number
}

export interface DuplicateGroup {
  groupIndex: number
  fingerprint: string
  nodes: NodeInfo[]
}

export interface SearchResult {
  groups: DuplicateGroup[]
  totalScanned: number
  totalDuplicates: number  // сумма (group.nodes.length - 1) по всем группам
  elapsedMs: number
}

// ── Сообщения между main и UI ──
export type PluginMessage =
  | { type: 'init'; settings: SearchConfig }
  | { type: 'search'; config: SearchConfig }
  | { type: 'search-results'; results: SearchResult }
  | { type: 'search-error'; message: string }
  | { type: 'select-node'; nodeId: string }
  | { type: 'select-group'; nodeIds: string[] }
  | { type: 'zoom-to-node'; nodeId: string }
  | { type: 'highlight-group'; nodeIds: string[]; groupIndex: number }
  | { type: 'clear-highlights' }
  | { type: 'convert-to-component'; nodeIds: string[] }
  | { type: 'save-settings'; config: SearchConfig }
  | { type: 'action-done'; message: string }
  | { type: 'close' }
```

### 9.4 Сохранение настроек (Settings Persistence)

```typescript
// utils/storage.ts
const STORAGE_KEY = 'uvf:settings'

export async function loadSettings(): Promise<SearchConfig> {
  const saved = await figma.clientStorage.getAsync(STORAGE_KEY)
  return {
    scope: saved?.scope ?? 'page',
    method: saved?.method ?? 'fillGeometry',
    tolerance: saved?.tolerance ?? 0.5,
    includeHidden: saved?.includeHidden ?? false,
    includeLocked: saved?.includeLocked ?? true,
    ...saved
  }
}

export async function saveSettings(config: SearchConfig): Promise<void> {
  await figma.clientStorage.setAsync(STORAGE_KEY, config)
}
```

### 9.5 Обработка команд (code.ts — entry point)

```typescript
// code.ts — главная логика
import { loadSettings, saveSettings } from './utils/storage'
import { runSearch } from './core/comparator'

async function main() {
  const settings = await loadSettings()
  const command = figma.command

  // Определяем scope из команды
  const scopeMap: Record<string, SearchScope | null> = {
    'open-settings': null,
    'search-frame': 'frame',
    'search-section': 'section',
    'search-page': 'page',
    'search-file': 'file',
  }

  const commandScope = scopeMap[command] ?? null

  // Всегда показываем UI
  figma.showUI(__html__, { width: 360, height: 540, themeColors: true })

  // Отправляем начальное состояние
  figma.ui.postMessage({
    type: 'init',
    settings: commandScope
      ? { ...settings, scope: commandScope }
      : settings
  })

  // Если команда быстрого поиска — сразу запускаем
  if (commandScope) {
    const config = { ...settings, scope: commandScope }
    const results = await runSearch(config)
    figma.ui.postMessage({ type: 'search-results', results })
  }

  // Обработка сообщений из UI
  figma.ui.onmessage = async (msg: PluginMessage) => {
    switch (msg.type) {
      case 'search':
        try {
          const results = await runSearch(msg.config)
          figma.ui.postMessage({ type: 'search-results', results })
        } catch (err) {
          figma.ui.postMessage({
            type: 'search-error',
            message: (err as Error).message
          })
        }
        break

      case 'save-settings':
        await saveSettings(msg.config)
        break

      case 'select-node':
        // ... (см. п. 8.1)
        break

      case 'zoom-to-node':
        // ... (см. п. 8.2)
        break

      case 'highlight-group':
        await highlightNodes(msg.nodeIds, msg.groupIndex)
        figma.ui.postMessage({
          type: 'action-done',
          message: `Подсвечено ${msg.nodeIds.length} элементов`
        })
        break

      case 'clear-highlights':
        clearHighlights()
        break

      case 'convert-to-component':
        await convertToComponent(msg.nodeIds)
        break

      case 'close':
        clearHighlights() // очистка при закрытии
        figma.closePlugin()
        break
    }
  }
}

main()
```

---

## 10. Производительность (Performance Considerations)

### 10.1 Оценка нагрузки

| Файл | Примерное кол-во VECTOR нод | Ожидаемое время |
|------|-----------------------------|-----------------|
| Малый (1–5 фреймов) | 50–200 | < 0.5 сек |
| Средний (10–30 фреймов) | 200–1000 | 0.5–3 сек |
| Большой (дизайн-система) | 1000–5000 | 3–10 сек |
| Очень большой (мультипейдж) | 5000+ | 10+ сек, нужен прогресс |

### 10.2 Оптимизации

1. **Ранний выход (Early exit):** если вектор не имеет path data — пропускаем
2. **Батчевая обработка:** для больших файлов — разбиваем на чанки и показываем прогресс
3. **Кэширование fingerprints:** сохраняем в `pluginData` ноды для повторного поиска
4. **Отложенная загрузка страниц:** при scope = 'file' загружаем страницы по одной через `page.loadAsync()`

### 10.3 Прогресс-индикация

Для больших файлов (>500 нод):
- Прогресс-бар в UI: "Анализ: 340 / 1200 нод..."
- Обновление через `postMessage` каждые 50 нод
- Возможность отмены (Cancel) — флаг `isCancelled` проверяется в цикле

---

## 11. Edge Cases и обработка ошибок

| Кейс | Обработка |
|------|-----------|
| Нет выделения при быстром запуске | Полное сканирование scope (режим US-2) |
| Выделена не-векторная нода | Сообщение: "Выделенная нода не является вектором. Запущен полный поиск." |
| Scope = Frame, но нода не внутри фрейма | Fallback на Page с уведомлением |
| Scope = Section, но секция не найдена | Fallback на Frame → Page с уведомлением |
| 0 векторов в scope | Сообщение: "Векторные ноды не найдены в выбранной области" |
| Нода удалена во время просмотра результатов | При action — проверка `getNodeByIdAsync` на null, удаление из списка |
| Очень длинные path data | Ограничение длины строки при хэшировании; предупреждение |
| vectorPaths пуст (BOOLEAN_OPERATION) | Fallback на fillGeometry с уведомлением |
| fillGeometry пуст | Пропускаем ноду, считаем как "не анализируемую" |

---

## 12. Ограничения MVP (Scope Limitations)

| Что НЕ входит в v1.0 | Причина | Запланировано |
|----------------------|---------|---------------|
| Превью/миниатюры в списке | Сложность UI + производительность | v2.0 |
| Поддержка примитивов (RECTANGLE, ELLIPSE и т.д.) | Требует отдельную нормализацию | v2.0 |
| Продвинутое хэширование (каноническая форма) | Достаточно JSON.stringify для MVP | v2.0 |
| Удаление дубликатов | Опасное действие, нужен Undo | v1.1 |
| Экспорт отчёта | Не критично для MVP | v1.1 |
| Интеграция с Design Lint | Отдельная архитектура | v3.0+ |
| Сравнение между файлами | Ограничение Figma API | Не планируется |

---

## 13. План реализации (Implementation Plan)

### Фаза 1 — Ядро (Core Engine) · ~8 часов

| Задача | Оценка |
|--------|--------|
| Настройка проекта (manifest, tsconfig, esbuild) | 0.5ч |
| `types.ts` — все типы и интерфейсы | 0.5ч |
| `path-parser.ts` — парсер SVG path data | 2ч |
| `collector.ts` — сбор нод по scope + фильтры | 1ч |
| `extractor.ts` — извлечение геометрии | 0.5ч |
| `normalizer.ts` — нормализация (масштаб, сдвиг) | 2ч |
| `hasher.ts` — fingerprinting с толерантностью | 1ч |
| `comparator.ts` — кластеризация + главный `runSearch()` | 0.5ч |

### Фаза 2 — UI · ~6 часов

| Задача | Оценка |
|--------|--------|
| HTML-каркас с CSS (тема Figma, layout) | 2ч |
| Панель настроек (scope, method, tolerance, filters) | 1.5ч |
| Панель результатов (collapsible groups, actions) | 2ч |
| Messaging layer (UI ↔ Main) | 0.5ч |

### Фаза 3 — Actions · ~4 часа

| Задача | Оценка |
|--------|--------|
| Select / Zoom to node | 0.5ч |
| Highlight (рамки + очистка) | 1.5ч |
| Convert to Component + Instance | 1.5ч |
| Диалог подтверждения | 0.5ч |

### Фаза 4 — Обвязка · ~4 часа

| Задача | Оценка |
|--------|--------|
| Storage (сохранение настроек) | 0.5ч |
| Обработка команд меню (menu commands) | 1ч |
| Прогресс-индикация для больших файлов | 1ч |
| Edge cases + error handling | 1ч |
| Тестирование на реальных файлах | 0.5ч |

### Итого: ~22 часа

| Фаза | Часы | Статус |
|------|------|--------|
| Ядро | 8ч | 🔲 |
| UI | 6ч | 🔲 |
| Actions | 4ч | 🔲 |
| Обвязка | 4ч | 🔲 |
| **Всего** | **22ч** | |

---

## 14. Метрики успеха (Success Criteria)

| Метрика | Целевое значение |
|---------|-----------------|
| Точность Exact mode (tolerance=0) | 100% — ни одного ложного срабатывания |
| Точность Pixel mode (tolerance=0.5) | >95% — минимум false positives |
| Время поиска (1000 нод, Page scope) | < 5 секунд |
| Время поиска (100 нод, Frame scope) | < 1 секунда |
| Успешная конвертация в компонент | Без потери позиций и размеров |

---

## 15. Конкурентное преимущество (Competitive Edge)

| Критерий | Аналоги | UVectorFinder |
|----------|---------|---------------|
| Сравнение по геометрии | ❌ | ✅ |
| Настраиваемая толерантность | ❌ | ✅ |
| Нормализация масштаба | ❌ | ✅ |
| Конвертация в компонент | ❌ | ✅ |
| Множественный scope | ❌ | ✅ (4 уровня) |
| Быстрые действия из меню | — | ✅ |
| Русская локализация | Частично | ✅ |

---

## 16. Связь с экосистемой Ray's Design Toolkit

- **E1 Boilerplate:** использует shared-модули `storage`, `messaging`, `traverse`
- **A2.2 Design Lint:** механика поиска дубликатов может стать одним из lint-правил в будущем
- **A3.1 Smart Renamer:** найденные дубликаты можно пакетно переименовать
- **A5.2 Plugin Hub:** UVectorFinder будет одним из плагинов в каталоге экосистемы

---

*Конец технического задания. Документ подлежит ревизии после первой итерации разработки.*
