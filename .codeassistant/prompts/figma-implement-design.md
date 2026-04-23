# Figma Implement Design Skill

## Обратный процесс: обновление макета на основе изменений в коде

Этот навык описывает рабочий процесс для синхронизации дизайн-макетов Figma с изменениями в кодовой базе. Используется когда разработчик вносит изменения в React/Vue/другие компоненты и нужно отразить эти изменения в дизайне.

## Необходимые инструменты

- `use_figma` - для редактирования существующих узлов
- `get_design_context` - для извлечения структуры макета и поиска соответствующих узлов

## Рабочий процесс

### 1. Анализ изменений в коде

- Получите diff изменений из Git или описание изменений от разработчика
- Определите какие компоненты были изменены: добавлены новые пропсы, изменена структура, обновлены стили
- Сопоставьте компоненты кода с компонентами в Figma (через Code Connect если доступно)

### 2. Поиск соответствующих узлов в Figma

```javascript
// Использование get_design_context для поиска
const designContext = await get_design_context({
  fileUrl: "https://figma.com/file/...",
  nodeQuery: "ComponentName",
});
```

### 3. Планирование изменений

- Определите нужно ли обновить существующий компонент или создать новый вариант
- Решите требуется ли изменение структуры Auto Layout
- Проверьте совместимость с существующей дизайн-системой

### 4. Внесение изменений в макет

- Обновите свойства компонента (размеры, отступы, цвета)
- Добавьте новые элементы если необходимо
- Удалите устаревшие элементы
- Обновите текстовое содержимое если изменились label

### 5. Проверка консистентности

- Убедитесь что изменения не сломали другие части макета
- Проверьте отзывчивость на разных размерах экрана
- Убедитесь что соблюдены правила дизайн-системы

## Шаблон для обновления компонента кнопки

```javascript
// 1. Загрузка шрифтов
await Promise.all([
  figma.loadFontAsync({ family: "Inter", style: "Regular" }),
  figma.loadFontAsync({ family: "Inter", style: "Medium" }),
]);

// 2. Поиск компонента Button в макете
const buttonNodes = figma.currentPage.findAll(
  (node) => node.type === "COMPONENT" && node.name.includes("Button"),
);

if (buttonNodes.length === 0) {
  throw new Error("Button component not found in the design");
}

// 3. Обновление основного компонента (мастера)
const masterButton = buttonNodes[0];
if (masterButton.type === "COMPONENT") {
  // 3.1. Добавление нового варианта "loading"
  const loadingVariant = masterButton.clone();
  loadingVariant.name = "Button/Loading";

  // 3.2. Добавление спиннера (иконка)
  const spinnerIcon = figma.createNodeFromSvg(`<svg>...</svg>`);
  spinnerIcon.name = "spinner";
  spinnerIcon.x = 12;
  spinnerIcon.y = 12;

  // 3.3. Обновление текста
  const textNode = loadingVariant.findOne((node) => node.type === "TEXT");
  if (textNode) {
    textNode.characters = "Loading...";
    textNode.opacity = 0.7;
  }

  // 3.4. Добавление спиннера в компонент
  loadingVariant.appendChild(spinnerIcon);

  // 3.5. Создание Component Set если его нет
  const parent = masterButton.parent;
  if (parent && parent.type !== "COMPONENT_SET") {
    const componentSet = figma.createComponentSet();
    componentSet.name = "Button";
    parent.appendChild(componentSet);
    componentSet.appendChild(masterButton);
    componentSet.appendChild(loadingVariant);
  } else if (parent && parent.type === "COMPONENT_SET") {
    parent.appendChild(loadingVariant);
  }

  // 3.6. Обновление существующих инстансов
  const allInstances = figma.currentPage.findAll(
    (node) => node.type === "INSTANCE" && node.mainComponent === masterButton,
  );

  // Опционально: обновить некоторые инстансы на новый вариант
  // allInstances[0].swapComponent(loadingVariant);
}

// 4. Обновление пропсов/параметров компонента
// Добавление нового boolean параметра "disabled"
try {
  masterButton.addComponentProperty("disabled", "BOOLEAN", false);
} catch (e) {
  console.log("Component property already exists or cannot be added");
}

return {
  success: true,
  message: `Updated Button component with loading variant. Found ${buttonNodes.length} button components.`,
  updatedNodes: buttonNodes.map((n) => n.id),
};
```

## Сценарии использования

### Сценарий 1: Добавление нового состояния компонента

- **В коде**: Добавлен пропс `isLoading` к компоненту Button
- **В Figma**: Создать вариант "Loading" с индикатором прогресса

### Сценарий 2: Изменение структуры компонента

- **В коде**: Компонент Card теперь принимает `headerAction` slot
- **В Figma**: Добавить область для action button в header карточки

### Сценарий 3: Обновление стилей

- **В коде**: Изменены border-radius с 8px на 12px
- **В Figma**: Обновить cornerRadius у всех инстансов компонента

### Сценарий 4: Добавление нового компонента

- **В коде**: Создан новый компонент `DataTable`
- **В Figma**: Создать соответствующий компонент в библиотеке дизайн-системы

## Рекомендации по промптам

- **Ссылайтесь на конкретный код**: "На основе изменений в `src/components/Modal.tsx`, обнови компонент Modal в Figma"
- **Указывайте версии**: "Используй последнюю версию дизайн-системы из библиотеки 'UIXRay v2.0'"
- **Определяйте scope**: "Обнови только компоненты на странице Settings, не трогай остальные"
- **Просите подтверждения**: "Покажи diff изменений перед применением"

## Интеграция с Code Connect

Если в проекте настроен Code Connect, используйте его для точного сопоставления:

```javascript
// Получение mapping между кодом и дизайном
const mappings = await send_code_connect_mappings({
  componentName: "Button",
  codeFilePath: "src/components/Button.tsx",
});
```

## Ограничения

1. **Именование**: Компоненты в Figma и коде должны иметь согласованные naming conventions
2. **Структурные изменения**: Большие структурные изменения могут потребовать редизайна
3. **Обратная совместимость**: Изменения не должны ломать существующие макеты
4. **Версионирование**: Учитывайте версии дизайн-системы при обновлении
