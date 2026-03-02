---
title: "Figma Variables API Reference"
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
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Reference documentation for the Figma Variables API"
---

2026-02-04
# Figma Plugin API — Variables API Справочник

> **Версия документа:** Январь 2026  
> **Источник:** Официальная документация Figma Developer Docs  
> **Назначение:** Дополнение к основному справочнику. Полный гайд по работе с переменными (Variables) в плагинах Figma.

---

## 1. Что такое Variables (Переменные)

Variables — это **reusable design tokens** внутри Figma. Каждая переменная принадлежит коллекции (VariableCollection), и каждая коллекция может иметь несколько **modes** (режимов). Переменная хранит **разное значение для каждого режима**, что позволяет реализовать тематизацию (light/dark), мультибрендинг и т.д.

```
VariableCollection "Semantic Colors"
├── Mode: "light"
├── Mode: "dark"
└── Variables:
    ├── text-primary      → light: #000000, dark: #FFFFFF
    ├── bg-primary        → light: #FFFFFF, dark: #1A1A1A
    └── accent            → light: #0066CC, dark: #4D9FFF
```

**Типы переменных (VariableResolvedDataType):**

|Тип|Значение|Пример значения|
|---|---|---|
|`COLOR`|RGBA цвет|`{ r: 1, g: 0, b: 0, a: 1 }`|
|`FLOAT`|Число|`16`, `0.5`, `1.5`|
|`STRING`|Строка|`"Inter"`, `"Hello"`|
|`BOOLEAN`|Булево|`true`, `false`|

---

## 2. Точка входа — `figma.variables`

Все операции с переменными идут через глобальный объект `figma.variables`. Существует две версии каждого метода — **deprecated синхронная** и **актуальная async**:

|❌ Deprecated (синхронный)|✅ Актуальный (async)|
|---|---|
|`getLocalVariableCollections()`|`getLocalVariableCollectionsAsync()`|
|`getLocalVariables()`|`getLocalVariablesAsync()`|
|`getVariableById(id)`|`getVariableByIdAsync(id)`|
|`getVariableCollectionById(id)`|`getVariableCollectionByIdAsync(id)`|

> ⚠️ Синхронные методы **выбрасывают исключение**, если в manifest.json указан `"documentAccess": "dynamic-page"`. Всегда используйте async-версии.

---

## 3. Чтение коллекций и переменных (Reading)

### 3.1 Все локальные коллекции

```typescript
// Получить все коллекции в текущем файле
const collections = await figma.variables.getLocalVariableCollectionsAsync()

// Коллекция — объект VariableCollection:
// {
//   id: string                  — уникальный ID коллекции
//   name: string                — имя коллекции
//   modes: { modeId, name }[]   — список режимов
//   variableIds: string[]       — ID всех переменных в коллекции
//   remote: boolean             — true если из библиотеки (library)
//   isExtension: boolean        — true если extended collection
//   hiddenFromPublishing: boolean
// }
```

### 3.2 Коллекция по ID

```typescript
// ID формат: "VariableCollectionId:fileHash/nodeId"
const collection = await figma.variables.getVariableCollectionByIdAsync(
  'VariableCollectionId:257c3beb2/57:13'
)
// Возвращает null если не найдена
```

### 3.3 Все локальные переменные (с фильтром по типу)

```typescript
// Без фильтра — все переменные файла
const allVars = await figma.variables.getLocalVariablesAsync()

// С фильтром по типу — только COLOR переменные
const colorVars = await figma.variables.getLocalVariablesAsync('COLOR')

// Доступные фильтры: 'COLOR' | 'FLOAT' | 'STRING' | 'BOOLEAN'
```

### 3.4 Переменная по ID

```typescript
// ID формат: "VariableID:fileHash/nodeId"
const variable = await figma.variables.getVariableByIdAsync('VariableID:10:337')
// Возвращает null если не найдена

// Объект Variable:
// {
//   id: string
//   name: string                        — например "color/Gray/750"
//   description: string
//   variableCollectionId: string        — ID родительской коллекции
//   resolvedType: string                — 'COLOR' | 'FLOAT' | 'STRING' | 'BOOLEAN'
//   valuesByMode: { [modeId]: value }   — значения для каждого режима
//   scopes: VariableScope[]             — видимость в UI picker
//   key: string                         — ключ для импорта из библиотеки
//   remote: boolean
//   hiddenFromPublishing: boolean
//   codeSyntax: { WEB?, ANDROID?, iOS? }
// }
```

