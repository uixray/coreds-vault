# A2.2 — Design Lint: Полная техническая спецификация

> **Версия:** 1.0  
> **Автор:** Ray (@uixray)  
> **Дата:** 2026-02-27  
> **Статус:** Проектирование  
> **Зависимости:** E1 Boilerplate, E2 UI Kit  

---

## 1. Концепция и позиционирование

### 1.1 Суть плагина

Design Lint — модульный аудитор дизайн-файлов Figma с тремя основными режимами работы:

1. **Typography** — анализ и массовая замена шрифтов, проверка привязки текстовых слоёв к стилям, суммаризация числовых параметров типографики
2. **Colors** — анализ привязки цветов к переменным (Variables) и стилям (Color Styles), поиск хардкод-значений, массовая переназначение
3. **Effects** — аналогичный анализ для эффектов (тени, блюры), проверка привязки к Effect Styles

Дополнительный режим:
4. **Overrides** — поиск стилевых оверрайдов в инстансах компонентов для сброса к значениям мастер-компонента

### 1.2 Ключевое отличие от конкурентов

| Проблема конкурентов | Наше решение |
|---|---|
| Зависание Figma при сканировании (Styles & Variables Organizer — десятки жалоб) | Чанковое сканирование (chunked scanning) с `setTimeout` yield, прогрессивная выдача результатов |
| Нет scope "Selection" (топ-запрос в S&VO) | Три уровня: Selection → Page → Document, по умолчанию Selection |
| Модификация инстансов при массовой замене (просьба множества пользователей) | Инстансы пропускаются по умолчанию, включаются явной галочкой |
| Пропуск скрытых слоёв (баг S&VO) | Скрытые слои включены с отдельным переключателем и маркировкой 👁 |
| Замена шрифтов ломает Text Style привязку (Batch Styler, Font Replacer) | Замена через TextStyle API — меняем стиль, а не слой |
| Потеря OpenType features при замене шрифтов | Сохранение font features, предупреждение при несовпадении |
| Окно не ресайзится (Style Lens) | Адаптивный UI, ресайз через `figma.ui.resize()` |
| Заброшенность (Style Lens — 3 года без обновлений) | Активная поддержка, open source |

### 1.3 Исследование конкурентов

**Styles & Variables Organizer** (117k users, $10)
- Поддержка: Color/Number/String Variables, Color/Text/Effect Styles
- Главная боль пользователей (из 158 комментариев):
  - "scanning..." висит бесконечно — множественные жалобы
  - "Please add feature to Scan Selected" — повторяется 3+ раз
  - "not include component instances — we dont want to override instance variables" — 2+ запроса
  - "skips hidden layers" — конкретный запрос от пользователя
  - Не работает при наличии FigJam-элементов на странице
  - Number Variables периодически ломаются
- Автор признал проблемы с производительностью из-за изменений Figma API

**Style Lens** (8.8k users, бесплатный, заброшен)
- Surfaces: fills, fonts, strokes, shadows, blurs, radii, text
- Позволяет массово менять значения "как инспектор наоборот"
- Критические проблемы:
  - Градиенты не поддерживаются
  - Mixed properties перезаписываются
  - Rich text не сохраняется при замене
  - Окно не ресайзится
  - Последнее обновление: август 2022

**Font Replacer / Smart Font Changer / Bulk Font Replacer**
- Фокус только на замене шрифтов на слоях
- Ломают привязку к Text Styles
- Не работают с Text Styles напрямую

**Batch Styler** (jansix.at)
- Bulk-редактирование стилей: font family, color, rename, delete
- Ломает OpenType features (font-weight 650+ вызывает ошибки)
- Не поддерживает Variables

**Find and Replace Styles Properties** (плагин от angyixin)
- Bulk-редактирование Text Styles + привязка к Variables
- Проблемы с нестандартными весами шрифтов (650, 850)
- Ломает OpenType features (частично пофикшено)

---

## 2. Функциональные требования

### 2.1 Общая архитектура режимов

```
┌─────────────────────────────────────────────────┐
│  Design Lint                               [×]  │
├──────┬──────┬──────┬──────┬─────────────────────┤
│  Aa  │  🎨  │  ✦   │  ◎   │                     │
│ Typo │Color │Effect│Over- │     [⚙ Settings]    │
│graphy│  s   │  s   │rides │                     │
├──────┴──────┴──────┴──────┴─────────────────────┤
│                                                 │
│  Scope: [● Selection ○ Page ○ Document]         │
│  ☐ Включить инстансы   ☐ Включить скрытые      │
│                                                 │
│  [🔍 Сканировать]                    [Отмена]   │
│                                                 │
│  ═══════════════════ 47% ═══                    │
│  Просканировано: 1,247 / 2,650 нод              │
│                                                 │
│  ─── Результаты (обновляются в реальном) ────   │
│                                                 │
│  ... контент зависит от выбранного режима ...   │
│                                                 │
└─────────────────────────────────────────────────┘
```

### 2.2 Режим Typography

#### FR-TYPO-01: Сканирование текстовых слоёв

Для каждого TextNode в scope собрать:
- `fontName.family` — семейство шрифта
- `fontName.style` — начертание (Regular, Bold, Italic...)
- `fontSize` — кегль
- `lineHeight` — межстрочное расстояние (value + unit: PIXELS / PERCENT / AUTO)
- `letterSpacing` — трекинг
- `paragraphSpacing` — межабзацное расстояние
- `textStyleId` — привязка к TextStyle (пустая строка = не привязан)
- `boundVariables` — привязка к Variables

> ⚠️ **Важно:** Все текстовые свойства могут возвращать `figma.mixed` если в одном TextNode несколько сегментов с разными значениями. Использовать `getStyledTextSegments()` для получения детализации по сегментам.

#### FR-TYPO-02: Суммаризация (Summary Table)

Группировка найденных текстовых слоёв по комбинациям параметров:

