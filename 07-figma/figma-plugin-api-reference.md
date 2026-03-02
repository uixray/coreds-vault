---
title: "Figma Plugin API Reference"
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
description: "Reference documentation for the Figma Plugin API"
---

2026-02-04
# Figma Plugin API — Справочник для вайбкодинга

> **Версия документа:** Январь 2026  
> **Источник:** Официальная документация Figma Developer Docs  
> **Назначение:** Контекст для Claude Projects при создании плагинов Figma

---

## 1. Архитектура плагина (Plugin Architecture)

Плагин состоит из **двух изолированных окружений**, которые общаются через `postMessage`:

```
┌─────────────────────────────────────────────────┐
│                   Figma Desktop App              │
│                                                 │
│  ┌─────────────────────┐   postMessage()        │
│  │   Main Thread        │ ◄──────────────────┐  │
│  │   (Sandbox / QuickJS)│                    │  │
│  │                     │ ──────────────────► │  │
│  │  • figma global obj  │                    │  │
│  │  • Работа с нодами   │  ┌────────────────┘  │
│  │  • ES6+ без DOM      │  │  <iframe>         │
│  │  • code.ts/code.js   │  │  (UI Thread)      │
│  │                     │  │                   │
│  │  ❌ fetch()          │  │  • HTML/CSS/JS    │
│  │  ❌ DOM APIs         │  │  • Browser APIs   │
│  │  ❌ XMLHttpRequest   │  │  • fetch()        │
│  └─────────────────────┘  │  • DOM            │
│                            │  • ui.html        │
│                            │                   │
│                            │  ❌ figma.*       │
│                            └───────────────────┘
└─────────────────────────────────────────────────┘
```

**Ключевые ограничения:**

- Один плагин и одно действие единовременно
- Фоновые процессы невозможны — плагин должен завершиться через `figma.closePlugin()`
- `localStorage`, `IndexedDB`, cookies **недоступны** в sandbox → используйте `figma.clientStorage`
- UI должен быть **единым HTML-файлом** — все CSS/JS инлайнируются или загружаются с CDN
- Поддерживаемые форматы изображений для вставки: PNG, JPG, GIF

---

## 2. Структура файлов и настройка (Project Setup)

### Минимальная структура проекта

```
my-plugin/
├── manifest.json        ← описание плагина (обязательный)
├── code.ts              ← main thread логика (компилируется в code.js)
├── ui.html              ← UI iframe
├── tsconfig.json
├── package.json
└── node_modules/
    └── @figma/plugin-typings   ← типы для figma.* API
```

### package.json (минимум)

```json
{
  "name": "my-figma-plugin",
  "devDependencies": {
    "@figma/plugin-typings": "latest"
  }
}
```

Установка типов:

```bash
npm install --save-dev @figma/plugin-typings
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "es6",
    "module": "commonjs",
    "strict": true,
    "jsx": "react",
    "typeRoots": ["node_modules/@figma/plugin-typings"]
  },
  "include": ["*.ts", "*.tsx"]
}
```

---

## 3. manifest.json — Полный справочник

### Полная структура

```json
{
  "name": "Название плагина",
  "id": "737805260747778092",
  "api": "1.0.0",
  "editorType": ["figma", "figjam"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["api.example.com", "*.cdn.example.com"],
    "devAllowedDomains": ["http://localhost:3000"]
  },
  "permissions": ["currentuser", "teamlibrary"],
  "capabilities": ["codegen", "inspect"],
  "menu": [
    { "name": "Основная функция", "command": "main" },
    { "separator": true },
    {
      "name": "Настройки",
      "menu": [
        { "name": "Конфигурация", "command": "settings" },
        { "name": "О плагине", "command": "about" }
      ]
    }
  ],
  "relaunchButtons": [
    { "command": "edit", "name": "Редактировать", "multipleSelection": false },
    { "command": "refresh", "name": "Обновить", "multipleSelection": true }
  ],
  "previewcommand": "tsc"
}
```

### Поля manifest.json

