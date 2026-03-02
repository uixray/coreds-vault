---
title: "О проекте CoreDS Vault"
type: meta
created: 2026-02-27
updated: 2026-02-27
---

# О проекте CoreDS Vault

## Два слоя, один vault

Этот vault объединяет два связанных проекта:

### 🎨 Design System (CoreDS)
Универсальная дизайн-система с архитектурой Core + Themes:
- Токены в формате [[W3C DTCG|DTCG 2025.10]]
- Компоненты для Web, iOS, Android
- Тематизация через переопределение токенов
- Автосборка через [[Style Dictionary]] v4

→ Подробнее: [[01-design-system/_spec/design-system-spec|ТЗ Design System]]

### 📚 Pattern Library
Библиотека UX-паттернов с AI-обновлением:
- [[02-patterns/foundations/_index|Foundations]]: эвристики, законы UX, когнитивная психология
- [[02-patterns/platform/_index|Platform]]: кроссплатформенные паттерны (Web/iOS/Android)
- [[02-patterns/interaction/_index|Interaction]]: формы, поиск, загрузка, ошибки
- [[02-patterns/ai/_index|AI Patterns]]: промпты, вывод, доверие, agentic UX
- [[02-patterns/domain/_index|Domain]]: SaaS, e-commerce, контент

→ Подробнее: [[02-patterns/_spec/patterns-spec|ТЗ Pattern Library]]

## Как связаны

```
Паттерн → информирует → Компонент
Компонент → реализует → Паттерн
Оба ← подпитываются ← Research
```

Каждый паттерн ссылается на компоненты CoreDS.
Каждый компонент ссылается на паттерны, которые он реализует.

## Навигация

- [[00-meta/conventions|Конвенции оформления]]
- [[00-meta/glossary|Глоссарий]]
- [[00-meta/roadmap|Дорожная карта]]
- [[00-meta/how-to-contribute|Как внести вклад]]
