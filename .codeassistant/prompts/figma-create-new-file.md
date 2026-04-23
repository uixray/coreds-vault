# Figma Create New File Skill

## Сценарий подготовки чистого рабочего пространства

Этот навык описывает процесс создания новых файлов Figma (Design или FigJam) для начала работы над новыми проектами, прототипами или мозговыми штурмами. Используется когда нужно начать с чистого листа.

## Необходимые инструменты

- `create_new_file` - для создания нового файла
- `whoami` - для определения текущего пользователя (опционально)

## Рабочий процесс

### 1. Определение типа файла

- **Design File**: Для UI/UX дизайна, прототипирования интерфейсов
- **FigJam File**: Для воркшопов, мозговых штурмов, диаграмм, планирования

### 2. Настройка параметров файла

- **Название**: Осмысленное имя, отражающее содержание
- **Описание**: Краткое описание цели файла
- **Шаблон**: Использовать существующий шаблон если доступно
- **Команда**: Выбор команды/организации для размещения файла

### 3. Начальная настройка файла

- Установка сетки (Grid) и направляющих (Guides)
- Создание основных страниц (Pages) если необходимо
- Импорт библиотек дизайн-системы
- Настройка цветовых режимов (light/dark)

### 4. Подготовка рабочего пространства

- Создание структуры папок/страниц для организации
- Добавление справочных материалов (бриф, требования)
- Настройка shared styles и components если начинаете с нуля

## Шаблон для создания дизайн-файла

```javascript
// Создание нового дизайн-файла
const newFile = await create_new_file({
  title: "SaaS Dashboard Redesign",
  description: "Redesign of admin dashboard for Analytics Pro SaaS product",
  fileType: "design", // или "figjam"
  teamId: "team_12345", // опционально, если несколько команд
});

if (!newFile.success) {
  throw new Error(`Failed to create file: ${newFile.error}`);
}

// Получение file_key для последующих операций
const fileKey = newFile.file_key;

// Теперь можно начать работу с файлом
// Пример: создание первой страницы с фреймом
const firstPage = figma.currentPage;
firstPage.name = "Desktop - 1440px";

// Создание основного фрейма
const mainFrame = figma.createFrame();
mainFrame.name = "Dashboard Overview";
mainFrame.resize(1440, 1024);
mainFrame.fills = [{ type: "SOLID", color: { r: 0.98, g: 0.98, b: 0.98 } }];

// Установка сетки
mainFrame.layoutGrids = [
  {
    pattern: "COLUMNS",
    sectionSize: 12,
    gutterSize: 20,
    alignment: "STRETCH",
    count: 12,
    offset: 40,
  },
];

// Добавление на страницу
firstPage.appendChild(mainFrame);

// Создание дополнительных страниц для организации
const pages = [
  "Mobile - 375px",
  "Tablet - 768px",
  "Components",
  "Explorations",
  "References",
];

pages.forEach((pageName) => {
  const page = figma.createPage();
  page.name = pageName;
});

// Импорт библиотек дизайн-системы (если доступно)
try {
  // Это примерный код, фактический импорт зависит от API
  await figma.importLibraryByKey("library_key_123");
} catch (e) {
  console.log("Library import failed or not available");
}

return {
  success: true,
  message: `Created new design file: ${newFile.title}`,
  fileKey: fileKey,
  fileUrl: `https://figma.com/file/${fileKey}`,
  pages: figma.root.children.map((p) => p.name),
};
```

## Шаблон для создания FigJam файла

```javascript
// Создание нового FigJam файла
const newFigJamFile = await create_new_file({
  title: "Product Planning Workshop",
  description: "Brainstorming session for Q3 features",
  fileType: "figjam",
  teamId: "team_12345",
});

if (!newFigJamFile.success) {
  throw new Error(`Failed to create FigJam file: ${newFigJamFile.error}`);
}

// FigJam имеет специфические элементы
// Создание canvas для workshop
const canvas = figma.createFrame();
canvas.name = "Main Workshop Canvas";
canvas.resize(3000, 2000); // FigJam часто требует больше пространства
canvas.fills = [{ type: "SOLID", color: { r: 1, g: 1, b: 1 } }];

// Добавление стандартных FigJam элементов
const elements = [
  { type: "STICKY", text: "Problem Statement", x: 100, y: 100 },
  { type: "STICKY", text: "User Needs", x: 100, y: 200 },
  { type: "STICKY", text: "Solutions", x: 100, y: 300 },
  { type: "SHAPE", shape: "ARROW", x: 400, y: 150 },
  { type: "TEXT", text: "Workshop Agenda", x: 600, y: 100 },
];

// В реальном FigJam API будут другие методы
// Это концептуальный пример

return {
  success: true,
  message: `Created new FigJam file: ${newFigJamFile.title}`,
  fileKey: newFigJamFile.file_key,
  fileUrl: `https://figma.com/figjam/${newFigJamFile.file_key}`,
};
```

## Сценарии использования

### Сценарий 1: Начало нового проекта

- **Запрос**: "Создай новый дизайн-файл для мобильного приложения доставки еды"
- **Действия**: Создать файл, настроить артборды для iOS/Android, импортировать дизайн-систему

### Сценарий 2: Прототипирование фичи

- **Запрос**: "Создай файл для прототипирования новой onboarding flow"
- **Действия**: Создать файл, настроить flow между экранами, добавить интерактивные элементы

### Сценарий 3: Воркшоп и планирование

- **Запрос**: "Создай FigJam файл для мозгового штурма по улучшению UX"
- **Действия**: Создать FigJam файл, добавить шаблон workshop, подготовить canvas для collaboration

### Сценарий 4: Дизайн-спринт

- **Запрос**: "Создай файл для 5-дневного дизайн-спринта"
- **Действия**: Создать файл с страницами для каждого дня (Understand, Sketch, Decide, Prototype, Test)

## Рекомендации по промптам

- **Будьте конкретны в названии**: "Создай файл с названием 'E-commerce Checkout Redesign - March 2026'"
- **Указывайте тип файла**: "Создай FigJam файл для ретроспективы спринта"
- **Определяйте структуру**: "Создай файл с тремя страницами: Research, Wireframes, Visual Design"
- **Упоминайте команду**: "Создай файл в команде 'Product Design Team'"

## Интеграция с существующими процессами

### Шаблоны организации

Создайте стандартные шаблоны для часто повторяющихся задач:

```javascript
// Псевдокод для создания из шаблона
const createFromTemplate = async (templateName) => {
  switch (templateName) {
    case "design-sprint":
      return createDesignSprintTemplate();
    case "component-audit":
      return createComponentAuditTemplate();
    case "usability-test":
      return createUsabilityTestTemplate();
    default:
      return createBasicDesignFile();
  }
};
```

### Автоматическая настройка

После создания файла можно автоматически:

1. Пригласить collaborators
2. Настроить permissions
3. Добавить в проекты (Projects)
4. Создать связанные задачи в Jira/Linear

## Ограничения и considerations

1. **Лимиты создания**: Бесплатные аккаунты Figma имеют ограничения на количество файлов
2. **Размер команды**: Файлы создаются в личном пространстве или команде в зависимости от прав
3. **Шаблоны**: Некоторые шаблоны доступны только на определенных тарифах
4. **Наследование библиотек**: Новые файлы не всегда автоматически наследуют библиотеки команды
