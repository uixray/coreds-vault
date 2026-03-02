---
title: "Figma Plugin Rules"
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
description: "Rules and guidelines for Figma plugin development"
---

# Figma Plugin Development Rules & Best Practices

## ⚠️ КРИТИЧЕСКИЕ ПРАВИЛА - ВСЕГДА СЛЕДОВАТЬ!

### 1. Network API - ИСПОЛЬЗУЙ ТОЛЬКО `fetch()`

**НЕПРАВИЛЬНО:**
```typescript
const response = await figma.network.fetch(url, options);
```

**ПРАВИЛЬНО:**
```typescript
const response = await fetch(url, options);
```

**Причина:** В Figma Plugin API используется стандартный глобальный `fetch()` API, а не `figma.network.fetch()`. Последнего просто не существует!

**Проверка доступности:**
```typescript
if (typeof fetch !== 'function') {
  console.error('fetch is not available');
  return;
}
```

**Источники:**
- [Making Network Requests | Plugin API](https://www.figma.com/plugin-docs/making-network-requests/)
- [fetch | Plugin API](https://www.figma.com/plugin-docs/api/properties/global-fetch/)

---

### 2. Network Access в manifest.json

**КРИТИЧНО:** IP адреса НЕ поддерживаются в `devAllowedDomains`!

**НЕПРАВИЛЬНО:**
```json
"devAllowedDomains": [
  "http://127.0.0.1:1234",
  "http://10.8.1.17:1234",
  "http://localhost:*"
]
```

**ПРАВИЛЬНО:**
```json
"devAllowedDomains": [
  "http://localhost:1234"
]
```

**Правила:**
- ✅ Используй `localhost` с конкретным портом
- ❌ НЕ используй IP адреса (127.0.0.1, 192.168.x.x, 10.x.x.x)
- ❌ НЕ используй wildcards в портах (`localhost:*`)
- ✅ Указывай протокол (`http://` или `https://`)
- ✅ Указывай конкретный порт (`:1234`, `:3000`, и т.д.)

**Валидация URL:**
Figma строго проверяет формат URL. Ошибка `Invalid value for devAllowedDomains. 'X' must be a valid URL` означает неверный формат.

**Источники:**
- [Plugin Manifest | Developer Docs](https://developers.figma.com/docs/plugins/manifest/)
- [Making Network Requests | Developer Docs](https://developers.figma.com/docs/plugins/making-network-requests/)

---

### 3. Доступ к Network API требует UI

**ПРОБЛЕМА:** `fetch()` доступен только когда плагин имеет UI.

**РЕШЕНИЕ для команд меню без UI:**

```typescript
// Создать невидимый UI
const html = `
  <html>
    <head><style>body { margin: 0; padding: 0; }</style></head>
    <body>
      <script>
        parent.postMessage({ pluginMessage: { type: 'ui-ready' } }, '*');
      </script>
    </body>
  </html>
`;

figma.showUI(html, { visible: false, width: 1, height: 1 });

// Затем в handleUIMessage
if (message.type === 'ui-ready') {
  // Теперь можно использовать fetch()
  const response = await fetch(url, options);
}
```

**Причина:** `fetch()` доступен только в контексте с браузерными API, которые требуют UI iframe.

---

### 4. CORS Requirements

Figma плагины имеют `null` origin, поэтому могут обращаться только к API с:
```
Access-Control-Allow-Origin: *
```

**Для локальных серверов (LM Studio, etc):**
- Убедись что сервер слушает на `localhost`, не на IP адресе
- Сервер должен возвращать CORS заголовки для `*` origin

---

### 5. Manifest.json - Структура NetworkAccess

```json
{
  "networkAccess": {
    "allowedDomains": [
      "https://api.production.com",
      "https://*.cdn.com"
    ],
    "devAllowedDomains": [
      "http://localhost:3000",
      "http://localhost:1234"
    ],
    "reasoning": "Required for communication with external APIs"
  }
}
```

**Правила:**
- `allowedDomains` - для production
- `devAllowedDomains` - для development/testing
- Можно использовать wildcards в subdomains: `https://*.example.com`
- НЕ забывай добавлять `reasoning` для прохождения review

---

### 6. Типичные Ошибки и Решения

#### Ошибка: `Cannot read properties of undefined (reading 'fetch')`
**Причина:** Использовался `figma.network.fetch` вместо `fetch`
**Решение:** Заменить на `fetch()`

#### Ошибка: `Invalid value for devAllowedDomains. 'X' must be a valid URL`
**Причина:** Неверный формат URL (IP адрес, wildcard в порту)
**Решение:** Использовать `http://localhost:PORT`

#### Ошибка: `fetch is not defined`
**Причина:** Команда выполняется без UI
**Решение:** Создать невидимый UI (см. пункт 3)

#### Ошибка: `Content Security Policy directive`
**Причина:** Домен не добавлен в `allowedDomains`/`devAllowedDomains`
**Решение:** Добавить домен в manifest.json

---

### 7. Best Practices

#### Логирование для отладки
```typescript
console.log('[MODULE] Action:', action);
console.log('[MODULE] fetch available:', typeof fetch);
console.log('[MODULE] Using URL:', url);
```

#### Обработка ошибок сети
```typescript
try {
  const response = await fetch(url, options);

  if (!response.ok) {
    const errorText = await response.text();
    console.error('[ERROR] Response:', response.status, errorText);
    figma.notify(`❌ Error ${response.status}`);
    return;
  }

  const data = await response.json();
  // process data...

} catch (error) {
  console.error('[ERROR] Network request failed:', error);
  figma.notify(`❌ ${error.message}`);
}
```

#### Проверка доступности API перед использованием
```typescript
if (typeof fetch !== 'function') {
  console.error('[ERROR] fetch API not available');
  figma.notify('❌ Network API not available');
  figma.closePlugin();
  return;
}
```

---

### 8. LM Studio / Local Server Integration

**Правильная конфигурация:**

1. **В LM Studio:**
   - Bind to: `localhost` или `127.0.0.1`
   - Port: `1234` (по умолчанию)
   - Убедись что Server URL показывает `http://localhost:1234`

2. **В manifest.json:**
   ```json
   "devAllowedDomains": [
     "http://localhost:1234"
   ]
   ```

3. **В настройках плагина:**
   - Base URL: `http://localhost:1234/v1`
   - Model: `ibm/granite-3.2-8b` (или другая модель)

4. **В коде:**
   ```typescript
   const url = `${baseUrl}/chat/completions`;
   const response = await fetch(url, {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify({
       model: 'ibm/granite-3.2-8b',
       messages: [{ role: 'user', content: prompt }],
       temperature: 0.7,
       max_tokens: 500
     })
   });
   ```

---

### 9. Тестирование Network Requests

**Чек-лист перед тестированием:**
- [ ] `devAllowedDomains` содержит правильный URL
- [ ] Используется `fetch()`, а не `figma.network.fetch()`
- [ ] Локальный сервер запущен на `localhost`, не на IP
- [ ] Плагин перезагружен после изменения manifest.json
- [ ] UI создан (даже невидимый) перед вызовом `fetch()`
- [ ] CORS настроен на сервере (`Access-Control-Allow-Origin: *`)

---

### 10. Команды из меню (Menu Commands)

**Структура в manifest.json:**
```json
"menu": [
  {
    "name": "My Command",
    "command": "my-command"
  }
]
```

**Обработка в code.ts:**
```typescript
private async initializePlugin(): Promise<void> {
  const command = figma.command;

  if (command === 'my-command') {
    // Если нужен fetch, создай UI
    figma.showUI(invisibleHTML, { visible: false, width: 1, height: 1 });
    // Жди ui-ready перед использованием fetch
  } else {
    // Показать обычный UI
    figma.showUI(__html__, { width: 400, height: 600 });
  }
}
```

---

## 📚 Полезные Ссылки

### Официальная документация:
- [Plugin API Overview](https://www.figma.com/plugin-docs/)
- [Making Network Requests](https://www.figma.com/plugin-docs/making-network-requests/)
- [Plugin Manifest](https://developers.figma.com/docs/plugins/manifest/)
- [How Plugins Run](https://www.figma.com/plugin-docs/how-plugins-run/)

### Форум и примеры:
- [Figma Plugin Forum](https://forum.figma.com/)
- [CORS Error Discussion](https://forum.figma.com/report-a-problem-6/cors-error-in-figma-plugin-despite-configuring-alloweddomains-and-devalloweddomains-36708)

---

## 🔄 История изменений

### 2024 (текущая версия плагина)
- ✅ Используется `fetch()` вместо `figma.network.fetch()`
- ✅ `devAllowedDomains` использует только `localhost` с конкретным портом
- ✅ Команды меню создают невидимый UI для network access
- ✅ Проверка `typeof fetch !== 'function'` перед использованием

---

## ⚡ Quick Reference

```typescript
// ✅ ПРАВИЛЬНО
const response = await fetch('http://localhost:1234/v1/chat/completions', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(data)
});

// ❌ НЕПРАВИЛЬНО
const response = await figma.network.fetch(url, options);

// ✅ ПРАВИЛЬНО в manifest.json
"devAllowedDomains": ["http://localhost:1234"]

// ❌ НЕПРАВИЛЬНО в manifest.json
"devAllowedDomains": ["http://127.0.0.1:1234"]
"devAllowedDomains": ["http://localhost:*"]
"devAllowedDomains": ["http://10.8.1.17:1234"]
```

---

**ВСЕГДА ПРОВЕРЯЙ ЭТОТ ДОКУМЕНТ ПЕРЕД РАБОТОЙ С NETWORK API В FIGMA ПЛАГИНАХ!**
