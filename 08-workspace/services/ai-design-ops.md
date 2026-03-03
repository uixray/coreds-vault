---
title: "AI Design Ops — Multi-Agent Design Orchestrator"
type: guide
status: seed
version: "0.1.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "category/services", "category/ai"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Experimental Python/FastAPI multi-agent system for routing design research tasks to specialized AI agents."
github: "TODO"
---

# AI Design Ops — Multi-Agent Orchestrator

> Экспериментальная мульти-агентная система для исследовательских дизайн-задач.

**Версия:** 0.1.0 (Experimental) · **GitHub:** TODO

---

## Концепция

Крупная дизайн-задача требует разных специалистов: кто-то ищет информацию, кто-то оценивает визуальное решение, кто-то проверяет техническую реализуемость. AI Design Ops моделирует эту команду через мульти-агентную архитектуру — Orchestrator получает задачу и распределяет её между специализированными агентами.

---

## Агенты

| Агент | Модель | Роль |
|-------|--------|------|
| **Orchestrator** | Gemma 3 12B (LM Studio, локально) | Разбивает задачу, координирует агентов, собирает ответ |
| **Research Lead** | Perplexity sonar-pro | Актуальная информация из интернета, бенчмарки |
| **Visual Lead** | Google Gemini 1.5 Pro | Оценка визуальных решений, анализ UI |
| **Tech Lead** | Google Gemini | Техническая реализуемость, компоненты |

---

## Пример задачи

**Вход:** "Как правильно реализовать empty states в мобильном приложении для iOS?"

**Обработка:**
1. Orchestrator (Gemma): разбивает на подзадачи
2. Research Lead (Perplexity): находит актуальные HIG гайдлайны, примеры из App Store
3. Visual Lead (Gemini): анализирует визуальные паттерны empty states
4. Tech Lead (Gemini): описывает технические ограничения iOS
5. Orchestrator: синтезирует финальный ответ

---

## Стек

| Компонент | Технология |
|----------|-----------|
| API | FastAPI 0.109 (Python 3.x) |
| Server | Uvicorn 0.27 |
| Validation | Pydantic 2.5 |
| LM Studio | Локальная модель (Gemma 3 12B) |
| Perplexity | sonar-pro (поиск в сети) |
| Gemini | Google AI Studio API |
| Database | PostgreSQL (Docker) |
| Deployment | Docker Compose |

---

## Архитектура

```
POST /chat → Orchestrator Agent
               ↓
    ┌──────────┼──────────┐
    ↓          ↓          ↓
Research    Visual     Tech
Lead        Lead       Lead
(Perplexity)(Gemini)  (Gemini)
    ↓          ↓          ↓
    └──────────┼──────────┘
               ↓
        Синтез ответа
               ↓
        Streaming response
```

---

## Статус

**Experimental** — активно используется для глубоких исследовательских задач, не готов к публикации.

Результаты работы системы → в `03-research/deep-research/` vault через ручной перенос.

---

## Место в стеке

AI Design Ops — самый мощный, но и самый сложный инструмент. Используется для задач, где нужно:
- Собрать актуальную информацию из сети (Perplexity)
- Оценить её с точки зрения визуального дизайна
- Получить структурированный итог для документирования в vault

**Связанные разделы:**
- [[../../03-research/deep-research/_index|Deep Research]] — сюда попадают результаты
- [[../philosophy/designer-as-creative-director|Философия]] — Data Layer стека
