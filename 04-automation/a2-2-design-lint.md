# A2.2 — Design Lint

> **Экосистема:** Ray's Design Toolkit  
> **Категория:** A2 — Продвинутые утилиты (No AI)  
> **Автор:** Ray (@uixray)  
> **Дата:** 2026-02-27  
> **Статус:** Техническое задание  
> **Сложность:** ⭐⭐⭐⭐  
> **Оценка трудозатрат:** ~50–65 ч  
> **Зависимости:** E1 Boilerplate, E2 UI Kit  

---

## 1. Концепция

### 1.1 Проблема

Дизайнеры работающие с крупными файлами регулярно сталкиваются с тремя категориями хаоса:

**Типографика.** Текстовые слои теряют привязку к TextStyle, используют произвольные размеры шрифта, межстрочные и межбуквенные интервалы. При смене шрифтового семейства (например, Inter → Golos Text) встроенный "Replace font" в Figma работает только при отсутствующих шрифтах и не даёт контроля над частичной заменой.

**Цвета.** Заливки (fills), обводки (strokes) и фоны используют хардкод hex-значений вместо привязки к Color Variables или Color Styles. При ребрендинге или миграции на переменные — ручная работа на часы.

**Эффекты.** Тени (drop shadow, inner shadow) и блюры (layer blur, background blur) применяются вручную с произвольными параметрами вместо привязки к Effect Styles.

**Инстансы.** Самая коварная проблема — дизайнеры непреднамеренно переопределяют стили внутри Instance, создавая "стилевые оверрайды" (style overrides). Это ломает связь с мастер-компонентом и делает массовое обновление дизайн-системы невозможным.

### 1.2 Решение

**Design Lint** — плагин-аудитор с тремя специализированными режимами и одним мета-режимом:

| Режим | Что делает |
|-------|------------|
| **Typography** | Сканирует шрифты, кегль, интерлиньяж, привязку к TextStyle. Массовая замена гарнитуры. Массовое переназначение числовых параметров |
| **Colors** | Сканирует fills/strokes, привязку к Variables/ColorStyles. Массовое переназначение цветов |
| **Effects** | Сканирует тени и блюры, привязку к EffectStyles. Массовое переназначение эффектов |
| **Overrides** | Находит инстансы со стилевыми оверрайдами (текст, цвет, эффект). Массовый сброс к мастер-компоненту с защитой контента и изображений |

### 1.3 Позиционирование vs конкуренты

| Критерий | Styles & Variables Organizer | Style Lens | **Design Lint** |
|----------|------------------------------|------------|-----------------|
| Scope сканирования | Страница (зависает) | Страница | **Selection → Page → Document** |
| Прогрессивные результаты | Нет (ждать до конца) | Нет | **Да, чанками** |
| Пропуск инстансов | Нет (топ-запрос) | Нет | **Да, toggle** |
| Обнаружение оверрайдов | Нет | Нет | **Отдельный режим** |
| Замена шрифтов | Нет | Частично | **Полная, как Replace Font** |
| Скрытые слои | Пропускает | Пропускает | **Toggle + отдельная группа** |
| Изображения в инстансах | Перезаписывает | — | **Отдельная группа, подтверждение** |
| Статус | Платный ($10), баги | Заброшен 3 года | **Бесплатный, open source** |
| Производительность | Зависает 10+ мин | Терпимо | **Chunked processing, UI не блокируется** |

---

## 2. Пользовательские сценарии

### 2.1 Сценарий: Замена шрифта по всему файлу

> Дизайнер: "Нужно заменить Inter на Golos Text во всём макете, при этом не трогать инстансы — только мастер-компоненты и обычные фреймы."

1. Открыть Design Lint → вкладка **Typography**
2. Scope: "Page" (или "Selection" если нужна часть)
3. Нажать **Scan** → плагин выдаёт сгруппированный список шрифтов
4. Рядом с "Inter" → кнопка **Replace** → выбрать "Golos Text"
5. Маппинг стилей: Inter Regular → Golos Text Regular, Inter Bold → Golos Text SemiBold (пользователь настраивает)
6. Toggle "Пропускать инстансы" ✅ (по умолчанию)
7. **Apply** → прогресс-бар → результат: "Заменено 847 слоёв, пропущено 312 в инстансах"

### 2.2 Сценарий: Аудит привязки цветов к переменным

> Дизайнер: "Перешли на Variables, но половина файла всё ещё использует хардкод цвета. Нужно найти все непривязанные цвета и массово привязать."

1. Design Lint → вкладка **Colors**
2. Scope: "Selection" (конкретный экран)
3. **Scan** → группы: "Привязаны к Variable", "Привязаны к Style", "Без привязки"
4. В группе "Без привязки" — список уникальных цветов с количеством использований
5. Рядом с `#0066CC (43 использования)` → **Reassign** → Variable picker → выбрать `brand/primary`
6. **Apply** → 43 слоя привязаны к переменной

### 2.3 Сценарий: Сброс стилевых оверрайдов в инстансах

> Дизайнер: "Джуниор поменял цвета в куче инстансов вместо того чтобы править мастер-компонент. Нужно найти все такие оверрайды и сбросить."

1. Design Lint → вкладка **Overrides**
2. Scope: "Page"
3. **Scan** → группы оверрайдов: "Цвет (fills/strokes)", "Текстовые стили", "Эффекты", "Изображения (требует подтверждения)"
4. Группа "Цвет" — список инстансов с оверрайдами, по каждому: имя, путь, что изменено (было → стало)
5. Checkbox для выбора конкретных / **Select All** → **Reset Overrides**
6. Группа "Изображения" — отдельно, каждый элемент требует явного подтверждения

### 2.4 Сценарий: Обнаружение "призрачных" параметров текста

> Дизайнер: "В файле 6 разных размеров шрифта, а в дизайн-системе только 4. Нужно найти лишние и переназначить."

1. Design Lint → Typography → **Scan**
2. Суммарная таблица кеглей: `12px (14 слоёв)`, `14px (187)`, `15px (3)`, `16px (402)`, `18px (89)`, `24px (45)`
3. `15px` — подозрительный. Клик → показать все 3 слоя на канвасе
4. **Reassign** → выбрать `14px` или привязать к TextStyle "Body/Small"
5. Аналогично для line-height, letter-spacing

---

## 3. Архитектура

### 3.1 Общая схема

```
┌─────────────────────────────────────────────────────┐
│                    Design Lint                       │
│                                                     │
│  ┌─────────────────────┐   ┌──────────────────────┐│
│  │   Main Thread        │   │   UI Thread (iframe) ││
│  │   (code.ts)          │   │   (ui.html)          ││
│  │                      │   │                      ││
│  │  Scanner Engine      │◄─►│  Tab UI              ││
│  │  ├ TypographyScanner │   │  ├ Typography Tab    ││
│  │  ├ ColorScanner      │   │  ├ Colors Tab        ││
│  │  ├ EffectScanner     │   │  ├ Effects Tab       ││
│  │  └ OverrideScanner   │   │  └ Overrides Tab     ││
│  │                      │   │                      ││
│  │  Applicator Engine   │   │  Results Panel       ││
│  │  ├ FontReplacer      │   │  ├ Grouped list      ││
│  │  ├ ColorReassigner   │   │  ├ Preview/select    ││
│  │  ├ EffectReassigner  │   │  ├ Progress bar      ││
│  │  └ OverrideResetter  │   │  └ Actions           ││
│  │                      │   │                      ││
│  │  Chunked Processor   │   │  Settings Panel      ││
│  │  (yield каждые N нод)│   │  ├ Scope selector    ││
│  │                      │   │  ├ Instance toggle   ││
│  │  Shared Modules (E1) │   │  └ Hidden toggle     ││
│  └─────────────────────┘   └──────────────────────┘│
└─────────────────────────────────────────────────────┘
```

### 3.2 Модульная структура файлов

```
plugins/design-lint/
├── src/
│   ├── code.ts                    ← Точка входа main thread
│   ├── ui.html                    ← UI с табами
│   ├── types.ts                   ← Типы сообщений и моделей данных
│   │
│   ├── engine/
│   │   ├── chunked-processor.ts   ← Механизм неблокирующего обхода
│   │   ├── node-filter.ts         ← Фильтрация: инстансы, скрытые, locked
│   │   ├── scope-resolver.ts      ← Определение scope: selection/page/document
│   │   │
│   │   ├── scanners/
│   │   │   ├── typography.ts      ← Сканер типографики
│   │   │   ├── colors.ts          ← Сканер цветов
│   │   │   ├── effects.ts         ← Сканер эффектов
│   │   │   └── overrides.ts       ← Сканер оверрайдов в инстансах
│   │   │
│   │   └── applicators/
│   │       ├── font-replacer.ts   ← Замена шрифтов
│   │       ├── color-reassign.ts  ← Переназначение цветов
│   │       ├── effect-reassign.ts ← Переназначение эффектов
│   │       └── override-reset.ts  ← Сброс оверрайдов
│   │
│   ├── shared/ → (симлинк или копия из E1 boilerplate)
│   └── ui/    → (симлинк или копия из E2 UI Kit)
│
├── manifest.json
├── package.json
├── tsconfig.json
└── esbuild.config.mjs
```

### 3.3 manifest.json

