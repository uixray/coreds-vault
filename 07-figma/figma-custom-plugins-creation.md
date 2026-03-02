---
title: "Creating Custom Figma Plugins"
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
description: "Guide for creating custom plugins for Figma"
---

# Создание кастомных Figma-плагинов: полный гид для опытного дизайнера

**Главный вывод:** Вы можете реалистично заменить **6-8 платных плагинов** собственными разработками с помощью Claude AI, сэкономив **$500-1500/год** на подписках. Приоритет — плагины для проверки макетов (Design QA), генерации контента и управления слоями, которые реализуются за **1-4 недели** каждый. Интеграция с Yandex AI требует бэкенд-прокси из-за CORS-ограничений Figma, но технически полностью осуществима.

---

## Анализ рынка платных плагинов: где теряются ваши деньги

Рынок платных Figma-плагинов сконцентрирован в нескольких нишах с высокими ценами. **Stark** для accessibility-проверки стоит **$198/год** за пользователя, **Anima** для генерации кода — **$468/год** ($39/месяц), а **Tokens Studio** для дизайн-токенов — **€39/месяц** (~$504/год). При этом многие функции этих плагинов реализуемы через Figma Plugin API без критических ограничений.

Наиболее дорогие категории плагинов:

|Категория|Топ-плагин|Цена|Замена возможна?|
|---|---|---|---|
|Accessibility (Доступность)|Stark|$198/год|✅ Да, базовые функции|
|Developer Handoff (Передача в разработку)|Anima|$468/год|⚠️ Частично|
|Design QA (Проверка макетов)|Pixelay|$108/год|✅ Да|
|Design Tokens|Tokens Studio|€468/год|⚠️ Частично|
|Design System Docs|Supernova|$35-80/год/редактор|❌ Сложно|
|Icons (Иконки)|Icons8|$108-228/год|✅ Да, через Iconify|

**Pixelay** от Hypermatic ($9/месяц или $79/месяц за бандл) — единственный полноценный инструмент для визуального сравнения дизайна с живым сайтом. Он поддерживает 7 режимов сравнения, включая overlay и split-screen. Это идеальный кандидат для кастомной замены, так как основная функция (screenshot + overlay) реализуема через стандартные API.

---

## Ваши референсные плагины: что делает их ценными

Анализ пяти плагинов, которые вы уже используете, раскрывает паттерны полезности. **Specs** от Nathan Curtis (EightShapes) автоматизирует генерацию анатомии компонентов, сравнение вариантов и документирование spacing — задачи, на которые вручную уходят часы. Плагин использует **node traversal** (обход узлов), **auto-layout properties** и **boundVariables** для детекции токенов.

**LayerSense** показывает силу AI-интеграции: анализирует контекст слоя, иерархию и текстовое содержимое для генерации семантических имён. Важно: он **бесплатный** и, вероятно, использует внешний AI API через `figma.ui.postMessage()`. Вы можете создать аналог с YandexGPT.

**html.to.design** демонстрирует возможности external API — конвертация веб-страниц требует серверного компонента для парсинга DOM. **Style Lens** работает как "Find & Replace" для визуальных свойств — чисто клиентская логика через page traversal. **Beautiful Shadows** — open source (MIT), использует математику для имитации физически корректных теней через multiple `DropShadowEffect` объекты.

---

## Возможности Figma Plugin API: что технически реализуемо

Figma Plugin API предоставляет **полный read/write доступ** ко всем типам узлов, стилям и переменным. Критические методы для ваших задач:

**Для проверки макетов (Design QA):**

```typescript
figma.currentPage.findAll(callback)     // Поиск всех элементов
node.getCSSAsync()                       // Экспорт CSS-свойств
figma.getSelectionColors()              // Все цвета в выделении
node.absoluteBoundingBox                 // Абсолютные координаты
```

**Для подготовки к вёрстке (Handoff):**

```typescript
node.exportAsync({ format: 'PNG'|'SVG'|'PDF' })  // Экспорт
node.fills, node.strokes, node.effects           // Визуальные свойства
node.layoutMode, node.itemSpacing, node.padding  // Auto-layout
```

**Для наполнения контентом (Content population):**

```typescript
await figma.loadFontAsync(fontName)      // Загрузка шрифта (обязательно!)
textNode.characters = "Новый текст"      // Замена текста
figma.createImageAsync(url)              // Создание изображения
```

**Для поиска компонентов:**

```typescript
figma.importComponentByKeyAsync(key)     // Импорт из библиотеки
node.mainComponent                       // Основной компонент инстанса
```

### Критические ограничения API

