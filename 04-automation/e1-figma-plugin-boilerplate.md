---
title: "E1 Figma Plugin Boilerplate"
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
description: "Boilerplate template and setup guide for Figma plugin development"
---

# E1 — Boilerplate для Figma плагинов

> **Автор:** Ray (@uixray)  
> **Дата:** 2026-02-21  
> **Назначение:** Единый шаблон проекта для всех плагинов экосистемы Ray's Design Toolkit  
> **Оценка:** ~12–16 ч на создание и отладку

---

## 1. Цель и обоснование

Boilerplate — фундамент экосистемы. Каждый новый плагин стартует с этого шаблона, получая из коробки:

- Настроенную сборку TypeScript → JavaScript (esbuild)
- Обёртки над Figma API (storage, selection, messaging, fonts)
- Базовый UI-каркас с поддержкой тёмной/светлой темы (E2)
- Типизированный postMessage-протокол между code ↔ UI
- Утилиты для частых операций (обход дерева, экспорт, цвета)
- Конфигурацию для публикации

**Без boilerplate:** каждый плагин = 2–4 часа на boilerplate-код + повторяющиеся баги.  
**С boilerplate:** `cp -r boilerplate/ my-plugin/` → 5 минут → пишем бизнес-логику.

---

## 2. Технологический стек

|Инструмент|Назначение|Почему|
|---|---|---|
|**TypeScript**|Язык|Type safety, автокомплит для Figma API|
|**esbuild**|Сборка|Мгновенная компиляция (<100ms), zero-config|
|**@figma/plugin-typings**|Типы|Официальные типы для `figma.*` API|
|**concurrently**|Dev mode|Параллельный watch для code.ts и ui.html|

> **Почему не Webpack/Vite?** esbuild проще, быстрее, не требует конфигурации. Для плагинов Figma (один файл на выходе) он идеален. Webpack оправдан только для UI с React/Vue — но мы используем ванильный HTML/CSS/JS для максимальной простоты.

---

## 3. Структура проекта

```
figma-plugin-boilerplate/
│
├── 📁 src/
│   ├── code.ts                 ← Точка входа main thread
│   ├── ui.html                 ← Точка входа UI (единый HTML)
│   │
│   ├── 📁 shared/              ← Переиспользуемые модули (code thread)
│   │   ├── storage.ts          ← Обёртка clientStorage + pluginData
│   │   ├── selection.ts        ← Работа с выделением
│   │   ├── messaging.ts        ← Типизированный postMessage
│   │   ├── traverse.ts         ← Обход дерева нод
│   │   ├── fonts.ts            ← Загрузка шрифтов
│   │   ├── colors.ts           ← Утилиты цвета (hex↔rgb, contrast)
│   │   ├── export.ts           ← Экспорт нод (PNG, SVG)
│   │   └── notify.ts           ← Обёртки для figma.notify
│   │
│   └── 📁 ui/                  ← Модули для UI (инлайнятся в html)
│       ├── theme.css           ← CSS-переменные, базовые стили (E2)
│       ├── components.css      ← Кнопки, инпуты, карточки
│       └── messaging.ts        ← postMessage helpers для UI стороны
│
├── manifest.json               ← Манифест плагина
├── package.json
├── tsconfig.json
├── esbuild.config.mjs          ← Конфигурация сборки
├── .gitignore
├── LICENSE
└── README.md
```

### Что собирается и куда

```
src/code.ts  ──esbuild──►  dist/code.js     (main thread bundle)
src/ui.html  ──copy────►  dist/ui.html      (CSS/JS инлайнятся при сборке)

manifest.json → указывает на dist/code.js и dist/ui.html
```

---

## 4. Файлы конфигурации

### 4.1 package.json

```json
{
  "name": "figma-plugin-name",
  "version": "1.0.0",
  "description": "Описание плагина",
  "author": "Ray (@uixray)",
  "license": "MIT",
  "scripts": {
    "build": "node esbuild.config.mjs",
    "watch": "node esbuild.config.mjs --watch",
    "dev": "concurrently \"npm run watch\" \"echo Dev mode ready\"",
    "clean": "rimraf dist"
  },
  "devDependencies": {
    "@figma/plugin-typings": "^1.103.0",
    "esbuild": "^0.24.0",
    "concurrently": "^9.1.0",
    "typescript": "^5.7.0",
    "rimraf": "^6.0.0"
  }
}
```

### 4.2 tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noEmit": true,
    "jsx": "react",
    "jsxFactory": "h",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": false,
    "typeRoots": [
      "node_modules/@figma/plugin-typings"
    ]
  },
  "include": ["src/**/*.ts", "src/**/*.tsx"],
  "exclude": ["node_modules", "dist"]
}
```

### 4.3 esbuild.config.mjs

```javascript
import { build, context } from 'esbuild';
import { readFileSync, writeFileSync, copyFileSync, mkdirSync, existsSync } from 'fs';
import { resolve, dirname } from 'path';

// Проверяем флаг --watch
const isWatch = process.argv.includes('--watch');

// Убедиться что dist/ существует
if (!existsSync('dist')) mkdirSync('dist');

// ═══════════════════════════════════════
// 1. Сборка code.ts → dist/code.js
// ═══════════════════════════════════════
const codeBuildOptions = {
  entryPoints: ['src/code.ts'],
  bundle: true,
  outfile: 'dist/code.js',
  target: 'es2020',
  format: 'iife',      // Figma ожидает IIFE (не ESM)
  sourcemap: false,
  minify: !isWatch,     // Минификация только для прод-сборки
  logLevel: 'info',
};

// ═══════════════════════════════════════
// 2. Обработка ui.html — инлайн CSS
// ═══════════════════════════════════════
function buildUI() {
  let html = readFileSync('src/ui.html', 'utf-8');

  // Инлайним theme.css и components.css
  const themeCSS = readFileSync('src/ui/theme.css', 'utf-8');
  const componentsCSS = readFileSync('src/ui/components.css', 'utf-8');

  // Заменяем <!-- INLINE_CSS --> на содержимое CSS
  html = html.replace(
    '<!-- INLINE_CSS -->',
    `<style>\n${themeCSS}\n${componentsCSS}\n</style>`
  );

  // Если есть ui-side JS модуль — тоже инлайним
  // (для простых плагинов JS пишется прямо в ui.html)
  try {
    const uiJS = readFileSync('src/ui/messaging.ts', 'utf-8');
    // Для TS в UI нужен отдельный esbuild pass или пишем на чистом JS
  } catch { /* файл необязателен */ }

  writeFileSync('dist/ui.html', html);
  console.log('✅ ui.html собран');
}