```json
{
  "name": "Design Lint",
  "id": "000000000000000000",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["none"]
  },
  "permissions": [],
  "menu": [
    { "name": "Typography", "command": "typography" },
    { "name": "Colors", "command": "colors" },
    { "name": "Effects", "command": "effects" },
    { "separator": true },
    { "name": "Override Detector", "command": "overrides" }
  ]
}
```

---

## 4. Ключевой механизм: Chunked Processor

### 4.1 Проблема блокировки

Figma плагины работают в **одном потоке** с UI Figma. Любая синхронная операция дольше ~50ms замораживает весь интерфейс. На файлах с 10–50k нод полный обход дерева занимает секунды-минуты.

Официальная рекомендация Figma: разбивать работу на чанки (chunks) через `setTimeout`, отдавая управление event loop между итерациями.

### 4.2 Реализация

```typescript
// engine/chunked-processor.ts

/** Размер чанка (chunk) — количество нод за одну итерацию */
const CHUNK_SIZE = 200;

/** Пауза между чанками (мс) — даёт Figma обработать события */
const YIELD_DELAY = 1; // setTimeout(resolve, 1)

interface ChunkProgress {
  processed: number;   // сколько нод обработано
  total: number;       // общее количество (оценка)
  phase: string;       // текущая фаза: "scanning" | "applying"
  partialResults?: any; // промежуточные результаты для отправки в UI
}

type ProgressCallback = (progress: ChunkProgress) => void;
type CancelToken = { cancelled: boolean };

/**
 * Отдаёт управление event loop Figma.
 * Позволяет пользователю взаимодействовать с канвасом
 * и плагину — обновлять прогресс-бар.
 */
function yieldToMain(): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, YIELD_DELAY));
}

/**
 * Обрабатывает массив нод чанками с поддержкой:
 * - прогресса (отправляется в UI)
 * - отмены (cancel token)
 * - промежуточных результатов (partial results)
 */
async function processInChunks<TNode, TResult>(
  nodes: TNode[],
  processor: (node: TNode) => TResult | null,
  onProgress: ProgressCallback,
  cancelToken: CancelToken
): Promise<TResult[]> {
  const results: TResult[] = [];
  const total = nodes.length;

  for (let i = 0; i < total; i += CHUNK_SIZE) {
    // Проверка отмены
    if (cancelToken.cancelled) {
      onProgress({ processed: i, total, phase: "cancelled" });
      break;
    }

    // Обработка чанка
    const chunk = nodes.slice(i, i + CHUNK_SIZE);
    for (const node of chunk) {
      const result = processor(node);
      if (result !== null) {
        results.push(result);
      }
    }

    // Отправка прогресса + промежуточных результатов
    onProgress({
      processed: Math.min(i + CHUNK_SIZE, total),
      total,
      phase: "scanning",
      partialResults: results.length > 0 ? [...results] : undefined,
    });

    // Отдаём управление Figma
    await yieldToMain();
  }

  return results;
}
```

### 4.3 Отправка промежуточных результатов в UI

Ключевой принцип: пользователь видит результаты **по мере появления**, а не ждёт окончания полного сканирования.

```typescript
// code.ts — в обработчике сообщения "start-scan"

let cancelToken: CancelToken = { cancelled: false };

async function runScan(mode: ScanMode, scopeNodes: SceneNode[]) {
  cancelToken = { cancelled: false };

  // Собираем все "листовые" ноды из дерева с учётом фильтров
  const flatNodes = collectNodes(scopeNodes, {
    skipInstances: settings.skipInstances,
    skipHidden: settings.skipHidden,
    includeHiddenSeparately: settings.showHiddenGroup,
  });

  // Уведомляем UI о начале и общем количестве
  sendToUI("scan-started", { total: flatNodes.main.length });

  // Обрабатываем чанками
  const results = await processInChunks(
    flatNodes.main,
    (node) => scanNode(node, mode),
    (progress) => {
      // Каждый чанк → обновление прогресс-бара + новые результаты
      sendToUI("scan-progress", progress);
    },
    cancelToken
  );

  // Если были скрытые ноды в отдельной группе — сканируем их тоже
  if (flatNodes.hidden.length > 0) {
    sendToUI("scan-phase", { phase: "hidden-layers" });
    const hiddenResults = await processInChunks(
      flatNodes.hidden,
      (node) => scanNode(node, mode),
      (progress) => sendToUI("scan-progress-hidden", progress),
      cancelToken
    );
    sendToUI("scan-hidden-complete", { results: hiddenResults });
  }

  // Финал
  sendToUI("scan-complete", {
    results: aggregateResults(results, mode),
    stats: { total: flatNodes.main.length, found: results.length },
  });
}
```

### 4.4 Отмена сканирования

Пользователь может нажать **Cancel** в любой момент:

```typescript
// code.ts
figma.ui.onmessage = async (msg) => {
  if (msg.type === "cancel-scan") {
    cancelToken.cancelled = true;
  }
};
```

```javascript
// ui.html — кнопка Cancel
cancelBtn.addEventListener("click", () => {
  sendToCode("cancel-scan", {});
  setUIState("idle"); // Разблокировать UI
});
```

---

## 5. Фильтрация нод

### 5.1 Определение "внутри инстанса"

Ключевой вопрос: как понять, что нода находится внутри Instance?

```typescript
// engine/node-filter.ts

/**
 * Проверяет, находится ли нода внутри InstanceNode.
 * Поднимается по дереву parent вверх до PageNode.
 * 
 * Возвращает:
 * - null — нода НЕ внутри инстанса
 * - InstanceNode — ближайший родительский инстанс
 */
function getParentInstance(node: SceneNode): InstanceNode | null {
  let current: BaseNode | null = node.parent;
  while (current && current.type !== "PAGE" && current.type !== "DOCUMENT") {
    if (current.type === "INSTANCE") {
      return current as InstanceNode;
    }
    current = current.parent;
  }
  return null;
}

/**
 * Проверяет, является ли нода самим инстансом верхнего уровня
 * (не вложенным инстансом внутри другого инстанса).
 */
function isTopLevelInstance(node: SceneNode): boolean {
  return node.type === "INSTANCE" && getParentInstance(node) === null;
}
```

### 5.2 Определение видимости

`node.visible === false` не означает, что нода действительно скрыта: родитель может быть скрыт. И наоборот — `node.visible === true` не гарантирует видимость, если родитель скрыт.

```typescript
/**
 * Проверяет, действительно ли нода видима.
 * Учитывает всю цепочку родителей.
 * 
 * Дополнительно проверяет:
 * - opacity === 0 (визуально скрыт, но visible === true)
 * - absoluteRenderBounds === null (не рендерится, например в Boolean Operation)
 */
function isNodeTrulyVisible(node: SceneNode): boolean {
  // Сама нода скрыта
  if (!node.visible) return false;
  
  // opacity 0 — визуально не видна (но формально visible)
  if ("opacity" in node && (node as any).opacity === 0) return false;

  // Нет рендер-баундов — нода не рендерится
  // (например, вырезанная часть Boolean Operation)
  if (node.absoluteRenderBounds === null) return false;

  // Проверяем всех родителей
  let current: BaseNode | null = node.parent;
  while (current && current.type !== "PAGE" && current.type !== "DOCUMENT") {
    if ("visible" in current && !(current as SceneNode).visible) return false;
    if ("opacity" in current && (current as any).opacity === 0) return false;
    current = current.parent;
  }

  return true;
}
```

### 5.3 Оптимизация: `skipInvisibleInstanceChildren`

Figma API имеет флаг `figma.skipInvisibleInstanceChildren`. При `true` — `findAll()` и `children` **не возвращают** скрытые ноды внутри инстансов. Это драматически ускоряет обход на больших файлах.

**Стратегия для Design Lint:**

```typescript
/**
 * СТРАТЕГИЯ ОБХОДА:
 * 
 * 1. По умолчанию: skipInvisibleInstanceChildren = true
 *    → быстрый обход, скрытые ноды в инстансах игнорируются
 *    → это нормально, т.к. инстансы мы и так пропускаем по умолчанию
 * 
 * 2. Если пользователь включил "Показать скрытые слои":
 *    → skipInvisibleInstanceChildren = false
 *    → ПРЕДУПРЕЖДЕНИЕ: "Сканирование скрытых слоёв может значительно 
 *      замедлить обработку на больших файлах"
 *    → Скрытые ноды собираются в ОТДЕЛЬНЫЙ массив
 * 
 * 3. Если пользователь включил "Включить инстансы":
 *    → skipInvisibleInstanceChildren = false
 *    → ПРЕДУПРЕЖДЕНИЕ аналогичное
 *    → Ноды внутри инстансов собираются в ОТДЕЛЬНЫЙ массив
 */
```

### 5.4 Сборка плоского списка нод