### 3.5 Полный паттерн — чтение всех переменных по коллекциям

```typescript
// Полный паттерн: коллекции → переменные → значения по модам
async function readAllVariables() {
  const collections = await figma.variables.getLocalVariableCollectionsAsync()

  for (const collection of collections) {
    console.log(`Коллекция: ${collection.name}`)
    console.log(`  Режимы: ${collection.modes.map(m => m.name).join(', ')}`)

    // Получаем переменные через их ID из коллекции
    for (const varId of collection.variableIds) {
      const variable = await figma.variables.getVariableByIdAsync(varId)
      if (!variable) continue

      console.log(`  Переменная: ${variable.name} [${variable.resolvedType}]`)

      // valuesByMode — это { modeId: значение }
      // ключ — это modeId из collection.modes
      for (const mode of collection.modes) {
        const value = variable.valuesByMode[mode.modeId]
        console.log(`    ${mode.name}: `, value)
      }
    }
  }
}
```

---

## 4. Создание коллекций и переменных (Writing)

### 4.1 Создать коллекцию

```typescript
// Создаёт коллекцию с одним режимом по умолчанию
const collection = figma.variables.createVariableCollection("My Collection")

// Первый режим создаётся автоматически — его можно переименовать
collection.renameMode(collection.modes[0].modeId, "light")

// Добавить новый режим — возвращает modeId нового режима
const darkModeId = collection.addMode("dark")

// Переименовать коллекцию
collection.name = "Semantic Colors"

// Удалить режим (по modeId)
collection.removeMode(darkModeId)

// Удалить всю коллекцию и все её переменные
collection.remove()
```

### 4.2 Создать переменную

```typescript
// figma.variables.createVariable(name, collection, resolvedType)
const colorVar = figma.variables.createVariable(
  "text-primary",       // имя
  collection,           // VariableCollection (объект, не ID)
  "COLOR"               // тип: 'COLOR' | 'FLOAT' | 'STRING' | 'BOOLEAN'
)

// Установить значения для каждого режима
const lightModeId = collection.modes[0].modeId  // первый режим (light)
const darkModeId  = collection.modes[1].modeId  // второй режим (dark)

colorVar.setValueForMode(lightModeId, { r: 0, g: 0, b: 0, a: 1 })   // #000000
colorVar.setValueForMode(darkModeId,  { r: 1, g: 1, b: 1, a: 1 })   // #FFFFFF

// Значения по типам:
// COLOR   → { r: number, g: number, b: number, a: number }  (0–1)
// FLOAT   → number
// STRING  → string
// BOOLEAN → boolean
```

### 4.3 Полный пример — создание dark/light темы

```typescript
async function createTheme() {
  // Создаём коллекцию
  const collection = figma.variables.createVariableCollection("Theme")
  collection.renameMode(collection.modes[0].modeId, "light")
  const darkId = collection.addMode("dark")
  const lightId = collection.modes[0].modeId

  // Цвета
  const bgColor = figma.variables.createVariable("bg/primary", collection, "COLOR")
  bgColor.setValueForMode(lightId, { r: 1, g: 1, b: 1, a: 1 })        // white
  bgColor.setValueForMode(darkId,  { r: 0.1, g: 0.1, b: 0.1, a: 1 })  // dark gray

  const textColor = figma.variables.createVariable("text/primary", collection, "COLOR")
  textColor.setValueForMode(lightId, { r: 0, g: 0, b: 0, a: 1 })      // black
  textColor.setValueForMode(darkId,  { r: 1, g: 1, b: 1, a: 1 })      // white

  // Числа (spacing, radius)
  const radius = figma.variables.createVariable("radius/default", collection, "FLOAT")
  radius.setValueForMode(lightId, 8)
  radius.setValueForMode(darkId, 8)   // может быть одинаковым

  const gap = figma.variables.createVariable("spacing/md", collection, "FLOAT")
  gap.setValueForMode(lightId, 16)
  gap.setValueForMode(darkId, 16)

  // Строки (шрифты)
  const fontFamily = figma.variables.createVariable("font/primary", collection, "STRING")
  fontFamily.setValueForMode(lightId, "Inter")
  fontFamily.setValueForMode(darkId, "Inter")

  console.log("Тема создана!")
}
```