// ═══════════════════════════════════════
// 3. Копирование manifest.json
// ═══════════════════════════════════════
function copyManifest() {
  // Обновляем пути в manifest для dist/
  const manifest = JSON.parse(readFileSync('manifest.json', 'utf-8'));
  manifest.main = 'code.js';
  manifest.ui = 'ui.html';
  writeFileSync('dist/manifest.json', JSON.stringify(manifest, null, 2));
  console.log('✅ manifest.json скопирован');
}

// ═══════════════════════════════════════
// Запуск
// ═══════════════════════════════════════
async function main() {
  if (isWatch) {
    // Watch mode: пересборка при изменениях
    const ctx = await context(codeBuildOptions);
    await ctx.watch();
    console.log('👀 Watch mode: code.ts');

    // Для UI — простой watch через setInterval (esbuild не умеет watch HTML)
    buildUI();
    copyManifest();

    // Пересборка UI каждые 2 секунды (простое решение)
    // В продвинутом варианте: chokidar для file watching
    const { watch } = await import('fs');
    for (const file of ['src/ui.html', 'src/ui/theme.css', 'src/ui/components.css']) {
      watch(file, () => {
        console.log(`🔄 ${file} изменён`);
        buildUI();
      });
    }
  } else {
    // Разовая сборка
    await build(codeBuildOptions);
    buildUI();
    copyManifest();
    console.log('🏁 Сборка завершена: dist/');
  }
}

main().catch(console.error);
```

### 4.4 manifest.json (шаблон)

```json
{
  "name": "Plugin Name",
  "id": "000000000000000000",
  "api": "1.0.0",
  "editorType": ["figma"],
  "main": "code.js",
  "ui": "ui.html",
  "documentAccess": "dynamic-page",
  "networkAccess": {
    "allowedDomains": ["none"],
    "devAllowedDomains": ["http://localhost:3000"]
  },
  "permissions": [],
  "menu": [
    { "name": "Open Plugin", "command": "open" }
  ]
}
```

### 4.5 .gitignore

```
node_modules/
dist/
*.js
!esbuild.config.mjs
.DS_Store
```

---

## 5. Shared-модули (ядро boilerplate)

### 5.1 storage.ts — Обёртка хранилища

```typescript
// src/shared/storage.ts
// Безопасная обёртка над figma.clientStorage и pluginData

/** Префикс для изоляции ключей между плагинами */
const STORAGE_PREFIX = 'rdt:'; // Ray's Design Toolkit

// ═══════════════════════════════════════
// ClientStorage — локальное хранилище (5 MB, на машине пользователя)
// ═══════════════════════════════════════

/** Сохранить значение в локальное хранилище */
export async function storageSet<T>(key: string, value: T): Promise<void> {
  await figma.clientStorage.setAsync(STORAGE_PREFIX + key, value);
}

/** Получить значение из локального хранилища */
export async function storageGet<T>(key: string, fallback: T): Promise<T> {
  const value = await figma.clientStorage.getAsync(STORAGE_PREFIX + key);
  return value !== undefined ? value : fallback;
}

/** Удалить значение */
export async function storageDelete(key: string): Promise<void> {
  await figma.clientStorage.deleteAsync(STORAGE_PREFIX + key);
}

/** Получить все ключи плагина */
export async function storageKeys(): Promise<string[]> {
  const allKeys = await figma.clientStorage.keysAsync();
  return allKeys
    .filter(k => k.startsWith(STORAGE_PREFIX))
    .map(k => k.slice(STORAGE_PREFIX.length));
}

// ═══════════════════════════════════════
// PluginData — данные на ноде (синхронизируются между пользователями файла)
// ═══════════════════════════════════════

/** Сохранить JSON-данные на ноде */
export function setNodeData<T>(node: SceneNode | DocumentNode, key: string, data: T): void {
  node.setPluginData(key, JSON.stringify(data));
}

/** Получить JSON-данные с ноды */
export function getNodeData<T>(node: SceneNode | DocumentNode, key: string): T | null {
  const raw = node.getPluginData(key);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as T;
  } catch {
    return null;
  }
}

/** Удалить данные с ноды */
export function deleteNodeData(node: SceneNode | DocumentNode, key: string): void {
  node.setPluginData(key, '');
}

/** Получить все ключи pluginData на ноде */
export function getNodeDataKeys(node: SceneNode | DocumentNode): string[] {
  return node.getPluginDataKeys();
}

// ═══════════════════════════════════════
// Данные на уровне документа (figma.root)
// ═══════════════════════════════════════

/** Сохранить данные на уровне файла (видны всем пользователям) */
export function setDocData<T>(key: string, data: T): void {
  setNodeData(figma.root, key, data);
}

/** Получить данные на уровне файла */
export function getDocData<T>(key: string): T | null {
  return getNodeData(figma.root, key);
}
```

### 5.2 selection.ts — Работа с выделением

```typescript
// src/shared/selection.ts
// Утилиты для безопасной работы с figma.currentPage.selection

/** Тип-предикат для фильтрации нод */
type NodePredicate<T extends SceneNode> = (node: SceneNode) => node is T;

/** Получить текущее выделение (пустой массив если ничего не выделено) */
export function getSelection(): readonly SceneNode[] {
  return figma.currentPage.selection;
}

/** Получить выделение с проверкой — минимум одна нода */
export function requireSelection(minCount: number = 1): SceneNode[] | null {
  const sel = figma.currentPage.selection;
  if (sel.length < minCount) {
    figma.notify(`⚠️ Выделите минимум ${minCount} элемент(ов)`, { timeout: 3000 });
    return null;
  }
  return [...sel];
}

/** Получить выделение определённого типа */
export function getSelectionOfType<T extends SceneNode>(
  typeName: NodeType
): T[] {
  return figma.currentPage.selection.filter(
    (n): n is T => n.type === typeName
  ) as T[];
}

/** Получить только фреймы из выделения */
export function getSelectedFrames(): FrameNode[] {
  return getSelectionOfType<FrameNode>('FRAME');
}

/** Получить только текстовые ноды из выделения */
export function getSelectedTexts(): TextNode[] {
  return getSelectionOfType<TextNode>('TEXT');
}

/** Получить только инстансы из выделения */
export function getSelectedInstances(): InstanceNode[] {
  return getSelectionOfType<InstanceNode>('INSTANCE');
}