```typescript
// engine/node-filter.ts

interface CollectedNodes {
  /** Основной список нод для обработки */
  main: SceneNode[];
  /** Скрытые ноды (если toggle включён) — отображаются отдельной группой */
  hidden: SceneNode[];
  /** Ноды внутри инстансов (если toggle включён) — отображаются отдельной группой */
  insideInstances: SceneNode[];
}

interface FilterOptions {
  /** Пропускать ноды внутри InstanceNode (по умолчанию: true) */
  skipInstances: boolean;
  /** Пропускать скрытые ноды (по умолчанию: true) */
  skipHidden: boolean;
  /** Показывать скрытые в отдельной группе (по умолчанию: false) */
  showHiddenGroup: boolean;
  /** Показывать инстансы в отдельной группе (по умолчанию: false) */
  showInstanceGroup: boolean;
  /** Максимальная глубина обхода (0 = без ограничений) */
  maxDepth: number;
}

/**
 * Собирает все "листовые" ноды из дерева scope.
 * 
 * Работает через свой рекурсивный обход (НЕ через findAll),
 * чтобы контролировать фильтрацию на каждом уровне
 * и избежать проблемы с медленными скрытыми нодами.
 * 
 * Ключевая оптимизация: если skipInstances === true
 * и встречаем InstanceNode — прекращаем рекурсию в этот поддерево.
 * Это критически ускоряет обход на файлах с тысячами инстансов.
 */
function collectNodes(
  scopeNodes: SceneNode[],
  options: FilterOptions
): CollectedNodes {
  const result: CollectedNodes = {
    main: [],
    hidden: [],
    insideInstances: [],
  };

  // Управляем флагом Figma API для оптимизации
  figma.skipInvisibleInstanceChildren =
    options.skipHidden && options.skipInstances && !options.showHiddenGroup;

  function walk(node: SceneNode, depth: number, isInsideInstance: boolean) {
    // Ограничение глубины
    if (options.maxDepth > 0 && depth > options.maxDepth) return;

    const isInstance = node.type === "INSTANCE";
    const inInstance = isInsideInstance || isInstance;

    // --- Фильтр: видимость ---
    const visible = isNodeTrulyVisible(node);
    if (!visible) {
      if (options.showHiddenGroup) {
        // Скрытые — в отдельную группу
        result.hidden.push(node);
        // Не углубляемся в скрытые поддеревья — их содержимое
        // унаследует скрытость от родителя
      }
      if (options.skipHidden) return;
    }

    // --- Фильтр: инстансы ---
    if (isInstance && options.skipInstances) {
      if (options.showInstanceGroup) {
        // Инстансы — в отдельную группу (только сам Instance, не его дети)
        result.insideInstances.push(node);
      }
      return; // НЕ углубляемся внутрь инстанса
    }

    // --- Листовая нода: добавляем в результат ---
    if (isLeafNode(node)) {
      if (inInstance && !isInstance) {
        // Нода внутри инстанса (когда skipInstances = false)
        result.insideInstances.push(node);
      } else {
        result.main.push(node);
      }
    }

    // --- Рекурсия в дочерние ноды ---
    if ("children" in node) {
      for (const child of node.children) {
        walk(child as SceneNode, depth + 1, inInstance);
      }
    }
  }

  for (const root of scopeNodes) {
    walk(root, 0, false);
  }

  return result;
}

/**
 * Определяет, является ли нода "листовой" для целей сканирования.
 * 
 * Листовая = содержит реальные визуальные свойства
 * (fills, strokes, effects, text properties).
 * 
 * Контейнеры (Frame, Group) тоже могут иметь fills/strokes/effects,
 * поэтому они НЕ пропускаются, а проверяются наравне с листьями.
 */
function isLeafNode(node: SceneNode): boolean {
  // Все ноды с визуальными свойствами — "листья" для нас
  const visualTypes = [
    "RECTANGLE", "ELLIPSE", "POLYGON", "STAR", "VECTOR",
    "TEXT", "LINE", "FRAME", "COMPONENT", "COMPONENT_SET",
    "INSTANCE", "BOOLEAN_OPERATION", "GROUP",
  ];
  return visualTypes.includes(node.type);
}
```

---

## 6. Режим Typography

### 6.1 Модель данных сканирования

```typescript
// types.ts

/** Результат сканирования одного текстового слоя */
interface TypographyScanResult {
  nodeId: string;
  nodeName: string;
  nodePath: string;              // "Page 1 / Header / Title"
  
  // Шрифт
  fontFamily: string | "MIXED";  // figma.mixed → "MIXED"
  fontStyle: string | "MIXED";
  fontWeight: number | "MIXED";
  
  // Числовые параметры
  fontSize: number | "MIXED";
  lineHeight: LineHeight | "MIXED";  // { value: number, unit: "PIXELS" | "PERCENT" | "AUTO" }
  letterSpacing: LetterSpacing | "MIXED";
  paragraphSpacing: number;
  
  // Привязка к стилю
  textStyleId: string | "";       // пустая строка = нет привязки
  textStyleName: string | "";     // "Heading/H1" или ""
  
  // Привязка к переменным (bound variables)
  boundVariables: {
    fontSize?: string;     // ID переменной
    lineHeight?: string;
    letterSpacing?: string;
    fontFamily?: string;
    fontWeight?: string;
  };
  
  // Мета
  isInsideInstance: boolean;
  isHidden: boolean;
  characterCount: number;
}

/** Агрегированная группа шрифтов */
interface FontGroup {
  fontFamily: string;
  styles: {
    fontStyle: string;
    count: number;
    nodeIds: string[];
  }[];
  totalCount: number;
}

/** Агрегированная группа числовых параметров */
interface NumericParamGroup {
  param: "fontSize" | "lineHeight" | "letterSpacing" | "paragraphSpacing";
  values: {
    value: number | string;     // число или "AUTO" для lineHeight
    unit?: string;              // "PIXELS" | "PERCENT"
    count: number;
    nodeIds: string[];
    linkedToStyle: number;      // сколько из них привязаны к TextStyle
    linkedToVariable: number;   // сколько привязаны к Variable
    unlinked: number;           // без привязки
  }[];
}
```

### 6.2 Логика сканирования типографики

```typescript
// engine/scanners/typography.ts

async function scanTypography(node: SceneNode): Promise<TypographyScanResult | null> {
  if (node.type !== "TEXT") return null;

  const textNode = node as TextNode;
  
  // --- Обработка MIXED значений ---
  // TextNode может иметь разные шрифты в разных частях текста.
  // fontName, fontSize, lineHeight — могут быть figma.mixed
  
  const fontName = textNode.fontName;
  const fontSize = textNode.fontSize;
  const lineHeight = textNode.lineHeight;
  const letterSpacing = textNode.letterSpacing;
  
  // --- Привязка к TextStyle ---
  // textStyleId может быть figma.mixed (разные стили на подстроках)
  const styleId = textNode.textStyleId;
  let textStyleName = "";
  
  if (typeof styleId === "string" && styleId !== "") {
    // Получаем имя стиля через async API
    const style = await figma.getStyleByIdAsync(styleId);
    if (style) textStyleName = style.name;
  }
  
  // --- Привязки к переменным ---
  const boundVars: TypographyScanResult["boundVariables"] = {};
  const bv = textNode.boundVariables;
  if (bv) {
    if (bv.fontSize) boundVars.fontSize = bv.fontSize.id;
    if (bv.lineHeight) boundVars.lineHeight = bv.lineHeight.id;
    if (bv.letterSpacing) boundVars.letterSpacing = bv.letterSpacing.id;
    if (bv.fontFamily) boundVars.fontFamily = bv.fontFamily.id;
    if (bv.fontWeight) boundVars.fontWeight = bv.fontWeight.id;
  }

  return {
    nodeId: node.id,
    nodeName: node.name,
    nodePath: getNodePath(node),
    
    fontFamily: fontName === figma.mixed ? "MIXED" : fontName.family,
    fontStyle: fontName === figma.mixed ? "MIXED" : fontName.style,
    fontWeight: textNode.fontWeight === figma.mixed ? "MIXED" : textNode.fontWeight as number,
    
    fontSize: fontSize === figma.mixed ? "MIXED" : fontSize as number,
    lineHeight: lineHeight === figma.mixed ? "MIXED" : lineHeight as LineHeight,
    letterSpacing: letterSpacing === figma.mixed ? "MIXED" : letterSpacing as LetterSpacing,
    paragraphSpacing: textNode.paragraphSpacing,
    
    textStyleId: typeof styleId === "string" ? styleId : "",
    textStyleName,
    boundVariables: boundVars,
    
    isInsideInstance: getParentInstance(node) !== null,
    isHidden: !isNodeTrulyVisible(node),
    characterCount: textNode.characters.length,
  };
}
```

### 6.3 Агрегация результатов

```typescript
// engine/scanners/typography.ts

/** 
 * Агрегирует плоский список результатов сканирования
 * в группы для отображения в UI
 */
function aggregateTypography(results: TypographyScanResult[]) {
  // --- Группировка по шрифтам ---
  const fontMap = new Map<string, FontGroup>();
  
  for (const r of results) {
    if (r.fontFamily === "MIXED") continue; // MIXED обрабатываем отдельно
    
    if (!fontMap.has(r.fontFamily)) {
      fontMap.set(r.fontFamily, {
        fontFamily: r.fontFamily,
        styles: [],
        totalCount: 0,
      });
    }
    
    const group = fontMap.get(r.fontFamily)!;
    group.totalCount++;
    
    const styleKey = r.fontStyle as string;
    let styleEntry = group.styles.find(s => s.fontStyle === styleKey);
    if (!styleEntry) {
      styleEntry = { fontStyle: styleKey, count: 0, nodeIds: [] };
      group.styles.push(styleEntry);
    }
    styleEntry.count++;
    styleEntry.nodeIds.push(r.nodeId);
  }

  // --- Группировка по числовым параметрам ---
  const fontSizeGroups = groupNumericParam(results, "fontSize");
  const lineHeightGroups = groupNumericParam(results, "lineHeight");
  const letterSpacingGroups = groupNumericParam(results, "letterSpacing");

  // --- Список слоёв без привязки к TextStyle ---
  const unlinked = results.filter(r => r.textStyleId === "");
  
  // --- MIXED-слои (разные стили на подстроках) ---
  const mixed = results.filter(r => 
    r.fontFamily === "MIXED" || r.fontSize === "MIXED"
  );

  return {
    fonts: Array.from(fontMap.values()),
    fontSizes: fontSizeGroups,
    lineHeights: lineHeightGroups,
    letterSpacings: letterSpacingGroups,
    unlinkedCount: unlinked.length,
    unlinked,
    mixedCount: mixed.length,
    mixed,
    totalScanned: results.length,
  };
}
```