```
┌─────────────────────────────────────────────────────────────────────┐
│ Typography Summary                                                  │
├─────────┬─────────┬──────┬────────┬──────────┬──────┬──────────────┤
│ Font    │ Style   │ Size │ Line H │ Letter S │ Count│ Bound to     │
├─────────┼─────────┼──────┼────────┼──────────┼──────┼──────────────┤
│ Inter   │ Regular │ 16   │ 24px   │ 0        │ 847  │ Body/Regular │
│ Inter   │ Regular │ 16   │ 24px   │ 0        │ 23   │ — (нет)      │
│ Inter   │ Bold    │ 24   │ 32px   │ -0.2     │ 156  │ H2/Bold      │
│ Inter   │ Medium  │ 14   │ 20px   │ 0.1      │ 12   │ — (нет)      │
│ Roboto  │ Regular │ 16   │ auto   │ 0        │ 5    │ — (нет)      │
├─────────┴─────────┴──────┴────────┴──────────┴──────┴──────────────┤
│ Итого: 1,043 текстовых слоя, 5 уникальных комбинаций               │
│ ⚠️ 40 слоёв не привязаны к TextStyle                               │
└─────────────────────────────────────────────────────────────────────┘
```

#### FR-TYPO-03: Замена шрифтовой гарнитуры (Font Replace)

Аналог встроенной функции "Replace missing fonts", но для любых шрифтов:

```
┌──────────────────────────────────────────────┐
│ Замена шрифта                                │
│                                              │
│ Заменить: [Inter          ▾]                 │
│ На:       [Golos Text     ▾] [Подобрать ▾]  │
│                                              │
│ Маппинг начертаний:                          │
│ ┌──────────────┬──────────────┬─────────┐    │
│ │ Inter        │ Golos Text   │ Статус  │    │
│ ├──────────────┼──────────────┼─────────┤    │
│ │ Thin         │ —            │ ⚠️      │    │
│ │ Light        │ Light        │ ✅      │    │
│ │ Regular      │ Regular      │ ✅      │    │
│ │ Medium       │ Medium       │ ✅      │    │
│ │ Semi Bold    │ DemiBold     │ ≈ авто  │    │
│ │ Bold         │ Bold         │ ✅      │    │
│ │ Extra Bold   │ ExtraBold    │ ✅      │    │
│ │ Black        │ Black        │ ✅      │    │
│ └──────────────┴──────────────┴─────────┘    │
│                                              │
│ ☑ Обновить Text Styles (а не только слои)    │
│ ☐ Обновить Variables fontFamily              │
│ ☐ Включить инстансы                          │
│                                              │
│ Затронуто: 1,003 слоя, 12 стилей             │
│                                              │
│ [Заменить]                     [Отмена]      │
└──────────────────────────────────────────────┘
```

**Логика маппинга начертаний:**
1. Точное совпадение имени стиля (Regular → Regular)
2. Нормализованное совпадение ("Semi Bold" → "SemiBold" → "DemiBold")
3. Совпадение по font-weight числовому значению (600 → 600)
4. Ближайшее по весу (если точного нет)
5. Ручной выбор пользователем для неразрешённых

**Маппинг весов (weight normalization):**

| Имя | Weight | Алиасы |
|-----|--------|--------|
| Thin | 100 | Hairline |
| Extra Light | 200 | UltraLight |
| Light | 300 | — |
| Regular | 400 | Normal, Book |
| Medium | 500 | — |
| Semi Bold | 600 | SemiBold, DemiBold, Demi |
| Bold | 700 | — |
| Extra Bold | 800 | ExtraBold, UltraBold |
| Black | 900 | Heavy |

#### FR-TYPO-04: Массовое переназначение параметров

Пользователь может выбрать строку в Summary Table и:
- **Привязать к TextStyle** — выбрать из существующих стилей
- **Создать новый TextStyle** — из текущих параметров
- **Изменить fontSize** — массово на всех слоях этой группы
- **Изменить lineHeight** — массово
- **Изменить letterSpacing** — массово
- **Выделить все слои** — `figma.currentPage.selection = nodes`
- **Навигация** — `figma.viewport.scrollAndZoomIntoView(nodes)`

#### FR-TYPO-05: Поиск соответствий (Matching)

Для непривязанных слоёв автоматически искать ближайший TextStyle по параметрам:
- Совпадение fontFamily + fontSize + lineHeight = "Точное совпадение с `Body/Regular`"
- Совпадение fontFamily + fontSize (lineHeight отличается) = "Частичное совпадение с `Body/Regular` (lineHeight: 24px vs 22px)"
- Нет совпадений = "Нет подходящего стиля"

### 2.3 Режим Colors

#### FR-COLOR-01: Сканирование цветовых значений

Для каждой ноды в scope собрать:
- **Fills** (type: SOLID) — цвет, opacity, привязка к Variable / Color Style
- **Fills** (type: GRADIENT_LINEAR, GRADIENT_RADIAL и др.) — gradient stops с цветами
- **Fills** (type: IMAGE) — пометить отдельно, не включать в цветовой анализ
- **Strokes** — цвет, opacity, привязка к Variable / Color Style
- **Для TextNode** — цвет текста (может быть отдельным от fill родителя)

Каждое найденное цветовое значение классифицировать:
- ✅ **Привязано к Variable** — показать имя переменной и коллекцию
- ✅ **Привязано к Color Style** — показать имя стиля
- ⚠️ **Не привязано (hardcoded)** — показать hex-значение + поискать ближайший Variable/Style

#### FR-COLOR-02: Суммаризация цветов

