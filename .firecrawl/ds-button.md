[Перейти к содержимому](https://ds.uixray.tech/components/button/#_top)

# Button

## Кнопка (Button)

[Заголовок раздела «Кнопка (Button)»](https://ds.uixray.tech/components/button/#%D0%BA%D0%BD%D0%BE%D0%BF%D0%BA%D0%B0-button)

Простейший компонент дизайн-системы, с которого обычно всё начинается. Используется для выполнения действий в интерфейсе.

### Свойства

[Заголовок раздела «Свойства»](https://ds.uixray.tech/components/button/#%D1%81%D0%B2%D0%BE%D0%B9%D1%81%D1%82%D0%B2%D0%B0)

| Prop | Type | Options | Default | Описание |
| --- | --- | --- | --- | --- |
| Size | String | xs / sm / md / lg / xl | md | Размер кнопки |
| Variant | String | primary / secondary / ghost / outline / destructive / link | primary | Вариант стиля кнопки |
| State | String | default / hover / active / focus / disabled / loading | default | Состояние кнопки |
| Has Icon | Boolean | true / false | false | Наличие иконки |
| Icon Position | String | leading / trailing | leading | Положение иконки относительно текста |

### Использование

[Заголовок раздела «Использование»](https://ds.uixray.tech/components/button/#%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)

#### Делайте так:

[Заголовок раздела «Делайте так:»](https://ds.uixray.tech/components/button/#%D0%B4%D0%B5%D0%BB%D0%B0%D0%B9%D1%82%D0%B5-%D1%82%D0%B0%D0%BA)

- Используйте одну кнопку primary CTA на экран.
- В тексте кнопки используйте глаголы, например: «Сохранить», «Отправить».

#### Не делайте так:

[Заголовок раздела «Не делайте так:»](https://ds.uixray.tech/components/button/#%D0%BD%D0%B5-%D0%B4%D0%B5%D0%BB%D0%B0%D0%B9%D1%82%D0%B5-%D1%82%D0%B0%D0%BA)

- Не используйте кнопку как ссылку для навигации.
- Не перегружайте кнопки иконками.

### Доступность

[Заголовок раздела «Доступность»](https://ds.uixray.tech/components/button/#%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%BD%D0%BE%D1%81%D1%82%D1%8C)

- Роль элемента должна быть `role=button` (или тег `<button>`).
- `tabindex=0` для обеспечения доступности с клавиатуры.
- Визуальное выделение при фокусе с помощью `focus-visible ring`.
- Контрастность согласно WCAG: не менее 4.5:1 для текста и 3:1 для UI-элементов.

* * *

📖 [Смотреть в Design System](https://ds.uixray.tech/components/button)