|Поле|Тип|Описание|
|---|---|---|
|`name`|string|Имя плагина в меню|
|`id`|string|Уникальный ID, выдаётся Figma при публикации|
|`api`|string|Версия API, всегда `"1.0.0"`|
|`main`|string|Путь к скомпилированному JS (main thread)|
|`ui`|string|Путь к HTML файлу (iframe)|
|`editorType`|string[]|`"figma"`, `"figjam"`, `"slides"`, `"buzz"`|
|`documentAccess`|string|`"dynamic-page"` — **рекомендуется** для всех новых плагинов|
|`networkAccess`|object|Список допустимых доменов для сетевых запросов|
|`permissions`|string[]|Необходимые права|
|`capabilities`|string[]|Дополнительные возможности|
|`menu`|array|Структура подменю|
|`relaunchButtons`|array|Кнопки повторного запуска на нодах|
|`previewcommand`|string|Команда сборки перед загрузкой (например `tsc`)|

### Permissions (права)

|Право|Для чего|
|---|---|
|`currentuser`|`figma.currentUser` — данные текущего пользователя|
|`activeusers`|`figma.activeUsers` — все активные пользователи файла|
|`fileusers`|Все пользователи файла|
|`payments`|Платные плагины|
|`teamlibrary`|Доступ к библиотекам команды|

> ⚠️ Если право не указано в `permissions`, вызов соответствующего API бросит исключение.

### documentAccess: dynamic-page (важно!)

При `"documentAccess": "dynamic-page"`:

- Страницы загружаются **по требованию**, а не все сразу
- Нужно использовать **async** версии API для работы со страницами
- `figma.currentPage` становится **read-only** → используйте `figma.setCurrentPageAsync()`
- Это **стандарт для всех новых плагинов**

---

## 4. Работа с нодами (Nodes API)

### Дерево документа

```
DocumentNode (figma.root)
  └── PageNode (figma.currentPage)
        ├── FrameNode
        │     ├── RectangleNode
        │     ├── TextNode
        │     └── InstanceNode (экземпляр компонента)
        ├── GroupNode
        ├── ComponentNode
        ├── VectorNode
        └── ...
```

### Типы нод (Node Types)

|Тип|Описание|
|---|---|
|`DOCUMENT`|Корень документа|
|`PAGE`|Страница|
|`FRAME`|Фрейм (основной контейнер)|
|`GROUP`|Группа|
|`RECTANGLE`|Прямоугольник|
|`ELLIPSE`|Эллипс|
|`TEXT`|Текстовый слой|
|`VECTOR`|Векторный путь|
|`COMPONENT`|Компонент|
|`COMPONENT_SET`|Набор компонентов|
|`INSTANCE`|Экземпляр компонента|
|`BOOLEAN_OPERATION`|Булева операция|
|`STAR`|Звезда|
|`POLYGON`|Полигон|
|`IMAGE`|Изображение|
|`SLICE`|Слайс|
|`STICKY`|Стикер (FigJam)|
|`SHAPE_WITH_TEXT_INSIDE`|Фигура с текстом (FigJam)|
|`CONNECTOR`|Коннектор (FigJam)|
|`TABLE`|Таблица|
|`GRID`|Сетка|

### Получение нод

```typescript
// Текущая выделенная нода
const selection: SceneNode[] = figma.currentPage.selection;

// Поиск первой ноды по условию
const textNode = figma.currentPage.findOne(
  (node) => node.type === "TEXT" && node.name === "Title"
);

// Поиск всех нод по условию
const allTexts = figma.currentPage.findAll(
  (node) => node.type === "TEXT"
);

// Получение ноды по ID (async, для dynamic-page)
const node = await figma.getNodeByIdAsync("123:456");

// Все дочерние ноды фрейма
if (frame.type === "FRAME") {
  const children: SceneNode[] = frame.children;
}
```

> ⚠️ `findAll()` по всему документу может быть медленным на больших файлах. Ограничивайте область поиска.

### Создание нод