### 6.4 Замена шрифтов (Font Replacer)

```typescript
// engine/applicators/font-replacer.ts

interface FontReplaceMap {
  /** Маппинг: "Inter/Regular" → "Golos Text/Regular" */
  styleMap: Record<string, { family: string; style: string }>;
  /** Заменять ли в MIXED-нодах (подстроки) */
  handleMixed: boolean;
}

/**
 * Замена шрифтовой гарнитуры.
 * 
 * ВАЖНО: перед заменой шрифта нужно ЗАГРУЗИТЬ новый шрифт
 * через figma.loadFontAsync(). Иначе — runtime error.
 * 
 * Для MIXED-нод (разные шрифты на подстроках) — используем
 * getStyledTextSegments для определения сегментов и
 * setRangeFontName для замены в каждом сегменте.
 */
async function replaceFont(
  nodeIds: string[],
  replaceMap: FontReplaceMap,
  onProgress: ProgressCallback,
  cancelToken: CancelToken
): Promise<{ replaced: number; skipped: number; errors: string[] }> {
  let replaced = 0;
  let skipped = 0;
  const errors: string[] = [];

  // Предзагрузка всех целевых шрифтов
  const fontsToLoad = new Set<string>();
  for (const target of Object.values(replaceMap.styleMap)) {
    fontsToLoad.add(`${target.family}/${target.style}`);
  }
  
  for (const fontKey of fontsToLoad) {
    const [family, style] = fontKey.split("/");
    try {
      await figma.loadFontAsync({ family, style });
    } catch (e) {
      errors.push(`Не удалось загрузить шрифт: ${family} ${style}`);
      return { replaced, skipped, errors };
    }
  }

  // Обработка чанками
  for (let i = 0; i < nodeIds.length; i += CHUNK_SIZE) {
    if (cancelToken.cancelled) break;

    const chunk = nodeIds.slice(i, i + CHUNK_SIZE);

    for (const nodeId of chunk) {
      const node = await figma.getNodeByIdAsync(nodeId);
      if (!node || node.type !== "TEXT") {
        skipped++;
        continue;
      }

      const textNode = node as TextNode;

      try {
        if (textNode.fontName === figma.mixed) {
          // --- MIXED: замена по сегментам ---
          if (!replaceMap.handleMixed) {
            skipped++;
            continue;
          }
          
          const segments = textNode.getStyledTextSegments(["fontName"]);
          
          // Загрузка всех шрифтов сегментов (исходных и целевых)
          for (const seg of segments) {
            await figma.loadFontAsync(seg.fontName);
            const key = `${seg.fontName.family}/${seg.fontName.style}`;
            if (replaceMap.styleMap[key]) {
              const target = replaceMap.styleMap[key];
              await figma.loadFontAsync({ family: target.family, style: target.style });
            }
          }
          
          // Замена по каждому сегменту
          for (const seg of segments) {
            const key = `${seg.fontName.family}/${seg.fontName.style}`;
            if (replaceMap.styleMap[key]) {
              const target = replaceMap.styleMap[key];
              textNode.setRangeFontName(seg.start, seg.end, {
                family: target.family,
                style: target.style,
              });
            }
          }
          replaced++;
          
        } else {
          // --- Единый шрифт ---
          const currentFont = textNode.fontName as FontName;
          const key = `${currentFont.family}/${currentFont.style}`;
          
          if (replaceMap.styleMap[key]) {
            const target = replaceMap.styleMap[key];
            // Загружаем исходный шрифт (нужен для чтения свойств)
            await figma.loadFontAsync(currentFont);
            textNode.fontName = { family: target.family, style: target.style };
            replaced++;
          } else {
            skipped++;
          }
        }
      } catch (e) {
        errors.push(`Ошибка на ноде ${textNode.name}: ${e}`);
        skipped++;
      }
    }

    onProgress({
      processed: Math.min(i + CHUNK_SIZE, nodeIds.length),
      total: nodeIds.length,
      phase: "applying",
    });

    await yieldToMain();
  }

  return { replaced, skipped, errors };
}
```

### 6.5 Массовое переназначение числовых параметров

```typescript
// engine/applicators/font-replacer.ts

interface NumericReassignment {
  param: "fontSize" | "lineHeight" | "letterSpacing" | "paragraphSpacing";
  fromValue: number;           // текущее значение
  toValue: number;             // новое значение
  toUnit?: string;             // для lineHeight: "PIXELS" | "PERCENT" | "AUTO"
  nodeIds: string[];           // список нод для изменения
  assignTextStyle?: string;    // опционально: ID TextStyle для привязки
  assignVariable?: string;     // опционально: ID Variable для привязки
}

/**
 * Массово меняет числовой параметр типографики.
 * 
 * Может одновременно:
 * - Изменить значение (14px → 16px)
 * - Привязать к TextStyle
 * - Привязать к Variable
 */
async function reassignTypographyParam(
  assignment: NumericReassignment,
  onProgress: ProgressCallback,
  cancelToken: CancelToken
): Promise<{ changed: number; errors: string[] }> {
  let changed = 0;
  const errors: string[] = [];

  for (let i = 0; i < assignment.nodeIds.length; i += CHUNK_SIZE) {
    if (cancelToken.cancelled) break;

    const chunk = assignment.nodeIds.slice(i, i + CHUNK_SIZE);

    for (const nodeId of chunk) {
      const node = await figma.getNodeByIdAsync(nodeId);
      if (!node || node.type !== "TEXT") continue;

      const textNode = node as TextNode;

      try {
        // Загрузка шрифта (обязательно перед изменением свойств текста)
        await loadNodeFonts(textNode);

        switch (assignment.param) {
          case "fontSize":
            textNode.fontSize = assignment.toValue;
            break;
          case "lineHeight":
            if (assignment.toUnit === "AUTO") {
              textNode.lineHeight = { unit: "AUTO" };
            } else {
              textNode.lineHeight = {
                value: assignment.toValue,
                unit: (assignment.toUnit || "PIXELS") as "PIXELS" | "PERCENT",
              };
            }
            break;
          case "letterSpacing":
            textNode.letterSpacing = {
              value: assignment.toValue,
              unit: (assignment.toUnit || "PIXELS") as "PIXELS" | "PERCENT",
            };
            break;
          case "paragraphSpacing":
            textNode.paragraphSpacing = assignment.toValue;
            break;
        }

        // Привязка к TextStyle (если указан)
        if (assignment.assignTextStyle) {
          await textNode.setTextStyleIdAsync(assignment.assignTextStyle);
        }

        // Привязка к Variable (если указана)
        if (assignment.assignVariable) {
          const variable = await figma.variables.getVariableByIdAsync(
            assignment.assignVariable
          );
          if (variable) {
            textNode.setBoundVariable(assignment.param, variable);
          }
        }

        changed++;
      } catch (e) {
        errors.push(`${textNode.name}: ${e}`);
      }
    }

    onProgress({
      processed: Math.min(i + CHUNK_SIZE, assignment.nodeIds.length),
      total: assignment.nodeIds.length,
      phase: "applying",
    });

    await yieldToMain();
  }

  return { changed, errors };
}
```

---

## 7. Режим Colors

### 7.1 Модель данных

```typescript
// types.ts

interface ColorScanResult {
  nodeId: string;
  nodeName: string;
  nodePath: string;
  
  /** Тип свойства, в котором найден цвет */
  property: "fill" | "stroke";
  /** Индекс в массиве fills/strokes */
  propertyIndex: number;
  
  /** Тип Paint */
  paintType: "SOLID" | "GRADIENT_LINEAR" | "GRADIENT_RADIAL" | "GRADIENT_ANGULAR" | "GRADIENT_DIAMOND" | "IMAGE" | "VIDEO";
  
  /** HEX цвета (для SOLID) */
  hex: string;
  /** RGBA (для SOLID) */
  rgba: { r: number; g: number; b: number; a: number };
  /** Opacity самого paint (opacity fill/stroke, НЕ ноды) */
  paintOpacity: number;
  
  /** Привязка */
  binding: {
    type: "variable" | "style" | "none";
    id: string;              // ID Variable или Style
    name: string;            // "brand/primary" или "Colors/Primary"
    collectionName?: string; // для Variable — имя коллекции
  };
  
  isInsideInstance: boolean;
  isHidden: boolean;
}

/** Агрегированная группа цветов */
interface ColorGroup {
  hex: string;
  rgba: { r: number; g: number; b: number; a: number };
  count: number;
  nodeIds: string[];         // для массовой операции
  properties: { nodeId: string; property: "fill" | "stroke"; index: number }[];
  
  binding: {
    variable: number;        // сколько привязаны к Variable
    style: number;           // сколько привязаны к Style
    none: number;            // без привязки
  };
}
```