```
┌────────────────────────────────────────────────────────────────────┐
│ Color Summary                                                      │
├──────────┬────────────┬───────────┬──────┬─────────────────────────┤
│ Цвет     │ Hex        │ Источник  │Count │ Привязка                │
├──────────┼────────────┼───────────┼──────┼─────────────────────────┤
│ ■        │ #0066CC    │ fill      │ 234  │ 🔗 color/primary/500    │
│ ■        │ #0066CC    │ fill      │ 12   │ ⚠️ не привязан          │
│ ■        │ #0068CF    │ fill      │ 3    │ ⚠️ ≈ color/primary/500  │
│ ■        │ #333333    │ fill      │ 456  │ 🔗 color/text/primary   │
│ ■        │ #333333    │ stroke    │ 28   │ ⚠️ не привязан          │
│ ■        │ #FF0000    │ fill      │ 7    │ ⚠️ нет совпадений       │
├──────────┴────────────┴───────────┴──────┴─────────────────────────┤
│ Итого: 740 цветовых значений, 45 уникальных                       │
│ ⚠️ 50 значений не привязаны к Variables/Styles                    │
└────────────────────────────────────────────────────────────────────┘
```

#### FR-COLOR-03: Поиск ближайшего Variable/Style (Color Matching)

Для каждого hardcoded цвета:
1. Загрузить все локальные Color Variables (`figma.variables.getLocalVariablesAsync('COLOR')`)
2. Загрузить все Color Styles (`figma.getLocalFillStylesAsync()`)
3. Вычислить цветовую дистанцию (Delta E в OKLCH или CIE76 в Lab)
4. Показать топ-3 ближайших совпадения с процентом похожести

**Пороги дистанции:**
- Delta E < 1 — "Идентичный" (различие незаметно глазу)
- Delta E < 3 — "Очень близкий" (различие заметно только при сравнении)
- Delta E < 5 — "Похожий" (небольшое различие)
- Delta E > 5 — "Отличается"

#### FR-COLOR-04: Массовое переназначение цветов

Действия для выбранной строки:
- **Привязать к Variable** — `figma.variables.setBoundVariableForPaint()`
- **Привязать к Color Style** — `node.fillStyleId = style.id`
- **Изменить hex-значение** — массовая замена на всех слоях
- **Выделить все слои** с данным цветом
- **Навигация** к конкретному слою

> ⚠️ **Критично:** При привязке к Variable — использовать правильный паттерн immutable массивов:
> ```typescript
> const fills = [...node.fills];
> fills[0] = figma.variables.setBoundVariableForPaint(fills[0], "color", variable);
> node.fills = fills;
> ```

### 2.4 Режим Effects

#### FR-EFFECT-01: Сканирование эффектов

Для каждой ноды с `node.effects.length > 0`:
- Тип эффекта: DROP_SHADOW, INNER_SHADOW, LAYER_BLUR, BACKGROUND_BLUR
- Параметры: color, offset (x, y), radius (blur), spread
- Привязка к Effect Style (`node.effectStyleId`)
- Привязка к Variables через `boundVariables`

#### FR-EFFECT-02: Суммаризация эффектов

Группировка по уникальным комбинациям параметров аналогично Typography и Colors.

#### FR-EFFECT-03: Массовое переназначение

- Привязать к существующему Effect Style
- Создать новый Effect Style из параметров
- Изменить параметры массово (color, blur, offset)
- Выделить/навигация

### 2.5 Режим Overrides

#### FR-OVER-01: Поиск стилевых оверрайдов в инстансах

Для каждого InstanceNode в scope:
1. Получить `mainComponent` через `await instance.getMainComponentAsync()`
2. Рекурсивно сравнить свойства дочерних нод инстанса с соответствующими нодами мастер-компонента
3. Классифицировать оверрайды:

| Категория | Что проверяем | Severity | Действие |
|---|---|---|---|
| **Текстовый контент** | `characters` изменён | ℹ️ Info | Норма — контент должен меняться |
| **Текстовый стиль** | `textStyleId` отличается или сброшен | ⚠️ Warning | Предложить сброс |
| **Цвет fill** (не IMAGE) | `fillStyleId` отличается, или Variable unbind | ⚠️ Warning | Предложить сброс |
| **Цвет fill** (IMAGE) | `fills[].type === 'IMAGE'` и imageHash отличается | 📷 Separate | Показать отдельно с предпросмотром |
| **Цвет stroke** | `strokeStyleId` отличается | ⚠️ Warning | Предложить сброс |
| **Effect** | `effectStyleId` отличается | ⚠️ Warning | Предложить сброс |
| **Размеры** | width/height отличается | ℹ️ Info | Может быть intentional |
| **Видимость** | `visible` отличается | ℹ️ Info | Может быть intentional |

#### FR-OVER-02: Отображение результатов

```
┌────────────────────────────────────────────────────────────────┐
│ Overrides                                                      │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│ ▼ Card / Product (15 инстансов с оверрайдами)                 │
│   ├ Instance "Card/1" (фрейм "Catalog")                       │
│   │   ⚠️ Text Style: "Title" → сброшен (hardcoded Bold 18px) │
│   │   ⚠️ Fill: "BG" → #F5F5F5 (было Variable bg/card)       │
│   │   ℹ️ Text: "Title" → "Кроссовки Nike Air"                │
│   │   📷 Image: "Photo" → изменён (ожидаемо)                 │
│   │   [Сбросить стилевые ▸] [Выделить ▸] [👁]                │
│   │                                                            │
│   ├ Instance "Card/2" (фрейм "Catalog")                       │
│   │   ⚠️ Fill: "BG" → #EEEEEE (было Variable bg/card)       │
│   │   [Сбросить стилевые ▸] [Выделить ▸] [👁]                │
│   ...                                                          │
│                                                                │
│ ▼ Button / Primary (3 инстанса с оверрайдами)                 │
│   ...                                                          │
│                                                                │
│ ─── Отдельная группа: Изменённые изображения ───               │
│ 📷 23 инстанса с изменёнными изображениями                    │
│    (это нормально для компонентов с контентом)                 │
│    [Показать все ▸]                                            │
│                                                                │
├────────────────────────────────────────────────────────────────┤
│ [Сбросить ВСЕ стилевые оверрайды (47)]  ← только стилевые!   │
│ ☐ Включить изображения (требует подтверждения)                │
└────────────────────────────────────────────────────────────────┘
```

