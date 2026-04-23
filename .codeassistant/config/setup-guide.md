# Figma MCP Setup Guide for SourceCraft

## Предварительные требования

### 1. Учетная запись Figma

- **Требуется**: Full Seat или Dev Seat на платном плане (Professional, Organization, Enterprise)
- **Бесплатный аккаунт**: Ограничено 6 вызовами в месяц, только черновики
- **Проверка**: Убедитесь что у вас есть доступ к Figma Plugin API

### 2. SourceCraft Plugin

- Установите плагин SourceCraft в VS Code
- Авторизуйтесь через Yandex ID или корпоративную учетную запись
- Убедитесь что версия плагина поддерживает MCP (2026.1+)

### 3. VS Code

- Версия 1.90 или выше
- Включен Agent Mode в настройках чата

## Установка Figma MCP Server

### Способ 1: Через Marketplace (рекомендуется)

1. В чате SourceCraft нажмите кнопку **Marketplace** в верхней панели
2. Перейдите на вкладку **MCP**
3. Найдите "Figma MCP Server"
4. Нажмите **Install**
5. Выберите область действия:
   - **Global**: Для всех проектов
   - **Project**: Только для текущего проекта

### Способ 2: Ручная конфигурация

1. Откройте командную палитру VS Code (`Ctrl+Shift+P`)
2. Выполните команду `MCP: Open User Configuration`
3. Добавьте конфигурацию Figma в файл `mcp.json`:

```json
{
  "mcpServers": {
    "figma": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp"
    }
  }
}
```

### Способ 3: Локальный сервер для разработки

```json
{
  "mcpServers": {
    "figma-dev": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@figma/mcp-server"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "your_token_here"
      }
    }
  }
}
```

## Авторизация OAuth

1. При первом запуске сервера откроется окно браузера
2. Войдите в свою учетную запись Figma
3. Предоставьте необходимые разрешения:
   - `file:read` - чтение файлов
   - `file:write` - запись в файлы
   - `library:read` - чтение библиотек

4. После успешной авторизации токен будет сохранен
5. Управление токенами: **Accounts** > **Manage Trusted MCP Servers**

## Проверка установки

### 1. Проверка сервера

```bash
# В терминале VS Code
curl -X POST https://mcp.figma.com/mcp/tools/list \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN"
```

### 2. Проверка в SourceCraft

1. Откройте чат SourceCraft
2. Переключитесь в **Agent Mode**
3. Спросите: "Какие инструменты Figma MCP доступны?"
4. Должны появиться инструменты: `use_figma`, `get_design_context`, и др.

### 3. Тестовый запрос

```javascript
// Запросите агента выполнить тестовый скрипт
"Создай простой фрейм в черновиках Figma для тестирования";
```

## Настройка навыков (Skills)

### Автоматическая загрузка

Навыки из директорий `.codeassistant/rules/` и `.codeassistant/prompts/` загружаются автоматически при старте агента.

### Ручная загрузка

Если навыки не загружаются автоматически:

1. В чате SourceCraft выполните: `/load-skill .codeassistant/rules/figma-use.md`
2. Или используйте команду: `SourceCraft: Reload Skills`

### Обязательные навыки

Убедитесь что загружены:

- `figma-use.md` - **обязательный** для любого редактирования
- `figma-generate-design.md` - для создания дизайнов
- `figma-implement-design.md` - для синхронизации с кодом
- `figma-create-new-file.md` - для создания файлов

## Конфигурация проекта

### 1. Файл `.codeassistant/mcp.json`

Основной конфигурационный файл. Пример полной конфигурации:

```json
{
  "mcpServers": {
    "figma": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp",
      "enabled": true,
      "description": "Figma MCP Server"
    }
  },
  "settings": {
    "autoStart": true,
    "skillsDirectory": ".codeassistant/rules",
    "promptsDirectory": ".codeassistant/prompts"
  }
}
```

### 2. Файл `.codeassistant/config/figma-rules.json`

Правила для AI агента. Загружается автоматически.

### 3. Переменные окружения

Создайте файл `.env` в корне проекта:

```
FIGMA_ACCESS_TOKEN=your_personal_access_token
FIGMA_TEAM_ID=your_team_id
FIGMA_DESIGN_SYSTEM_URL=https://figma.com/file/...
```

## Интеграция с дизайн-системой

### 1. Подключение библиотек

Убедитесь что библиотеки дизайн-системы опубликованы и доступны:

1. В Figma откройте файл дизайн-системы
2. Нажмите "Publish" в правом верхнем углу
3. В настройках MCP укажите library keys

### 2. Использование переменных (Variables)

```javascript
// Получение цветовой переменной
const primaryColorVar = figma.variables.getVariableById("VariableID:12345");
if (primaryColorVar) {
  const colorValue = primaryColorVar.valuesByMode[figma.currentPage];
}
```

