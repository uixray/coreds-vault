> Пример документации экрана через Claude с подключенным MCP сервером Figma
# Документация для разработки: Экран "Профиль"

**Figma:** [301. Profile](https://www.figma.com/design/BGqcd00JMVixZfxg8fOdVG/Untitled?node-id=5-252&m=dev)  
**Платформа:** Flutter (iOS/Android)  
**Дата:** 31.01.2026

---

## 1. Обзор экрана (Overview)

Экран профиля пользователя — основной хаб для доступа к настройкам, управлению аккаунтом и дополнительным функциям приложения. Содержит информацию о пользователе, статус синхронизации и навигацию к вложенным разделам.

### Структура экрана

```
ProfileScreen
├── Header (AppBar)
│   ├── StatusBar (системный)
│   ├── ConnectionIndicator
│   ├── Title "Профиль"
│   └── MoreActionsButton
├── ScrollableContent
│   ├── UserCard
│   ├── SyncCard
│   └── MenuList
│       ├── ListItem (×11 пунктов)
│       └── Специальные варианты (alert, badge)
└── BottomNavigationBar
    └── 4 таба + StatusBadge
```

---

## 2. Дизайн-токены (Design Tokens)

### 2.1 Цветовая палитра

|Токен|HEX|Использование|
|---|---|---|
|`primary.red`|`#B12535`|Акцентный цвет, аватар, активные элементы|
|`primary.black`|`#353535`|Основной текст|
|`secondary.white`|`#FFFFFF`|Фон экрана, карточки|
|`secondary.icons`|`#B6B6B6`|Неактивные иконки|
|`secondary.input`|`#F2F2F2`|Фон инпутов, разделители|
|`text.gray`|`#808080`|Вторичный текст, подписи|
|`text.empty`|`#D0CFCE`|Placeholder текст|
|`tertiary.green`|`#25B144`|Индикатор онлайн/подключения|
|`tertiary.latte`|`#F7F1EE`|Фон карточки пользователя|
|`accent.brown`|`#8E6C59`|Значения в списке|

### 2.2 Типографика

|Стиль|Параметры|Использование|
|---|---|---|
|`titlePage`|Open Sans Bold, 34px, lh: 40px|Заголовок экрана|
|`title18B`|Open Sans Bold, 18px, lh: 24px|Заголовки карточек, имя пользователя|
|`body16R`|Open Sans Regular, 16px, lh: 1.3|Пункты меню|
|`body14R`|Open Sans Regular, 14px, lh: 1.3|Значения, бейджи|
|`body12R`|Open Sans Regular, 12px, lh: 1.3|Подписи, мета-информация|
|`caption10R`|Open Sans Regular, 10px, lh: 1.3|Подписи навигации, мелкий текст|

### 2.3 Отступы и размеры

|Токен|Значение|Использование|
|---|---|---|
|`edgeInsets`|16px|Горизонтальные отступы от края экрана|
|`cardPadding`|16px|Внутренние отступы карточек|
|`sectionGap`|24px|Расстояние между секциями|
|`itemHeight`|48px|Высота пункта меню|
|`iconSize`|24px|Размер иконок|
|`avatarSize`|56px|Размер аватара пользователя|
|`borderRadius.card`|12px|Скругление карточек|
|`borderRadius.avatar`|12px|Скругление аватара|
|`borderRadius.screen`|40px|Скругление экрана (для mockup)|

### 2.4 Тени (Shadows)

```dart
// Card Shadow
BoxShadow cardShadow = [
  BoxShadow(
    color: Color(0x17000000), // rgba(0,0,0,0.09)
    offset: Offset(0, 0),
    blurRadius: 12,
  ),
  BoxShadow(
    color: Color(0x0F000000), // rgba(0,0,0,0.06)
    offset: Offset(0, 3),
    blurRadius: 4,
  ),
];

// Bottom Navigation Shadow
BoxShadow bottomShadow = [
  BoxShadow(
    color: Color(0x29000000), // rgba(0,0,0,0.16)
    offset: Offset(0, 0),
    blurRadius: 12,
  ),
  BoxShadow(
    color: Color(0x0D000000), // rgba(0,0,0,0.05)
    offset: Offset(0, -2),
    blurRadius: 4,
  ),
];
```

---

## 3. Компоненты (Components)

### 3.1 Header

**Node ID:** `5:253`

```
┌─────────────────────────────────────┐
│ 9:41                    ⦿ .·))🔋   │ ← StatusBar (системный)
│ Профиль                      ⋮     │ ← Title + Actions
└─────────────────────────────────────┘
```

|Элемент|Спецификация|
|---|---|
|Фон|`secondary.white` (#FFFFFF)|
|Заголовок|`titlePage`, цвет `primary.black`|
|Иконка "More"|24×24px, цвет `secondary.icons`|
|ConnectionIndicator|16×16px, фон `tertiary.green`, позиция: top-right|
|Padding|horizontal: 16px, top: 24px, bottom: 4px|

**ConnectionIndicator состояния:**

- Online: `#25B144` (зелёный) + белая точка внутри
- Offline: `#B12535` (красный)
- Syncing: анимация пульсации

### 3.2 UserCard

**Node ID:** `5:161`

```
┌─────────────────────────────────────┐
│ ┌────┐                              │
│ │ ВК │  Василий Кешнов              │
│ └────┘  Открыть профиль →           │
└─────────────────────────────────────┘
```

|Элемент|Спецификация|
|---|---|
|Контейнер|Фон `tertiary.latte` (#F7F1EE), radius: 16px|
|Аватар|56×56px, фон `primary.red`, radius: 12px|
|Инициалы|Open Sans Regular, 18px, белый, центрирование|
|Имя|`title18B`, цвет `primary.black`|
|Подпись|`body12R`, цвет `text.gray`, содержит "→"|
|Padding|left: 0, right: 16px (аватар edge-to-edge слева)|
|Gap|16px между аватаром и текстом|

**Интерактивность:**

- Вся карточка кликабельна → переход на экран профиля пользователя
- Ripple effect при нажатии

### 3.3 SyncCard (Card Order)

**Node ID:** `5:176`

```
┌─────────────────────────────────────┐
│ Синхронизация                       │
│                                     │
│ Последняя синхронизация  22.09.23   │
│ ─────────────────────────────────── │
│ Заказов не выгружено            12  │
└─────────────────────────────────────┘
```

|Элемент|Спецификация|
|---|---|
|Контейнер|Фон `secondary.white`, radius: 12px, shadow: `cardShadow`|
|Заголовок|`title18B`, цвет `primary.black`|
|Label|`body12R`, цвет `primary.black`|
|Value|`body14R`, цвет `primary.black`, letter-spacing: -0.14px|
|Divider|1px, цвет `secondary.input` (#F2F2F2)|
|Padding|16px со всех сторон|
|Gap|16px между заголовком и контентом, 12px между строками|

### 3.4 ListItem

**Node ID:** `5:192`

Переиспользуемый компонент для пунктов меню с вариациями.

#### Базовый вариант

```
┌─────────────────────────────────────┐
│ Заказ брака                       › │
└─────────────────────────────────────┘
```

#### С значением

```
┌─────────────────────────────────────┐
│ Пункт                    Значение › │
└─────────────────────────────────────┘
```

#### С предупреждением (Alert)

```
┌─────────────────────────────────────┐
│ Прайс-лист                    ⚠️  › │
└─────────────────────────────────────┘
```

#### С бейджем (Badge)

```
┌─────────────────────────────────────┐
│ Уведомления              [144]    › │
└─────────────────────────────────────┘
```

|Свойство|Спецификация|
|---|---|
|Высота|48px|
|Padding|horizontal: 16px, vertical: 8px|
|Label|`body16R`, цвет `primary.black`, flex: 1|
|Value|`body14R`, цвет `accent.brown` (#8E6C59)|
|Chevron|24×24px, цвет `secondary.icons`|
|Alert icon|24×24px, жёлтый треугольник с "!"|
|Badge|Фон `primary.red`, radius: 16px, padding: 8×4px|
|Badge text|`body14R`, белый|
|Gap|8px между элементами, 4px между label и value|

**Props для Flutter:**

```dart
class ListItem extends StatelessWidget {
  final String label;
  final String? value;
  final bool showChevron;
  final Widget? trailing; // Для кастомных элементов (alert, badge)
  final VoidCallback? onTap;
  
  // ...
}
```

### 3.5 BottomNavigationBar

**Node ID:** `5:279`

```
┌─────────────────────────────────────┐
│  🏠      🛒      📍      👤        │
│ Заказы  Корзина Маршруты Профиль   │
│         ───────────────────        │
└─────────────────────────────────────┘
```

|Элемент|Спецификация|
|---|---|
|Контейнер|Фон `secondary.white`, border-top: 1px `secondary.input`, shadow: `bottomShadow`|
|Tab height|64px|
|Icon size|24×24px|
|Label|Mona Sans Medium, 10px, цвет `text.gray`|
|Active color|`primary.red` (#B12535)|
|Inactive color|`text.gray` (#808080)|
|Home Indicator|iOS-style, 139×5px, radius: 100px, цвет `primary.black`|

**StatusBadge (на иконке Профиль):**

- Позиция: top-right от иконки
- Фон: `primary.black` (#353535)
- Border: 1px white
- Radius: 16px
- Text: `caption10R`, белый
- Padding: 4×3px

**Табы:**

1. **Заказы** (Home) — иконка дом
2. **Корзина** (Cart) — иконка корзины
3. **Маршруты** (Map) — иконка метки на карте
4. **Профиль** (User) — иконка пользователя (активный)

---

## 4. Список пунктов меню

|№|Label|Trailing|Навигация|
|---|---|---|---|
|1|Заказ брака|chevron|→ DefectOrderScreen|
|2|Торговые точки|chevron|→ OutletsScreen|
|3|Избранное|chevron|→ FavoritesScreen|
|4|Прайс-лист|alert + chevron|→ PriceListScreen|
|5|Отложенное|chevron|→ PostponedScreen|
|6|Уведомления|badge(144) + chevron|→ NotificationsScreen|
|7|Дебиторские задолженности|chevron|→ DebtsScreen|
|8|Ассортиментная дистрибуция|chevron|→ DistributionScreen|
|9|Предложить идею|chevron|→ SuggestIdeaScreen|
|10|Написать в поддержку|chevron|→ SupportScreen|
|11|Разрешения приложения|chevron|→ PermissionsScreen|

---

## 5. Поведение и состояния

### 5.1 Скролл

- Контент между Header и BottomNavigation скроллится
- Header фиксирован (не скроллится)
- BottomNavigation фиксирован

### 5.2 Pull-to-Refresh

- Доступен на этом экране
- Обновляет данные синхронизации
- Анимация: стандартный RefreshIndicator с цветом `primary.red`

### 5.3 Состояния загрузки

**SyncCard:**

- Loading: skeleton placeholder для значений
- Error: красный текст ошибки вместо значений
- Success: отображение данных

**Badge на "Уведомления":**

- Скрыт если count = 0
- Максимальное значение: "99+" для count > 99

### 5.4 Доступность (Accessibility)

- Все интерактивные элементы имеют `semanticLabel`
- Минимальный touch target: 48×48px
- Контраст текста соответствует WCAG AA

---

## 6. Ассеты (Assets)

### Иконки (SVG/PNG)

|Иконка|Файл|Размер|
|---|---|---|
|Chevron right|`ic_chevron_right.svg`|24×24|
|More vertical|`ic_more_vertical.svg`|24×24|
|Alert fill|`ic_alert_fill.svg`|24×24|
|Home|`ic_home.svg`|24×24|
|Cart|`ic_cart.svg`|24×24|
|Map pin|`ic_map_pin.svg`|24×24|
|User|`ic_user.svg`|24×24|
|Connection dot|`ic_connection_dot.svg`|6×6|

### Шрифты

- **Open Sans**: Regular (400), Bold (700)
- **Mona Sans**: Medium (500) — только для навигации

---

## 7. Пример реализации (Flutter)

### Структура файлов

```
lib/
├── features/
│   └── profile/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── profile_screen.dart
│       │   └── widgets/
│       │       ├── user_card.dart
│       │       ├── sync_card.dart
│       │       └── profile_list_item.dart
│       ├── domain/
│       │   └── entities/
│       │       └── user_profile.dart
│       └── data/
│           └── repositories/
│               └── profile_repository.dart
└── core/
    ├── theme/
    │   ├── app_colors.dart
    │   ├── app_typography.dart
    │   └── app_shadows.dart
    └── widgets/
        └── bottom_navigation.dart
```

### Базовый код экрана

```dart
// profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const ProfileHeader(),
            
            // Scrollable content
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryRed,
                onRefresh: () async {
                  // Обновление данных синхронизации
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const UserCard(
                        initials: 'ВК',
                        name: 'Василий Кешнов',
                      ),
                      const SizedBox(height: 24),
                      const SyncCard(
                        lastSync: '22.09.23 14:30',
                        pendingOrders: 12,
                      ),
                      const SizedBox(height: 8),
                      
                      // Menu items
                      ..._buildMenuItems(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 3, // Профиль
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      ProfileListItem(
        label: 'Заказ брака',
        onTap: () => Navigator.pushNamed(context, '/defect-order'),
      ),
      ProfileListItem(
        label: 'Торговые точки',
        onTap: () => Navigator.pushNamed(context, '/outlets'),
      ),
      ProfileListItem(
        label: 'Избранное',
        onTap: () => Navigator.pushNamed(context, '/favorites'),
      ),
      ProfileListItem(
        label: 'Прайс-лист',
        trailing: const AlertIcon(),
        onTap: () => Navigator.pushNamed(context, '/price-list'),
      ),
      ProfileListItem(
        label: 'Отложенное',
        onTap: () => Navigator.pushNamed(context, '/postponed'),
      ),
      ProfileListItem(
        label: 'Уведомления',
        trailing: const NotificationBadge(count: 144),
        onTap: () => Navigator.pushNamed(context, '/notifications'),
      ),
      ProfileListItem(
        label: 'Дебиторские задолженности',
        onTap: () => Navigator.pushNamed(context, '/debts'),
      ),
      ProfileListItem(
        label: 'Ассортиментная дистрибуция',
        onTap: () => Navigator.pushNamed(context, '/distribution'),
      ),
      ProfileListItem(
        label: 'Предложить идею',
        onTap: () => Navigator.pushNamed(context, '/suggest-idea'),
      ),
      ProfileListItem(
        label: 'Написать в поддержку',
        onTap: () => Navigator.pushNamed(context, '/support'),
      ),
      ProfileListItem(
        label: 'Разрешения приложения',
        onTap: () => Navigator.pushNamed(context, '/permissions'),
      ),
    ];
  }
}
```

### Цвета

```dart
// app_colors.dart

abstract class AppColors {
  // Primary
  static const Color primaryRed = Color(0xFFB12535);
  static const Color primaryBlack = Color(0xFF353535);
  
  // Secondary
  static const Color secondaryWhite = Color(0xFFFFFFFF);
  static const Color secondaryIcons = Color(0xFFB6B6B6);
  static const Color secondaryInput = Color(0xFFF2F2F2);
  
  // Text
  static const Color textBlack = Color(0xFF353535);
  static const Color textGray = Color(0xFF808080);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textEmpty = Color(0xFFD0CFCE);
  
  // Tertiary
  static const Color tertiaryGreen = Color(0xFF25B144);
  static const Color tertiaryLatte = Color(0xFFF7F1EE);
  
  // Accent
  static const Color accentBrown = Color(0xFF8E6C59);
  
  // Aliases
  static const Color backgroundPrimary = secondaryWhite;
}
```

---

## 8. Чеклист для разработчика

- [ ] Настроены цвета в соответствии с токенами
- [ ] Подключены шрифты Open Sans и Mona Sans
- [ ] UserCard кликабелен и ведёт на профиль
- [ ] SyncCard отображает актуальные данные
- [ ] Alert-иконка на "Прайс-лист" отображается при наличии проблем
- [ ] Badge на "Уведомления" обновляется и скрывается при 0
- [ ] StatusBadge на навигации (44) обновляется
- [ ] ConnectionIndicator отражает реальный статус подключения
- [ ] Pull-to-Refresh работает
- [ ] Все навигации реализованы
- [ ] Доступность проверена (VoiceOver/TalkBack)

---

## 9. Вопросы к дизайнеру

1. Какое поведение при отсутствии аватара пользователя — всегда инициалы?
2. Что отображать в SyncCard при ошибке синхронизации?
3. При каких условиях показывается alert на "Прайс-лист"?
4. Есть ли анимация перехода между экранами?
5. Нужен ли skeleton loading для всего экрана или только для карточек?