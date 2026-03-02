---
title: "Figma Connector Plugin Creation Plan"
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
description: "Plan for creating a menu-based connector plugin for Figma"
---

# План разработки плагина Figma: "Smart Connectors" (Menu-based)

Этот документ описывает шаги по созданию плагина Figma, который позволяет создавать стилизованные соединительные линии (коннекторы) **через командное меню плагина**.

## 1. Анализ и Цели (Обновлено)

- **Цель:** Ускорить процесс прототипирования и создания схем (user flow, diagrams), предоставляя быстрый доступ к стилизованным стрелкам.
    
- **Основная функция:** При выборе двух объектов, пользователь заходит в меню плагинов, выбирает "Smart Connectors" и видит 4 варианта стрелок прямо в меню. Выбор одного из вариантов немедленно создает стрелку.
    
- **Ключевая технология:** Использование `figma.createConnector()` и `manifest.json` (свойство `menu`).
    

## 2. Структура файлов плагина (Обновлено)

Для плагина понадобятся **всего два** основных файла:

1. `manifest.json`: Файл конфигурации, который регистрирует плагин и **определяет его меню**.
    
2. `code.ts` (или `code.js`): Основной код плагина, который будет проверять, какая команда меню была нажата.
    

_(Файл `ui.html` больше не нужен)._

## 3. Подробный План Реализации

### Шаг 1: `manifest.json` (Настройка Меню)

Это "сердце" нового подхода. Мы убираем `ui` и `capabilities` и добавляем `menu`.

```
{
  "name": "Smart Connectors",
  "id": "UNIQUE_PLUGIN_ID",
  "api": "1.0.0", 
  "main": "code.js",
  
  "editorType": ["figma", "figjam"],

  "menu": [
    {
      "name": "Стрелка: Обычная (Серая)",
      "command": "create-regular"
    },
    {
      "name": "Стрелка: Успех (Зеленая)",
      "command": "create-success"
    },
    {
      "name": "Стрелка: Ошибка (Красная)",
      "command": "create-error"
    },
    {
      "name": "Стрелка: Неявная (Пунктир)",
      "command": "create-implicit"
    }
  ]
}







```

### Шаг 2: `ui.html` (Интерфейс пользователя)

Этот файл **удален** из плана.

### Шаг 3: `code.ts` (Основная логика плагина)

Логика кардинально меняется. Мы больше не показываем UI и не слушаем сообщения. Вместо этого, плагин запускается, **немедленно** проверяет `figma.command` и выполняет действие.

```
// code.ts (или code.js)

// 1. Плагин запускается и сразу проверяет, какая команда была вызвана
const command = figma.command;

// 2. Проверяем, что выбрано ровно два объекта
const selection = figma.currentPage.selection;
if (selection.length !== 2) {
  figma.notify('Пожалуйста, выберите ровно два элемента.', { error: true });
  figma.closePlugin();
} else {
  // 3. Если с выбором все ок, определяем стиль по команде
  // и создаем коннектор
  let styleType = 'regular'; // по умолчанию

  switch (command) {
    case 'create-regular':
      styleType = 'regular';
      break;
    case 'create-success':
      styleType = 'success';
      break;
    case 'create-error':
      styleType = 'error';
      break;
    case 'create-implicit':
      styleType = 'implicit';
      break;
  }

  createConnector(selection, styleType);
}

// 4. Наша основная функция (немного изменена)
function createConnector(selection, styleType) {
  const [node1, node2] = selection;

  // Создаем коннектор
  const connector = figma.createConnector();
  connector.name = "Connector";

  // Применяем стили
  applyStyle(connector, styleType);

  // "Приклеиваем" коннектор к элементам.
  // Денотация 'auto' по-прежнему лучшая
  connector.connectorStart = {
    endpointNodeId: node1.id,
    magnet: 'AUTO', // ИСПРАВЛЕНО: 'auto' -> 'AUTO'
  };
  connector.connectorEnd = {
    endpointNodeId: node2.id,
    magnet: 'AUTO', // ИСПРАВЛЕНО: 'auto' -> 'AUTO'
  };

  // Добавляем стрелку на конец линии
  // ИСПРАВЛЕНО: 'connectorEndArrow' -> 'connectorEndStrokeCap'
  // И формат изменен с объекта на строку
  connector.connectorEndStrokeCap = 'TRIANGLE_FILLED';
  
  // Помещаем коннектор
  if (node1.parent) {
    node1.parent.appendChild(connector);
  } else {
    figma.currentPage.appendChild(connector);
  }

  // Молча закрываем плагин. Уведомление не нужно,
  // так как пользователь сразу видит результат.
  figma.closePlugin();
}


// 5. Вспомогательная функция для стилизации (остается без изменений)
function applyStyle(connector, styleType) {
  // Цвета в Figma API задаются в долях от 0 до 1
  const gray = { r: 0.5, g: 0.5, b: 0.5 };
  const green = { r: 0.18, g: 0.8, b: 0.44 };
  const red = { r: 0.9, g: 0.1, b: 0.1 };

  connector.strokeWeight = 2; 
  connector.strokes = [{ type: 'SOLID', color: gray }];
  connector.strokeDashPattern = []; 

  switch (styleType) {
    case 'regular':
      break;
    case 'success':
      connector.strokes = [{ type: 'SOLID', color: green }];
      break;
    case 'error':
      connector.strokes = [{ type: 'SOLID', color: red }];
      break;
    case 'implicit':
      // Для "имплицитной" (неявной) связи
      connector.strokeWeight = 1;
      connector.strokeDashPattern = [4, 4];
      break;
  }
}




```

## 4. Тестирование и отладка (Упрощено)

Шаги 1, 2, 3 и 4 остаются теми же (установка, компиляция, импорт).

5. **Тестируйте:**
    
    - Выберите 2 объекта.
        
    - Кликните правой кнопкой мыши -> Plugins -> Smart Connectors.
        
    - Вы должны увидеть 4 опции: "Стрелка: Обычная", "Стрелка: Успех" и т.д.
        
    - Выберите "Стрелка: Успех (Зеленая)".
        
    - П