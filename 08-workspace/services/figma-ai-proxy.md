---
title: "figma-ai-proxy — Multi-Provider AI Proxy"
type: guide
status: seed
version: "2.0.0"
created: 2026-03-03
updated: 2026-03-03
freshness: current
freshness_checked: 2026-03-03
tags: ["type/guide", "category/tools", "category/services", "platform/web"]
related_components: []
related_tokens: []
related_patterns: []
platforms: [web]
description: "Production CORS proxy for Figma plugins to access multiple AI providers, deployed at proxy.uixray.tech."
github: "https://github.com/uixray/figma-ai-proxy"
---

# figma-ai-proxy

> Мульти-провайдер CORS-прокси для AI API — создан для Figma плагинов.

**Версия:** 2.0.0 · **Лицензия:** MIT · [GitHub](https://github.com/uixray/figma-ai-proxy)
**Production:** `proxy.uixray.tech` (Nginx + PM2 + Let's Encrypt)

---

## Зачем этот сервис

Figma плагины работают в iframe с `null` origin — большинство AI API отклоняют такие запросы из-за CORS-политики браузера. figma-ai-proxy решает это: принимает запросы от плагина, добавляет корректные заголовки и проксирует к нужному AI-провайдеру.

Без этого прокси плагины UText, UData, URenaming не могут работать с облачными AI API.

---

## Поддерживаемые провайдеры

| Провайдер | Endpoint |
|----------|---------|
| Yandex Cloud | `https://llm.api.cloud.yandex.net` |
| Anthropic Claude | `https://api.anthropic.com` |
| Google Gemini | `https://generativelanguage.googleapis.com` |
| Groq | `https://api.groq.com` |
| Mistral AI | `https://api.mistral.ai` |
| Cohere | `https://api.cohere.ai` |

---

## Безопасность и ограничения

- **Stateless** — прокси не хранит данные, не логирует содержимое запросов
- **Rate limiting** — 60 запросов в минуту на IP/провайдер
- **Security headers** — Helmet.js (HSTS, CSP, X-Frame-Options)
- **Safe logging** — только метаданные (метод, статус), не содержимое

---

## Архитектура развёртывания

```
Клиент (Figma plugin)
    ↓ HTTPS
Nginx (reverse proxy, SSL termination)
    ↓
figma-ai-proxy (Node.js, порт 3001)
    ↓
AI Provider API
```

**PM2** управляет процессом Node.js, **Let's Encrypt** обеспечивает HTTPS.

Альтернатива для регионов с ограничениями: Cloudflare Workers tunnel.

---

## Дополнительные endpoints

| Endpoint | Назначение |
|---------|-----------|
| `GET /health` | Health check |
| `GET /api/info` | Информация о доступных провайдерах |
| `GET /` | Web UI для тестирования запросов |

---

## Стек

Node.js 18+, Express, Helmet.js, Nginx, PM2

---

## Место в стеке

figma-ai-proxy — **невидимая инфраструктура**, которую не замечаешь пока она работает. Единственный сервер, который необходимо поддерживать для работы AI-плагинов.

**Плагины, использующие прокси:**
- [[../figma-plugins/utext|UText]] — все AI-запросы
- [[../figma-plugins/udata|UData]] — AI-генерация данных
- [[../figma-plugins/urenaing|URenaming]] — AI-режим переименования
