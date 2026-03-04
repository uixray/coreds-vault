---
title: "Button"
type: component
status: seed
version: "0.3.0"
created: 2026-03-04
updated: 2026-03-04
freshness: current
freshness_checked: 2026-03-04
tags: ["type/component"]
platforms: [web]
figma_link: ""
description: "Auto-generated from Figma"
---

## Кнопка (Button)

Кнопка — это простейший компонент дизайн-системы, который обычно используется для выполнения действий, таких как «Сохранить» или «Отправить».

### Свойства

| Prop | Type | Options | Default | Описание |
| --- | --- | --- | --- | --- |
| Size | String | xs / sm / md / lg / xl | md | Размер кнопки |
| Variant | String | primary / secondary / ghost / outline / destructive / link | primary | Вариант стиля кнопки |
| State | String | default / hover / active / focus / disabled / loading | default | Состояние кнопки |
| Has Icon | Boolean | true / false | false | Наличие иконки |
| Icon Position | String | leading / trailing / icon-only | — | Положение иконки |

### Использование

#### Делайте так:

- Используйте одну кнопку primary CTA на экран.
- В тексте кнопки используйте глагол («Сохранить», «Отправить»).

#### Не делайте так:

- Не используйте кнопку как ссылку для навигации.
- Не перегружайте кнопку иконками.

### Доступность

- Роль: `role=button` (или `<button>`).
- `tabindex=0`.
- Видимое кольцо при фокусе.
- Контрастность по WCAG ≥4.5:1 для текста и ≥3:1 для UI-элементов.