```typescript
// Прямоугольник
const rect = figma.createRectangle();
rect.width = 200;
rect.height = 100;
rect.x = 50;
rect.y = 50;
rect.fills = [{ type: "SOLID", color: { r: 0.2, g: 0.4, b: 0.6 } }];
figma.currentPage.appendChild(rect);

// Текст (требует предварительной загрузки шрифта!)
await figma.loadFontAsync({ family: "Inter", style: "Regular" });
const text = figma.createText();
text.characters = "Hello, Figma!";
text.fontSize = 24;
text.fontName = { family: "Inter", style: "Regular" };
figma.currentPage.appendChild(text);

// Фрейм
const frame = figma.createFrame();
frame.name = "My Frame";
frame.width = 400;
frame.height = 300;
frame.fills = [{ type: "SOLID", color: { r: 1, g: 1, b: 1 } }];
figma.currentPage.appendChild(frame);

// Эллипс
const ellipse = figma.createEllipse();
ellipse.width = 100;
ellipse.height = 100;

// Компонент из существующей ноды
const component = figma.createComponentFromNode(someNode);

// Из SVG строки
const svgNode = figma.createNodeFromSVG(`<svg>...</svg>`);
```

### Модификация свойств нод

```typescript
// ⚠️ ВАЖНО: массивы свойств (fills, strokes) нельзя мутировать напрямую!
// Нужно создать копию, изменить, и присвоить обратно.

const node = figma.currentPage.selection[0];

// ❌ НЕПРАВИЛЬНО — мутация массива
node.fills[0].opacity = 0.5;  // НЕ СРАБОТАЕТ

// ✅ ПРАВИЛЬНО — копия + присвоение
const fills = [...node.fills];
fills[0] = { ...fills[0], opacity: 0.5 };
node.fills = fills;

// Аналогично для strokes
const strokes = [...node.strokes];
strokes[0] = { ...strokes[0], color: { r: 1, g: 0, b: 0 } };
node.strokes = strokes;
```

### Работа с экземплярами компонентов (Instances)

```typescript
// Создание экземпляра из компонента
if (component.type === "COMPONENT") {
  const instance = component.createInstance();
  figma.currentPage.appendChild(instance);
}

// Загрузка компонента из библиотеки по ключу
const comp = await figma.importComponentByKeyAsync("component_key_here");
const instance = comp.createInstance();

// Получение main component из экземпляра (async!)
if (node.type === "INSTANCE") {
  const mainComponent = await node.getMainComponentAsync();
}

// Сброс оверрайдов
if (node.type === "INSTANCE") {
  node.removeOverrides();
}
```

### Работа со стилями и переменными

```typescript
// Получение всех локальных стилей
const fillStyles = await figma.getLocalFillStylesAsync();
const strokeStyles = await figma.getLocalStrokeStylesAsync();
const textStyles = await figma.getLocalTextStylesAsync();

// Применение стиля по ID
node.fillStyleId = fillStyle.id;

// Для dynamic-page используем async setters:
await node.setFillStyleIdAsync(fillStyle.id);

// Работа с переменными
const collections = await figma.variables.getLocalVariableCollectionsAsync();
const variables = await figma.variables.getLocalVariablesAsync();

// Привязка переменной к свойству ноды
figma.bindVariableToNode(node, "fills.0.color", variable);
```

---

## 5. Коммуникация между main thread и UI (postMessage)

### Из UI → Main Thread (plugin code)

```html
<!-- ui.html -->
<script>
// Отправляем сообщение в main thread
parent.postMessage({ pluginMessage: { type: "do-something", data: { value: 42 } } }, "*");

// Для повышенной безопасности (если передаётся sensitive data):
parent.postMessage(
  { pluginMessage: { type: "secure-action" }, pluginId: "YOUR_PLUGIN_ID" },
  "https://www.figma.com"
);
</script>
```

### Из Main Thread → UI

```typescript
// code.ts — показ UI
figma.showUI(__html__, { width: 400, height: 500 });

// Отправка сообщения в UI
figma.ui.postMessage({ type: "update-data", payload: { items: [...] } });
```