### 7.2 Логика сканирования цветов

```typescript
// engine/scanners/colors.ts

async function scanColors(node: SceneNode): Promise<ColorScanResult[]> {
  const results: ColorScanResult[] = [];
  
  // --- Fills ---
  if ("fills" in node && node.fills !== figma.mixed) {
    const fills = node.fills as ReadonlyArray<Paint>;
    for (let i = 0; i < fills.length; i++) {
      const paint = fills[i];
      if (!paint.visible) continue; // Пропускаем невидимые fills
      
      const result = await analyzePaint(node, paint, "fill", i);
      if (result) results.push(result);
    }
  }

  // --- Strokes ---
  if ("strokes" in node && node.strokes !== figma.mixed) {
    const strokes = node.strokes as ReadonlyArray<Paint>;
    for (let i = 0; i < strokes.length; i++) {
      const paint = strokes[i];
      if (!paint.visible) continue;
      
      const result = await analyzePaint(node, paint, "stroke", i);
      if (result) results.push(result);
    }
  }

  return results;
}

async function analyzePaint(
  node: SceneNode,
  paint: Paint,
  property: "fill" | "stroke",
  index: number
): Promise<ColorScanResult | null> {
  // Пропускаем IMAGE fills — это не цвета
  if (paint.type === "IMAGE" || paint.type === "VIDEO") return null;

  let hex = "";
  let rgba = { r: 0, g: 0, b: 0, a: 1 };

  if (paint.type === "SOLID") {
    const color = paint.color;
    rgba = { r: color.r, g: color.g, b: color.b, a: paint.opacity ?? 1 };
    hex = rgbToHex(color);
  }
  // Для градиентов — фиксируем как "GRADIENT" без конкретного HEX
  // (градиенты показываются отдельной группой)

  // --- Определяем привязку ---
  const binding = await detectColorBinding(node, property, index);

  return {
    nodeId: node.id,
    nodeName: node.name,
    nodePath: getNodePath(node),
    property,
    propertyIndex: index,
    paintType: paint.type,
    hex,
    rgba,
    paintOpacity: paint.opacity ?? 1,
    binding,
    isInsideInstance: getParentInstance(node) !== null,
    isHidden: !isNodeTrulyVisible(node),
  };
}

/**
 * Определяет, привязан ли цвет к Variable, Style или ни к чему.
 * 
 * Порядок проверки:
 * 1. boundVariables.fills[index] / boundVariables.strokes[index] — Variable
 * 2. fillStyleId / strokeStyleId — Color Style
 * 3. Иначе — "none"
 */
async function detectColorBinding(
  node: SceneNode,
  property: "fill" | "stroke",
  index: number
): Promise<ColorScanResult["binding"]> {
  const bv = (node as any).boundVariables;

  // 1. Проверяем Variable binding
  if (bv) {
    const boundArray = property === "fill" ? bv.fills : bv.strokes;
    if (boundArray && boundArray[index]) {
      const varAlias = boundArray[index];
      const variable = await figma.variables.getVariableByIdAsync(varAlias.id);
      if (variable) {
        const collection = await figma.variables.getVariableCollectionByIdAsync(
          variable.variableCollectionId
        );
        return {
          type: "variable",
          id: variable.id,
          name: variable.name,
          collectionName: collection?.name ?? "",
        };
      }
    }
  }

  // 2. Проверяем Style binding
  if (property === "fill" && "fillStyleId" in node) {
    const styleId = (node as any).fillStyleId;
    if (typeof styleId === "string" && styleId !== "") {
      const style = await figma.getStyleByIdAsync(styleId);
      return {
        type: "style",
        id: styleId,
        name: style?.name ?? "Unknown style",
      };
    }
  }
  if (property === "stroke" && "strokeStyleId" in node) {
    const styleId = (node as any).strokeStyleId;
    if (typeof styleId === "string" && styleId !== "") {
      const style = await figma.getStyleByIdAsync(styleId);
      return {
        type: "style",
        id: styleId,
        name: style?.name ?? "Unknown style",
      };
    }
  }

  // 3. Нет привязки
  return { type: "none", id: "", name: "" };
}
```

### 7.3 Переназначение цветов

```typescript
// engine/applicators/color-reassign.ts

interface ColorReassignment {
  /** Список целей: какие ноды, какие свойства */
  targets: { nodeId: string; property: "fill" | "stroke"; index: number }[];
  
  /** Что назначить */
  action:
    | { type: "set-variable"; variableId: string }
    | { type: "set-style"; styleId: string }
    | { type: "set-color"; rgba: { r: number; g: number; b: number; a: number } };
}

async function reassignColor(
  assignment: ColorReassignment,
  onProgress: ProgressCallback,
  cancelToken: CancelToken
): Promise<{ changed: number; errors: string[] }> {
  let changed = 0;
  const errors: string[] = [];

  for (let i = 0; i < assignment.targets.length; i += CHUNK_SIZE) {
    if (cancelToken.cancelled) break;

    const chunk = assignment.targets.slice(i, i + CHUNK_SIZE);

    for (const target of chunk) {
      const node = await figma.getNodeByIdAsync(target.nodeId);
      if (!node) continue;

      try {
        if (assignment.action.type === "set-variable") {
          // Привязка к Variable через setBoundVariableForPaint
          const variable = await figma.variables.getVariableByIdAsync(
            assignment.action.variableId
          );
          if (!variable) throw new Error("Variable not found");

          if (target.property === "fill") {
            const fills = [...(node as any).fills] as Paint[];
            fills[target.index] = figma.variables.setBoundVariableForPaint(
              fills[target.index], "color", variable
            );
            (node as any).fills = fills;
          } else {
            const strokes = [...(node as any).strokes] as Paint[];
            strokes[target.index] = figma.variables.setBoundVariableForPaint(
              strokes[target.index], "color", variable
            );
            (node as any).strokes = strokes;
          }
          
        } else if (assignment.action.type === "set-style") {
          // Привязка к Color Style
          if (target.property === "fill") {
            await (node as any).setFillStyleIdAsync(assignment.action.styleId);
          } else {
            await (node as any).setStrokeStyleIdAsync(assignment.action.styleId);
          }
          
        } else if (assignment.action.type === "set-color") {
          // Прямая замена цвета (без привязки)
          const { r, g, b, a } = assignment.action.rgba;
          if (target.property === "fill") {
            const fills = [...(node as any).fills] as Paint[];
            fills[target.index] = {
              ...fills[target.index],
              type: "SOLID",
              color: { r, g, b },
              opacity: a,
            } as SolidPaint;
            (node as any).fills = fills;
          } else {
            const strokes = [...(node as any).strokes] as Paint[];
            strokes[target.index] = {
              ...strokes[target.index],
              type: "SOLID",
              color: { r, g, b },
              opacity: a,
            } as SolidPaint;
            (node as any).strokes = strokes;
          }
        }

        changed++;
      } catch (e) {
        errors.push(`${(node as any).name}: ${e}`);
      }
    }

    onProgress({
      processed: Math.min(i + CHUNK_SIZE, assignment.targets.length),
      total: assignment.targets.length,
      phase: "applying",
    });

    await yieldToMain();
  }

  return { changed, errors };
}
```

---

## 8. Режим Effects

### 8.1 Модель данных

```typescript
// types.ts

interface EffectScanResult {
  nodeId: string;
  nodeName: string;
  nodePath: string;
  
  /** Индекс эффекта в массиве effects */
  effectIndex: number;
  
  /** Тип эффекта */
  effectType: "DROP_SHADOW" | "INNER_SHADOW" | "LAYER_BLUR" | "BACKGROUND_BLUR";
  
  /** Параметры (для сравнения и группировки) */
  params: {
    color?: { r: number; g: number; b: number; a: number };
    offset?: { x: number; y: number };
    radius: number;
    spread?: number;
    blendMode?: string;
  };
  
  /** Сигнатура для группировки одинаковых эффектов */
  signature: string; // "DROP_SHADOW|0,4|8|0|rgba(0,0,0,0.12)"
  
  /** Привязка к EffectStyle */
  binding: {
    type: "style" | "none";
    id: string;
    name: string;
  };
  
  isInsideInstance: boolean;
  isHidden: boolean;
}
```

### 8.2 Логика сканирования и группировки