### 4.4 Alias — переменная ссылается на другую переменную

```typescript
// Переменная может быть алиасом на другую переменную
const baseColor = figma.variables.createVariable("base/blue", collection, "COLOR")
baseColor.setValueForMode(lightId, { r: 0, g: 0.4, b: 0.8, a: 1 })

const semanticColor = figma.variables.createVariable("action/primary", collection, "COLOR")

// Устанавливаем алиас — значение берётся из base/blue
semanticColor.setValueForMode(lightId, {
  type: "VARIABLE_ALIAS",
  id: baseColor.id
})
```

---

## 5. Привязка переменных к нодам (Binding)

Чтобы переменная **влияла** на ноду, её нужно **привязать (bind)**. Есть два механизма:

1. **`node.setBoundVariable(field, variable)`** — для простых полей (width, height, opacity, cornerRadius и т.д.)
2. **Helper-функции** — для сложных объектов (fills, strokes, effects, layoutGrids)

### 5.1 Простые поля — setBoundVariable

```typescript
const node = await figma.getNodeByIdAsync("1:4") as RectangleNode

const widthVar  = figma.variables.createVariable("size/width", collection, "FLOAT")
const opacityVar = figma.variables.createVariable("opacity/default", collection, "FLOAT")

widthVar.setValueForMode(lightId, 200)
opacityVar.setValueForMode(lightId, 0.8)

// Привязка — очень просто
node.setBoundVariable("width", widthVar)
node.setBoundVariable("opacity", opacityVar)
node.setBoundVariable("cornerRadius", radiusVar)

// Отвязка — передаём null
node.setBoundVariable("width", null)
```

**Список привязываемых полей для нод (VariableBindableNodeField):**

|Поле|Тип переменной|Применимо к|
|---|---|---|
|`width`|FLOAT|Почти все ноды|
|`height`|FLOAT|Почти все ноды|
|`opacity`|FLOAT|Почти все ноды|
|`cornerRadius`|FLOAT|RectangleNode и др.|
|`cornerRadiusTopLeft`|FLOAT|RectangleNode|
|`cornerRadiusTopRight`|FLOAT|RectangleNode|
|`cornerRadiusBottomLeft`|FLOAT|RectangleNode|
|`cornerRadiusBottomRight`|FLOAT|RectangleNode|
|`strokeWeight`|FLOAT|Ноды со stroke|
|`minWidth`|FLOAT|FrameNode (auto layout)|
|`minHeight`|FLOAT|FrameNode|
|`maxWidth`|FLOAT|FrameNode|
|`maxHeight`|FLOAT|FrameNode|
|`itemSpacing`|FLOAT|FrameNode (auto layout)|
|`paddingTop`|FLOAT|FrameNode|
|`paddingRight`|FLOAT|FrameNode|
|`paddingBottom`|FLOAT|FrameNode|
|`paddingLeft`|FLOAT|FrameNode|
|`rotation`|FLOAT|Все ноды|

### 5.2 Fills и Strokes — через helper `setBoundVariableForPaint`

> ⚠️ `fills` и `strokes` — **immutable массивы**. Нельзя просто изменить элемент. Нужно копировать массив, менять копию, присваивать обратно.

```typescript
const node = await figma.getNodeByIdAsync("1:4") as RectangleNode
const colorVar = figma.variables.createVariable("color/bg", collection, "COLOR")
colorVar.setValueForMode(lightId, { r: 0, g: 0.4, b: 0.8, a: 1 })

// ПАТТЕРН: копия → изменение → присвоение
const fillsCopy = JSON.parse(JSON.stringify(node.fills)) as Paint[]

// setBoundVariableForPaint(paint, field, variable)
// field для цвета в SolidPaint — всегда "color"
fillsCopy[0] = figma.variables.setBoundVariableForPaint(
  fillsCopy[0],   // исходный Paint объект
  "color",        // поле внутри Paint (для SolidPaint — "color")
  colorVar        // переменная COLOR
)

// Записываем обратно
node.fills = fillsCopy

// Аналогично для strokes
const strokesCopy = JSON.parse(JSON.stringify(node.strokes)) as Paint[]
strokesCopy[0] = figma.variables.setBoundVariableForPaint(strokesCopy[0], "color", colorVar)
node.strokes = strokesCopy
```