### Приём сообщений

```typescript
// code.ts — приём сообщений от UI
figma.ui.onmessage = async (msg: any) => {
  switch (msg.type) {
    case "do-something":
      // обработка
      console.log("Получено:", msg.data);
      break;

    case "close":
      figma.closePlugin();
      break;
  }
};
```

```html
<!-- ui.html — приём сообщений от main thread -->
<script>
window.onmessage = (event: MessageEvent) => {
  const msg = event.data.pluginMessage;  // ⚠️ данные приходят в pluginMessage!
  if (msg.type === "update-data") {
    console.log("Получено в UI:", msg.payload);
  }
};
</script>
```

> ⚠️ Синтаксис **отличается** между UI и main thread:
> 
> - **UI отправляет**: `parent.postMessage({ pluginMessage: DATA }, "*")`
> - **Main thread отправляет**: `figma.ui.postMessage(DATA)`
> - **UI получает**: `event.data.pluginMessage`
> - **Main thread получает**: напрямую объект в `figma.ui.onmessage`

### Паттерн запрос-ответ (Request-Response)

```typescript
// code.ts
figma.ui.onmessage = async (msg: any) => {
  if (msg.type === "get-selection-info") {
    const info = figma.currentPage.selection.map((node) => ({
      id: node.id,
      name: node.name,
      type: node.type,
    }));
    // Отправляем ответ обратно
    figma.ui.postMessage({ type: "selection-info-response", data: info });
  }
};
```

```html
<script>
// ui.html — запрос данных
parent.postMessage({ pluginMessage: { type: "get-selection-info" } }, "*");

// Ожидание ответа
window.onmessage = (event: MessageEvent) => {
  const msg = event.data.pluginMessage;
  if (msg.type === "selection-info-response") {
    renderSelectionInfo(msg.data);
  }
};
</script>
```

---

## 6. Хранение данных (Storage)

### figma.clientStorage — локальное хранилище

Хранит данные **на машине пользователя** (не синхронизируется между пользователями). Квота: **5 MB** на плагин.

```typescript
// Сохранение
await figma.clientStorage.setAsync("user-prefs", {
  theme: "dark",
  autoSave: true,
  lastUsed: Date.now(),
});

// Получение
const prefs = await figma.clientStorage.getAsync("user-prefs");
// prefs === undefined, если ключ не найден

// Удаление
await figma.clientStorage.deleteAsync("user-prefs");

// Список всех ключей
const keys: string[] = await figma.clientStorage.keysAsync();
```

### setPluginData / getPluginData — данные на ноде

Данные хранятся **внутри ноды документа** и синхронизируются между всеми пользователями файла.

```typescript
// Сохранение данных на ноде
node.setPluginData("my-metadata", JSON.stringify({ tag: "processed", version: 2 }));

// Получение данных с ноды
const raw = node.getPluginData("my-metadata");
const data = raw ? JSON.parse(raw) : null;

// Список ключей плагина на ноде
const keys = node.getPluginDataKeys();
```

> ⚠️ `setPluginData` принимает только **строки**. Для объектов — `JSON.stringify` / `JSON.parse`.

### Обёртка для надёжной работы со storage

```typescript
// Удобная обёртка для clientStorage
class Storage {
  private static PREFIX = "my-plugin:";

  static async set(key: string, value: any): Promise<void> {
    await figma.clientStorage.setAsync(this.PREFIX + key, value);
  }

  static async get<T>(key: string, fallback: T): Promise<T> {
    const value = await figma.clientStorage.getAsync(this.PREFIX + key);
    return value ?? fallback;
  }

  static async delete(key: string): Promise<void> {
    await figma.clientStorage.deleteAsync(this.PREFIX + key);
  }
}

// Использование
await Storage.set("last-export-path", "/exports");
const path = await Storage.get<string>("last-export-path", "/default");
```

---

## 7. Сетевые запросы (Network Requests)

Сетевые запросы **невозможны** из main thread (sandbox). Они выполняются **только из UI iframe**.