#### FR-OVER-03: Сброс оверрайдов

**Что сбрасываем (по умолчанию):**
- fillStyleId / fill colors (кроме IMAGE)
- strokeStyleId / stroke colors
- textStyleId + связанные свойства (font, size, lineHeight)
- effectStyleId

**Что НЕ сбрасываем (никогда без явного подтверждения):**
- `characters` (текстовый контент)
- fills с `type: IMAGE` (изображения)
- Instance swap (замена вложенных компонентов)

**Что сбрасываем только при установленной галочке:**
- Изображения (fills type IMAGE)
- Размеры (width/height)
- Visibility

---

## 3. Нефункциональные требования

### 3.1 Производительность (Performance)

**Это ключевое конкурентное преимущество.** Главная боль пользователей конкурентов — зависание.

#### NFR-PERF-01: Чанковое сканирование (Chunked Scanning)

Figma выполняет плагин в main thread. Длительные операции замораживают весь UI. Решение — разбивка на чанки с yield через `setTimeout`.

```typescript
// Паттерн чанкового обхода нод
const CHUNK_SIZE = 100; // нод за один тик

async function traverseChunked(
  nodes: SceneNode[],
  processor: (node: SceneNode) => void,
  onProgress: (processed: number, total: number) => void
): Promise<void> {
  const total = nodes.length;
  
  for (let i = 0; i < total; i++) {
    processor(nodes[i]);
    
    // Каждые CHUNK_SIZE нод — пауза для UI
    if (i % CHUNK_SIZE === 0 && i > 0) {
      onProgress(i, total);
      // yield для main thread — позволяет Figma обработать UI events
      await new Promise(resolve => setTimeout(resolve, 0));
    }
  }
  
  onProgress(total, total);
}
```

**Из документации Figma (Frozen Plugins):** _"The best way to keep the UI responsive is to split your work into chunks... yield to the main thread before continuing. This allows the browser to process any events, such as a mouse click on the cancel button."_

#### NFR-PERF-02: Прогрессивная выдача результатов

Результаты отправляются в UI по мере сканирования, а не после завершения:

```typescript
// Отправляем пачку результатов каждые CHUNK_SIZE нод
if (i % CHUNK_SIZE === 0) {
  figma.ui.postMessage({
    type: 'scan-progress',
    data: {
      processed: i,
      total: total,
      newResults: batchResults,  // результаты текущего чанка
      isComplete: false
    }
  });
  batchResults = []; // очищаем для следующего чанка
}
```

#### NFR-PERF-03: Оптимизация через skipInvisibleInstanceChildren

```typescript
// Ключевая оптимизация — пропуск невидимых нод внутри инстансов
// Если пользователь НЕ включил "Включить скрытые":
figma.skipInvisibleInstanceChildren = !settings.includeHidden;
```

Из документации Figma: _"Setting `figma.skipInvisibleInstanceChildren = true` often makes document traversal significantly faster — findAll and findOne can be up to several times faster in large documents."_

#### NFR-PERF-04: Ленивая загрузка данных для переназначения

Полные данные о Variables и Styles загружаются **только при открытии режима переназначения**, а не при сканировании:

```typescript
// При сканировании — только проверяем наличие привязки (быстро)
const hasFillStyle = node.fillStyleId !== '';
const hasBoundVar = node.boundVariables?.fills?.length > 0;

// При открытии панели переназначения — загружаем полные данные (один раз)
let cachedVariables: Variable[] | null = null;
async function getColorVariables(): Promise<Variable[]> {
  if (!cachedVariables) {
    cachedVariables = await figma.variables.getLocalVariablesAsync('COLOR');
  }
  return cachedVariables;
}
```

#### NFR-PERF-05: Отмена сканирования

Пользователь может отменить сканирование в любой момент:

```typescript
let scanAborted = false;

figma.ui.onmessage = (msg) => {
  if (msg.type === 'abort-scan') {
    scanAborted = true;
  }
};

// В цикле сканирования:
for (let i = 0; i < total; i++) {
  if (scanAborted) {
    figma.ui.postMessage({ type: 'scan-aborted', processed: i, total });
    return;
  }
  // ... обработка
}
```

#### NFR-PERF-06: CSS-анимация для индикатора загрузки

Даже при замороженном JS, CSS-анимации продолжают работать на некоторых браузерах (включая Electron, на котором работает Figma Desktop):

```css
/* CSS-only спиннер — работает даже при заблокированном JS */
.spinner {
  width: 16px;
  height: 16px;
  border: 2px solid var(--figma-color-border);
  border-top-color: var(--figma-color-ui);
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
```

### 3.2 Работа со скрытыми элементами (Hidden Layers)

#### NFR-HIDDEN-01: Обнаружение истинной видимости

```typescript
// node.visible не учитывает родителей
// Для истинной видимости — проверяем цепочку родителей
function isTrulyVisible(node: SceneNode): boolean {
  let current: BaseNode | null = node;
  while (current && current.type !== 'DOCUMENT' && current.type !== 'PAGE') {
    if ('visible' in current && !(current as SceneNode).visible) {
      return false;
    }
    // Дополнительно: opacity 0 = визуально невидим
    if ('opacity' in current && (current as SceneNode).opacity === 0) {
      return false;
    }
    current = current.parent;
  }
  return true;
}
```

#### NFR-HIDDEN-02: Переключатель "Включить скрытые"

- По умолчанию: **выключен** (скрытые пропускаются для скорости)
- При включении: скрытые слои сканируются, но маркируются иконкой 👁 в результатах
- Массовые операции на скрытых слоях проходят корректно — `node.visible = false` не мешает изменению свойств

Из документации Figma: _"visible: Whether the node is visible or not. **Does not affect a plugin's ability to access the node.**"_

#### NFR-HIDDEN-03: Проблема с конкурентами и скрытыми слоями

