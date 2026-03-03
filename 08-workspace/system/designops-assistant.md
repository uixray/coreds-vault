---
title: "DesignOps Assistant — AI Hotkeys for Windows"
type: guide
status: seed
version: "1.0.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "platform/windows"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "AutoHotkey v2 application for Windows that adds AI assistant, professional typography, and context-aware prompts as global hotkeys."
github: "TODO"
---

# DesignOps Assistant

> Middleware for Designers — AI-ассистент + типографика + интеграция с Figma через глобальные хоткеи на Windows.

**Версия:** 1.0.0 · **Лицензия:** MIT · **Платформа:** Windows 10/11 · **GitHub:** TODO

---

## Зачем этот инструмент

Главная проблема: чтобы воспользоваться AI, нужно переключиться в браузер или другое приложение, скопировать текст, получить ответ, вернуться. DesignOps Assistant убирает это переключение — AI доступен прямо там, где ты работаешь, одним хоткеем.

**Философия:** *Middleware for Designers* — посредник между намерением дизайнера и рабочими инструментами.

---

## Главные возможности

### AI Spotlight — `Alt + J`

Cmd+K-стиль окно с нечётким поиском по промптам. Выдели текст → `Alt+J` → выбери команду → AI отвечает с typing-анимацией.

**Контекстная адаптация** — ответ меняется в зависимости от активного приложения:

| Активное приложение | Поведение AI |
|--------------------|-------------|
| **Figma** | Краткий UX-текст, без Markdown, sentence case |
| **Obsidian** | Валидный Markdown, структурированные заметки |
| **VS Code** | Чистый код, без code fences |
| **Telegram** | Разговорный тон |
| **Chrome** | Краткий ассистент |

### Быстрая перезапись — `Shift + Alt + D`

Выдели текст → моментальная обработка первым промптом из списка. Один хоткей для самой частой задачи.

### Профессиональная типографика

В Design Mode (`CapsLock` toggle) работают хоткеи для правильных типографических символов:

| Хоткей | Символ | Описание |
|--------|--------|---------|
| `Alt + -` | — | Длинное тире |
| `Alt + Shift + -` | − | Минус (математический) |
| `Alt + .` | … | Многоточие |
| `Alt + Space` | ` ` | Неразрывный пробел (NBSP) |
| `Alt + [` | « | Левая кавычка-ёлочка |
| `Alt + ]` | » | Правая кавычка-ёлочка |
| `Alt + R` | ₽ | Знак рубля |

### Другие инструменты

| Хоткей | Функция |
|--------|---------|
| `Alt + S` | Сниппеты — мгновенная вставка шаблонов |
| `Alt + P` | Запуск плагинов Figma по имени |
| `Shift + Alt + C` | Смена регистра: lower → Title → UPPER |
| `Win + F` | Открыть Figma deep link в desktop-приложении |

---

## Встроенные промпты

| Промпт | Что делает |
|--------|-----------|
| ✨ Improve Text | Редактура и улучшение текста |
| 📝 Fix Grammar | Корректура без изменения стиля |
| 🖋️ Typographer | Типографика по стандартам Лебедева |
| 🇺🇸/🇷🇺 Translate | Авто-определение и перевод RU↔EN |
| 📢 Tone: Official | Официальный деловой тон |
| 🤝 Tone: Friendly | Дружелюбный разговорный тон |
| ⚠️ Tone: Error | UX-friendly сообщение об ошибке |
| 💡 5 Headlines | Варианты заголовков |
| 🎨 Color Palette | Палитра цветов по настроению текста |
| 🐟 Smart Dummy | Умный плейсхолдер вместо Lorem Ipsum |

Все промпты настраиваемы — редактируются через Settings → AI Prompts.

---

## Поддерживаемые AI-провайдеры

| Провайдер | Тип | Endpoint |
|----------|-----|---------|
| LM Studio | Локальный | `http://localhost:1234/v1/chat/completions` |
| Ollama | Локальный | `http://localhost:11434/v1/chat/completions` |
| OpenAI | Облако | api.openai.com |
| DeepSeek | Облако | api.deepseek.com |
| Claude | Облако | api.anthropic.com |
| YandexGPT | Облако | llm.api.cloud.yandex.net |

---

## Архитектура

```
DesignOps.ahk (Entry Point)
├── Runtime.ahk        AI Spotlight UI, Context Engine, Clipboard Manager
│   └── AIWorkerManager → AI_Runner.ahk (изолированный дочерний процесс)
├── Config.ahk         INI/JSON хранилище, XOR-обфускация ключей
└── GUI.ahk            8-вкладочный Settings (Dark theme, Mica blur)
```

**Ключевое:** AI-запросы выполняются в изолированном дочернем процессе через Stdin/Stdout IPC — интерфейс никогда не зависает. Атомарное сохранение данных защищает от потерь при краше.

---

## Установка

**Требования:** Windows 10 (1809+) или Windows 11, AutoHotkey v2.0

```bash
git clone https://github.com/uixray/DesignOps.git
copy settings.ini.example settings.ini
copy data.json.example data.json
```

Запустить `DesignOps.ahk` → иконка в трее → правый клик → Настройки.

Для работы без API-ключей: установить [LM Studio](https://lmstudio.ai) с любой локальной моделью.

---

## Место в стеке

DesignOps Assistant — **System Layer** в [[../philosophy/designer-as-creative-director|стеке автоматизации]]. Это единственный инструмент, который работает вне Figma и доступен в **любом** приложении. Именно он делает AI по-настоящему доступным в ежедневной работе дизайнера.