### 5.3 Gradient stops — привязка через boundVariables в объекте

```typescript
// Для градиентов setBoundVariableForPaint НЕ работает.
// Нужно вручную подставить boundVariables в каждый color stop

const colorStop1Var = figma.variables.createVariable("gradient/start", collection, "COLOR")
const colorStop2Var = figma.variables.createVariable("gradient/end", collection, "COLOR")

node.fills = [
  {
    type: "GRADIENT_LINEAR",
    gradientTransform: [[1, 0, 0], [0, 1, 0]],
    gradientStops: [
      {
        position: 0,
        color: { r: 0, g: 0, b: 0, a: 1 },  // цвет игнорируется при наличии boundVariables
        boundVariables: {
          color: { type: "VARIABLE_ALIAS", id: colorStop1Var.id }
        }
      },
      {
        position: 1,
        color: { r: 1, g: 1, b: 1, a: 1 },
        boundVariables: {
          color: { type: "VARIABLE_ALIAS", id: colorStop2Var.id }
        }
      }
    ]
  } as any  // cast необходим — типы Paint не включают boundVariables явно
]
```

### 5.4 Effects — через helper `setBoundVariableForEffect`

```typescript
const shadowColorVar = figma.variables.createVariable("shadow/color", collection, "COLOR")
const shadowBlurVar  = figma.variables.createVariable("shadow/blur", collection, "FLOAT")

// Effects тоже immutable массив
const effectsCopy = JSON.parse(JSON.stringify(node.effects)) as Effect[]

// Привязать цвет тени
effectsCopy[0] = figma.variables.setBoundVariableForEffect(effectsCopy[0], "color", shadowColorVar)

// Привязать blur
effectsCopy[0] = figma.variables.setBoundVariableForEffect(effectsCopy[0], "radius", shadowBlurVar)

node.effects = effectsCopy
```

### 5.5 LayoutGrid — через helper `setBoundVariableForLayoutGrid`

```typescript
const gridSizeVar = figma.variables.createVariable("grid/size", collection, "FLOAT")
const frame = await figma.getNodeByIdAsync("2:1") as FrameNode

const gridsCopy = JSON.parse(JSON.stringify(frame.layoutGrids)) as LayoutGrid[]
gridsCopy[0] = figma.variables.setBoundVariableForLayoutGrid(gridsCopy[0], "size", gridSizeVar)
frame.layoutGrids = gridsCopy
```

### 5.6 Прочитать привязанные переменные с ноды

```typescript
const node = await figma.getNodeByIdAsync("1:4") as RectangleNode

// boundVariables — объект, где ключ = поле, значение = Variable Alias или массив алиасов
const bound = node.boundVariables

// Пример boundVariables:
// {
//   "width": { type: "VARIABLE_ALIAS", id: "VariableID:1:7" },
//   "fills": [
//     { type: "VARIABLE_ALIAS", id: "VariableID:2:3" }
//   ],
//   "strokes": [
//     { type: "VARIABLE_ALIAS", id: "VariableID:3:5" }
//   ]
// }

// Простые поля — это объект VARIABLE_ALIAS
if (bound.width) {
  console.log("Width привязано к:", bound.width.id)
}

// fills/strokes — массивы (по одному алиасу на элемент массива)
if (bound.fills && bound.fills.length > 0) {
  console.log("Fill привязан к:", bound.fills[0].id)
}
```

---

## 6. Typography Variables (Переменные для текста)

Текстовые переменные — отдельная категория. Поддерживаются привязки к свойствам типографии на `TextNode`, `TextSublayer` (подстрока) и `TextStyle`.

### 6.1 Привязываемые текстовые поля (VariableBindableTextField)