```typescript
// engine/scanners/effects.ts

async function scanEffects(node: SceneNode): Promise<EffectScanResult[]> {
  if (!("effects" in node)) return [];
  
  const effects = (node as any).effects as ReadonlyArray<Effect>;
  if (!effects || effects.length === 0) return [];
  
  const results: EffectScanResult[] = [];

  // Привязка к EffectStyle
  const effectStyleId = (node as any).effectStyleId;
  let effectStyleName = "";
  if (typeof effectStyleId === "string" && effectStyleId !== "") {
    const style = await figma.getStyleByIdAsync(effectStyleId);
    effectStyleName = style?.name ?? "";
  }

  for (let i = 0; i < effects.length; i++) {
    const effect = effects[i];
    if (!effect.visible) continue;

    const params: EffectScanResult["params"] = {
      radius: effect.radius,
    };

    if (effect.type === "DROP_SHADOW" || effect.type === "INNER_SHADOW") {
      params.color = effect.color;
      params.offset = effect.offset;
      params.spread = effect.spread;
      params.blendMode = effect.blendMode;
    }

    // Сигнатура — для группировки идентичных эффектов
    const sig = buildEffectSignature(effect);

    results.push({
      nodeId: node.id,
      nodeName: node.name,
      nodePath: getNodePath(node),
      effectIndex: i,
      effectType: effect.type,
      params,
      signature: sig,
      binding: {
        type: effectStyleId ? "style" : "none",
        id: effectStyleId || "",
        name: effectStyleName,
      },
      isInsideInstance: getParentInstance(node) !== null,
      isHidden: !isNodeTrulyVisible(node),
    });
  }

  return results;
}

function buildEffectSignature(effect: Effect): string {
  if (effect.type === "DROP_SHADOW" || effect.type === "INNER_SHADOW") {
    const c = effect.color;
    return `${effect.type}|${effect.offset.x},${effect.offset.y}|${effect.radius}|${effect.spread}|rgba(${Math.round(c.r*255)},${Math.round(c.g*255)},${Math.round(c.b*255)},${c.a.toFixed(2)})`;
  }
  return `${effect.type}|${effect.radius}`;
}
```

### 8.3 Переназначение эффектов

Аналогично цветам: пользователь выбирает группу одинаковых эффектов → назначает EffectStyle → массовое применение чанками.

```typescript
// engine/applicators/effect-reassign.ts

interface EffectReassignment {
  nodeIds: string[];
  action:
    | { type: "set-style"; styleId: string }
    | { type: "remove-effect"; effectIndex: number }
    | { type: "replace-effect"; effect: Effect };
}

async function reassignEffect(
  assignment: EffectReassignment,
  onProgress: ProgressCallback,
  cancelToken: CancelToken
): Promise<{ changed: number; errors: string[] }> {
  let changed = 0;
  const errors: string[] = [];

  for (let i = 0; i < assignment.nodeIds.length; i += CHUNK_SIZE) {
    if (cancelToken.cancelled) break;

    const chunk = assignment.nodeIds.slice(i, i + CHUNK_SIZE);

    for (const nodeId of chunk) {
      const node = await figma.getNodeByIdAsync(nodeId);
      if (!node || !("effects" in node)) continue;

      try {
        if (assignment.action.type === "set-style") {
          await (node as any).setEffectStyleIdAsync(assignment.action.styleId);
        } else if (assignment.action.type === "replace-effect") {
          const effects = [...(node as any).effects];
          // Заменяем все эффекты указанного типа
          (node as any).effects = [assignment.action.effect];
        }
        changed++;
      } catch (e) {
        errors.push(`${(node as any).name}: ${e}`);
      }
    }

    onProgress({
      processed: Math.min(i + CHUNK_SIZE, assignment.nodeIds.length),
      total: assignment.nodeIds.length,
      phase: "applying",
    });

    await yieldToMain();
  }

  return { changed, errors };
}
```

---

## 9. Режим Overrides (Override Detector)

### 9.1 Концепция

Режим Overrides — это уникальная функция, не имеющая аналогов в конкурентах. Он опирается на методологию, при которой:

- **Инстансы** должны менять только **контент** (текст, изображения)
- **Стили** (цвет, типографика, эффекты) всегда должны быть привязаны к **мастер-компоненту**
- Любой стилевой оверрайд в инстансе — это **дефект**, подлежащий сбросу

### 9.2 API для обнаружения оверрайдов

Figma API предоставляет `InstanceNode.overrides` — массив всех прямых оверрайдов на инстансе.

```typescript
// Структура overrides (из Figma API):
// instance.overrides возвращает OverrideInfo[]
// 
// interface OverrideInfo {
//   id: string;             — ID ноды с оверрайдом (внутри инстанса)
//   overriddenFields: string[];  — список полей с оверрайдами
// }
//
// Примеры overriddenFields:
// ["fills"]                  — изменён цвет заливки
// ["strokes"]                — изменена обводка
// ["effects"]                — изменены эффекты
// ["textStyleId"]            — отвязан TextStyle
// ["fillStyleId"]            — отвязан FillStyle
// ["characters"]             — изменён текст (контент!)
// ["fontName", "fontSize"]   — изменены параметры шрифта
```

### 9.3 Классификация оверрайдов

```typescript
// engine/scanners/overrides.ts

/** Категория оверрайда */
type OverrideCategory =
  | "color"           // fills, strokes, fillStyleId, strokeStyleId
  | "typography"      // fontName, fontSize, lineHeight, letterSpacing, textStyleId
  | "effect"          // effects, effectStyleId
  | "content-text"    // characters (текст — это контент, НЕ стиль)
  | "content-image"   // fills с type IMAGE (изображения — контент)
  | "layout"          // width, height, padding, itemSpacing (размеры, спейсинг)
  | "other";          // всё остальное

/** Результат анализа одного инстанса */
interface OverrideScanResult {
  /** ID самого инстанса */
  instanceId: string;
  instanceName: string;
  instancePath: string;
  
  /** Имя мастер-компонента */
  masterComponentName: string;
  masterComponentId: string;
  
  /** Оверрайды, классифицированные по категориям */
  overrides: {
    category: OverrideCategory;
    /** ID ноды внутри инстанса, на которой оверрайд */
    sublayerNodeId: string;
    sublayerName: string;
    /** Какие поля переопределены */
    fields: string[];
    /** Можно ли безопасно сбросить (контент — нельзя без подтверждения) */
    safeToReset: boolean;
  }[];
}

// --- Классификация полей ---
const STYLE_OVERRIDE_FIELDS: Record<string, OverrideCategory> = {
  // Цвета
  fills: "color",
  strokes: "color",
  fillStyleId: "color",
  strokeStyleId: "color",
  
  // Типографика
  fontName: "typography",
  fontSize: "typography",
  fontWeight: "typography",
  lineHeight: "typography",
  letterSpacing: "typography",
  paragraphSpacing: "typography",
  textStyleId: "typography",
  
  // Эффекты
  effects: "effect",
  effectStyleId: "effect",
  
  // Контент (текст)
  characters: "content-text",
  
  // Layout
  width: "layout",
  height: "layout",
  paddingTop: "layout",
  paddingRight: "layout",
  paddingBottom: "layout",
  paddingLeft: "layout",
  itemSpacing: "layout",
};

/** 
 * Определяет, является ли оверрайд fills изменением изображения (контент)
 * или изменением цвета (стиль).
 * 
 * Правило: если fill.type === "IMAGE" → это контент (image override).
 * Если fill.type === "SOLID" → это стилевой оверрайд.
 */
async function classifyFillOverride(
  sublayerNode: SceneNode
): Promise<OverrideCategory> {
  if ("fills" in sublayerNode && sublayerNode.fills !== figma.mixed) {
    const fills = sublayerNode.fills as ReadonlyArray<Paint>;
    // Если хотя бы один fill — IMAGE, считаем контентным
    for (const fill of fills) {
      if (fill.type === "IMAGE") return "content-image";
    }
  }
  return "color";
}
```

### 9.4 Сканирование оверрайдов

```typescript
// engine/scanners/overrides.ts

async function scanOverrides(node: SceneNode): Promise<OverrideScanResult | null> {
  if (node.type !== "INSTANCE") return null;

  const instance = node as InstanceNode;
  
  // Получаем список оверрайдов
  const rawOverrides = instance.overrides;
  if (!rawOverrides || rawOverrides.length === 0) return null;

  // Получаем мастер-компонент
  const mainComponent = await instance.getMainComponentAsync();
  if (!mainComponent) return null;

  const overrides: OverrideScanResult["overrides"] = [];

  for (const override of rawOverrides) {
    // Получаем ноду внутри инстанса по ID
    const sublayer = await figma.getNodeByIdAsync(override.id);
    if (!sublayer) continue;

    for (const field of override.overriddenFields) {
      let category: OverrideCategory = STYLE_OVERRIDE_FIELDS[field] || "other";

      // Специальная обработка fills: цвет vs изображение
      if (field === "fills" && sublayer.type !== "TEXT") {
        category = await classifyFillOverride(sublayer as SceneNode);
      }

      // Определяем безопасность сброса
      const safeToReset = 
        category === "color" || 
        category === "typography" || 
        category === "effect";
      // content-text, content-image, layout — НЕ безопасны для автосброса

      overrides.push({
        category,
        sublayerNodeId: override.id,
        sublayerName: sublayer.name,
        fields: [field],
        safeToReset,
      });
    }
  }

  // Если нет стилевых оверрайдов — нет смысла показывать
  const hasStyleOverrides = overrides.some(o => 
    o.category === "color" || 
    o.category === "typography" || 
    o.category === "effect"
  );
  if (!hasStyleOverrides) return null;

  return {
    instanceId: instance.id,
    instanceName: instance.name,
    instancePath: getNodePath(instance),
    masterComponentName: mainComponent.name,
    masterComponentId: mainComponent.id,
    overrides,
  };
}
```

### 9.5 Сброс оверрайдов