Нет возможности **обращаться к другим файлам** — только текущий документ. Нет **фонового выполнения** — плагин работает только при явном вызове. Для **team library** нужны известные ключи компонентов — нельзя просмотреть весь список. **CORS-ограничение**: внешние API должны возвращать `Access-Control-Allow-Origin: *`, иначе запросы блокируются.

**Лимиты хранения:** `setPluginData` — 100 KB на запись, `clientStorage` — 5 MB всего, `localStorage` — 1 MB на плагин.

---

## Интеграция с Yandex AI: практическое руководство

### Модели и цены YandexGPT

|Модель|Вход (1K токенов)|Выход (1K токенов)|Применение|
|---|---|---|---|
|**YandexGPT Lite**|$0.0017|$0.0017|Переименование слоёв, простые задачи|
|**YandexGPT Pro 5.1**|$0.0033*|$0.0033*|Генерация контента, анализ|
|**Alice AI LLM**|$0.0042|$0.0167|Диалоговые сценарии|

*Скидка 50% до 10 февраля 2026

**YandexART** (генерация изображений): **$0.018 за запрос**. Подходит для маркетинговых изображений, но **не оптимизирован для UI-элементов и иконок**.

### Архитектура интеграции: прокси обязателен

Figma-плагины выполняются в sandbox iframe с `origin: null`. Yandex Cloud API **не поддерживает** wildcard CORS, поэтому прямые вызовы невозможны. Решение — бэкенд-прокси:

```
[Figma Plugin] → [Ваш Proxy Server] → [Yandex Cloud API]
                 (CORS: *)
```

**Варианты хостинга прокси:**

- **Cloudflare Workers** — бесплатно до 100K запросов/день, edge-deployed
- **Vercel Functions** — бесплатный tier, легко деплоить
- **Docker на своём сервере** — полный контроль

### Пример прокси на Node.js

```javascript
const express = require('express');
const cors = require('cors');
const axios = require('axios');

app.use(cors({ origin: '*' }));

app.post('/api/yandex-gpt', async (req, res) => {
  const response = await axios.post(
    'https://llm.api.cloud.yandex.net/foundationModels/v1/completion',
    req.body,
    { headers: { 'Authorization': `Api-Key ${process.env.YANDEX_API_KEY}` }}
  );
  res.json(response.data);
});
```

### Настройка manifest.json

```json
{
  "networkAccess": {
    "allowedDomains": ["your-proxy.workers.dev"],
    "reasoning": "Proxy для Yandex AI API"
  }
}
```

**Триальный период Yandex Cloud:** 60 дней, грант ₽4000. Программа **Yandex Cloud Boost AI** предоставляет до **1 000 000 ₽** на AI-проекты.

---

## Матрица приоритизации: с чего начать

На основе анализа сложности, экономии времени, частоты использования и стоимости альтернатив:

### 🥇 Высший приоритет (Quick Wins, 1-2 недели)

|Плагин|Экономия|Сложность|Основные API|
|---|---|---|---|
|**AI Layer Renamer**|Время + организация|Низкая|selection, node.name, HTTP→YandexGPT|
|**Design Lint / Checker**|Stark: $198/год|Низкая|page.findAll, fills, strokes, effects|
|**Contrast Checker**|Stark: $198/год|Низкая|getSelectionColors, математика WCAG|
|**Content Populator**|Content Reel: бесплатный, но ограничен|Низкая|textNode.characters, createImageAsync|

### 🥈 Средний приоритет (2-4 недели)

|Плагин|Экономия|Сложность|Основные API|
|---|---|---|---|
|**Specs Generator**|Specs Pro: подписка|Средняя|node traversal, auto-layout, exportAsync|
|**Style Inventory**|Style Lens: бесплатный|Средняя|getLocalStyles, page traversal|
|**Design↔Web Overlay**|Pixelay: $108/год|Средняя|exportAsync + external screenshot API|
|**Icon Search**|Icons8: $108-228/год|Средняя|HTTP→Iconify API, createImageAsync|

### 🥉 Низкий приоритет (1-2 месяца, высокая сложность)

|Плагин|Экономия|Сложность|Причина сложности|
|---|---|---|---|
|**Code Generator**|Anima: $468/год|Высокая|Парсинг auto-layout в CSS/React|
|**Token Manager**|Tokens Studio: €468/год|Высокая|Git-интеграция, multi-brand themes|
|**Cross-File Components**|—|Высокая|API не поддерживает cross-file|

---

## Технические рецепты для каждого типа плагина

### 1. AI Layer Renamer (аналог LayerSense)