### Паттерн: запрос из UI, обработка в main thread

```html
<!-- ui.html -->
<script>
async function fetchData() {
  try {
    const response = await fetch("https://api.example.com/data");
    const data = await response.json();
    // Передаём данные в main thread для работы с Figma
    parent.postMessage({ pluginMessage: { type: "apply-data", data } }, "*");
  } catch (err) {
    console.error("Network error:", err);
  }
}
</script>
```

```typescript
// code.ts — обработка полученных данных
figma.ui.onmessage = async (msg: any) => {
  if (msg.type === "apply-data") {
    // Используем data для модификации Figma-документа
    applyDataToCanvas(msg.data);
  }
};
```

### Загрузка изображения и вставка в Figma

```html
<script>
async function loadAndSendImage(url: string) {
  const response = await fetch(url);
  const arrayBuffer = await response.arrayBuffer();
  const bytes = new Uint8Array(arrayBuffer);
  // Передаём байты в main thread
  parent.postMessage({
    pluginMessage: { type: "insert-image", imageBytes: bytes }
  }, "*");
}
</script>
```

```typescript
// code.ts
figma.ui.onmessage = async (msg: any) => {
  if (msg.type === "insert-image") {
    const imageHash = await figma.createImage(new Uint8Array(msg.imageBytes)).hash;
    // Применяем как fill к ноде
    const node = figma.createRectangle();
    node.width = 400;
    node.height = 300;
    node.fills = [{
      type: "IMAGE",
      scaleMode: "FILL",
      imageHash: imageHash,
    }];
    figma.currentPage.appendChild(node);
  }
};
```

### networkAccess в manifest.json

```json
{
  "networkAccess": {
    "allowedDomains": [
      "api.example.com",
      "*.cdn.example.com",
      "https://specific-path.com/api/"
    ],
    "devAllowedDomains": [
      "http://localhost:3000"
    ]
  }
}
```

> ⚠️ Если плагин попытается сделать запрос к домену не из списка — запрос будет заблокирован.

---

## 8. UI: создание интерфейса

### Базовая структура ui.html

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    /* Figma предоставляет CSS-переменные для темы при themeColors: true */
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      margin: 0;
      padding: 16px;
      color: var(--figma-color-text, #000);
      background: var(--figma-color-bg, #fff);
    }
    button {
      background: var(--figma-color-ui, #0c99e4);
      color: white;
      border: none;
      border-radius: 4px;
      padding: 8px 16px;
      cursor: pointer;
    }
    button:hover { opacity: 0.85; }
  </style>
</head>
<body>
  <h3>Мой Плагин</h3>
  <button id="run-btn">Запустить</button>
  <button id="close-btn">Закрыть</button>

  <script>
    // Закрытие по ESC (вне input)
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && document.activeElement?.tagName !== "INPUT") {
        parent.postMessage({ pluginMessage: { type: "close" } }, "*");
      }
    });

    document.getElementById("run-btn")!.addEventListener("click", () => {
      parent.postMessage({ pluginMessage: { type: "run-main-action" } }, "*");
    });

    document.getElementById("close-btn")!.addEventListener("click", () => {
      parent.postMessage({ pluginMessage: { type: "close" } }, "*");
    });

    // Приём сообщений от main thread
    window.onmessage = (event: MessageEvent) => {
      const msg = event.data.pluginMessage;
      if (!msg) return;
      // обработка входящих сообщений
    };
  </script>
</body>
</html>
```

### figma.showUI — параметры

```typescript
figma.showUI(__html__, {
  width: 400,           // ширина окна в px
  height: 500,          // высота окна в px
  themeColors: true,    // передача CSS-переменных темы Figma
  relativeTo: "cursor", // позиция окна: "cursor" | "viewport"
});