/** Выделить ноды и центрировать viewport */
export function focusNodes(nodes: SceneNode[]): void {
  if (nodes.length === 0) return;
  figma.currentPage.selection = nodes;
  figma.viewport.scrollAndZoomIntoView(nodes);
}

/** Выделить одну ноду и центрировать */
export function focusNode(node: SceneNode): void {
  focusNodes([node]);
}
```

### 5.3 messaging.ts — Типизированный postMessage

```typescript
// src/shared/messaging.ts
// Типизированная коммуникация code ↔ UI

// ═══════════════════════════════════════
// Определяем протокол сообщений
// Каждый плагин расширяет эти типы
// ═══════════════════════════════════════

/** Базовые сообщения UI → Code (расширяются плагином) */
export interface BaseUIMessages {
  'close': undefined;
  'get-selection': undefined;
  'save-settings': { settings: any };
}

/** Базовые сообщения Code → UI (расширяются плагином) */
export interface BaseCodeMessages {
  'init': { settings: any };
  'selection-update': { nodes: NodeInfo[] };
  'error': { message: string };
  'success': { message: string };
}

/** Информация о ноде для передачи в UI */
export interface NodeInfo {
  id: string;
  name: string;
  type: string;
  width: number;
  height: number;
}

// ═══════════════════════════════════════
// Хелперы для code.ts (main thread)
// ═══════════════════════════════════════

/**
 * Отправить типизированное сообщение в UI
 * Использование: sendToUI('selection-update', { nodes: [...] })
 */
export function sendToUI<K extends keyof BaseCodeMessages>(
  type: K,
  payload: BaseCodeMessages[K]
): void {
  figma.ui.postMessage({ type, ...payload });
}

/** Отправить сообщение без payload */
export function sendToUISig<K extends keyof BaseCodeMessages>(
  type: K
): void {
  figma.ui.postMessage({ type });
}

/**
 * Типизированный обработчик сообщений от UI
 * Использование:
 *   onUIMessage('close', () => figma.closePlugin())
 *   onUIMessage('save-settings', (msg) => saveSettings(msg.settings))
 */
type MessageHandler<T> = (payload: T) => void | Promise<void>;
const handlers = new Map<string, MessageHandler<any>>();

export function onUIMessage<K extends keyof BaseUIMessages>(
  type: K,
  handler: MessageHandler<BaseUIMessages[K] extends undefined ? {} : BaseUIMessages[K]>
): void {
  handlers.set(type as string, handler);
}

/** Инициализация слушателя (вызвать один раз в code.ts) */
export function initMessageListener(): void {
  figma.ui.onmessage = async (msg: any) => {
    const handler = handlers.get(msg.type);
    if (handler) {
      try {
        await handler(msg);
      } catch (err: any) {
        console.error(`Ошибка в обработчике "${msg.type}":`, err);
        sendToUI('error', { message: err.message || 'Неизвестная ошибка' });
      }
    } else {
      console.warn(`Нет обработчика для сообщения: ${msg.type}`);
    }
  };
}

// ═══════════════════════════════════════
// Хелпер для отправки информации о selection
// ═══════════════════════════════════════

export function sendSelectionInfo(): void {
  const nodes: NodeInfo[] = figma.currentPage.selection.map(n => ({
    id: n.id,
    name: n.name,
    type: n.type,
    width: Math.round('width' in n ? n.width : 0),
    height: Math.round('height' in n ? n.height : 0),
  }));
  sendToUI('selection-update', { nodes });
}
```

### 5.4 traverse.ts — Обход дерева нод

```typescript
// src/shared/traverse.ts
// Рекурсивный обход дерева нод с фильтрацией

/** Параметры обхода */
export interface TraverseOptions {
  /** Включать невидимые ноды (visible: false) */
  includeHidden?: boolean;
  /** Включать заблокированные ноды (locked: true) */
  includeLocked?: boolean;
  /** Максимальная глубина вложенности (0 = только верхний уровень) */
  maxDepth?: number;
  /** Пропускать ноды внутри инстансов */
  skipInstances?: boolean;
}

const DEFAULT_OPTIONS: TraverseOptions = {
  includeHidden: false,
  includeLocked: true,
  maxDepth: Infinity,
  skipInstances: false,
};

/**
 * Рекурсивный обход дерева нод.
 * Возвращает плоский массив всех нод, прошедших фильтр.
 * 
 * Пример: найти все текстовые ноды
 *   traverse(frame, node => node.type === 'TEXT')
 */
export function traverse(
  root: SceneNode | PageNode,
  filter?: (node: SceneNode) => boolean,
  options?: TraverseOptions
): SceneNode[] {
  const opts = { ...DEFAULT_OPTIONS, ...options };
  const results: SceneNode[] = [];

  function walk(node: SceneNode | PageNode, depth: number): void {
    // Проверяем глубину
    if (depth > (opts.maxDepth ?? Infinity)) return;

    // Для SceneNode (не PageNode) проверяем фильтры видимости
    if ('visible' in node) {
      if (!opts.includeHidden && !node.visible) return;
      if (!opts.includeLocked && node.locked) return;
    }

    // Если у ноды есть тип (SceneNode), проверяем пользовательский фильтр
    if ('type' in node && node.type !== 'PAGE') {
      const sceneNode = node as SceneNode;
      if (!filter || filter(sceneNode)) {
        results.push(sceneNode);
      }
    }

    // Рекурсия в дочерние ноды
    if ('children' in node) {
      // Пропуск содержимого инстансов
      if (opts.skipInstances && 'type' in node && node.type === 'INSTANCE') return;

      for (const child of node.children) {
        walk(child, depth + 1);
      }
    }
  }

  walk(root, 0);
  return results;
}

/** Найти все ноды определённого типа */
export function findAllOfType<T extends SceneNode>(
  root: SceneNode | PageNode,
  nodeType: NodeType,
  options?: TraverseOptions
): T[] {
  return traverse(root, n => n.type === nodeType, options) as T[];
}

/** Найти все текстовые ноды */
export function findAllTexts(
  root: SceneNode | PageNode,
  options?: TraverseOptions
): TextNode[] {
  return findAllOfType<TextNode>(root, 'TEXT', options);
}

/** Найти все фреймы */
export function findAllFrames(
  root: SceneNode | PageNode,
  options?: TraverseOptions
): FrameNode[] {
  return findAllOfType<FrameNode>(root, 'FRAME', options);
}

/** Найти все инстансы */
export function findAllInstances(
  root: SceneNode | PageNode,
  options?: TraverseOptions
): InstanceNode[] {
  return findAllOfType<InstanceNode>(root, 'INSTANCE', options);
}