|Поле|Тип переменной|Применимо к подстрокам?|
|---|---|---|
|`fontFamily`|STRING|✅|
|`fontStyle`|STRING|✅|
|`fontWeight`|FLOAT|✅|
|`fontSize`|FLOAT|✅|
|`lineHeight`|FLOAT|✅|
|`letterSpacing`|FLOAT|✅|
|`paragraphSpacing`|FLOAT|❌ (только полный TextNode)|
|`paragraphIndent`|FLOAT|❌ (только полный TextNode)|

> ⚠️ `fontStyle` — зависит от `fontFamily`. Например, для `"Inter"` допустимы `"Light"`, `"Regular"`, `"Semi Bold"` и т.д. Если значение не соответствует — берётся ближайший валидный вариант.

### 6.2 Привязка на весь TextNode

```typescript
const textNode = await figma.getNodeByIdAsync("1:4") as TextNode

const fontFamilyVar = figma.variables.createVariable("font/family", collection, "STRING")
fontFamilyVar.setValueForMode(lightId, "Inter")

const fontWeightVar = figma.variables.createVariable("font/weight/body", collection, "FLOAT")
fontWeightVar.setValueForMode(lightId, 400)

const fontSizeVar = figma.variables.createVariable("font/size/body", collection, "FLOAT")
fontSizeVar.setValueForMode(lightId, 16)

// setBoundVariable работает для текстовых полей на весь TextNode
textNode.setBoundVariable("fontFamily", fontFamilyVar)
textNode.setBoundVariable("fontWeight", fontWeightVar)
textNode.setBoundVariable("fontSize", fontSizeVar)
textNode.setBoundVariable("lineHeight", lineHeightVar)
textNode.setBoundVariable("letterSpacing", letterSpacingVar)
```

### 6.3 Привязка на подстроку текста — setRangeBoundVariable

```typescript
// Текст "Hello World" — привязать fontWeight только к "Hello" (символы 0–5)
textNode.setRangeBoundVariable(
  0,              // начало диапазона (включительно)
  5,              // конец диапазона (исключительно)
  "fontWeight",   // поле
  fontWeightVar   // переменная
)

// Отвязать подстроку
textNode.setRangeBoundVariable(0, 5, "fontWeight", null)
```

### 6.4 Читать привязки по подстрокам — getStyledTextSegments

```typescript
// Получить все сегменты текста с их привязками
const segments = textNode.getStyledTextSegments(["boundVariables"])

// Результат:
// [
//   {
//     characters: "Hello",
//     start: 0,
//     end: 5,
//     boundVariables: {
//       fontFamily: { type: "VARIABLE_ALIAS", id: "VariableID:1:7" },
//       fontWeight: { type: "VARIABLE_ALIAS", id: "VariableID:2:8" }
//     }
//   },
//   {
//     characters: " World",
//     start: 5,
//     end: 11,
//     boundVariables: {}   // нет привязок на этот сегмент
//   }
// ]
```

### 6.5 Читать привязку для конкретного диапазона

```typescript
// Получить привязку fontWeight для символов 0–5
const alias = textNode.getRangeBoundVariable(0, 5, "fontWeight")
// Возвращает { type: "VARIABLE_ALIAS", id: "VariableID:..." } или null
```

### 6.6 Привязка к TextStyle

```typescript
const styles = await figma.getLocalTextStylesAsync()
const bodyStyle = styles[0]

// TextStyle тоже поддерживает setBoundVariable для текстовых полей
bodyStyle.setBoundVariable("fontWeight", fontWeightVar)
bodyStyle.setBoundVariable("fontFamily", fontFamilyVar)

// Читать привязки стиля
const styleBound = bodyStyle.boundVariables
```

---

## 7. Scopes — контроль видимости в UI

`scopes` определяют, **в каких полях UI** переменная будет видна в variable picker. Полезно для организации большого количества переменных.

### Все допустимые значения VariableScope

