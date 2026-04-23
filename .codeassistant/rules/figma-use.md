# Figma Use Skill

## Обязательный пререквизит для работы с Figma MCP

Этот навык является фундаментальным для любого вызова инструмента `use_figma` в сервере Figma MCP. Он содержит правила работы с Figma Plugin API, которые должен соблюдать AI-агент при генерации JavaScript-кода для редактирования макетов.

## Ключевые правила

### 1. Асинхронная загрузка шрифтов

Перед любыми операциями с текстовыми узлами необходимо загрузить используемые шрифты:

```javascript
await figma.loadFontAsync({ family: "Inter", style: "Regular" });
```

### 2. Работа с цветовыми пространствами

- Используйте `figma.util.rgbToHex()` и `figma.util.hexToRgb()` для преобразования цветов
- Для переменных цвета используйте `figma.variables.getVariableById()`
- Всегда проверяйте наличие цветовых переменных перед использованием HEX-кодов

### 3. Безопасное создание и изменение узлов

- Всегда проверяйте существование узлов перед их модификацией
- Используйте `try-catch` блоки для обработки ошибок
- После создания узлов устанавливайте корректные `parent` отношения

### 4. Auto Layout правила

- При создании контейнеров всегда используйте Auto Layout
- Устанавливайте `layoutMode: "HORIZONTAL"` или `"VERTICAL"`
- Настраивайте `padding`, `itemSpacing`, `counterAxisSpacing` в соответствии с дизайн-системой

### 5. Работа с компонентами

- Для инстанцирования компонентов используйте `component.createInstance()`
- Не изменяйте мастер-компоненты напрямую
- Используйте `swapComponent()` для замены вариантов компонентов

### 6. Ограничения производительности

- Каждый вызов `use_figma` ограничен 20 КБ выходных данных
- Разбивайте большие изменения на несколько вызовов (чанкинг)
- Используйте `get_metadata` для анализа структуры перед редактированием

## Шаблон кода для `use_figma`

```javascript
// 1. Загрузка необходимых шрифтов
await Promise.all([
  figma.loadFontAsync({ family: "Inter", style: "Regular" }),
  figma.loadFontAsync({ family: "Inter", style: "Medium" }),
  figma.loadFontAsync({ family: "Inter", style: "Bold" }),
]);

// 2. Получение целевого фрейма/узла
const targetFrame = figma.currentPage.findOne(
  (node) => node.name === "Target Frame",
);
if (!targetFrame) {
  throw new Error("Target frame not found");
}

// 3. Создание/изменение узлов с Auto Layout
const container = figma.createFrame();
container.name = "New Container";
container.layoutMode = "VERTICAL";
container.primaryAxisSizingMode = "AUTO";
container.counterAxisSizingMode = "AUTO";
container.paddingTop = 16;
container.paddingBottom = 16;
container.paddingLeft = 16;
container.paddingRight = 16;
container.itemSpacing = 8;

// 4. Добавление дочерних элементов
const textNode = figma.createText();
textNode.characters = "Sample Text";
textNode.fontSize = 14;
textNode.fills = [{ type: "SOLID", color: { r: 0, g: 0, b: 0 } }];
container.appendChild(textNode);

// 5. Добавление в иерархию
targetFrame.appendChild(container);

// 6. Возврат результата
return {
  success: true,
  message: `Created container with ${container.children.length} children`,
  nodeId: container.id,
};
```

## Ошибки, которых следует избегать

1. **Попытка редактирования без загрузки шрифтов** → "Missing Font" ошибка
2. **Изменение удаленных узлов** → "Node not found" ошибка
3. **Превышение лимита размера ответа** → обрезка данных
4. **Использование локальных шрифтов** → используйте только системные или корпоративные шрифты
5. **Прямая работа с растровыми изображениями** → пока не поддерживается

## Рекомендации по промптам

- Всегда указывайте конкретные имена узлов или ID
- Просите агента показать сгенерированный код перед исполнением
- Используйте переменные дизайн-системы вместо жестких значений
- Разбивайте сложные задачи на последовательные шаги
