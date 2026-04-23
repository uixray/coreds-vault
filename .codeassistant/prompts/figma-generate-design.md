# Figma Generate Design Skill

## Создание полноценных страниц на основе текстового описания или кода

Этот навык описывает рабочий процесс для генерации дизайн-макетов в Figma на основе текстовых описаний, требований или существующего кода. Используется для быстрого прототипирования интерфейсов.

## Необходимые инструменты

- `use_figma` - для создания и редактирования узлов
- `search_design_system` - для поиска компонентов в библиотеках
- `get_screenshot` - для визуальной проверки результата

## Рабочий процесс

### 1. Анализ требований

- Получите четкое описание интерфейса от пользователя
- Определите ключевые компоненты: навигация, контентные блоки, формы, кнопки
- Уточните требования к отзывчивости (responsive/adaptive)

### 2. Поиск компонентов в дизайн-системе

```javascript
// Пример использования search_design_system
const components = await search_design_system({
  query: "button primary",
  types: ["COMPONENT"],
});
```

### 3. Создание структуры макета

- Начните с создания основного фрейма с правильными размерами (например, 1440×1024 для десктопа)
- Установите сетку (Grid) и направляющие (Guides)
- Создайте основные секции: Header, Main Content, Sidebar, Footer

### 4. Инстанцирование компонентов

- Используйте найденные компоненты из библиотеки
- Настройте варианты компонентов через `swapComponent()` если необходимо
- Применяйте Auto Layout для правильного расположения

### 5. Настройка текстового контента

- Загрузите необходимые шрифты перед работой с текстом
- Используйте текстовые стили из дизайн-системы
- Применяйте семантическую иерархию заголовков

### 6. Применение переменных дизайн-системы

- Используйте цветовые переменные вместо HEX-кодов
- Применяйте токены для spacing, borderRadius, elevation
- Проверьте консистентность с бренд-гайдлайнами

## Шаблон для создания экрана пользовательского профиля

```javascript
// 1. Загрузка шрифтов
await Promise.all([
  figma.loadFontAsync({ family: "Inter", style: "Regular" }),
  figma.loadFontAsync({ family: "Inter", style: "Medium" }),
  figma.loadFontAsync({ family: "Inter", style: "Bold" }),
]);

// 2. Создание основного фрейма
const mainFrame = figma.createFrame();
mainFrame.name = "User Profile - Desktop";
mainFrame.resize(1440, 1024);
mainFrame.fills = [{ type: "SOLID", color: { r: 1, g: 1, b: 1 } }];
mainFrame.layoutMode = "VERTICAL";
mainFrame.itemSpacing = 0;

// 3. Добавление хедера (поиск компонента в библиотеке)
const headerComponent = await findComponent("Header");
if (headerComponent) {
  const headerInstance = headerComponent.createInstance();
  mainFrame.appendChild(headerInstance);
}

// 4. Создание контентной области
const contentSection = figma.createFrame();
contentSection.name = "Content";
contentSection.layoutMode = "HORIZONTAL";
contentSection.primaryAxisSizingMode = "FILL";
contentSection.counterAxisSizingMode = "FILL";
contentSection.paddingTop = 40;
contentSection.paddingBottom = 40;
contentSection.paddingLeft = 80;
contentSection.paddingRight = 80;
contentSection.itemSpacing = 40;

// 5. Добавление сайдбара и основного контента
const sidebar = createSidebar();
const mainContent = createProfileContent();

contentSection.appendChild(sidebar);
contentSection.appendChild(mainContent);
mainFrame.appendChild(contentSection);

// 6. Добавление футера
const footerComponent = await findComponent("Footer");
if (footerComponent) {
  const footerInstance = footerComponent.createInstance();
  mainFrame.appendChild(footerInstance);
}

// Помещаем на текущую страницу
figma.currentPage.appendChild(mainFrame);

return {
  success: true,
  message: "Created user profile screen",
  frameId: mainFrame.id,
};
```

## Рекомендации по промптам

- **Будьте конкретны**: "Создай экран дашборда для SaaS-продукта с графиками, таблицей и боковой навигацией"
- **Указывайте контекст**: "Используй компоненты из библиотеки 'UIXRay Design System'"
- **Определяйте приоритеты**: "Сначала создай мобильную версию, затем адаптируй под десктоп"
- **Просите подтверждения**: "Покажи скриншот результата перед сохранением"

## Ограничения и обходные пути

1. **Изображения**: Используйте плейсхолдеры для изображений пользователей
2. **Сложные графики**: Создавайте простые прямоугольники с подписями для графиков
3. **Интерактивные состояния**: Создавайте отдельные фреймы для hover/focus состояний
4. **Многостраничность**: Создавайте отдельные страницы в файле Figma для разных экранов