Styles & Variables Organizer пропускает скрытые слои при сканировании. Пользователь Jop J.F. Cobussen: _"It would be really helpful if the plugin could also detect and process variables used on hidden layers. Many of us keep components or elements hidden that still rely on variables."_

Наше решение: отдельный toggle с чёткой маркировкой в результатах.

### 3.3 Работа с инстансами (Instance Handling)

#### NFR-INST-01: Пропуск инстансов по умолчанию

При рекурсивном обходе дерева нод:

```typescript
function shouldProcessNode(
  node: SceneNode, 
  settings: ScanSettings
): boolean {
  // Проверка скрытых
  if (!settings.includeHidden && !node.visible) return false;
  
  // Проверка инстансов — пропускаем ноду И её потомков
  if (!settings.includeInstances && isInsideInstance(node)) return false;
  
  return true;
}

// Проверяем, находится ли нода внутри инстанса (на любом уровне вложенности)
function isInsideInstance(node: SceneNode): boolean {
  let current: BaseNode | null = node.parent;
  while (current && current.type !== 'PAGE' && current.type !== 'DOCUMENT') {
    if (current.type === 'INSTANCE') return true;
    current = current.parent;
  }
  return false;
}
```

Методология Ray: _"Инстансы должны менять только контент, стили всегда привязаны к мастер-компоненту."_

#### NFR-INST-02: Включение инстансов (opt-in)

При установке галочки "Включить инстансы":
- Инстансы сканируются и отображаются в результатах с маркировкой 🔲
- Массовые операции применяются к инстансам **только** если пользователь явно выбрал "Применить к инстансам" в диалоге подтверждения
- Предупреждение: "Изменение стилей в инстансах создаёт оверрайды. Рекомендуется менять мастер-компонент."

### 3.4 Сканирование по запросу

#### NFR-SCAN-01: Только по кнопке

Сканирование **никогда** не запускается автоматически:
- Не при открытии плагина
- Не при смене выделения
- Не при смене страницы
- Только по нажатию кнопки "Сканировать"

При смене scope (Selection/Page) — предыдущие результаты остаются, но появляется hint: "Scope изменён. Нажмите Сканировать для обновления результатов."

---

## 4. Техническая архитектура

### 4.1 Структура проекта

```
design-lint/
├── manifest.json
├── code.ts                    ← Entry point, оркестратор
├── ui.html                    ← Single-file UI (инлайн CSS+JS)
│
├── src/
│   ├── scanner/
│   │   ├── base.ts            ← Абстрактный Scanner, chunked traversal
│   │   ├── typography.ts      ← Сканер текстовых слоёв
│   │   ├── colors.ts          ← Сканер цветов
│   │   ├── effects.ts         ← Сканер эффектов
│   │   └── overrides.ts       ← Сканер оверрайдов инстансов
│   │
│   ├── actions/
│   │   ├── font-replace.ts    ← Логика замены шрифтов
│   │   ├── color-assign.ts    ← Привязка цветов к Variables/Styles
│   │   ├── effect-assign.ts   ← Привязка эффектов к Styles
│   │   ├── override-reset.ts  ← Сброс оверрайдов
│   │   └── bulk-edit.ts       ← Массовое изменение числовых параметров
│   │
│   ├── utils/
│   │   ├── traverse.ts        ← Chunked tree traversal
│   │   ├── color-distance.ts  ← Delta E вычисление
│   │   ├── font-weight-map.ts ← Нормализация font weight/style
│   │   ├── visibility.ts      ← Проверка isTrulyVisible
│   │   └── instance-check.ts  ← Проверка isInsideInstance
│   │
│   ├── types.ts               ← Все TypeScript интерфейсы
│   └── storage.ts             ← Обёртка clientStorage
│
├── tsconfig.json
├── esbuild.config.mjs         ← Сборка в один файл
└── package.json
```

### 4.2 Ключевые типы данных

```typescript
// ═══ Общие типы ═══

interface ScanSettings {
  scope: 'selection' | 'page' | 'document';
  includeInstances: boolean;
  includeHidden: boolean;
}

interface ScanProgress {
  processed: number;
  total: number;
  isComplete: boolean;
}

// ═══ Typography ═══

interface TypographyEntry {
  fontFamily: string;
  fontStyle: string;       // "Regular", "Bold" и т.д.
  fontSize: number;
  lineHeight: LineHeight;  // { value: number, unit: 'PIXELS' | 'PERCENT' | 'AUTO' }
  letterSpacing: number;
  paragraphSpacing: number;
  textStyleId: string;     // пустая строка = не привязан
  textStyleName: string;   // имя стиля для отображения
  hasBoundVariables: boolean;
  nodeIds: string[];       // ID всех нод с этой комбинацией
  nodeCount: number;
  isHidden: boolean[];     // для каждого nodeId — скрыт ли
  isInInstance: boolean[]; // для каждого nodeId — в инстансе ли
}

interface FontMapping {
  fromFamily: string;
  toFamily: string;
  styleMap: Record<string, string | null>;  // "Regular" → "Regular", "Thin" → null
  updateTextStyles: boolean;
  updateVariables: boolean;
  includeInstances: boolean;
}

// ═══ Colors ═══

interface ColorEntry {
  hex: string;             // "#0066CC"
  rgba: RGBA;              // { r, g, b, a } в диапазоне 0-1
  source: 'fill' | 'stroke' | 'text-fill';
  fillStyleId: string;
  fillStyleName: string;
  boundVariableId: string;
  boundVariableName: string;
  boundCollectionName: string;
  nodeIds: string[];
  nodeCount: number;
  isHidden: boolean[];
  isInInstance: boolean[];
  // Для hardcoded — ближайшие совпадения
  nearestMatches?: ColorMatch[];
}

interface ColorMatch {
  type: 'variable' | 'style';
  id: string;
  name: string;
  hex: string;
  deltaE: number;         // расстояние CIE76 или OKLCH
  label: string;          // "Идентичный" | "Очень близкий" | "Похожий"
}

// ═══ Effects ═══

interface EffectEntry {
  type: 'DROP_SHADOW' | 'INNER_SHADOW' | 'LAYER_BLUR' | 'BACKGROUND_BLUR';
  color?: RGBA;
  offset?: { x: number; y: number };
  radius: number;
  spread?: number;
  effectStyleId: string;
  effectStyleName: string;
  nodeIds: string[];
  nodeCount: number;
}

// ═══ Overrides ═══

interface OverrideEntry {
  instanceId: string;
  instanceName: string;
  instancePath: string;     // "Page / Frame / Instance"
  mainComponentId: string;
  mainComponentName: string;
  overrides: Override[];
}

interface Override {
  category: 'text-content' | 'text-style' | 'fill-color' | 'fill-image' 
            | 'stroke' | 'effect' | 'size' | 'visibility';
  severity: 'info' | 'warning' | 'separate'; // separate = для изображений
  childNodeId: string;
  childNodeName: string;
  currentValue: string;     // описание текущего значения
  originalValue: string;    // описание значения из мастера
  canReset: boolean;
}
```