/**
 * Получить полный путь ноды в дереве
 * "Page 1 / Header / Logo / Text"
 */
export function getNodePath(node: SceneNode): string {
  const parts: string[] = [node.name];
  let current = node.parent;
  while (current && current.type !== 'DOCUMENT') {
    parts.unshift(current.name);
    current = current.parent;
  }
  return parts.join(' / ');
}

/**
 * Подсчёт нод по типам в поддереве
 * Возвращает: { TEXT: 12, FRAME: 5, INSTANCE: 3, ... }
 */
export function countNodeTypes(root: SceneNode | PageNode): Record<string, number> {
  const counts: Record<string, number> = {};
  traverse(root, (node) => {
    counts[node.type] = (counts[node.type] || 0) + 1;
    return true;
  }, { includeHidden: true });
  return counts;
}
```

### 5.5 fonts.ts — Загрузка шрифтов

```typescript
// src/shared/fonts.ts
// Безопасная загрузка шрифтов перед работой с текстом

/** Кеш уже загруженных шрифтов (в рамках одного запуска плагина) */
const loadedFonts = new Set<string>();

/** Ключ для кеша: "Inter::Regular" */
function fontKey(family: string, style: string): string {
  return `${family}::${style}`;
}

/** Загрузить шрифт, если ещё не загружен */
export async function loadFont(family: string, style: string): Promise<void> {
  const key = fontKey(family, style);
  if (loadedFonts.has(key)) return;

  await figma.loadFontAsync({ family, style });
  loadedFonts.add(key);
}

/** Загрузить шрифт по объекту FontName */
export async function loadFontName(fontName: FontName): Promise<void> {
  await loadFont(fontName.family, fontName.style);
}

/**
 * Загрузить все шрифты, используемые в TextNode.
 * Обрабатывает mixed fonts (разные стили в одном тексте).
 * ОБЯЗАТЕЛЬНО вызвать перед node.characters = ...
 */
export async function loadNodeFonts(node: TextNode): Promise<void> {
  // Если шрифт единый
  if (node.fontName !== figma.mixed) {
    await loadFontName(node.fontName as FontName);
    return;
  }

  // Mixed fonts: получаем все сегменты
  const segments = node.getStyledTextSegments(['fontName']);
  const unique = new Set<string>();

  for (const seg of segments) {
    const fn = seg.fontName as FontName;
    const key = fontKey(fn.family, fn.style);
    if (!unique.has(key)) {
      unique.add(key);
      await loadFont(fn.family, fn.style);
    }
  }
}

/**
 * Загрузить шрифты для массива текстовых нод.
 * Полезно перед batch-операциями.
 */
export async function loadFontsForNodes(nodes: TextNode[]): Promise<void> {
  for (const node of nodes) {
    await loadNodeFonts(node);
  }
}

/** Маппинг числового fontWeight → имя стиля (для Inter и большинства шрифтов) */
export const WEIGHT_TO_STYLE: Record<number, string> = {
  100: 'Thin',
  200: 'Extra Light',
  300: 'Light',
  400: 'Regular',
  500: 'Medium',
  600: 'Semi Bold',
  700: 'Bold',
  800: 'Extra Bold',
  900: 'Black',
};
```

### 5.6 colors.ts — Утилиты цвета

```typescript
// src/shared/colors.ts
// Конвертация цветов, контрастность, утилиты

/** Figma RGB (0–1) */
export interface RGB01 { r: number; g: number; b: number; }
export interface RGBA01 { r: number; g: number; b: number; a: number; }

/** HEX → Figma RGB (0–1) */
export function hexToRGB(hex: string): RGB01 {
  const clean = hex.replace('#', '');
  return {
    r: parseInt(clean.slice(0, 2), 16) / 255,
    g: parseInt(clean.slice(2, 4), 16) / 255,
    b: parseInt(clean.slice(4, 6), 16) / 255,
  };
}

/** HEX → Figma RGBA (0–1) */
export function hexToRGBA(hex: string, alpha: number = 1): RGBA01 {
  return { ...hexToRGB(hex), a: alpha };
}

/** Figma RGB (0–1) → HEX */
export function rgbToHex(color: RGB01): string {
  const r = Math.round(color.r * 255).toString(16).padStart(2, '0');
  const g = Math.round(color.g * 255).toString(16).padStart(2, '0');
  const b = Math.round(color.b * 255).toString(16).padStart(2, '0');
  return `#${r}${g}${b}`.toUpperCase();
}

/** Относительная яркость (luminance) для расчёта контраста */
export function relativeLuminance(color: RGB01): number {
  const [rs, gs, bs] = [color.r, color.g, color.b].map(c =>
    c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4)
  );
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}

/**
 * Контрастность по WCAG 2.1
 * Возвращает число от 1 (нет контраста) до 21 (макс. контраст)
 * AA: ≥ 4.5 для обычного текста, ≥ 3.0 для крупного
 * AAA: ≥ 7.0 для обычного текста, ≥ 4.5 для крупного
 */