```typescript
type VariableScope =
  // Специальные
  | "ALL_SCOPES"           // показывать везде (нельзя добавить другие scope)
  | "ALL_FILLS"            // все поля заливки (FRAME_FILL + SHAPE_FILL + TEXT_FILL)

  // Цвета (COLOR)
  | "FRAME_FILL"           // заливка frame
  | "SHAPE_FILL"           // заливка shape (rectangle, ellipse...)
  | "TEXT_FILL"            // заливка текста
  | "STROKE_COLOR"         // цвет обводки
  | "EFFECT_COLOR"         // цвет эффекта (тень, blur...)

  // Числа (FLOAT)
  | "CORNER_RADIUS"        // скругление углов
  | "WIDTH_HEIGHT"         // ширина и высота
  | "GAP"                  // gap в auto layout
  | "OPACITY"              // прозрачность
  | "STROKE_FLOAT"         // толщина обводки (число)
  | "EFFECT_FLOAT"         // числовые параметры эффектов
  | "FONT_WEIGHT"          // вес шрифта (число)
  | "FONT_SIZE"            // размер шрифта
  | "LINE_HEIGHT"          // межстрочный интервал
  | "LETTER_SPACING"       // кернинг
  | "PARAGRAPH_SPACING"    // межабзацный интервал
  | "PARAGRAPH_INDENT"     // отступ абзаца

  // Строки (STRING)
  | "TEXT_CONTENT"         // содержимое текста
  | "FONT_FAMILY"          // семейство шрифта
  | "FONT_STYLE"           // стиль шрифта (Regular, Bold...)
```

### Допустимые scope по типам

|Тип переменной|Допустимые scopes|
|---|---|
|**COLOR**|`ALL_SCOPES`, `ALL_FILLS`, `FRAME_FILL`, `SHAPE_FILL`, `TEXT_FILL`, `STROKE_COLOR`, `EFFECT_COLOR`|
|**FLOAT**|`ALL_SCOPES`, `CORNER_RADIUS`, `WIDTH_HEIGHT`, `GAP`, `OPACITY`, `STROKE_FLOAT`, `EFFECT_FLOAT`, `FONT_WEIGHT`, `FONT_SIZE`, `LINE_HEIGHT`, `LETTER_SPACING`, `PARAGRAPH_SPACING`, `PARAGRAPH_INDENT`|
|**STRING**|`ALL_SCOPES`, `TEXT_CONTENT`, `FONT_FAMILY`, `FONT_STYLE`|
|**BOOLEAN**|scope не поддерживается|

### Пример использования

```typescript
const spacingVar = figma.variables.createVariable("spacing/md", collection, "FLOAT")
spacingVar.setValueForMode(lightId, 16)

// Ограничить видимость — показывать только в полях gap и padding-like
spacingVar.scopes = ["GAP"]

const colorVar = figma.variables.createVariable("color/bg", collection, "COLOR")
// Показывать только в заливках frame и shape, но НЕ в stroke и effect
colorVar.scopes = ["FRAME_FILL", "SHAPE_FILL"]

// Показать во всех полях
colorVar.scopes = ["ALL_SCOPES"]
```

---

## 8. CodeSyntax — кодовые обозначения

Переменные могут иметь `codeSyntax` — имена для разных платформ, видимые в Dev Mode.

```typescript
const colorVar = figma.variables.createVariable("color/primary", collection, "COLOR")

// Установить code syntax
colorVar.setVariableCodeSyntax("WEB",     "--color-primary")
colorVar.setVariableCodeSyntax("ANDROID", "colorPrimary")
colorVar.setVariableCodeSyntax("iOS",     "colorPrimary")

// Удалить code syntax для платформы
colorVar.removeVariableCodeSyntax("WEB")

// Прочитать текущий codeSyntax
console.log(colorVar.codeSyntax)
// { WEB: "--color-primary", ANDROID: "colorPrimary", iOS: "colorPrimary" }
```

---

## 9. Extended Collections (Расширенные коллекции)

> ⚠️ Extended collections требуют **Enterprise plan**. На других тарифах метод `extend()` выбрасывает исключение.

Extended collection **наследует** все переменные и режимы из родительской коллекции, но может **переопределить (override)** значения для создания тематических вариантов.

### 9.1 Создать extended collection из локальной коллекции

```typescript
const baseCollection = figma.variables.createVariableCollection("Base Theme")
// ... наполнить переменными ...

// Создать расширение
const brandA = baseCollection.extend("Brand A")
// brandA — ExtendedVariableCollection
// brandA.isExtension === true
// brandA.parentVariableCollectionId === baseCollection.id
```

### 9.2 Создать extended collection из библиотеки