### 3. Code Connect (опционально)

Если используется Code Connect для связи кода с дизайном:

1. Установите Figma Code Connect CLI
2. Сгенерируйте mapping файлы
3. Используйте инструмент `send_code_connect_mappings`

## Типичные сценарии использования

### Сценарий 1: Быстрое прототипирование

```
"Создай прототип экрана входа в систему с email, паролем и кнопкой входа"
```

### Сценарий 2: Обновление дизайна на основе кода

```
"На основе изменений в компоненте Button.tsx, обнови компонент в Figma файле <URL>"
```

### Сценарий 3: Создание документации

```
"Создай FigJam файл с диаграммой пользовательского потока для фичи поиска"
```

## Устранение неполадок

### Ошибка: "Authentication Failed"

1. Проверьте срок действия OAuth токена
2. Выполните: `SourceCraft Code Assistant: Login`
3. Перезапустите сервер Figma MCP
4. Проверьте разрешения учетной записи Figma

### Ошибка: "Rate Limit Exceeded" (429)

1. Проверьте лимиты вашего тарифного плана:
   - Starter: 6 вызовов/месяц
   - Professional: 200 вызовов/день
   - Enterprise: 600 вызовов/день
2. Оптимизируйте запросы (объединяйте изменения)
3. Используйте кэширование где возможно

### Ошибка: "Node not found"

1. Убедитесь что узел еще существует в файле
2. Используйте `get_metadata` для получения актуальной структуры
3. Проверьте правильность node ID или имени

### Ошибка: "Missing Font"

1. Используйте только системные шрифты (Inter, Roboto, SF Pro)
2. Или шрифты загруженные в корпоративную библиотеку Figma
3. Всегда вызывайте `figma.loadFontAsync()` перед работой с текстом

### Ошибка: "Response too large" (20KB limit)

1. Разбейте изменения на части
2. Используйте стратегию chunking
3. Сначала измените header, затем content, затем footer

### Сервер не запускается

1. Проверьте интернет-соединение
2. Убедитесь что URL `https://mcp.figma.com/mcp` доступен
3. Проверьте firewall на блокировку запросов
4. Попробуйте использовать локальный сервер

## Оптимизация производительности

### 1. Кэширование метаданных

```javascript
// Кэшируйте результаты get_metadata
const metadata = await get_metadata({ fileUrl });
// Используйте cached metadata для последующих операций
```

### 2. Пакетные операции

```javascript
// Вместо множества мелких вызовов
await use_figma(script1);
await use_figma(script2);
await use_figma(script3);

// Объедините в один вызов
await use_figma(combinedScript);
```

### 3. Предварительная загрузка

Загружайте шрифты и библиотеки заранее:

```javascript
// В начале сессии
await Promise.all([
  figma.loadFontAsync({ family: "Inter", style: "Regular" }),
  figma.loadFontAsync({ family: "Inter", style: "Bold" }),
  search_design_system({ query: "colors" }),
]);
```

## Безопасность

### 1. Токены доступа

- Никогда не коммитьте токены в репозиторий
- Используйте .env файлы и .gitignore
- Регулярно обновляйте токены

### 2. Разрешения

- Предоставляйте минимально необходимые разрешения
- Регулярно проверяйте список доверенных приложений в Figma
- Отзывайте доступ у неиспользуемых серверов

### 3. Аудит действий

- Figma сохраняет историю изменений
- MCP сервер логирует все вызовы
- Настройте уведомления о подозрительной активности

## Дальнейшие шаги

### 1. Интеграция с CI/CD

Настройте автоматическую проверку дизайна в pipeline:

```yaml
# .github/workflows/design-check.yml
name: Design Compliance Check
on: [pull_request]
jobs:
  check-design:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check design consistency
        run: |
          # Используйте MCP для проверки соответствия кода дизайну
```

### 2. Кастомные навыки

Создавайте специализированные навыки для вашей команды:

- `figma-design-review.md` - для ревью дизайна
- `figma-token-sync.md` - для синхронизации токенов
- `figma-a11y-check.md` - для проверки доступности

### 3. Мониторинг

Настройте мониторинг использования:

- Количество вызовов в день
- Частота ошибок
- Время выполнения операций

## Получение помощи

### Официальная документация

- [Figma MCP Documentation](https://www.figma.com/developers/mcp)
- [SourceCraft Plugin Docs](https://sourcecraft.yandex.com/docs)
- [Model Context Protocol Spec](https://spec.modelcontextprotocol.io)

### Сообщество

- Figma Community Plugins форум
- SourceCraft Discord сервер
- GitHub Issues для багов и feature requests

### Поддержка

- Для проблем с Figma MCP: support@figma.com
- Для проблем с SourceCraft: support@sourcecraft.yandex.com
- Для общих вопросов по MCP: mcp-community@modelcontextprotocol.io