// Изменение размера после открытия
figma.ui.resize(500, 600);
```

### Поддержка темы Figma

При `themeColors: true` доступны CSS-переменные:

- `--figma-color-bg` — фон
- `--figma-color-text` — текст
- `--figma-color-ui` — акцент UI
- `--figma-color-border` — границы

---

## 9. Async-операции и dynamic-page loading

При `"documentAccess": "dynamic-page"` многие API становятся **async**.

### Устаревшие (deprecated) vs. новые async API

|❌ Устаревший|✅ Новый async|
|---|---|
|`figma.getNodeById(id)`|`await figma.getNodeByIdAsync(id)`|
|`figma.currentPage = page`|`await figma.setCurrentPageAsync(page)`|
|`figma.getLocalStyles()`|`await figma.getLocalFillStylesAsync()`|
|`figma.variables.getLocalVariableCollections()`|`await figma.variables.getLocalVariableCollectionsAsync()`|
|`node.effectStyleId = id`|`await node.setEffectStyleIdAsync(id)`|
|`node.fillStyleId = id`|`await node.setFillStyleIdAsync(id)`|
|`node.strokeStyleId = id`|`await node.setStrokeStyleIdAsync(id)`|
|`instance.mainComponent`|`await instance.getMainComponentAsync()`|
|`component.instances`|`await component.getInstancesAsync()`|

### Загрузка шрифтов (обязательный async)

```typescript
// Шрифт ДОЛЖЕН быть загружен перед использованием
await figma.loadFontAsync({ family: "Inter", style: "Regular" });
await figma.loadFontAsync({ family: "Inter", style: "Bold" });

// Получение списка доступных шрифтов
const fonts = await figma.getAvailableFontsAsync();
```

### Работа со страницами

```typescript
// Список всех страниц
const pages = figma.root.children; // PageNode[]

// Загрузка и переход на страницу
const targetPage = pages.find(p => p.name === "Components");
if (targetPage) {
  await targetPage.loadAsync(); // Загружаем содержимое
  await figma.setCurrentPageAsync(targetPage);
}
```

---

## 10. Relaunch Buttons — кнопки повторного запуска

Позволяют пользователю повторно запустить плагин с конкретной ноды.

### Настройка в manifest.json

```json
{
  "relaunchButtons": [
    { "command": "edit", "name": "Edit Component" },
    { "command": "sync", "name": "Sync Data", "multipleSelection": true }
  ]
}
```

### Установка данных для relaunching

```typescript
// Сохраняем relaunch data на ноде
node.setRelaunchData({
  "edit": "Component ID: 123",  // ключ = command из manifest
  "sync": "Last synced: ..."
});

// При запуске через relaunch button:
const command = figma.command; // "edit" или "sync"
const relaunchData = node.relaunchData; // сохранённые данные
```

### Обработка команд

```typescript
// code.ts — обработка различных команд
figma.showUI(__html__);

switch (figma.command) {
  case "edit":
    // логика редактирования
    figma.ui.postMessage({ type: "mode", mode: "edit" });
    break;
  case "sync":
    // логика синхронизации
    figma.ui.postMessage({ type: "mode", mode: "sync" });
    break;
  default:
    // обычный запуск без команды
    figma.ui.postMessage({ type: "mode", mode: "default" });
}
```

---

## 11. Часто встречаемые паттерны и подводные камни

### 11.1 Паттерн: сохранение и восстановление настроек

```typescript
// code.ts
async function init() {
  figma.showUI(__html__, { width: 400, height: 500, themeColors: true });

  // Загружаем настройки из storage
  const settings = await figma.clientStorage.getAsync("plugin-settings");
  // Отправляем в UI
  figma.ui.postMessage({ type: "init", settings: settings || {} });
}

figma.ui.onmessage = async (msg: any) => {
  if (msg.type === "save-settings") {
    await figma.clientStorage.setAsync("plugin-settings", msg.settings);
  }
  if (msg.type === "close") {
    figma.closePlugin();
  }
};

