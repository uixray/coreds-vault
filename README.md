# CoreDS Vault

> Универсальная дизайн-система + библиотека UX-паттернов в формате Obsidian vault

## Что это

Открытый Obsidian vault, объединяющий два слоя:

- **Design System (CoreDS)** — токены, компоненты, темы для Web / iOS / Android
- **Pattern Library** — UX-паттерны, эвристики, AI interaction patterns

Vault периодически обновляется — AI-assisted freshness checking гарантирует актуальность контента.

## Быстрый старт

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/uixray/coreds-vault.git
   ```
2. Откройте папку `coreds-vault` как vault в Obsidian
3. Установите рекомендуемые плагины (Obsidian предложит автоматически)
4. Начните с `00-meta/about.md`

## Структура

```
00-meta/           Конвенции, глоссарий, roadmap
01-design-system/  Токены, компоненты, темы, гайды
02-patterns/       UX-паттерны по категориям
03-research/       Исследования и источники
04-automation/     Скрипты и шаблоны
05-tokens/         DTCG JSON — source of truth
06-platforms/      Сгенерированные CSS / Swift / Kotlin
07-figma/          Figma-связанные материалы
```

## Включённые ресурсы

Vault включает промпты из проекта **[Fabric](https://github.com/danielmiessler/fabric)** (MIT License),
расположенные в `04-automation/prompts/fabric/`. Fabric — open-source framework для работы с AI,
разработанный [Daniel Miessler](https://github.com/danielmiessler). Авторство оригинальных промптов сохранено.

## Статус

🚧 В разработке — v0.1.0 (инициализация vault)

## Лицензии

- **Код и токены:** MIT (`LICENSE-CODE.md`)
- **Документация и паттерны:** CC BY-SA 4.0 (`LICENSE-CONTENT.md`)

## Автор

Ray ([@uixray](https://github.com/uixray)) — UI/UX дизайнер, 10+ лет опыта