```typescript
// extendLibraryCollectionByKeyAsync для remote (библиотечных) коллекций
const libraryExtension = await figma.variables.extendLibraryCollectionByKeyAsync(
  libraryCollectionKey,  // key коллекции из библиотеки
  "My Brand Override"    // имя нового extended collection
)
```

### 9.3 Переопределить значения в extended collection

```typescript
// Получить переменную из базовой коллекции
const baseColorVar = await figma.variables.getVariableByIdAsync(baseColorId)

// Переопределить значение для режима в extended collection
// Если modeId принадлежит extended collection, значение устанавливается как override
baseColorVar.setValueForMode(brandA.modes[0].modeId, { r: 1, g: 0, b: 0, a: 1 })

// Получить значения с учётом overrides для конкретной коллекции
const valuesForBrandA = await baseColorVar.valuesByModeForCollectionAsync(brandA)
```

### 9.4 Убрать override

```typescript
// Убрать override для конкретного режима — вернуть к наследуемому значению
baseColorVar.removeOverrideForMode(brandA.modes[0].modeId)

// Убрать все overrides для переменной в данной коллекции
brandA.removeOverridesForVariable(baseColorVar.id)
```

---

## 10. Библиотечные переменные (Team Library)

Для работы с переменными из **team libraries** используется `figma.teamLibrary`:

```typescript
// Получить все доступные библиотечные коллекции
const libCollections = await figma.teamLibrary.getAvailableLibraryVariableCollectionsAsync()
// Возвращает: { key: string, name: string }[]

// Получить переменные в библиотечной коллекции
const libVars = await figma.teamLibrary.getVariablesInLibraryCollectionAsync(
  libCollections[0].key
)
// Возвращает: { key: string, name: string, resolvedType: string }[]

// Импортировать переменную по key — добавляет в текущий файл
const importedVar = await figma.variables.importVariableByKeyAsync(libVars[0].key)
// importedVar — полный объект Variable, можно использовать для привязки

// ⚠️ scopes доступны только после импорта
console.log(importedVar.scopes)
```

---

## 11. Подводные камни (Gotchas)

### 11.1 valuesByMode не резолвит алиасы

```typescript
const variable = await figma.variables.getVariableByIdAsync(id)

// valuesByMode может содержать VARIABLE_ALIAS вместо реального значения
const value = variable.valuesByMode[modeId]
// { type: "VARIABLE_ALIAS", id: "VariableID:..." }  ← это НЕ реальное значение!

// Для получения резолвленного значения — используйте resolveForConsumer
const resolved = variable.resolveForConsumer(consumerNode)
// Возвращает реальное значение с учётом алиасов и active mode
```

### 11.2 Fills/Strokes/Effects — immutable массивы

```typescript
// ❌ НЕ работает:
node.fills[0] = figma.variables.setBoundVariableForPaint(node.fills[0], "color", colorVar)

// ✅ Правильно: копия → изменение → присвоение
const fills = [...node.fills]
fills[0] = figma.variables.setBoundVariableForPaint(fills[0], "color", colorVar)
node.fills = fills
```

### 11.3 COLOR значения в диапазоне 0–1, а НЕ 0–255

```typescript
// ❌ Неправильно:
colorVar.setValueForMode(modeId, { r: 255, g: 0, b: 0, a: 255 })

// ✅ Правильно — значения от 0 до 1:
colorVar.setValueForMode(modeId, { r: 1, g: 0, b: 0, a: 1 })
```

### 11.4 scopes для library переменных доступны только после импорта

```typescript
// Из библиотеки scopes недоступны:
const libVars = await figma.teamLibrary.getVariablesInLibraryCollectionAsync(key)
// libVars[0].scopes — undefined!

// Нужно импортировать:
const imported = await figma.variables.importVariableByKeyAsync(libVars[0].key)
console.log(imported.scopes) // теперь доступны
```

### 11.5 Extended collections — Enterprise only

```typescript
// На не-Enterprise тарифах:
baseCollection.extend("name")
// Выбрасывает: "in extend: Cannot create extended collections outside of enterprise plan"
```

### 11.6 Тип переменной должен совпадать с типом поля

```typescript
// ❌ Привязать COLOR переменную к width (FLOAT поле)
node.setBoundVariable("width", colorVar)  // throws или работает некорректно

// ✅ Типы должны совпадать
node.setBoundVariable("width", floatVar)
node.fills = [setBoundVariableForPaint(fills[0], "color", colorVar)]
```