init();
```

### 11.2 Паттерн: обработка выделения

```typescript
// Безопасная обработка selection с проверкой типов
function processSelection() {
  const selection = figma.currentPage.selection;

  if (selection.length === 0) {
    figma.ui.postMessage({ type: "error", message: "Ничего не выделено" });
    return;
  }

  for (const node of selection) {
    // Проверка типа перед доступом к специфичным свойствам
    if (node.type === "FRAME" || node.type === "COMPONENT") {
      processFrame(node);
    } else if (node.type === "TEXT") {
      processText(node);
    } else if (node.type === "INSTANCE") {
      processInstance(node);
    }
  }
}
```

### 11.3 Паттерн: рекурсивный обход дерева нод

```typescript
// Рекурсивный обход с фильтрацией по типу
function findAllTextNodes(node: SceneNode): TextNode[] {
  const results: TextNode[] = [];

  if (node.type === "TEXT") {
    results.push(node);
  }

  // Только контейнеры имеют children
  if ("children" in node) {
    for (const child of node.children) {
      results.push(...findAllTextNodes(child));
    }
  }

  return results;
}

// Использование
const texts = findAllTextNodes(figma.currentPage);
```

### 11.4 Подводные камни (Gotchas)

**1. Не забывайте `figma.closePlugin()`** Если плагин не вызывает `closePlugin()`, он остаётся "висящим" и блокирует другие плагины. Для плагинов без UI — вызывайте в конце main. Для плагинов с UI — по событию закрытия.

**2. Массивы свойств — иммутабельны** `fills`, `strokes`, `shadows`, `layoutGrids` — всё это возвращает **копию**. Мутация оригинала ничего не делает. Всегда: копия → изменение → присвоение.

**3. `figma.mixed`** Если у нескольких выделенных нод разные значения свойства, оно возвращает специальное значение `figma.mixed`. Всегда проверяйте на это.

```typescript
const fill = node.fills;
if (fill !== figma.mixed && fill.length > 0) {
  // безопасно работать с fill
}
```

**4. Шрифты** Шрифт должен быть загружен через `loadFontAsync()` **до** его использования в текстовых нодах. Иначе — runtime error.

**5. Изображения в Figma — через hash** Изображения сохраняются как hash. Для создания нового изображения: получаем bytes → `figma.createImage(bytes)` → используем `imageHash` как fill.

**6. ID ноды не уникален между файлами** Node ID уникален **внутри одного файла**, но может повторяться в разных файлах.

**7. `__html__` — встроенная переменная** `__html__` автоматически подставляется содержимым файла, указанного как `ui` в manifest.json. Использовать его можно только если UI задан через manifest.

---

## 12. Полный пример минимального плагина

### manifest.json

```json
{
  "name": "Color Swap",
  "id": "000000000000000000",
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

### code.ts

```typescript
// Показ UI с передачей темы
figma.showUI(__html__, { width: 320, height: 280, themeColors: true });

// Отправка информации о выделении при запуске
function sendSelectionInfo() {
  const info = figma.currentPage.selection.map((node) => ({
    id: node.id,
    name: node.name,
    type: node.type,
  }));
  figma.ui.postMessage({ type: "selection-update", data: info });
}

sendSelectionInfo();

// Обработка сообщений из UI
figma.ui.onmessage = async (msg: any) => {
  switch (msg.type) {
    case "swap-colors": {
      const { fromColor, toColor } = msg.payload;
      // Логика замены цветов на выделенных нодах
      for (const node of figma.currentPage.selection) {
        if ("fills" in node && node.fills !== figma.mixed) {
          const newFills = node.fills.map((fill) => {
            if (fill.type === "SOLID" && colorsMatch(fill.color, fromColor)) {
              return { ...fill, color: toColor };
            }
            return fill;
          });
          node.fills = newFills;
        }
      }
      figma.ui.postMessage({ type: "swap-done" });
      break;
    }

    case "close":
      figma.closePlugin();
      break;
  }
};

// Вспомогательная функция сравнения цветов
function colorsMatch(a: RGB, b: { r: number; g: number; b: number }): boolean {
  const tolerance = 0.01;
  return (
    Math.abs(a.r - b.r) < tolerance &&
    Math.abs(a.g - b.g) < tolerance &&
    Math.abs(a.b - b.b) < tolerance
  );
}
```

### ui.html

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      margin: 0;
      padding: 16px;
      color: var(--figma-color-text, #1a1a1a);
      background: var(--figma-color-bg, #ffffff);
    }
    h3 { margin: 0 0 16px; font-size: 14px; }
    .color-row { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
    .color-row label { font-size: 12px; width: 60px; }
    input[type="color"] { width: 40px; height: 32px; border: 1px solid var(--figma-color-border, #ccc); border-radius: 4px; cursor: pointer; }
    button {
      width: 100%;
      padding: 8px;
      background: var(--figma-color-ui, #0c99e4);
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 13px;
      margin-top: 8px;
    }
    button:hover { opacity: 0.85; }
    #status { font-size: 11px; color: var(--figma-color-text-secondary, #666); margin-top: 8px; }
  </style>
</head>
<body>
  <h3>Color Swap</h3>
  <div class="color-row">
    <label>From</label>
    <input type="color" id="from-color" value="#3366cc" />
  </div>
  <div class="color-row">
    <label>To</label>
    <input type="color" id="to-color" value="#cc3333" />
  </div>
  <button id="swap-btn">Swap Colors</button>
  <button id="close-btn" style="background: var(--figma-color-border, #ccc); color: var(--figma-color-text, #000);">Close</button>
  <div id="status">Выделите элементы и нажмите Swap</div>

  <script>
    // Утилита: hex → {r, g, b} в диапазоне 0-1
    function hexToRGB(hex: string) {
      const r = parseInt(hex.slice(1, 3), 16) / 255;
      const g = parseInt(hex.slice(3, 5), 16) / 255;
      const b = parseInt(hex.slice(5, 7), 16) / 255;
      return { r, g, b };
    }

    document.getElementById("swap-btn")!.addEventListener("click", () => {
      const fromHex = (document.getElementById("from-color") as HTMLInputElement).value;
      const toHex = (document.getElementById("to-color") as HTMLInputElement).value;

      parent.postMessage({
        pluginMessage: {
          type: "swap-colors",
          payload: {
            fromColor: hexToRGB(fromHex),
            toColor: hexToRGB(toHex),
          },
        },
      }, "*");
    });

    document.getElementById("close-btn")!.addEventListener("click", () => {
      parent.postMessage({ pluginMessage: { type: "close" } }, "*");
    });

    // Закрытие по ESC
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && document.activeElement?.tagName !== "INPUT") {
        parent.postMessage({ pluginMessage: { type: "close" } }, "*");
      }
    });

    // Приём сообщений из main thread
    window.onmessage = (event: MessageEvent) => {
      const msg = event.data.pluginMessage;
      if (!msg) return;

      if (msg.type === "selection-update") {
        document.getElementById("status")!.textContent =
          `Выделено: ${msg.data.length} элемент(ов)`;
      }
      if (msg.type === "swap-done") {
        document.getElementById("status")!.textContent = "✓ Цвета заменены";
      }
    };
  </script>
</body>
</html>
```

---

## 13. Ссылки на актуальную документацию

|Ресурс|URL|
|---|---|
|Главная документация плагинов|https://developers.figma.com/docs/plugins/|
|API Reference|https://developers.figma.com/docs/plugins/api/api-reference/|
|figma global object|https://www.figma.com/plugin-docs/api/figma/|
|Manifest справочник|https://www.figma.com/plugin-docs/manifest/|
|Создание UI|https://developers.figma.com/docs/plugins/creating-ui/|
|clientStorage API|https://www.figma.com/plugin-docs/api/figma-clientStorage/|
|TypeScript типы|https://github.com/figma/plugin-typings|
|Dynamic page loading|https://www.figma.com/plugin-docs/migrating-to-dynamic-loading/|
|Changelog (обновления API)|https://www.figma.com/plugin-docs/updates/|
|TypeScript boilerplate|https://github.com/aarongarciah/figma-plugin-typescript-boilerplate|