### 4.3 Паттерн коммуникации main ↔ UI

```
UI (iframe)                          Main Thread (sandbox)
    │                                       │
    │──── { type: 'start-scan',            │
    │       mode: 'typography',            │
    │       settings: {...} }        ────►  │ Начинает обход
    │                                       │
    │  ◄──── { type: 'scan-progress',      │ Каждые 100 нод
    │         processed: 100,               │
    │         total: 2650,                  │
    │         newResults: [...] }           │
    │                                       │
    │  ◄──── { type: 'scan-progress',      │
    │         processed: 200, ... }         │
    │         ...                            │
    │                                       │
    │  ◄──── { type: 'scan-complete',      │ Финал
    │         summary: {...} }              │
    │                                       │
    │──── { type: 'select-nodes',          │ Навигация
    │       nodeIds: [...] }         ────►  │
    │                                       │
    │──── { type: 'apply-action',          │ Массовое действие
    │       action: 'assign-variable',      │
    │       targetNodeIds: [...],           │
    │       variableId: '...' }      ────►  │
    │                                       │
    │  ◄──── { type: 'action-complete',    │
    │         affected: 234 }               │
```

### 4.4 Сборка

```javascript
// esbuild.config.mjs
import * as esbuild from 'esbuild';

// Main thread bundle
await esbuild.build({
  entryPoints: ['code.ts'],
  bundle: true,
  outfile: 'code.js',
  target: 'es2020',
  format: 'cjs',       // Figma sandbox = CommonJS
  sourcemap: false,
});

// UI bundle через inline HTML (как требует Figma)
// ui.html собирается отдельно со всеми зависимостями инлайн
```

### 4.5 manifest.json

```json
{
  "name": "Design Lint",
  "id": "PLACEHOLDER_ID",
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
    { "name": "Overrides", "command": "overrides" },
    { "separator": true },
    { "name": "Settings", "command": "settings" }
  ]
}
```

---

## 5. Алгоритмы

### 5.1 Color Distance (Delta E CIE76)

Простейшая формула для быстрого сравнения (достаточно для нашей задачи):

```typescript
// sRGB → Linear RGB
function srgbToLinear(c: number): number {
  return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
}

// Linear RGB → CIE XYZ (D65)
function rgbToXyz(r: number, g: number, b: number): [number, number, number] {
  const lr = srgbToLinear(r);
  const lg = srgbToLinear(g);
  const lb = srgbToLinear(b);
  return [
    lr * 0.4124564 + lg * 0.3575761 + lb * 0.1804375,
    lr * 0.2126729 + lg * 0.7151522 + lb * 0.0721750,
    lr * 0.0193339 + lg * 0.1191920 + lb * 0.9503041,
  ];
}

// CIE XYZ → CIE Lab
function xyzToLab(x: number, y: number, z: number): [number, number, number] {
  const D65 = [0.95047, 1.0, 1.08883];
  const f = (t: number) => t > 0.008856 ? Math.cbrt(t) : 7.787 * t + 16 / 116;
  const fx = f(x / D65[0]);
  const fy = f(y / D65[1]);
  const fz = f(z / D65[2]);
  return [116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)];
}

// Delta E (CIE76) — евклидово расстояние в Lab
function deltaE(color1: RGBA, color2: RGBA): number {
  const [x1, y1, z1] = rgbToXyz(color1.r, color1.g, color1.b);
  const [L1, a1, b1] = xyzToLab(x1, y1, z1);
  const [x2, y2, z2] = rgbToXyz(color2.r, color2.g, color2.b);
  const [L2, a2, b2] = xyzToLab(x2, y2, z2);
  return Math.sqrt((L1 - L2) ** 2 + (a1 - a2) ** 2 + (b1 - b2) ** 2);
}
```

### 5.2 Font Weight Normalization