```typescript
// engine/applicators/override-reset.ts

interface OverrideResetRequest {
  instanceId: string;
  /** Какие категории сбрасывать */
  categories: OverrideCategory[];
  /** Конкретные sublayer IDs (если пользователь выбрал вручную) */
  specificSublayers?: string[];
}

/**
 * Сбрасывает стилевые оверрайды в инстансе.
 * 
 * ВАЖНО: НЕ трогаем:
 * - content-text (characters) — текст это контент
 * - content-image (IMAGE fills) — изображения это контент
 * - layout — если пользователь явно не попросил
 * 
 * Для content-image — показываем в UI как отдельную группу
 * с кнопкой "Сбросить" на каждом элементе (требует подтверждения).
 */
async function resetOverrides(
  requests: OverrideResetRequest[],
  onProgress: ProgressCallback,
  cancelToken: CancelToken
): Promise<{ reset: number; errors: string[] }> {
  let resetCount = 0;
  const errors: string[] = [];

  for (let i = 0; i < requests.length; i++) {
    if (cancelToken.cancelled) break;

    const req = requests[i];
    const node = await figma.getNodeByIdAsync(req.instanceId);
    
    if (!node || node.type !== "INSTANCE") {
      errors.push(`Node ${req.instanceId} not found or not instance`);
      continue;
    }

    const instance = node as InstanceNode;

    try {
      // Если сбрасываем ВСЕ стилевые категории и нет специфичных sublayers
      if (
        !req.specificSublayers &&
        req.categories.includes("color") &&
        req.categories.includes("typography") &&
        req.categories.includes("effect")
      ) {
        // Используем встроенный resetOverrides()
        // НО он сбрасывает ВСЕ, включая контент!
        // Поэтому нам нужен ручной подход:
        
        const overrides = instance.overrides;
        if (overrides) {
          for (const override of overrides) {
            const sublayer = await figma.getNodeByIdAsync(override.id);
            if (!sublayer) continue;
            
            for (const field of override.overriddenFields) {
              const cat = STYLE_OVERRIDE_FIELDS[field] || "other";
              
              // Сбрасываем только если категория входит в запрос
              if (req.categories.includes(cat)) {
                // К сожалению, Figma API не позволяет сбросить
                // конкретное поле оверрайда.
                // instance.resetOverrides() сбрасывает ВСЁ.
                // Поэтому используем обходной путь:
                // копируем значение из мастер-компонента.
                
                await copyPropertyFromMaster(instance, override.id, field);
              }
            }
          }
        }
        
      } else if (req.specificSublayers) {
        // Сброс конкретных sublayer'ов
        for (const sublayerId of req.specificSublayers) {
          const overrides = instance.overrides;
          const override = overrides?.find(o => o.id === sublayerId);
          if (!override) continue;
          
          for (const field of override.overriddenFields) {
            const cat = STYLE_OVERRIDE_FIELDS[field] || "other";
            if (req.categories.includes(cat)) {
              await copyPropertyFromMaster(instance, sublayerId, field);
            }
          }
        }
      }

      resetCount++;
    } catch (e) {
      errors.push(`${instance.name}: ${e}`);
    }

    onProgress({
      processed: i + 1,
      total: requests.length,
      phase: "applying",
    });

    // yield каждые N инстансов
    if (i % 10 === 0) await yieldToMain();
  }

  return { reset: resetCount, errors };
}

/**
 * Копирует значение свойства из мастер-компонента в sublayer инстанса.
 * 
 * Это обходной путь, т.к. Figma API не предоставляет метод
 * для сброса конкретного оверрайда (только resetOverrides() для всех).
 */
async function copyPropertyFromMaster(
  instance: InstanceNode,
  sublayerIdInInstance: string,
  field: string
): Promise<void> {
  const mainComponent = await instance.getMainComponentAsync();
  if (!mainComponent) return;

  // Находим соответствующий sublayer в мастер-компоненте.
  // Sublayer ID в инстансе отличается от ID в компоненте,
  // но имя ноды и позиция в дереве совпадают.
  // Используем overrides API — он даёт id ноды в инстансе.
  
  const sublayerInInstance = await figma.getNodeByIdAsync(sublayerIdInInstance);
  if (!sublayerInInstance) return;

  // Находим "зеркало" в мастер-компоненте по имени и пути
  const pathInInstance = getRelativePath(sublayerInInstance, instance);
  const mirrorInMaster = findNodeByRelativePath(mainComponent, pathInInstance);
  if (!mirrorInMaster) return;

  // Копируем значение свойства
  switch (field) {
    case "fills":
      if ("fills" in mirrorInMaster && "fills" in sublayerInInstance) {
        (sublayerInInstance as any).fills = (mirrorInMaster as any).fills;
      }
      break;
    case "strokes":
      if ("strokes" in mirrorInMaster && "strokes" in sublayerInInstance) {
        (sublayerInInstance as any).strokes = (mirrorInMaster as any).strokes;
      }
      break;
    case "effects":
      if ("effects" in mirrorInMaster && "effects" in sublayerInInstance) {
        (sublayerInInstance as any).effects = (mirrorInMaster as any).effects;
      }
      break;
    case "fillStyleId":
      if ("fillStyleId" in mirrorInMaster) {
        await (sublayerInInstance as any).setFillStyleIdAsync(
          (mirrorInMaster as any).fillStyleId
        );
      }
      break;
    case "strokeStyleId":
      if ("strokeStyleId" in mirrorInMaster) {
        await (sublayerInInstance as any).setStrokeStyleIdAsync(
          (mirrorInMaster as any).strokeStyleId
        );
      }
      break;
    case "effectStyleId":
      if ("effectStyleId" in mirrorInMaster) {
        await (sublayerInInstance as any).setEffectStyleIdAsync(
          (mirrorInMaster as any).effectStyleId
        );
      }
      break;
    case "textStyleId":
      if ("textStyleId" in mirrorInMaster) {
        await (sublayerInInstance as any).setTextStyleIdAsync(
          (mirrorInMaster as any).textStyleId
        );
      }
      break;
    case "fontName":
    case "fontSize":
    case "lineHeight":
    case "letterSpacing":
      // Для текстовых свойств нужно загрузить шрифт
      if (sublayerInInstance.type === "TEXT" && mirrorInMaster.type === "TEXT") {
        await loadNodeFonts(mirrorInMaster as TextNode);
        await loadNodeFonts(sublayerInInstance as TextNode);
        (sublayerInInstance as any)[field] = (mirrorInMaster as any)[field];
      }
      break;
  }
}
```

---

## 10. Интерфейс пользователя (UI)

### 10.1 Layout

```
┌─────────────────────────────────────────┐
│  Design Lint                        [×] │
├─────────────────────────────────────────┤
│  [Typography] [Colors] [Effects] [↻ OV] │  ← Табы режимов
├─────────────────────────────────────────┤
│  Scope: [● Selection] [○ Page] [○ Doc] │
│  ☑ Пропускать инстансы                  │
│  ☐ Показывать скрытые слои              │
│                                         │
│  [▶ Сканировать]        [✕ Отменить]    │
├─────────────────────────────────────────┤
│  ░░░░░░░░░░░████████ 1,247 / 3,500     │  ← Прогресс (при сканировании)
├─────────────────────────────────────────┤
│                                         │
│  ┌ Шрифты ─────────────────────────┐    │
│  │ Inter                  847 слоёв│    │
│  │  ├ Regular       612    [Replace]│   │
│  │  ├ Medium        148    [Replace]│   │
│  │  └ Bold           87    [Replace]│   │
│  │ Roboto                   23 слоя│    │
│  │  └ Regular        23    [Replace]│   │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌ Размер шрифта ──────────────────┐    │
│  │ 12px  14 слоёв  ☐ [Reassign ▾] │    │
│  │ 14px 187 слоёв  ☐ [Reassign ▾] │    │
│  │ 15px   3 слоя   ☐ [Reassign ▾] │    │ ← Подозрительные
│  │ 16px 402 слоя   ☐              │    │    выделяются цветом
│  │ 18px  89 слоёв  ☐ [Reassign ▾] │    │
│  │ 24px  45 слоёв  ☐              │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌ Без привязки к TextStyle ───────┐    │
│  │ 156 слоёв без стиля    [Select] │    │
│  └─────────────────────────────────┘    │
│                                         │
├─────────────────────────────────────────┤
│  Просканировано: 870 слоёв              │
│  Время: 2.3 сек                         │
└─────────────────────────────────────────┘
```

### 10.2 Принципы UI

**Прогрессивная загрузка.** Результаты появляются по мере сканирования. Группы "Шрифты" и "Размер шрифта" наполняются в реальном времени — пользователь видит промежуточный результат.

**Навигация.** Клик по группе → выделяет все ноды на канвасе (focusNodes). Клик по конкретному элементу → выделяет и центрирует на нём (focusNode).

**Actions.** Каждая группа имеет контекстное действие: Replace (замена шрифта), Reassign (переназначить значение / привязать к стилю/переменной), Select (выделить на канвасе).

**Сканирование по кнопке.** Плагин НЕ сканирует автоматически при открытии, смене фокуса или смене вкладки. Только по явному нажатию кнопки **Scan**.

**Фиксированное окно.** Размер окна: 420×600px. Внутренний скролл для результатов.