### 11.7 Первый режим создаётся автоматически

```typescript
const collection = figma.variables.createVariableCollection("Test")

// collection.modes уже содержит один режим с именем "Mode 1"
console.log(collection.modes.length) // 1
console.log(collection.modes[0].name) // "Mode 1"

// Не забыть переименовать перед добавлением второго режима
collection.renameMode(collection.modes[0].modeId, "light")
```

---

## 12. Полный рабочий пример — Экспорт Variables в JSON

```typescript
// code.ts — плагин экспорта всех переменных файла в JSON

// Тип для экспорта
interface ExportedVariable {
  id: string
  name: string
  type: string
  collectionName: string
  scopes: string[]
  values: { [modeName: string]: any }
}

async function exportVariables(): Promise<ExportedVariable[]> {
  const collections = await figma.variables.getLocalVariableCollectionsAsync()
  const result: ExportedVariable[] = []

  for (const collection of collections) {
    // Карта modeId → modeNam для текущей коллекции
    const modeNames: Record<string, string> = {}
    for (const mode of collection.modes) {
      modeNames[mode.modeId] = mode.name
    }

    // Перебираем все переменные коллекции
    for (const varId of collection.variableIds) {
      const variable = await figma.variables.getVariableByIdAsync(varId)
      if (!variable) continue

      // Формируем значения по режимам с именами
      const values: Record<string, any> = {}
      for (const [modeId, value] of Object.entries(variable.valuesByMode)) {
        const modeName = modeNames[modeId] || modeId

        // Если значение — алиас, указываем ссылку
        if (typeof value === "object" && "type" in value && value.type === "VARIABLE_ALIAS") {
          values[modeName] = { __alias__: value.id }
        } else {
          values[modeName] = value
        }
      }

      result.push({
        id: variable.id,
        name: variable.name,
        type: variable.resolvedType,
        collectionName: collection.name,
        scopes: variable.scopes,
        values
      })
    }
  }

  return result
}

// Запуск плагина
figma.showUI(__html__, { width: 360, height: 200 })

figma.ui.onmessage = async (msg) => {
  if (msg.type === "export") {
    const data = await exportVariables()
    // Отправляем в UI для отображения и копирования
    figma.ui.postMessage({ type: "exported", data })
  }
}
```

```html
<!-- ui.html -->
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Inter, sans-serif; padding: 16px; }
    button { padding: 8px 16px; cursor: pointer; }
    #output { margin-top: 12px; font-size: 12px; white-space: pre-wrap; max-height: 120px; overflow: auto; }
  </style>
</head>
<body>
  <button id="exportBtn">Export Variables to JSON</button>
  <div id="output">Нажмите кнопку для экспорта...</div>

  <script>
    // Отправляем команду в main thread
    document.getElementById("exportBtn").onclick = () => {
      parent.postMessage({ pluginMessage: { type: "export" } }, "*")
      document.getElementById("output").textContent = "Экспортируем..."
    }

    // Слушаем ответ от main thread
    window.onmessage = (event) => {
      if (event.data.pluginMessage?.type === "exported") {
        const json = JSON.stringify(event.data.pluginMessage.data, null, 2)
        document.getElementById("output").textContent = json

        // Копируем в clipboard
        navigator.clipboard.writeText(json).then(() => {
          document.getElementById("output").textContent = "Скопирован в буфер!\n\n" + json
        })
      }
    }
  </script>
</body>
</html>
```

---

## 13. Ссылки на документацию

- [Working with Variables — Figma Developer Docs](https://developers.figma.com/docs/plugins/working-with-variables/)
- [figma.variables — API Reference](https://developers.figma.com/docs/plugins/api/figma-variables/)
- [Variable — properties](https://developers.figma.com/docs/plugins/api/Variable/)
- [VariableCollection — properties](https://developers.figma.com/docs/plugins/api/VariableCollection/)
- [VariableScope — types](https://developers.figma.com/docs/plugins/api/VariableScope/)
- [Extended Collections](https://developers.figma.com/docs/plugins/api/ExtendedVariableCollection/)
- [Plugin API Updates (changelog)](https://developers.figma.com/docs/plugins/updates/)