# Figma MCP Quick Start Guide

## 🚀 Начало работы за 5 минут

### Шаг 1: Проверка предварительных требований

- [ ] У вас есть Figma аккаунт с Full/Dev Seat (Professional+ план)
- [ ] Установлен VS Code версии 1.90+
- [ ] Установлен плагин SourceCraft
- [ ] Вы авторизованы в SourceCraft

### Шаг 2: Настройка Figma MCP

1. Откройте проект "UIXRay Design System" в VS Code
2. Убедитесь что файлы в `.codeassistant/` присутствуют
3. Сервер Figma MCP уже настроен в `.codeassistant/mcp.json`

### Шаг 3: Авторизация

1. Откройте чат SourceCraft (`Ctrl+Shift+P` → "SourceCraft: Open Chat")
2. Переключитесь в **Agent Mode**
3. При первом использовании Figma MCP откроется браузер для OAuth
4. Войдите в Figma и предоставьте разрешения

### Шаг 4: Тестирование

Выполните в чате SourceCraft:

```
"Проверь доступность Figma MCP"
```

Или создайте тестовый файл:

```
"Создай тестовый файл Figma с названием 'UIXRay Quick Test'"
```

## 📁 Структура инструментария

```
.codeassistant/
├── mcp.json                    # Конфигурация MCP серверов
├── rules/
│   └── figma-use.md           # ОБЯЗАТЕЛЬНЫЙ навык для редактирования
├── prompts/
│   ├── figma-generate-design.md
│   ├── figma-implement-design.md
│   └── figma-create-new-file.md
├── config/
│   ├── figma-rules.json       # Правила для AI агента
│   └── setup-guide.md         # Полное руководство
└── QUICKSTART.md              # Этот файл
```

## 🛠️ Основные команды

### Для дизайнеров

```
"Создай мобильный экран входа в систему используя компоненты UIXRay"
```

```
"Добавь loading состояние к компоненту Button"
```

```
"Обнови цвета во всех компонентах на новую палитру"
```

### Для разработчиков

```
"На основе изменений в Modal.tsx, обнови компонент в Figma"
```

```
"Создай прототип фичи поиска с фильтрами"
```

```
"Проверь соответствие кода макету в Figma файле <URL>"
```

## ⚡ Быстрые примеры

### Пример 1: Создание компонента

```javascript
// Агент сгенерирует подобный код
await use_figma(`
  // Загрузка шрифтов
  await figma.loadFontAsync({ family: "Inter", style: "Regular" });
  
  // Создание компонента
  const button = figma.createComponent();
  button.name = "PrimaryButton";
  button.resize(120, 48);
  
  // Добавление Auto Layout
  button.layoutMode = "HORIZONTAL";
  button.paddingLeft = 24;
  button.paddingRight = 24;
  button.itemSpacing = 8;
  
  // Добавление текста
  const text = figma.createText();
  text.characters = "Click me";
  text.fontSize = 16;
  button.appendChild(text);
`);
```

### Пример 2: Поиск в дизайн-системе

```javascript
// Поиск компонентов
const results = await search_design_system({
  query: "card",
  types: ["COMPONENT"],
  library: "UIXRay Design System",
});
```

## 🚨 Частые проблемы и решения

### Проблема: "Authentication Failed"

**Решение**:

1. Выполните `SourceCraft Code Assistant: Login`
2. Перезапустите сервер Figma MCP
3. Проверьте разрешения учетной записи Figma

### Проблема: "Rate Limit Exceeded"

**Решение**:

- Бесплатный аккаунт: 6 вызовов/месяц
- Professional: 200 вызовов/день
- Enterprise: 600 вызовов/день
- Объединяйте изменения в один вызов

### Проблема: "Missing Font"

**Решение**:

- Используйте только системные шрифты (Inter, Roboto, SF Pro)
- Всегда вызывайте `figma.loadFontAsync()` перед работой с текстом

## 📚 Дополнительные ресурсы

- [Полное руководство](.codeassistant/config/setup-guide.md)
- [Интеграция с UIXRay](07-figma/figma-mcp-integration-guide.md)
- [Figma Plugin API Reference](07-figma/figma-plugin-api-reference.md)
- [Исследование интеграции](00-meta/Inbox/Figma%20MCP%20и%20Source%20Craft%20-%20Интеграция%20для%20редактирования.md)

## 🆘 Получение помощи

1. **Проверьте логи**: `~/.sourcecraft/logs/mcp-figma.log`
2. **Используйте debug режим**: `export SOURCECRAFT_LOG_LEVEL=debug`
3. **Обратитесь к сообществу**:
   - Figma Community Forum
   - SourceCraft Discord
   - GitHub Issues проекта

## 🎯 Следующие шаги

После успешной настройки:

1. **Изучите навыки** в `.codeassistant/prompts/`
2. **Настройте интеграцию** с вашей дизайн-системой
3. **Автоматизируйте** рутинные задачи
4. **Расширьте функциональность** кастомными навыками

---

**Готовы к работе?** Откройте чат SourceCraft и начните с простого запроса!

```
"Создай простой фрейм с текстом 'Hello Figma MCP!'"
```