```typescript
const WEIGHT_MAP: Record<string, number> = {
  'thin': 100, 'hairline': 100,
  'extralight': 200, 'ultralight': 200,
  'light': 300,
  'regular': 400, 'normal': 400, 'book': 400,
  'medium': 500,
  'semibold': 600, 'demibold': 600, 'demi': 600,
  'bold': 700,
  'extrabold': 800, 'ultrabold': 800,
  'black': 900, 'heavy': 900,
};

function normalizeStyleName(style: string): string {
  return style.toLowerCase().replace(/[\s\-_]/g, '');
}

function getWeightFromStyle(style: string): number | null {
  const normalized = normalizeStyleName(style);
  // Извлечь основной вес, игнорируя Italic
  const base = normalized.replace('italic', '').trim();
  return WEIGHT_MAP[base] ?? null;
}

function findBestStyleMatch(
  sourceStyle: string, 
  targetStyles: string[]
): { match: string | null; confidence: 'exact' | 'normalized' | 'weight' | 'closest' | 'none' } {
  // 1. Точное совпадение
  const exact = targetStyles.find(s => s === sourceStyle);
  if (exact) return { match: exact, confidence: 'exact' };
  
  // 2. Нормализованное совпадение
  const srcNorm = normalizeStyleName(sourceStyle);
  const normMatch = targetStyles.find(s => normalizeStyleName(s) === srcNorm);
  if (normMatch) return { match: normMatch, confidence: 'normalized' };
  
  // 3. Совпадение по weight
  const srcWeight = getWeightFromStyle(sourceStyle);
  if (srcWeight !== null) {
    const weightMatch = targetStyles.find(s => getWeightFromStyle(s) === srcWeight);
    if (weightMatch) return { match: weightMatch, confidence: 'weight' };
    
    // 4. Ближайший по weight
    let closestDist = Infinity;
    let closest: string | null = null;
    for (const ts of targetStyles) {
      const tw = getWeightFromStyle(ts);
      if (tw !== null) {
        const dist = Math.abs(tw - srcWeight);
        if (dist < closestDist) {
          closestDist = dist;
          closest = ts;
        }
      }
    }
    if (closest) return { match: closest, confidence: 'closest' };
  }
  
  return { match: null, confidence: 'none' };
}
```

### 5.3 Рекурсивный обход с чанками

```typescript
// Собирает все ноды в плоский массив для последующего chunked-обхода
function flattenNodes(
  root: SceneNode[],
  settings: ScanSettings
): SceneNode[] {
  const result: SceneNode[] = [];
  
  function walk(node: SceneNode) {
    // Фильтрация по видимости
    if (!settings.includeHidden && !node.visible) return;
    
    // Фильтрация по инстансам — пропускаем поддерево
    if (!settings.includeInstances && node.type === 'INSTANCE') return;
    
    result.push(node);
    
    if ('children' in node) {
      for (const child of node.children) {
        walk(child);
      }
    }
  }
  
  for (const node of root) {
    walk(node);
  }
  
  return result;
}
```

---

## 6. UI/UX детали

### 6.1 Размеры окна

- Начальный размер: **420 × 580 px**
- Минимальный: 360 × 400 px
- Поддержка `figma.ui.resize()` при переключении режимов

### 6.2 Тема

`themeColors: true` — автоматическая поддержка светлой и тёмной темы Figma через CSS-переменные.

### 6.3 Интерактивность результатов

- **Клик по строке результата** → `figma.viewport.scrollAndZoomIntoView([node])` — навигация к ноде
- **Hover над строкой** → подсветка на canvas (если API позволяет)
- **Кнопка "Выделить все"** → `figma.currentPage.selection = affectedNodes`
- **Цветовой превью** — квадратик с hex-цветом рядом с каждым цветовым значением

### 6.4 Горячие клавиши

- `Escape` — закрытие плагина (вне input)
- `Enter` — запуск сканирования (когда фокус на кнопке)

### 6.5 Состояния UI

1. **Idle** — плагин открыт, ничего не происходит, ожидание действия пользователя
2. **Scanning** — прогресс-бар, кнопка "Отмена", результаты появляются постепенно
3. **Results** — таблица результатов, действия доступны
4. **Applying** — индикатор применения действия, количество обработанных
5. **Error** — сообщение об ошибке (например, "Ничего не выделено")

---

## 7. Хранение настроек

### 7.1 Локальные настройки (figma.clientStorage)

```typescript
interface DesignLintSettings {
  // Общие
  lastMode: 'typography' | 'colors' | 'effects' | 'overrides';
  scope: 'selection' | 'page' | 'document';
  includeInstances: boolean;
  includeHidden: boolean;
  
  // Typography
  fontReplaceHistory: FontMapping[];  // последние 5 замен
  
  // Colors
  colorDistanceThreshold: number;     // порог Delta E для "похожих" (default: 5)
  
  // Window
  windowWidth: number;
  windowHeight: number;
}
```

### 7.2 Данные на документе (pluginData)

```typescript
// Помечаем ноды, которые пользователь пометил как "игнорировать"
node.setPluginData('lint-ignore', 'true');

// Помечаем ноды, прошедшие проверку
node.setPluginData('lint-checked', Date.now().toString());
```

---

## 8. Этапы реализации

| Этап | Задача | Часы | Приоритет |
|------|--------|------|-----------|
| **Фаза 1: Ядро** | | | |
| 1.1 | Скелет проекта: manifest, сборка esbuild, базовые типы | 2 | 🔴 |
| 1.2 | Chunked traversal: `flattenNodes` + `traverseChunked` + progress | 3 | 🔴 |
| 1.3 | UI каркас: табы режимов, scope selector, кнопка сканирования, прогресс-бар | 4 | 🔴 |
| 1.4 | Фильтрация: `isInsideInstance`, `isTrulyVisible`, `skipInvisibleInstanceChildren` | 2 | 🔴 |
| **Фаза 2: Typography** | | | |
| 2.1 | Сканер текстовых слоёв: сбор всех параметров, обработка `figma.mixed` | 3 | 🔴 |
| 2.2 | Суммаризация: группировка по комбинациям, UI таблица | 3 | 🔴 |
| 2.3 | Font Replace: маппинг начертаний, weight normalization | 4 | 🔴 |
| 2.4 | Font Replace: применение замены (слои + TextStyles + Variables) | 3 | 🔴 |
| 2.5 | Массовое переназначение параметров (fontSize, lineHeight и т.д.) | 3 | 🟡 |
| 2.6 | Matching: поиск ближайшего TextStyle для непривязанных слоёв | 2 | 🟡 |
| **Фаза 3: Colors** | | | |
| 3.1 | Сканер цветов: fills, strokes, text-fills, привязки | 3 | 🔴 |
| 3.2 | Суммаризация + UI | 3 | 🔴 |
| 3.3 | Color Matching: Delta E вычисление, поиск ближайших Variables/Styles | 3 | 🟡 |
| 3.4 | Массовое привязка к Variable / Color Style | 3 | 🔴 |
| **Фаза 4: Effects** | | | |
| 4.1 | Сканер эффектов + суммаризация + UI | 3 | 🟡 |
| 4.2 | Массовая привязка к Effect Style | 2 | 🟡 |
| **Фаза 5: Overrides** | | | |
| 5.1 | Сканер оверрайдов: сравнение инстанса с мастером | 5 | 🟡 |
| 5.2 | Классификация оверрайдов (text/style/image) | 2 | 🟡 |
| 5.3 | Сброс стилевых оверрайдов (без изображений и контента) | 3 | 🟡 |
| 5.4 | Отдельная группа изображений с подтверждением | 2 | 🟡 |
| **Фаза 6: Полировка** | | | |
| 6.1 | Сохранение/восстановление настроек (clientStorage) | 2 | 🟢 |
| 6.2 | Команды меню (menu в manifest) | 1 | 🟢 |
| 6.3 | Экспорт отчёта: JSON / Markdown | 2 | 🟢 |
| 6.4 | Тестирование на больших файлах (1000+ нод) | 3 | 🔴 |
| 6.5 | UX-полировка: edge cases, error states, уведомления | 3 | 🟡 |
| | **Итого** | **~70 ч** | |