### 10.3 Состояния UI

| Состояние | Что видит пользователь |
|-----------|----------------------|
| **idle** | Scope selector, toggles, кнопка "Scan". Нет результатов |
| **scanning** | Прогресс-бар, кнопка "Cancel", частичные результаты наполняются |
| **results** | Полные результаты, сгруппированные секции, action-кнопки |
| **applying** | Прогресс-бар операции (замена/переназначение), кнопка "Cancel" |
| **done** | Итог: "Заменено N слоёв, пропущено M, ошибок K" + кнопка "Re-scan" |
| **error** | Сообщение об ошибке + кнопка "Retry" |

---

## 11. Типы сообщений (postMessage)

```typescript
// types.ts

/** Сообщения из UI → Main Thread */
interface UIMessages {
  // Сканирование
  "start-scan": { mode: ScanMode; scope: ScanScope; options: FilterOptions };
  "cancel-scan": {};
  
  // Навигация
  "focus-nodes": { nodeIds: string[] };
  "focus-node": { nodeId: string };
  
  // Действия — Typography
  "replace-font": { 
    fromFamily: string;
    styleMap: Record<string, { family: string; style: string }>;
    handleMixed: boolean;
    nodeIds: string[];
  };
  "reassign-param": NumericReassignment;
  
  // Действия — Colors
  "reassign-color": ColorReassignment;
  
  // Действия — Effects
  "reassign-effect": EffectReassignment;
  
  // Действия — Overrides
  "reset-overrides": OverrideResetRequest[];
  
  // Общие
  "save-settings": PluginSettings;
  "close": {};
}

/** Сообщения из Main Thread → UI */
interface CodeMessages {
  // Инициализация
  "init": { settings: PluginSettings; mode: ScanMode };
  
  // Прогресс сканирования
  "scan-started": { total: number };
  "scan-progress": ChunkProgress;
  "scan-phase": { phase: string };
  "scan-complete": { results: any; stats: ScanStats };
  
  // Прогресс скрытых слоёв
  "scan-progress-hidden": ChunkProgress;
  "scan-hidden-complete": { results: any };
  
  // Прогресс применения
  "apply-progress": ChunkProgress;
  "apply-complete": { changed: number; skipped: number; errors: string[] };
  
  // Навигация
  "selection-update": NodeInfo[];
  
  // Данные для пикеров
  "available-text-styles": { id: string; name: string }[];
  "available-color-variables": { id: string; name: string; collection: string }[];
  "available-color-styles": { id: string; name: string }[];
  "available-effect-styles": { id: string; name: string }[];
  "available-fonts": { family: string; styles: string[] }[];
}

type ScanMode = "typography" | "colors" | "effects" | "overrides";
type ScanScope = "selection" | "page" | "document";

interface PluginSettings {
  skipInstances: boolean;
  skipHidden: boolean;
  showHiddenGroup: boolean;
  showInstanceGroup: boolean;
  lastMode: ScanMode;
  lastScope: ScanScope;
}

interface ScanStats {
  totalScanned: number;
  totalFound: number;
  timeMs: number;
  hiddenCount: number;
  instanceCount: number;
}
```

---

## 12. Оценка трудозатрат

| Этап | Компоненты | Часы |
|------|-----------|------|
| **Архитектура и типы** | types.ts, структура проекта, manifest | 2 |
| **Chunked Processor** | chunked-processor.ts, node-filter.ts, scope-resolver.ts | 4 |
| **Typography Scanner** | Сканер, агрегация, MIXED-обработка | 5 |
| **Font Replacer** | Замена шрифтов, маппинг стилей, MIXED-сегменты | 5 |
| **Numeric Reassigner** | Переназначение кегля/интерлиньяжа + привязка к Style/Variable | 3 |
| **Color Scanner** | Сканер fills/strokes, определение binding | 4 |
| **Color Reassigner** | Назначение Variable/Style/прямой цвет | 3 |
| **Effect Scanner** | Сканер эффектов, сигнатуры, группировка | 3 |
| **Effect Reassigner** | Назначение EffectStyle | 2 |
| **Override Scanner** | Классификация оверрайдов, IMAGE vs SOLID detection | 5 |
| **Override Resetter** | Сброс через копирование из мастера | 5 |
| **UI: табы и layout** | HTML/CSS, 4 вкладки, scope selector, toggles | 4 |
| **UI: результаты** | Группированные списки, прогресс-бар, real-time обновление | 5 |
| **UI: пикеры и модалы** | Font picker, Variable picker, Style picker, подтверждение | 4 |
| **Интеграция и тесты** | Связка scanner → UI → applicator, тесты на больших файлах | 6 |
| **Итого** | | **~55–65 ч** |

---

## 13. Риски и ограничения

### 13.1 Технические риски

| Риск | Вероятность | Митигация |
|------|-------------|-----------|
| **Сброс оверрайдов ломает другие свойства** | Средняя | Figma API `resetOverrides()` сбрасывает ВСЁ. Обходим через копирование из мастера. Необходимо тщательное тестирование |
| **Скрытые ноды в инстансах замедляют обход** | Высокая | `skipInvisibleInstanceChildren = true` по умолчанию. Предупреждение при включении |
| **MIXED-значения в текстовых нодах** | Средняя | Специальная обработка через `getStyledTextSegments`. Показываем как отдельную группу |
| **Поиск "зеркала" sublayer в мастер-компоненте** | Средняя | Поиск по относительному пути (имя + позиция). Может сломаться если структура компонента изменена |
| **Большие файлы (50k+ нод)** | Средняя | Chunk processing, scope по умолчанию Selection, предупреждение для Document scope |
| **Ноды без родителя (detached, removed)** | Низкая | Проверка `node !== null` после каждого `getNodeByIdAsync` |

### 13.2 Ограничения первой версии (v1.0)

Чего **не будет** в первой версии:

- **Градиенты** — показываются как группа, но массовая замена не поддерживается
- **Auto Layout параметры** — spacing, padding не сканируются в режиме Colors/Typography (это отдельная задача)
- **Библиотечные стили** — только локальные стили и переменные (библиотечные требуют teamLibrary permission)
- **Undo** — нет встроенного undo; полагаемся на Ctrl+Z в Figma (работает для всех изменений через Plugin API)
- **Multi-page** — сканирование Document scope загружает все страницы последовательно; может быть медленным

### 13.3 Возможные расширения (v2.0+)

- **Auto Layout audit** — сканирование spacing, padding, gap
- **Accessibility audit** — контраст, минимальный кегль, touch targets
- **Team Library** — работа с библиотечными стилями и переменными
- **AI режим** — умный матчинг "этот цвет похож на brand/primary, привязать?" (интеграция с A3 плагинами)
- **Export report** — JSON/CSV/Markdown отчёт о состоянии файла
- **Сравнение** — diff двух сканирований ("было → стало")

---

## 14. Чеклист перед реализацией

### Подготовка
- [ ] E1 Boilerplate собран и протестирован
- [ ] E2 UI Kit содержит компоненты: tabs, progress bar, grouped list, badge, toggle
- [ ] Создан проект через `create-plugin.sh design-lint "Design Lint" "Модульный аудит стилей"`

### Фаза 1 — Skeleton (8 ч)
- [ ] Chunked Processor работает (тест на 5000 нод < 5 сек)
- [ ] Node Filter: инстансы, скрытые, scope — всё фильтруется корректно
- [ ] UI: 4 таба переключаются, scope selector, toggles работают
- [ ] Прогресс-бар обновляется при сканировании, Cancel останавливает
- [ ] Промежуточные результаты появляются по мере сканирования

### Фаза 2 — Typography (13 ч)
- [ ] Typography Scanner собирает все параметры текстовых нод
- [ ] Агрегация по шрифтам и числовым параметрам
- [ ] Font Replacer: замена гарнитуры с маппингом стилей
- [ ] Font Replacer: корректная обработка MIXED-нод
- [ ] Numeric Reassigner: изменение кегля/интерлиньяжа
- [ ] Привязка к TextStyle и Variable при переназначении

### Фаза 3 — Colors (7 ч)
- [ ] Color Scanner: fills и strokes, определение binding
- [ ] Агрегация по HEX с подсчётом привязанных/непривязанных
- [ ] Color Reassigner: привязка к Variable, Style, прямой цвет
- [ ] IMAGE fills корректно пропускаются (не считаются цветами)

### Фаза 4 — Effects (5 ч)
- [ ] Effect Scanner: тени и блюры, сигнатуры для группировки
- [ ] Агрегация по типам эффектов
- [ ] Effect Reassigner: привязка к EffectStyle

### Фаза 5 — Overrides (10 ч)
- [ ] Override Scanner: классификация по категориям
- [ ] Корректное определение IMAGE vs SOLID в fills
- [ ] Сброс стилевых оверрайдов через копирование из мастера
- [ ] Изображения в отдельной группе с подтверждением
- [ ] Текстовый контент НЕ сбрасывается

### Фаза 6 — Polish (8 ч)
- [ ] Все пикеры работают (Font, Variable, Style)
- [ ] Тёмная тема корректна
- [ ] Тестирование на файле 10k+ нод
- [ ] Тестирование на файле с 50+ компонентами и инстансами
- [ ] ESC закрывает плагин
- [ ] Нет утечек памяти при повторном сканировании