export function contrastRatio(color1: RGB01, color2: RGB01): number {
  const l1 = relativeLuminance(color1);
  const l2 = relativeLuminance(color2);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

/** Проверка WCAG уровня */
export function getWCAGLevel(ratio: number, isLargeText: boolean = false): 'AAA' | 'AA' | 'FAIL' {
  if (isLargeText) {
    if (ratio >= 4.5) return 'AAA';
    if (ratio >= 3.0) return 'AA';
  } else {
    if (ratio >= 7.0) return 'AAA';
    if (ratio >= 4.5) return 'AA';
  }
  return 'FAIL';
}

/**
 * Извлечь цвет из fills ноды (первый solid fill).
 * Возвращает null если нет solid fill или fills === figma.mixed.
 */
export function getNodeFillColor(node: SceneNode): RGB01 | null {
  if (!('fills' in node)) return null;
  const fills = node.fills;
  if (fills === figma.mixed || !Array.isArray(fills)) return null;

  const solid = fills.find(f => f.type === 'SOLID' && f.visible !== false);
  if (!solid || solid.type !== 'SOLID') return null;

  return solid.color;
}

/**
 * Расстояние между двумя цветами в RGB (простой евклидов).
 * Для более точного сравнения используйте deltaE в OKLCH (нужна библиотека culori).
 */
export function colorDistance(a: RGB01, b: RGB01): number {
  return Math.sqrt(
    Math.pow(a.r - b.r, 2) +
    Math.pow(a.g - b.g, 2) +
    Math.pow(a.b - b.b, 2)
  );
}

/**
 * Создать Figma SolidPaint из HEX
 */
export function solidPaint(hex: string, opacity: number = 1): SolidPaint {
  return {
    type: 'SOLID',
    color: hexToRGB(hex),
    opacity,
  };
}
```

### 5.7 export.ts — Экспорт нод

```typescript
// src/shared/export.ts
// Утилиты для экспорта нод в PNG/SVG/JPG

export interface ExportOptions {
  format: 'PNG' | 'SVG' | 'JPG' | 'PDF';
  /** Scale factor (только для PNG/JPG). По умолчанию 2 */
  scale?: number;
  /** Ограничение по ширине (px). Альтернатива scale */
  maxWidth?: number;
}

/** Экспортировать ноду в байты */
export async function exportNode(
  node: SceneNode,
  options: ExportOptions = { format: 'PNG' }
): Promise<Uint8Array> {
  const settings: ExportSettings = { format: options.format } as ExportSettings;

  if (options.format === 'PNG' || options.format === 'JPG') {
    if (options.maxWidth) {
      (settings as ExportSettingsImage).constraint = {
        type: 'WIDTH',
        value: options.maxWidth,
      };
    } else {
      (settings as ExportSettingsImage).constraint = {
        type: 'SCALE',
        value: options.scale ?? 2,
      };
    }
  }

  return await node.exportAsync(settings);
}

/** Экспортировать ноду как Base64-строку (для передачи в UI) */
export async function exportNodeBase64(
  node: SceneNode,
  options: ExportOptions = { format: 'PNG' }
): Promise<string> {
  const bytes = await exportNode(node, options);
  return figma.base64Encode(bytes);
}

/**
 * Экспортировать ноду как thumbnail (маленький preview).
 * Возвращает base64 PNG с шириной 200px.
 */
export async function exportThumbnail(node: SceneNode): Promise<string> {
  return exportNodeBase64(node, { format: 'PNG', maxWidth: 200 });
}
```

### 5.8 notify.ts — Уведомления

```typescript
// src/shared/notify.ts
// Обёртки над figma.notify для удобства

/** Обычное уведомление (серое) */
export function notify(message: string, timeout: number = 3000): void {
  figma.notify(message, { timeout });
}

/** Уведомление об успехе (с галочкой) */
export function notifySuccess(message: string): void {
  figma.notify(`✓ ${message}`, { timeout: 3000 });
}

/** Уведомление об ошибке (красное) */
export function notifyError(message: string): void {
  figma.notify(`⚠️ ${message}`, { timeout: 5000, error: true });
}

/** Уведомление с кнопкой действия */
export function notifyWithAction(
  message: string,
  actionLabel: string,
  onAction: () => void,
  timeout: number = 10000
): void {
  figma.notify(message, {
    timeout,
    button: {
      text: actionLabel,
      action: onAction,
    },
  });
}
```

---

## 6. UI-каркас (E2 integration)

### 6.1 theme.css — Базовые стили

```css
/* src/ui/theme.css
 * Единый стиль для всех плагинов экосистемы.
 * Использует CSS-переменные Figma (themeColors: true).
 * Поддерживает светлую и тёмную тему автоматически.
 */

/* ═══ Сброс ═══ */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

/* ═══ Кастомные переменные поверх Figma ═══ */
:root {
  /* Figma предоставляет: --figma-color-bg, --figma-color-text, --figma-color-border, --figma-color-text-secondary */
  /* Добавляем свои: */
  --rdt-radius-sm: 4px;
  --rdt-radius-md: 6px;
  --rdt-radius-lg: 8px;
  --rdt-space-xs: 4px;
  --rdt-space-sm: 8px;
  --rdt-space-md: 12px;
  --rdt-space-lg: 16px;
  --rdt-space-xl: 24px;
  --rdt-font-size-xs: 11px;
  --rdt-font-size-sm: 12px;
  --rdt-font-size-md: 13px;
  --rdt-font-size-lg: 14px;
  --rdt-transition: 150ms ease;

  /* Цвета статусов */
  --rdt-color-success: #34A853;
  --rdt-color-warning: #FBBC04;
  --rdt-color-error: #EA4335;
  --rdt-color-info: #4285F4;
}

/* ═══ Базовые элементы ═══ */
html, body {
  width: 100%;
  height: 100%;
  overflow: hidden;
}

body {
  font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  font-size: var(--rdt-font-size-md);
  line-height: 1.5;
  color: var(--figma-color-text, #333);
  background: var(--figma-color-bg, #fff);
  padding: var(--rdt-space-lg);
  overflow-y: auto;
}

/* ═══ Скроллбар ═══ */
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb {
  background: var(--figma-color-border, #ccc);
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
  background: var(--figma-color-text-secondary, #999);
}

/* ═══ Типографика ═══ */
h1, h2, h3, h4 {
  font-weight: 600;
  line-height: 1.3;
  color: var(--figma-color-text, #1a1a1a);
}
h3 { font-size: var(--rdt-font-size-lg); margin-bottom: var(--rdt-space-md); }
h4 { font-size: var(--rdt-font-size-md); margin-bottom: var(--rdt-space-sm); }

p { margin-bottom: var(--rdt-space-sm); }

.text-secondary {
  color: var(--figma-color-text-secondary, #666);
  font-size: var(--rdt-font-size-sm);
}

.text-xs {
  font-size: var(--rdt-font-size-xs);
  color: var(--figma-color-text-secondary, #999);
}

/* ═══ Секции ═══ */
.section {
  margin-bottom: var(--rdt-space-lg);
}

.section + .section {
  border-top: 1px solid var(--figma-color-border, #e5e5e5);
  padding-top: var(--rdt-space-lg);
}

/* ═══ Flex утилиты ═══ */
.row { display: flex; align-items: center; gap: var(--rdt-space-sm); }
.row-between { display: flex; align-items: center; justify-content: space-between; }
.col { display: flex; flex-direction: column; gap: var(--rdt-space-sm); }
.gap-xs { gap: var(--rdt-space-xs); }
.gap-md { gap: var(--rdt-space-md); }
.gap-lg { gap: var(--rdt-space-lg); }
.flex-1 { flex: 1; }

/* ═══ Разделитель ═══ */
.divider {
  height: 1px;
  background: var(--figma-color-border, #e5e5e5);
  margin: var(--rdt-space-md) 0;
}
```

### 6.2 components.css — UI-компоненты

```css
/* src/ui/components.css
 * Переиспользуемые UI компоненты для плагинов.
 */

/* ═══ Кнопки ═══ */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--rdt-space-xs);
  padding: 6px 12px;
  border: none;
  border-radius: var(--rdt-radius-md);
  font-size: var(--rdt-font-size-sm);
  font-weight: 500;
  cursor: pointer;
  transition: opacity var(--rdt-transition), background var(--rdt-transition);
  line-height: 1;
  white-space: nowrap;
}
.btn:hover { opacity: 0.85; }
.btn:active { opacity: 0.7; }
.btn:disabled { opacity: 0.4; cursor: not-allowed; }

/* Primary (акцентная) */
.btn-primary {
  background: var(--figma-color-bg-brand, #0C8CE9);
  color: #fff;
}

/* Secondary (обводка) */
.btn-secondary {
  background: transparent;
  border: 1px solid var(--figma-color-border, #ccc);
  color: var(--figma-color-text, #333);
}
.btn-secondary:hover { background: var(--figma-color-bg-hover, #f5f5f5); }

/* Ghost (только текст) */
.btn-ghost {
  background: transparent;
  color: var(--figma-color-text-secondary, #666);
}
.btn-ghost:hover { color: var(--figma-color-text, #333); }

/* Danger (красная) */
.btn-danger {
  background: var(--rdt-color-error);
  color: #fff;
}

/* Full width */
.btn-full { width: 100%; }

/* ═══ Инпуты ═══ */
.input {
  width: 100%;
  padding: 6px 8px;
  border: 1px solid var(--figma-color-border, #ccc);
  border-radius: var(--rdt-radius-sm);
  font-size: var(--rdt-font-size-sm);
  background: var(--figma-color-bg, #fff);
  color: var(--figma-color-text, #333);
  outline: none;
  transition: border-color var(--rdt-transition);
}
.input:focus {
  border-color: var(--figma-color-bg-brand, #0C8CE9);
}
.input::placeholder {
  color: var(--figma-color-text-tertiary, #aaa);
}

/* Select */
.select {
  appearance: none;
  padding-right: 24px;
  background-image: url("data:image/svg+xml,%3Csvg width='10' height='6' viewBox='0 0 10 6' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M1 1L5 5L9 1' stroke='%23999' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 8px center;
}

/* ═══ Чекбоксы и радио ═══ */
.checkbox-label, .radio-label {
  display: flex;
  align-items: center;
  gap: var(--rdt-space-sm);
  font-size: var(--rdt-font-size-sm);
  cursor: pointer;
  user-select: none;
}

/* ═══ Карточки ═══ */
.card {
  background: var(--figma-color-bg, #fff);
  border: 1px solid var(--figma-color-border, #e5e5e5);
  border-radius: var(--rdt-radius-md);
  padding: var(--rdt-space-md);
  transition: border-color var(--rdt-transition);
}
.card:hover { border-color: var(--figma-color-text-secondary, #999); }
.card-clickable { cursor: pointer; }

/* ═══ Badges ═══ */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 2px 6px;
  border-radius: 10px;
  font-size: var(--rdt-font-size-xs);
  font-weight: 500;
}
.badge-error { background: #FFEAEA; color: var(--rdt-color-error); }
.badge-warning { background: #FFF8E1; color: #F57F17; }
.badge-success { background: #E6F4EA; color: var(--rdt-color-success); }
.badge-info { background: #E8F0FE; color: var(--rdt-color-info); }

/* ═══ Прогресс-бар ═══ */
.progress-bar {
  width: 100%;
  height: 4px;
  background: var(--figma-color-border, #e5e5e5);
  border-radius: 2px;
  overflow: hidden;
}
.progress-bar-fill {
  height: 100%;
  background: var(--figma-color-bg-brand, #0C8CE9);
  border-radius: 2px;
  transition: width 300ms ease;
}

/* ═══ Пустое состояние ═══ */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--rdt-space-xl);
  text-align: center;
  color: var(--figma-color-text-secondary, #999);
}
.empty-state-icon { font-size: 32px; margin-bottom: var(--rdt-space-sm); }

/* ═══ Список элементов ═══ */
.list-item {
  display: flex;
  align-items: center;
  gap: var(--rdt-space-sm);
  padding: var(--rdt-space-sm) var(--rdt-space-md);
  border-radius: var(--rdt-radius-sm);
  cursor: pointer;
  transition: background var(--rdt-transition);
}
.list-item:hover { background: var(--figma-color-bg-hover, #f5f5f5); }
.list-item-active { background: var(--figma-color-bg-selected, #EBF5FF); }

/* ═══ Tooltip ═══ */
.tooltip {
  position: relative;
}
.tooltip::after {
  content: attr(data-tooltip);
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  padding: 4px 8px;
  background: var(--figma-color-text, #333);
  color: var(--figma-color-bg, #fff);
  font-size: var(--rdt-font-size-xs);
  border-radius: var(--rdt-radius-sm);
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transition: opacity var(--rdt-transition);
}
.tooltip:hover::after { opacity: 1; }

/* ═══ Tabs ═══ */
.tabs {
  display: flex;
  border-bottom: 1px solid var(--figma-color-border, #e5e5e5);
  gap: 0;
}
.tab {
  padding: var(--rdt-space-sm) var(--rdt-space-md);
  font-size: var(--rdt-font-size-sm);
  color: var(--figma-color-text-secondary, #666);
  border-bottom: 2px solid transparent;
  cursor: pointer;
  transition: color var(--rdt-transition), border-color var(--rdt-transition);
  background: none;
  border-top: none;
  border-left: none;
  border-right: none;
}
.tab:hover { color: var(--figma-color-text, #333); }
.tab-active {
  color: var(--figma-color-bg-brand, #0C8CE9);
  border-bottom-color: var(--figma-color-bg-brand, #0C8CE9);
  font-weight: 500;
}
```

### 6.3 ui.html — Шаблон

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <!-- CSS инлайнится при сборке на место этого комментария -->
  <!-- INLINE_CSS -->
</head>
<body>

  <!-- ═══ Заголовок плагина ═══ -->
  <div class="row-between" style="margin-bottom: 12px;">
    <h3>🔧 Plugin Name</h3>
  </div>

  <!-- ═══ Основной контент (заменить) ═══ -->
  <div class="section">
    <p class="text-secondary">Выделите элементы и нажмите кнопку.</p>
  </div>

  <!-- ═══ Нижняя панель действий ═══ -->
  <div class="section">
    <div class="row" style="gap: 8px;">
      <button id="run-btn" class="btn btn-primary btn-full">Запустить</button>
      <button id="close-btn" class="btn btn-secondary">Закрыть</button>
    </div>
  </div>

  <!-- ═══ Статусная строка ═══ -->
  <div id="status" class="text-xs" style="margin-top: 8px;">
    Готово к работе
  </div>

  <script>
    // ═══════════════════════════════════════
    // UI → Code: отправка сообщений
    // ═══════════════════════════════════════
    function sendToCode(type, payload) {
      parent.postMessage({ pluginMessage: { type, ...payload } }, '*');
    }

    // ═══════════════════════════════════════
    // Code → UI: приём сообщений
    // ═══════════════════════════════════════
    window.onmessage = (event) => {
      const msg = event.data.pluginMessage;
      if (!msg) return;

      switch (msg.type) {
        case 'init':
          // Инициализация UI с данными из code.ts
          console.log('Init:', msg);
          break;

        case 'selection-update':
          document.getElementById('status').textContent =
            `Выделено: ${msg.nodes.length} элемент(ов)`;
          break;

        case 'error':
          document.getElementById('status').textContent = `⚠️ ${msg.message}`;
          break;

        case 'success':
          document.getElementById('status').textContent = `✓ ${msg.message}`;
          break;
      }
    };

    // ═══════════════════════════════════════
    // Обработчики событий
    // ═══════════════════════════════════════
    document.getElementById('run-btn').addEventListener('click', () => {
      sendToCode('run-main-action', {});
    });

    document.getElementById('close-btn').addEventListener('click', () => {
      sendToCode('close');
    });

    // Закрытие по ESC (если фокус не в input)
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && document.activeElement.tagName !== 'INPUT'
          && document.activeElement.tagName !== 'TEXTAREA') {
        sendToCode('close');
      }
    });
  </script>
</body>
</html>
```

### 6.4 code.ts — Точка входа (шаблон)

```typescript
// src/code.ts
// Точка входа main thread плагина
// Импортируем shared-модули (esbuild соберёт всё в один файл)

import { storageGet, storageSet } from './shared/storage';
import { requireSelection, focusNode } from './shared/selection';
import { sendToUI, onUIMessage, initMessageListener, sendSelectionInfo } from './shared/messaging';
import { notify, notifySuccess, notifyError } from './shared/notify';

// ═══════════════════════════════════════
// Инициализация
// ═══════════════════════════════════════

async function init() {
  // Показываем UI
  figma.showUI(__html__, {
    width: 320,
    height: 400,
    themeColors: true,
  });

  // Загружаем сохранённые настройки
  const settings = await storageGet('settings', {});

  // Отправляем начальные данные в UI
  sendToUI('init', { settings });
  sendSelectionInfo();
}

// ═══════════════════════════════════════
// Обработчики сообщений из UI
// ═══════════════════════════════════════

initMessageListener();

onUIMessage('close', () => {
  figma.closePlugin();
});

onUIMessage('get-selection', () => {
  sendSelectionInfo();
});

onUIMessage('save-settings', async (msg) => {
  await storageSet('settings', msg.settings);
  notifySuccess('Настройки сохранены');
});

// Пользовательский обработчик (заменить своей логикой)
// onUIMessage('run-main-action', async (msg) => {
//   const selection = requireSelection();
//   if (!selection) return;
//   // ... бизнес-логика ...
//   notifySuccess('Готово!');
// });

// ═══════════════════════════════════════
// Обработка изменения выделения
// ═══════════════════════════════════════

figma.on('selectionchange', () => {
  sendSelectionInfo();
});

// ═══════════════════════════════════════
// Обработка команд (из menu в manifest.json)
// ═══════════════════════════════════════

switch (figma.command) {
  case 'open':
  default:
    init();
    break;
}
```

---

## 7. Пошаговая инструкция: создание нового плагина

### Шаг 1: Копирование шаблона

```bash
# Копируем boilerplate
cp -r figma-plugin-boilerplate/ my-new-plugin/
cd my-new-plugin/

# Устанавливаем зависимости
npm install
```

### Шаг 2: Настройка manifest.json

Обновить 4 поля:

```json
{
  "name": "Pixel Audit",              ← Имя плагина
  "id": "000000000000000000",          ← ID из Figma (при публикации)
  "networkAccess": {
    "allowedDomains": ["none"]         ← Или список доменов если нужен fetch
  },
  "permissions": [],                   ← "currentuser", "teamlibrary" и др.
  "menu": [
    { "name": "Open Pixel Audit", "command": "open" }
  ]
}
```

### Шаг 3: Настройка package.json

```json
{
  "name": "figma-pixel-audit",
  "description": "Поиск нод с дробными координатами и авто-фикс"
}
```

### Шаг 4: Расширение типов сообщений

Создать файл с типами сообщений для плагина:

```typescript
// src/types.ts
// Расширяем базовые типы сообщений

import type { BaseUIMessages, BaseCodeMessages } from './shared/messaging';

// Сообщения от UI к Code
export interface UIMessages extends BaseUIMessages {
  'run-scan': { scope: 'selection' | 'page' };
  'fix-node': { nodeId: string; strategy: 'round' | 'floor' | 'ceil' };
  'fix-all': { strategy: 'round' | 'floor' | 'ceil' };
}

// Сообщения от Code к UI
export interface CodeMessages extends BaseCodeMessages {
  'scan-results': { issues: PixelIssue[] };
  'fix-complete': { fixedCount: number };
}

export interface PixelIssue {
  nodeId: string;
  nodeName: string;
  nodePath: string;
  property: 'x' | 'y' | 'width' | 'height';
  currentValue: number;
  roundedValue: number;
}
```

### Шаг 5: Написание бизнес-логики

```typescript
// src/code.ts — заменяем шаблонный код своей логикой
import { traverse, getNodePath } from './shared/traverse';
import { sendToUI, onUIMessage, initMessageListener } from './shared/messaging';
import { requireSelection } from './shared/selection';
import { notifySuccess } from './shared/notify';

// ... свой код ...
```

### Шаг 6: Сборка и подключение к Figma

```bash
# Сборка
npm run build

# Или watch-режим для разработки
npm run watch
```

**Подключение в Figma Desktop:**

1. Figma → Plugins → Development → Import plugin from manifest...
2. Указать путь к `dist/manifest.json`
3. Готово: плагин доступен через Plugins → Development → Plugin Name

### Шаг 7: Тестирование

```bash
# Watch mode — пересборка при любом изменении
npm run dev

# В Figma: Plugins → Development → Plugin Name
# Каждый раз при сохранении файла:
# 1. esbuild пересоберёт code.js (~50ms)
# 2. В Figma: Cmd+Opt+P (Mac) / Ctrl+Alt+P (Win) — перезапуск плагина
```

---

## 8. Чеклист при создании нового плагина

```markdown
## Setup
- [ ] Скопировал boilerplate
- [ ] Обновил name/description в package.json
- [ ] Обновил name/id/permissions/menu в manifest.json
- [ ] Добавил networkAccess.allowedDomains (если нужен fetch)
- [ ] npm install

## Development
- [ ] Определил типы сообщений (UIMessages, CodeMessages)
- [ ] Написал логику в code.ts
- [ ] Обновил UI в ui.html
- [ ] Добавил обработку selectionchange (если нужно)
- [ ] Добавил обработку figma.command (если menu с командами)

## Testing
- [ ] npm run build — без ошибок
- [ ] Подключил через Figma Desktop
- [ ] Проверил на пустом выделении (graceful error)
- [ ] Проверил на большом файле (производительность)
- [ ] Проверил тёмную тему Figma
- [ ] Проверил ESC закрывает плагин

## Publishing
- [ ] Создал иконку 128×128 (PNG)
- [ ] Написал описание для Figma Community
- [ ] Заполнил ID от Figma в manifest.json
- [ ] Сделал финальную сборку (npm run build с минификацией)
- [ ] Опубликовал
```

---

## 9. Скрипт автоматического создания нового плагина

Утилитарный скрипт для быстрого создания плагина из boilerplate:

```bash
#!/bin/bash
# create-plugin.sh — Создание нового плагина из boilerplate
# Использование: ./create-plugin.sh pixel-audit "Pixel Audit" "Поиск дробных координат"

PLUGIN_SLUG=$1       # pixel-audit
PLUGIN_NAME=$2       # "Pixel Audit"
PLUGIN_DESC=$3       # "Описание"

BOILERPLATE_DIR="./figma-plugin-boilerplate"
TARGET_DIR="./plugins/${PLUGIN_SLUG}"

if [ -z "$PLUGIN_SLUG" ] || [ -z "$PLUGIN_NAME" ]; then
  echo "Использование: ./create-plugin.sh <slug> <name> [description]"
  echo "Пример: ./create-plugin.sh pixel-audit \"Pixel Audit\" \"Поиск дробных координат\""
  exit 1
fi

if [ -d "$TARGET_DIR" ]; then
  echo "⚠️  Директория ${TARGET_DIR} уже существует!"
  exit 1
fi

echo "📦 Создаю плагин: ${PLUGIN_NAME} → ${TARGET_DIR}"

# Копируем boilerplate
cp -r "$BOILERPLATE_DIR" "$TARGET_DIR"

# Удаляем node_modules и dist если скопировались
rm -rf "${TARGET_DIR}/node_modules" "${TARGET_DIR}/dist"

# Обновляем package.json
cd "$TARGET_DIR"
sed -i "s/\"name\": \"figma-plugin-name\"/\"name\": \"figma-${PLUGIN_SLUG}\"/" package.json
sed -i "s/\"description\": \"Описание плагина\"/\"description\": \"${PLUGIN_DESC:-$PLUGIN_NAME}\"/" package.json

# Обновляем manifest.json
sed -i "s/\"name\": \"Plugin Name\"/\"name\": \"${PLUGIN_NAME}\"/" manifest.json
sed -i "s/\"name\": \"Open Plugin\"/\"name\": \"Open ${PLUGIN_NAME}\"/" manifest.json

# Обновляем заголовок в ui.html
sed -i "s/Plugin Name/${PLUGIN_NAME}/g" src/ui.html

# Устанавливаем зависимости
npm install

echo ""
echo "✅ Плагин создан: ${TARGET_DIR}"
echo ""
echo "Следующие шаги:"
echo "  cd ${TARGET_DIR}"
echo "  npm run dev          # запустить watch mode"
echo "  # Подключить dist/manifest.json в Figma Desktop"
echo ""
```

---

## 10. Структура репозиториев

### Вариант A: Mono-repo (рекомендуемый для старта)

```
rays-design-toolkit/
├── boilerplate/          ← E1 шаблон
├── plugins/
│   ├── pixel-audit/
│   ├── snapshotter/
│   ├── typograph/
│   └── ...
├── shared/               ← Общие модули (симлинк или npm workspace)
├── create-plugin.sh
├── package.json          ← workspaces: ["plugins/*"]
└── README.md
```

**Преимущества:** общие зависимости, один git history, легко шарить код.

### Вариант B: Multi-repo (для публикации)

```
github.com/uixray/
├── figma-plugin-boilerplate    ← Шаблон (template repo)
├── figma-pixel-audit
├── figma-snapshotter
├── figma-typograph
└── ...
```

**Преимущества:** каждый плагин — отдельный пакет, проще для контрибьюторов.

**Рекомендация:** Начать с mono-repo, при публикации — копировать/extract в отдельные репо.

---

## 11. Оценка трудозатрат

|Этап|Задача|Срок|
|---|---|---|
|1|Структура проекта, package.json, tsconfig, esbuild|2 ч|
|2|storage.ts + selection.ts|1.5 ч|
|3|messaging.ts (типизированный протокол)|2 ч|
|4|traverse.ts + fonts.ts|1.5 ч|
|5|colors.ts + export.ts + notify.ts|1.5 ч|
|6|theme.css + components.css (E2)|2 ч|
|7|ui.html (шаблон) + code.ts (шаблон)|1 ч|
|8|esbuild.config.mjs (сборка + watch + инлайн CSS)|1.5 ч|
|9|create-plugin.sh + README|1 ч|
|10|Тестирование: собрать тестовый плагин, проверить все модули|2 ч|
|**Итого**||**~16 ч (2–3 дня)**|

---

## 12. Что окупится сразу

Каждый из 15+ плагинов экосистемы получит из коробки:

|Что экономится|Сколько на плагин|На 15 плагинов|
|---|---|---|
|Настройка сборки (esbuild, TS)|~2 ч|~30 ч|
|Storage обёртки|~1 ч|~15 ч|
|Selection helpers|~30 мин|~7.5 ч|
|PostMessage boilerplate|~1 ч|~15 ч|
|Базовый UI (тема, стили)|~1.5 ч|~22.5 ч|
|Обход дерева, утилиты|~1 ч|~15 ч|
|**Итого**|**~7 ч**|**~105 ч**|

**Инвестиция 16 ч → экономия 105 ч.** ROI ≈ 6.5x.