```typescript
// Получение выделенных слоёв
const selection = figma.currentPage.selection;
for (const node of selection) {
  const context = {
    type: node.type,
    currentName: node.name,
    parentName: node.parent?.name,
    textContent: node.type === 'TEXT' ? node.characters : null
  };
  // Отправка в UI → прокси → YandexGPT
  figma.ui.postMessage({ type: 'rename', context });
}
```

**Промпт для YandexGPT:** "Предложи семантическое имя для слоя типа {type}, содержащего текст '{textContent}', в родительском контейнере '{parentName}'. Ответь одним именем в формате kebab-case."

### 2. Contrast Checker (аналог Stark)

```typescript
function checkContrast(fg: RGB, bg: RGB): number {
  const L1 = relativeLuminance(fg);
  const L2 = relativeLuminance(bg);
  return (Math.max(L1, L2) + 0.05) / (Math.min(L1, L2) + 0.05);
}

function relativeLuminance(rgb: RGB): number {
  const [r, g, b] = [rgb.r, rgb.g, rgb.b].map(c => 
    c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4)
  );
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

// WCAG AA: ≥4.5:1 для текста, ≥3:1 для крупного текста
// WCAG AAA: ≥7:1 для текста
```

### 3. Content Populator с Yandex AI

```typescript
// Генерация реалистичных русских данных
const prompts = {
  name: "Сгенерируй реалистичное русское ФИО",
  address: "Сгенерируй реалистичный российский адрес",
  phone: "Сгенерируй российский номер телефона в формате +7 (XXX) XXX-XX-XX",
  email: "Сгенерируй реалистичный email на русском домене"
};

// Замена текста (обязательна загрузка шрифта!)
async function replaceText(node: TextNode, newText: string) {
  await figma.loadFontAsync(node.fontName as FontName);
  node.characters = newText;
}
```

### 4. Design Specs Exporter

```typescript
async function generateSpecs(node: SceneNode) {
  const specs = {
    dimensions: { width: node.width, height: node.height },
    position: { x: node.x, y: node.y },
    fills: 'fills' in node ? node.fills : [],
    effects: 'effects' in node ? node.effects : [],
    css: await node.getCSSAsync(),
    autoLayout: 'layoutMode' in node ? {
      mode: node.layoutMode,
      spacing: node.itemSpacing,
      padding: { top: node.paddingTop, right: node.paddingRight, 
                 bottom: node.paddingBottom, left: node.paddingLeft }
    } : null
  };
  return specs;
}
```

---

## Структура проекта и инструменты разработки

### Рекомендуемый стек

```
figma-plugins/
├── shared/                 # Общий код для всех плагинов
│   ├── yandex-api.ts      # Клиент для прокси
│   ├── figma-utils.ts     # Утилиты traversal
│   └── wcag-utils.ts      # Функции accessibility
├── layer-renamer/
│   ├── manifest.json
│   ├── src/
│   │   ├── code.ts        # Main thread
│   │   └── ui.tsx         # React UI
│   └── package.json
├── contrast-checker/
└── proxy-server/           # Cloudflare Worker или Node.js
    └── index.ts
```

### Настройка TypeScript

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020"],
    "strict": true,
    "typeRoots": ["./node_modules/@figma/plugin-typings"]
  }
}
```

**Зависимости:**

```bash
npm install -D @figma/plugin-typings typescript esbuild
npm install -D @figma/eslint-plugin-figma-plugins  # Опционально
```

### Тестирование и публикация

Разработка требует **Figma Desktop App** — в браузере не работает. Импорт плагина: Plugins → Development → Import plugin from manifest. Для hot reload используйте `tsc --watch` или `esbuild --watch`.

Публикация: Plugins → Development → Publish. Требуется иконка **128×128 PNG**, описание, скриншоты. После первичного review от Figma обновления публикуются мгновенно.

---

## Заключение: план действий на 3 месяца

**Месяц 1 (Quick Wins):**

1. Разверните прокси-сервер на Cloudflare Workers (~2 часа)
2. Создайте AI Layer Renamer с YandexGPT Lite (~1 неделя)
3. Создайте Contrast Checker с формулами WCAG (~3 дня)
4. Создайте Content Populator для русских данных (~1 неделя)

**Месяц 2 (Productivity Boost):**

1. Specs Generator для автоматизации handoff (~2 недели)
2. Style Inventory / Design Lint (~1 неделя)
3. Icon Search через Iconify API (~1 неделя)

**Месяц 3 (Advanced):**

1. Design↔Web Overlay с screenshot API (~2 недели)
2. Оптимизация и объединение плагинов в suite

**Экономия за год:** ~$500-800 на подписках + значительная экономия времени на рутинных задачах. Ключевое преимущество — полный контроль над функциональностью и возможность кастомизации под ваш воркфлоу.