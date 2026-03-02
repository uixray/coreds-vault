---
title: "Eagle Plugin API Documentation"
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
description: "API documentation for the Eagle design asset manager plugin"
---

2026-02-04
# Eagle Plugin API — Документация для разработки плагинов

> Полная документация для создания плагинов Eagle.cool с помощью AI-ассистентов (vibe-coding).
> Версия: Eagle 4.0+
> Источник: https://developer.eagle.cool/plugin-api/

---

## Оглавление

1. [Введение](#введение)
2. [Типы плагинов](#типы-плагинов)
3. [Структура файлов плагина](#структура-файлов-плагина)
4. [manifest.json — Конфигурация](#manifestjson--конфигурация)
5. [API Reference](#api-reference)
   - [event — События](#event--события)
   - [item — Работа с файлами](#item--работа-с-файлами)
   - [folder — Работа с папками](#folder--работа-с-папками)
   - [tag — Работа с тегами](#tag--работа-с-тегами)
   - [library — Библиотека](#library--библиотека)
   - [window — Управление окном](#window--управление-окном)
   - [app — Приложение](#app--приложение)
   - [dialog — Диалоги](#dialog--диалоги)
   - [notification — Уведомления](#notification--уведомления)
   - [shell — Системные операции](#shell--системные-операции)
   - [clipboard — Буфер обмена](#clipboard--буфер-обмена)
   - [contextMenu — Контекстное меню](#contextmenu--контекстное-меню)
6. [Дополнительные модули](#дополнительные-модули)
7. [Примеры кода](#примеры-кода)
8. [Локализация (i18n)](#локализация-i18n)
9. [Публикация плагина](#публикация-плагина)

---

## Введение

Eagle Plugin API основан на веб-технологиях (HTML, CSS, JavaScript) и работает на базе:
- **Chromium 107** — нет проблем с совместимостью браузеров
- **Node.js 16** — доступ к нативным API и npm-модулям
- **Без CORS-ограничений** — плагины могут обращаться к любым URL

### Основные возможности

- Получение и модификация файлов/папок/тегов библиотеки
- Управление окном плагина
- Работа с буфером обмена
- Системные диалоги (открытие/сохранение файлов)
- Уведомления и контекстные меню
- Поддержка Node.js API и npm-модулей

---

## Типы плагинов

### 1. Window Plugin (Оконный плагин)
Открывается при клике пользователя, предоставляет интерактивный UI.

```json
{
  "main": {
    "url": "index.html",
    "width": 640,
    "height": 480
  }
}
```

### 2. Background Service Plugin (Фоновый сервис)
Автоматически запускается при старте Eagle, работает в фоне.

```json
{
  "main": {
    "serviceMode": true,
    "url": "index.html",
    "width": 640,
    "height": 480
  }
}
```

### 3. Format Extension Plugin (Расширение форматов)
Добавляет поддержку новых форматов файлов, превью и миниатюр.

```json
{
  "preview": {
    "extensions": ["custom"],
    "url": "preview.html"
  }
}
```

### 4. Inspector Extension Plugin (Расширение инспектора)
Добавляет панель в правую боковую панель Eagle с дополнительной информацией о файлах.

```json
{
  "inspector": {
    "extensions": ["jpg", "png"],
    "url": "inspector.html"
  }
}
```

---

## Структура файлов плагина

```
MyPlugin/
├── manifest.json      # Обязательно: метаданные и конфигурация
├── logo.png           # Иконка плагина (128×128 px, PNG)
├── index.html         # Главная HTML-страница
├── js/
│   └── plugin.js      # JavaScript-логика
├── css/
│   └── style.css      # Стили (опционально)
└── locales/           # Локализация (опционально)
    ├── en.json
    ├── zh_CN.json
    └── ru.json
```

---

## manifest.json — Конфигурация

Полный пример конфигурации:

```json
{
  "id": "LBCZE8V6LPCKD",
  "version": "1.0.0",
  "platform": "all",
  "arch": "all",
  "name": "My Plugin",
  "logo": "/logo.png",
  "keywords": ["utility", "automation"],
  "devTools": false,
  "dependencies": [],
  "main": {
    "url": "index.html",
    "width": 640,
    "height": 480,
    "minWidth": 320,
    "minHeight": 240,
    "maxWidth": 1920,
    "maxHeight": 1080,
    "alwaysOnTop": false,
    "frame": true,
    "fullscreenable": true,
    "maximizable": true,
    "minimizable": true,
    "resizable": true,
    "backgroundColor": "#ffffff",
    "multiple": false,
    "runAfterInstall": false,
    "serviceMode": false
  }
}
```

### Поля manifest.json

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | string | Уникальный ID плагина |
| `version` | string | Версия в формате semver (1.0.0) |
| `platform` | string | Платформа: `all`, `mac`, `win` |
| `arch` | string | Архитектура: `all`, `arm`, `x64` |
| `name` | string | Название плагина |
| `logo` | string | Путь к иконке (png, jpg, webp) |
| `keywords` | string[] | Ключевые слова для поиска |
| `devTools` | boolean | Открывать DevTools при запуске |
| `dependencies` | string[] | Зависимости: `["ai-sdk"]`, `["ffmpeg"]` |

### Поля main (настройки окна)

| Поле | Тип | По умолчанию | Описание |
|------|-----|--------------|----------|
| `url` | string | — | Точка входа (HTML-файл) |
| `width` | number | 640 | Ширина окна |
| `height` | number | 480 | Высота окна |
| `minWidth` | number | — | Минимальная ширина |
| `minHeight` | number | — | Минимальная высота |
| `maxWidth` | number | — | Максимальная ширина |
| `maxHeight` | number | — | Максимальная высота |
| `alwaysOnTop` | boolean | false | Всегда поверх других окон |
| `frame` | boolean | true | Показывать рамку окна |
| `resizable` | boolean | true | Разрешить изменение размера |
| `backgroundColor` | string | "#ffffff" | Цвет фона (HEX) |
| `multiple` | boolean | false | Разрешить несколько экземпляров |
| `serviceMode` | boolean | false | Фоновый режим |
| `runAfterInstall` | boolean | false | Запустить после установки |

---

## API Reference

### event — События

Регистрация callback-функций для событий Eagle.

```javascript
// Вызывается при создании окна плагина
eagle.onPluginCreate((plugin) => {
  console.log(plugin.manifest.name);    // Название плагина
  console.log(plugin.manifest.version); // Версия
  console.log(plugin.path);             // Путь к папке плагина
});

// Вызывается при клике на плагин в панели
eagle.onPluginRun(() => {
  console.log('Плагин запущен');
});

// Вызывается перед закрытием окна
eagle.onPluginBeforeExit(() => {
  console.log('Плагин закрывается');
});

// Вызывается при показе окна
eagle.onPluginShow(() => {
  console.log('Окно показано');
});

// Вызывается при скрытии окна
eagle.onPluginHide(() => {
  console.log('Окно скрыто');
});

// Вызывается при смене библиотеки
eagle.onLibraryChanged((libraryPath) => {
  console.log(`Новая библиотека: ${libraryPath}`);
});

// Вызывается при смене темы
eagle.onThemeChanged((theme) => {
  // theme: 'Auto', 'LIGHT', 'LIGHTGRAY', 'GRAY', 'DARK', 'BLUE', 'PURPLE'
  console.log(`Тема изменена: ${theme}`);
});
```

**Предотвращение закрытия окна:**
```javascript
window.onbeforeunload = (event) => {
  return event.returnValue = false;
};
```

---

### item — Работа с файлами

#### Методы получения файлов

```javascript
// Получить выбранные файлы
let selected = await eagle.item.getSelected();

// Получить файл по ID
let item = await eagle.item.getById('item_id');

// Получить файлы по массиву ID
let items = await eagle.item.getByIds(['id1', 'id2', 'id3']);

// Получить все файлы (осторожно с большими библиотеками!)
let allItems = await eagle.item.getAll();

// Универсальный поиск с фильтрами
let items = await eagle.item.get({
  ids: [],                    // Массив ID
  isSelected: true,           // Только выбранные
  isUntagged: true,           // Без тегов
  isUnfiled: true,            // Без папок
  keywords: ["design"],       // Ключевые слова
  tags: ["logo", "icon"],     // Теги
  folders: ["folder_id"],     // ID папок
  ext: "png",                 // Расширение
  annotation: "важное",       // Аннотация
  rating: 5,                  // Рейтинг (0-5)
  url: "dribbble.com",        // URL источника
  shape: "square",            // Форма: square, portrait, landscape, panoramic-portrait, panoramic-landscape
  fields: ["id", "name", "tags"] // Только нужные поля (оптимизация)
});

// Подсчёт файлов (быстрее чем get + length)
let count = await eagle.item.count({ ext: "jpg" });
let totalCount = await eagle.item.countAll();
let selectedCount = await eagle.item.countSelected();

// Получить ID и время модификации (для инкрементальной синхронизации)
let fileInfo = await eagle.item.getIdsWithModifiedAt();
// Результат: [{ id: "item_id", modifiedAt: 1234567890 }, ...]
```

#### Добавление файлов

```javascript
// Добавить из URL
const itemId = await eagle.item.addFromURL('https://example.com/image.jpg', {
  name: 'My Image',
  website: 'https://example.com',
  tags: ['download', 'web'],
  folders: ['folder_id'],
  annotation: 'Описание файла'
});

// Добавить из Base64
const itemId = await eagle.item.addFromBase64('data:image/png;base64,...', {
  name: 'Base64 Image',
  tags: ['generated']
});

// Добавить из локального пути
const itemId = await eagle.item.addFromPath('C:\\Users\\User\\image.png', {
  name: 'Local Image',
  tags: ['local']
});

// Добавить закладку
const itemId = await eagle.item.addBookmark('https://google.com', {
  name: 'Google',
  base64: 'data:image/png;base64,...', // Превью (опционально)
  tags: ['bookmark'],
  annotation: 'Поисковик'
});
```

#### Выбор и открытие файлов

```javascript
// Выбрать файлы (заменяет текущий выбор)
await eagle.item.select(['item_id_1', 'item_id_2']);

// Очистить выбор
await eagle.item.select([]);

// Открыть файл в списке
await eagle.item.open('item_id');

// Открыть в новом окне (Eagle 4.0 build12+)
await eagle.item.open('item_id', { window: true });
```

#### Класс Item — Свойства экземпляра

```javascript
let item = await eagle.item.getById('item_id');

// Только для чтения (read-only)
item.id;              // string - ID файла
item.ext;             // string - Расширение
item.isDeleted;       // boolean - В корзине?
item.palettes;        // Object[] - Цветовая палитра
item.size;            // number - Размер в байтах
item.modifiedAt;      // number - Время изменения (timestamp)
item.noThumbnail;     // boolean - Нет превью?
item.noPreview;       // boolean - Нельзя открыть двойным кликом?
item.filePath;        // string - Путь к файлу
item.fileURL;         // string - URL файла (file:///)
item.thumbnailPath;   // string - Путь к превью
item.thumbnailURL;    // string - URL превью (file:///)
item.metadataFilePath; // string - Путь к metadata.json

// Для чтения и записи (read-write)
item.name;            // string - Название
item.width;           // number - Ширина
item.height;          // number - Высота
item.url;             // string - URL источника
item.annotation;      // string - Аннотация
item.tags;            // string[] - Теги
item.folders;         // string[] - ID папок
item.star;            // number - Рейтинг (0-5)
item.importedAt;      // number - Время импорта (Eagle 4.0 build18+)
```

#### Методы экземпляра Item

```javascript
let item = await eagle.item.getById('item_id');

// Изменить свойства
item.name = 'Новое название';
item.tags = ['tag1', 'tag2'];
item.star = 5;
item.annotation = 'Важный файл';

// Сохранить изменения (ОБЯЗАТЕЛЬНО!)
await item.save();

// Переместить в корзину
await item.moveToTrash();

// Заменить файл
await item.replaceFile('C:\\path\\to\\new_file.png');

// Обновить превью (после модификации файла)
await item.refreshThumbnail();

// Установить кастомное превью
await item.setCustomThumbnail('C:\\path\\to\\thumbnail.png');

// Открыть файл
await item.open();
await item.open({ window: true }); // В новом окне

// Выбрать файл
await item.select();
```

⚠️ **Важно:** Всегда используйте `item.save()` для сохранения изменений. Не модифицируйте metadata.json напрямую!

---

### folder — Работа с папками

#### Методы

```javascript
// Создать папку
let folder = await eagle.folder.create({
  name: 'New Folder',
  description: 'Описание папки'
});

// Создать подпапку
let subfolder = await eagle.folder.createSubfolder('parent_folder_id', {
  name: 'Subfolder'
});

// Получить выбранную папку
let selected = await eagle.folder.getSelected();

// Получить папку по ID
let folder = await eagle.folder.getById('folder_id');

// Получить папки по массиву ID
let folders = await eagle.folder.getByIds(['id1', 'id2']);

// Получить все папки
let allFolders = await eagle.folder.getAll();

// Получить недавние папки
let recent = await eagle.folder.getRecents();

// Открыть папку в Eagle
await eagle.folder.open('folder_id');

// Поиск папок
let folders = await eagle.folder.get({
  name: 'design'
});
```

#### Класс Folder — Свойства

```javascript
let folder = await eagle.folder.getById('folder_id');

folder.id;          // string - ID папки (read-only)
folder.name;        // string - Название
folder.description; // string - Описание
folder.icon;        // string - Иконка
folder.iconColor;   // string - Цвет иконки
folder.createdAt;   // number - Время создания (read-only)
folder.parent;      // string - ID родительской папки (Eagle 4.0 build12+)
folder.children;    // Folder[] - Дочерние папки (read-only)
```

#### Методы экземпляра Folder

```javascript
let folder = await eagle.folder.getById('folder_id');

// Изменить свойства
folder.name = 'Новое название';
folder.description = 'Новое описание';
folder.parent = 'new_parent_id'; // Переместить (Eagle 4.0 build12+)
folder.parent = null;            // Переместить в корень

// Сохранить
await folder.save();

// Открыть
await folder.open();
```

---

### tag — Работа с тегами

```javascript
// Получить все теги
let tags = await eagle.tag.getAll();

// Поиск тегов
let tags = await eagle.tag.get({
  name: 'design'
});

// Получить недавние теги
let recent = await eagle.tag.getRecents();

// Свойства тега
let tag = tags[0];
tag.id;     // string - ID
tag.name;   // string - Название
tag.color;  // string - Цвет

// Изменить тег
tag.name = 'new-name';
await tag.save();
```

---

### library — Библиотека

```javascript
// Информация о текущей библиотеке
let info = await eagle.library.info();

console.log(info.name);          // Название библиотеки
console.log(info.path);          // Путь к библиотеке
console.log(info.modificationTime); // Время изменения

// Переключить библиотеку
await eagle.library.switch('C:\\path\\to\\library.library');
```

---

### window — Управление окном

```javascript
// Показать/скрыть окно
await eagle.window.show();
await eagle.window.hide();
await eagle.window.focus();

// Закрыть окно
await eagle.window.close();

// Минимизация/максимизация
await eagle.window.minimize();
await eagle.window.maximize();
await eagle.window.unmaximize();
await eagle.window.restore();

// Полноэкранный режим
await eagle.window.setFullScreen(true);
await eagle.window.setFullScreen(false);
let isFullScreen = await eagle.window.isFullScreen();

// Размер и позиция
await eagle.window.setSize(800, 600);
await eagle.window.setPosition(100, 100);
await eagle.window.center();

let size = await eagle.window.getSize();        // { width, height }
let position = await eagle.window.getPosition(); // { x, y }
let bounds = await eagle.window.getBounds();     // { x, y, width, height }

await eagle.window.setBounds({ x: 100, y: 100, width: 800, height: 600 });

// Ограничения размера
await eagle.window.setMinimumSize(320, 240);
await eagle.window.setMaximumSize(1920, 1080);

// Соотношение сторон
await eagle.window.setAspectRatio(16 / 9);

// Цвет фона
await eagle.window.setBackgroundColor('#ffffff');

// Always on top
await eagle.window.setAlwaysOnTop(true);
let isOnTop = await eagle.window.isAlwaysOnTop();

// Непрозрачность
await eagle.window.setOpacity(0.9); // 0.0 - 1.0

// Заголовок
await eagle.window.setTitle('Мой плагин');
let title = await eagle.window.getTitle();

// Скриншот страницы (Eagle 4.0 build12+)
let image = await eagle.window.capturePage();
let image2 = await eagle.window.capturePage({ x: 0, y: 0, width: 100, height: 50 });

// HTTP Referer для сетевых запросов
await eagle.window.setReferer('https://example.com');

// Проверки состояния
let isMaximized = await eagle.window.isMaximized();
let isMinimized = await eagle.window.isMinimized();
let isVisible = await eagle.window.isVisible();
let isFocused = await eagle.window.isFocused();
```

---

### app — Приложение

```javascript
// Свойства (read-only)
eagle.app.version;    // string - Версия Eagle
eagle.app.build;      // number - Номер билда
eagle.app.locale;     // string - Язык: en, zh_CN, zh_TW, ja_JP, ru
eagle.app.arch;       // string - Архитектура: x64, arm
eagle.app.platform;   // string - Платформа: darwin, win32
eagle.app.isWindows;  // boolean
eagle.app.isMac;      // boolean
eagle.app.theme;      // string - Тема: LIGHT, DARK, etc.
eagle.app.env;        // Object - Переменные окружения
eagle.app.execPath;   // string - Путь к исполняемому файлу
eagle.app.pid;        // number - ID процесса
eagle.app.userDataPath; // string - Путь к данным пользователя (Eagle 4.0 build12+)
eagle.app.runningUnderARM64Translation; // boolean - Работает в Rosetta/WOW?

// Методы
let isDark = await eagle.app.isDarkColors(); // Тёмная тема системы?

// Получить системные пути
let appData = await eagle.app.getPath('appData');
let desktop = await eagle.app.getPath('desktop');
let documents = await eagle.app.getPath('documents');
let downloads = await eagle.app.getPath('downloads');
let pictures = await eagle.app.getPath('pictures');
let music = await eagle.app.getPath('music');
let videos = await eagle.app.getPath('videos');
let temp = await eagle.app.getPath('temp');
let userData = await eagle.app.getPath('userData');

// Получить иконку файла
let icon = await eagle.app.getFileIcon('C:\\path\\to\\file.exe', { size: 'large' });
// size: 'small' (16x16), 'normal' (32x32), 'large' (48x48)
let base64 = icon.toDataURL();
let buffer = icon.toPNG();

// Создать превью из файла
let thumbnail = await eagle.app.createThumbnailFromPath('C:\\path\\to\\file.png', { width: 200, height: 200 });
```

---

### dialog — Диалоги

```javascript
// Диалог открытия файла
let result = await eagle.dialog.showOpenDialog({
  title: 'Выберите файл',
  defaultPath: 'C:\\Users',
  buttonLabel: 'Открыть',
  filters: [
    { name: 'Images', extensions: ['jpg', 'png', 'gif'] },
    { name: 'All Files', extensions: ['*'] }
  ],
  properties: [
    'openFile',        // Выбор файла
    'openDirectory',   // Выбор папки
    'multiSelections', // Множественный выбор
    'showHiddenFiles'  // Показать скрытые файлы
  ]
});
// result.filePaths - массив выбранных путей

// Диалог сохранения файла
let result = await eagle.dialog.showSaveDialog({
  title: 'Сохранить как',
  defaultPath: 'C:\\Users\\document.txt',
  buttonLabel: 'Сохранить',
  filters: [
    { name: 'Text Files', extensions: ['txt'] }
  ]
});
// result.filePath - путь для сохранения

// Диалог сообщения
let result = await eagle.dialog.showMessageBox({
  title: 'Подтверждение',
  message: 'Вы уверены?',
  detail: 'Это действие нельзя отменить.',
  buttons: ['OK', 'Отмена'],
  type: 'warning' // 'none', 'info', 'error', 'question', 'warning'
});
// result.response - индекс нажатой кнопки (0, 1, ...)

// Диалог ошибки
await eagle.dialog.showErrorBox('Ошибка', 'Что-то пошло не так!');
```

---

### notification — Уведомления

```javascript
// Показать уведомление
await eagle.notification.show({
  title: 'Заголовок',
  body: 'Текст уведомления',
  silent: false // true - без звука
});
```

---

### shell — Системные операции

```javascript
// Открыть URL в браузере
await eagle.shell.openExternal('https://google.com');

// Открыть файл системным приложением
await eagle.shell.openPath('C:\\path\\to\\file.pdf');

// Показать файл в проводнике
await eagle.shell.showItemInFolder('C:\\path\\to\\file.txt');

// Системный звук
await eagle.shell.beep();
```

---

### clipboard — Буфер обмена

```javascript
// Текст
let text = await eagle.clipboard.readText();
await eagle.clipboard.writeText('Привет, мир!');

// HTML
let html = await eagle.clipboard.readHTML();
await eagle.clipboard.writeHTML('<b>Bold</b>');

// RTF
let rtf = await eagle.clipboard.readRTF();
await eagle.clipboard.writeRTF('{\\rtf1\\ansi Hello}');

// Изображение
let image = await eagle.clipboard.readImage();
await eagle.clipboard.writeImage(nativeImage);

// Очистить
await eagle.clipboard.clear();

// Проверить формат
let formats = await eagle.clipboard.availableFormats();
// ['text/plain', 'text/html', 'image/png', ...]
```

---

### contextMenu — Контекстное меню

```javascript
// Показать контекстное меню (Eagle 4.0 build12+)
await eagle.contextMenu.open([
  {
    label: 'Копировать',
    click: () => console.log('Копировать')
  },
  { type: 'separator' },
  {
    label: 'Подменю',
    submenu: [
      { label: 'Пункт 1', click: () => {} },
      { label: 'Пункт 2', click: () => {} }
    ]
  },
  {
    label: 'Отключено',
    enabled: false
  },
  {
    label: 'С галочкой',
    type: 'checkbox',
    checked: true,
    click: () => {}
  }
]);
```

---

## Дополнительные модули

### FFmpeg

Для работы с видео и аудио. Требует добавления зависимости:

```json
{
  "dependencies": ["ffmpeg"]
}
```

```javascript
const ffmpeg = eagle.extraModule.ffmpeg;

// Получить информацию о файле
let info = await ffmpeg.getMediaInfo('video.mp4');

// Конвертация
await ffmpeg.run(['-i', 'input.mp4', '-c:v', 'libx264', 'output.mp4']);
```

### AI SDK

Для интеграции с AI-моделями (OpenAI, Anthropic, Google и др.):

```json
{
  "dependencies": ["ai-sdk"]
}
```

```javascript
const ai = eagle.extraModule.ai;
const { openai } = await ai.getProviders();
const { generateText, generateObject } = ai;

// Генерация текста
const result = await generateText({
  model: openai("gpt-4"),
  messages: [
    { role: "user", content: "Привет!" }
  ]
});

// Генерация структурированных данных
const result = await generateObject({
  model: openai("gpt-4"),
  schema: {
    type: "object",
    properties: {
      tags: { type: "array", items: { type: "string" } },
      description: { type: "string" }
    }
  },
  messages: [
    { role: "user", content: "Проанализируй изображение..." }
  ]
});
```

---

## Примеры кода

### Базовый шаблон плагина

**manifest.json:**
```json
{
  "id": "MY_PLUGIN_ID",
  "version": "1.0.0",
  "name": "My Plugin",
  "logo": "/logo.png",
  "keywords": ["utility"],
  "main": {
    "url": "index.html",
    "width": 400,
    "height": 300
  }
}
```

**index.html:**
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Plugin</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      padding: 20px;
      margin: 0;
    }
    button {
      padding: 10px 20px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <h1>My Plugin</h1>
  <button id="btn">Выполнить</button>
  <div id="result"></div>
  <script src="js/plugin.js"></script>
</body>
</html>
```

**js/plugin.js:**
```javascript
eagle.onPluginCreate(async (plugin) => {
  console.log(`Плагин "${plugin.manifest.name}" v${plugin.manifest.version} загружен`);
  
  document.getElementById('btn').addEventListener('click', async () => {
    try {
      // Получить выбранные файлы
      const items = await eagle.item.getSelected();
      
      if (items.length === 0) {
        await eagle.dialog.showMessageBox({
          title: 'Внимание',
          message: 'Выберите файлы в Eagle',
          type: 'warning'
        });
        return;
      }
      
      // Обработать файлы
      for (const item of items) {
        item.tags.push('processed');
        await item.save();
      }
      
      document.getElementById('result').textContent = 
        `Обработано файлов: ${items.length}`;
      
      await eagle.notification.show({
        title: 'Готово',
        body: `Обработано ${items.length} файлов`
      });
      
    } catch (error) {
      console.error(error);
      await eagle.dialog.showErrorBox('Ошибка', error.message);
    }
  });
});
```

### Пример: Массовое добавление тегов

```javascript
eagle.onPluginCreate(async (plugin) => {
  const tagInput = document.getElementById('tagInput');
  const addBtn = document.getElementById('addBtn');
  
  addBtn.addEventListener('click', async () => {
    const newTag = tagInput.value.trim();
    if (!newTag) return;
    
    const items = await eagle.item.getSelected();
    if (items.length === 0) {
      alert('Выберите файлы!');
      return;
    }
    
    let processed = 0;
    for (const item of items) {
      if (!item.tags.includes(newTag)) {
        item.tags.push(newTag);
        await item.save();
        processed++;
      }
    }
    
    alert(`Тег "${newTag}" добавлен к ${processed} файлам`);
    tagInput.value = '';
  });
});
```

### Пример: Экспорт метаданных в JSON

```javascript
eagle.onPluginCreate(async (plugin) => {
  document.getElementById('exportBtn').addEventListener('click', async () => {
    const items = await eagle.item.getSelected();
    
    const data = items.map(item => ({
      id: item.id,
      name: item.name,
      tags: item.tags,
      rating: item.star,
      annotation: item.annotation,
      url: item.url,
      size: item.size
    }));
    
    const result = await eagle.dialog.showSaveDialog({
      title: 'Сохранить метаданные',
      defaultPath: 'metadata.json',
      filters: [{ name: 'JSON', extensions: ['json'] }]
    });
    
    if (result.filePath) {
      const fs = require('fs');
      fs.writeFileSync(result.filePath, JSON.stringify(data, null, 2));
      
      await eagle.notification.show({
        title: 'Экспорт завершён',
        body: `Сохранено: ${result.filePath}`
      });
    }
  });
});
```

---

## Локализация (i18n)

Eagle использует встроенный модуль i18next.

**Структура:**
```
locales/
├── en.json
├── zh_CN.json
├── zh_TW.json
├── ja_JP.json
└── ru.json
```

**locales/en.json:**
```json
{
  "manifest": {
    "app": {
      "name": "My Plugin"
    }
  },
  "ui": {
    "button": "Click me",
    "greeting": "Hello, {{name}}!"
  }
}
```

**locales/ru.json:**
```json
{
  "manifest": {
    "app": {
      "name": "Мой плагин"
    }
  },
  "ui": {
    "button": "Нажми меня",
    "greeting": "Привет, {{name}}!"
  }
}
```

**manifest.json:**
```json
{
  "name": "{{manifest.app.name}}",
  "fallbackLanguage": "en",
  "languages": ["en", "zh_CN", "zh_TW", "ja_JP", "ru"],
  ...
}
```

**Использование в JS:**
```javascript
// Получить перевод
const text = i18next.t('ui.button');

// С интерполяцией
const greeting = i18next.t('ui.greeting', { name: 'Ray' });

// Сменить язык
i18next.changeLanguage('ru');
```

---

## Публикация плагина

### Подготовка

1. Убедитесь, что `manifest.json` заполнен корректно
2. Добавьте иконку `logo.png` (128×128 px)
3. Протестируйте плагин
4. Включите `devTools: false`

### Упаковка

В Eagle: Plugin → Developer Options → Package Plugin

### Публикация

1. Зарегистрируйтесь на [Eagle Plugin Center](https://eagle.cool/plugins)
2. Загрузите `.eagleplugin` файл
3. Заполните описание и скриншоты
4. Отправьте на модерацию

### Обновление

1. Увеличьте `version` в manifest.json
2. Упакуйте новую версию
3. Загрузите обновление в Plugin Center

---

## Полезные ссылки

- [Официальная документация](https://developer.eagle.cool/plugin-api/)
- [Шаблон иконки плагина (Figma)](https://www.figma.com/community/file/1301113485954941759)
- [Eagle REST API](https://api.eagle.cool/) — для внешних интеграций (порт 41595)

---

## Changelog (основные изменения)

### Eagle 4.0 Build12+
- `eagle.item.select()` — выбор файлов
- `eagle.item.open({ window: true })` — открытие в новом окне
- `eagle.folder.parent` — перемещение папок
- `eagle.window.capturePage()` — скриншот страницы
- `eagle.window.setReferer()` — установка HTTP Referer
- `eagle.contextMenu.open()` — кастомные контекстные меню
- `eagle.app.userDataPath` — путь к данным пользователя

### Eagle 4.0 Build18+
- `item.importedAt` — редактирование времени импорта