### Рекомендуемый MVP (Minimum Viable Plugin)

**Фаза 1 + 2 (Typography) = ~27 часов** — уже полноценный полезный плагин, который закрывает самую частую боль: замену шрифтов и аудит текстовых стилей.

Выпуск MVP → сбор фидбека → Фаза 3-6 итерациями.

---

## 9. Подводные камни и edge cases

### 9.1 `figma.mixed` — множественные значения

Когда TextNode содержит несколько сегментов с разными шрифтами:
```typescript
if (textNode.fontName === figma.mixed) {
  // Используем getStyledTextSegments для детализации
  const segments = textNode.getStyledTextSegments([
    'fontName', 'fontSize', 'lineHeight', 'letterSpacing',
    'fontWeight', 'textStyleId', 'boundVariables'
  ]);
  // Каждый сегмент — отдельная строка в суммаризации
}
```

### 9.2 Замена шрифта в TextStyle vs на слое

**Правильный подход:** менять шрифт **на TextStyle**, а не на слоях:
```typescript
// ✅ Правильно — меняем стиль, все привязанные слои обновятся
const textStyles = await figma.getLocalTextStylesAsync();
for (const style of textStyles) {
  if (style.fontName.family === 'Inter') {
    await figma.loadFontAsync({ family: 'Golos Text', style: style.fontName.style });
    style.fontName = { family: 'Golos Text', style: mappedStyle };
  }
}
```

```typescript
// ❌ Неправильно — меняем на слое, ломаем привязку к стилю
textNode.fontName = { family: 'Golos Text', style: 'Regular' };
// textStyleId теперь может сброситься!
```

### 9.3 Загрузка шрифтов перед заменой

```typescript
// Шрифт ОБЯЗАН быть загружен до модификации
await figma.loadFontAsync({ family: targetFamily, style: targetStyle });
```

### 9.4 Immutable arrays

```typescript
// fills, strokes, effects — всегда копировать!
const fills = [...node.fills]; // или JSON.parse(JSON.stringify(node.fills))
fills[0] = { ...fills[0], color: newColor };
node.fills = fills;
```

### 9.5 FigJam-элементы

Styles & Variables Organizer ломается при наличии FigJam-элементов. Наше решение:
```typescript
// Пропускаем типы нод FigJam
const FIGJAM_TYPES = ['STICKY', 'SHAPE_WITH_TEXT_INSIDE', 'CONNECTOR'];
if (FIGJAM_TYPES.includes(node.type)) continue;
```

### 9.6 Пустые стили и none-fills

```typescript
// node.fills может быть пустым массивом или содержать невидимые fills
if (node.fills !== figma.mixed && Array.isArray(node.fills)) {
  for (const fill of node.fills) {
    if (!fill.visible) continue; // пропускаем скрытые fills
    // ...обработка
  }
}
```

### 9.7 Async-операции в dynamic-page

Все API вызовы должны использовать async-версии:
```typescript
// ❌ Deprecated — бросит исключение при documentAccess: dynamic-page
const node = figma.getNodeById(id);

// ✅ Правильно
const node = await figma.getNodeByIdAsync(id);
```

---

## 10. Связи с другими плагинами экосистемы

| Плагин | Связь |
|--------|-------|
| **A1.1 Pixel Audit** | Код chunked traversal переиспользуется из общего boilerplate |
| **A1.4 Instance Reset** | Логика сравнения инстанса с мастером переиспользуется в режиме Overrides |
| **A1.6 Palette Lab** | Color Matching использует тот же алгоритм Delta E |
| **A2.1 Typograph** | Может запускаться как пост-процесс после Typography scan |
| **A2.3 Typo Spec** | Экспорт Typography Summary в формат для Typo Spec |
| **A2.9 Design Checklist** | Результаты lint интегрируются в чеклист |
| **E1 Boilerplate** | Общие модули: storage, traverse, messaging, fonts, colors |

---

## 11. Метрики успеха

| Метрика | Цель |
|---------|------|
| Время сканирования страницы с 1000 нод | < 5 секунд |
| Время сканирования страницы с 5000 нод | < 15 секунд |
| Figma UI остаётся отзывчивой при сканировании | Да (CSS-анимация не фризится) |
| Кнопка "Отмена" срабатывает за | < 500 мс |
| Первые результаты появляются за | < 2 секунды |
| Font Replace на 1000 текстовых слоёв | < 10 секунд |
| Не модифицирует инстансы при выключенном toggle | 100% |
| Не ломает привязку к TextStyles при замене через стиль | 100% |

---

## 12. Open Source и публикация

- **Репозиторий:** `github.com/uixray/figma-design-lint`
- **Лицензия:** MIT
- **Публикация:** Figma Community (бесплатный)
- **README:** На русском и английском
- **Changelog:** Semantic versioning

---
