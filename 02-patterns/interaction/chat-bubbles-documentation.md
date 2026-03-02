---
title: "Chat Bubbles Documentation"
type: "pattern"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/pattern"
  - "category/interaction"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Documentation and patterns for chat message bubble UI components"
category: "interaction"
---

# **Архитектура и проектирование компонентов обмена сообщениями в дизайн-системах: баблы, логика группировки и технические стандарты**

Развитие современных интерфейсов привело к тому, что мессенджеры и чат-системы перестали быть изолированными инструментами, превратившись в фундаментальные паттерны взаимодействия внутри корпоративных платформ, CRM-систем и инструментов совместной работы. Центральным элементом таких интерфейсов является сообщение, визуально представленное в виде «бабла» (message bubble) — контейнера, который инкапсулирует текст, медиафайлы и метаданные, обеспечивая при этом четкую идентификацию отправителя и хронологию беседы. Проектирование этого компонента требует глубокого понимания принципов гештальт-психологии, технических ограничений различных платформ и строгих стандартов доступности.

## **Теоретические основы проектирования диалоговых интерфейсов**

В основе визуального восприятия чата лежит принцип близости (Proximity), сформулированный в рамках гештальт-психологии. Согласно этому принципу, объекты, расположенные близко друг к другу, воспринимаются как группа, имеющая общее назначение или принадлежность. В контексте баблов сообщений это означает, что расстояние между репликами одного автора должно быть значительно меньше, чем расстояние между сообщениями разных участников. Правильное использование свободного пространства (white space) позволяет избежать визуального загромождения и помогает пользователю интуитивно считывать структуру диалога без необходимости постоянно проверять аватары или имена отправителей.  
Дизайн-система должна обеспечивать предсказуемость (Clarity) и логичность (Consistency). Если интерактивные элементы следуют единому шаблону состояний (hover, focus, disabled), пользователи быстрее осваивают интерфейс и чувствуют себя увереннее. Для чат-баблов это выражается в единообразном поведении при клике, долгом нажатии для вызова контекстного меню или свайпе для ответа.

### **Сравнительный анализ популярных дизайн-систем**

Ведущие технологические компании выработали специфические подходы к документированию и реализации компонентов чата, отражающие их платформенную философию.

| Дизайн-система | Основной подход к баблам | Метаданные и аватары | Ключевая особенность |
| :---- | :---- | :---- | :---- |
| **Apple HIG** | Округлые прямоугольники с «хвостами» (tails) для указания направления | Аватары часто скрыты в групповых чатах, акцент на цвете | Использование материалов Liquid Glass для иерархии |
| **Material Design 3** | Вариативные формы, акцент на выравнивании и цветовых схемах | Строгая сетка и типизированные размеры аватаров | Система токенов и динамическое изменение цвета |
| **Microsoft Fluent UI** | Фокус на доступности и интеграции с Graph API | Поддержка статусов доступности (available, busy) | Четкая иерархия важности сообщений (normal, high, urgent) |
| **IBM Carbon** | Фреймворк для AI-чатов с разделением на «плавающие» и встроенные макеты | Цветовая дифференциация человеческих и машинных ответов | AI-тема включена по умолчанию для прозрачности взаимодействия |
| **Salesforce Lightning** | Настраиваемые LWC-компоненты (Lightning Web Components) | Поддержка ролей (Агент, Бот, Пользователь) | Возможность полной кастомизации CSS через теневой DOM |

## **Анатомия и геометрия бабла сообщения**

Бабл сообщения не является статичным объектом; его форма и размер динамически адаптируются к содержимому и контексту. Математическая точность в определении радиусов скругления и отступов напрямую влияет на «мягкость» или «официальность» интерфейса.

### **Радиусы скругления и вложенность**

В дизайн-системах, таких как Uber Base или Massachusetts Design System, используется модульная система с шагом в 4px для определения радиусов. Общее правило гласит: чем больше контейнер, тем больше его радиус. Для вложенных элементов, какими являются баблы внутри списка сообщений, применяется формула гармоничного скругления:  
Это позволяет избежать визуального искажения кривых при вложении одного объекта в другой. Большие радиусы создают ощущение дружелюбности и неформальности, что идеально подходит для мессенджеров, в то время как малые радиусы характерны для корпоративных инструментов и систем управления данными.

### **Геометрия «хвостов» (tails)**

«Хвост» бабла служит визуальным якорем, указывающим на отправителя. В iOS чат-баблы традиционно имеют закругленный прямоугольный корпус с треугольным или изогнутым указателем, который бесшовно сливается с краем. С технической точки зрения на мобильных платформах (iOS/Android) такие формы часто реализуются через пути Безье (Bezier Paths), что позволяет динамически изменять размер тела сообщения, сохраняя пропорции хвоста.  
В веб\-среде для реализации хвостов часто используются псевдоэлементы CSS (:before и :after). Первый создает цветную форму, а второй, наложенный сверху и имеющий цвет фона подложки, «вырезает» часть формы, создавая эффект изгиба. Это позволяет избежать лишних DOM-узлов и обеспечивает высокую производительность рендеринга.

## **Логика группировки и кластеризации**

Одним из наиболее сложных аспектов документации чата является описание логики объединения нескольких последовательных сообщений от одного автора в визуальный кластер. Это критически важно для уменьшения когнитивной нагрузки и визуального шума.

### **Правила изменения радиусов в кластере**

При поступлении цепочки сообщений от одного отправителя, дизайн-система должна динамически изменять границы баблов для создания единого «блока речи».

1. **Одиночное сообщение:** Все четыре угла имеют максимальный радиус скругления.  
2. **Первое сообщение в группе:** Сохраняет скругление сверху и с внешней стороны, но уменьшает радиус снизу со стороны выравнивания (например, нижний правый угол для исходящих).  
3. **Среднее сообщение:** Имеет минимальные радиусы со стороны выравнивания (почти прямые углы), соединяясь с верхним и нижним баблами.  
4. **Последнее сообщение:** Сохраняет скругление снизу и с внешней стороны, но имеет малый радиус сверху со стороны выравнивания.

### **Управление метаданными в группах**

В кластеризованных сообщениях аватары и имена отправителей обычно отображаются только один раз — рядом с первым или последним сообщением группы (в зависимости от платформенных гайдлайнов). Временные метки (timestamps) могут отображаться при наведении или клике, либо группироваться по временным интервалам (например, показывать время только если разрыв между сообщениями превышает 5-10 минут). Дизайн-система Zendesk Garden, например, рекомендует центрировать индикаторы набора текста в бабле, когда другая сторона готовит ответ.

## **Технические ограничения и производительность**

Реализация чата сопряжена с серьезными вызовами в области производительности фронтенда, особенно при работе с большими объемами данных.

### **Оптимизация DOM и рендеринга**

Каждый бабл сообщения добавляет узлы в дерево DOM. При достижении критического порога (обычно более 1,500 узлов на страницу) производительность прокрутки и время отклика на ввод начинают деградировать. Для решения этой проблемы используются методы виртуализации списков (например, FlashList в React Native или специализированные библиотеки для Web), которые рендерят только те сообщения, которые находятся в видимой области экрана.  
Важным фактором является выбор между использованием SVG и CSS для отрисовки сложных форм баблов. SVG обеспечивает идеальную независимость от разрешения и легко экспортируется из графических редакторов, однако он может быть менее доступным и сложным в управлении через CSS-классы. Современный подход часто склоняется к CSS-утилитам (Tailwind) или CSS-in-JS (xstyled), которые позволяют эффективно управлять динамическими стилями, сохраняя при этом небольшой размер бандла.

### **Обработка переполнения контента**

Пользовательский контент непредсказуем. Дизайн-система должна четко определять правила переноса длинных слов и URL-адресов.

* **overflow-wrap: break-word**: Современный стандарт, который разрывает слова только в случае, если они не помещаются в строку целиком, сохраняя читаемость в остальных случаях.  
* **word-break: break-all**: Более жесткий метод, разрывающий текст в любой точке. Это предотвращает поломку макета, но затрудняет чтение.

## **Доступность и инклюзивность (Accessibility)**

Чат является динамической средой, что создает особые сложности для пользователей скринридеров. Документация должна требовать соблюдения стандартов WCAG и использования соответствующих ARIA-ролей.

### **Живые регионы и роли**

Для списка сообщений обязательным является использование role="log". В отличие от role="alert", которая прерывает чтение текущего контента, role="log" имеет неявное значение aria-live="polite". Это означает, что скринридер уведомит пользователя о новом сообщении только тогда, когда он закончит текущую операцию.  
Необходимо использовать атрибут aria-atomic="false", чтобы скринридер зачитывал только вновь добавленные узлы (новые сообщения), а не весь список заново при каждом обновлении. Если сообщение требует немедленной реакции (например, системная ошибка или предупреждение о завершении сессии), следует использовать role="alert".

### **Текстовое описание и фокус**

* **Альтернативный текст:** Все эмодзи, изображения и вложения должны иметь корректные alt-описания. Имена отправителей должны быть доступны для программного считывания, даже если они визуально скрыты в кластере.  
* **Управление фокусом:** При отправке сообщения фокус должен оставаться в поле ввода (input), а не перемещаться на новое сообщение, чтобы пользователь мог продолжать диалог без лишних действий.

## **Специфика мобильных платформ и жесты**

Взаимодействие с чатом на мобильных устройствах во многом определяется естественными движениями рук. Gestures (жесты) заменяют традиционные методы ввода, такие как мышь и клавиатура.

### **Паттерны взаимодействия**

1. **Swipe to Reply (Свайп для ответа):** Стандартный жест в iOS и Android, позволяющий быстро процитировать сообщение. Реализация должна включать тактильную отдачу (haptic feedback) и визуальный индикатор (иконку стрелки), который плавно появляется при достижении порога свайпа (обычно 25-30% ширины экрана).  
2. **Long Press (Долгое нажатие):** Используется для вызова контекстного меню действий над сообщением (копирование, удаление, пересылка) и панели реакций.  
3. **Pull to Load (Потянуть для загрузки):** Хотя чаще используется «Swipe to Refresh» для обновления актуального контента, в чатах этот жест при прокрутке вверх инициирует подгрузку истории сообщений.

## **Проектирование для AI и ботов**

С появлением больших языковых моделей (LLM) роль чата трансформировалась. Дизайн-система Carbon от IBM выделяет взаимодействие с AI в отдельную категорию, где баблы могут быть более сложными, содержать блоки кода, таблицы и элементы обратной связи (лайки/дизлайки).  
Особое внимание уделяется латентности (задержке). Для AI-сообщений рекомендуется использовать специфические индикаторы загрузки, отличные от стандартных «трех точек», чтобы подчеркнуть процесс генерации ответа. Также важна возможность «стриминга» текста, когда ответ появляется по мере генерации, что требует от бабла способности плавно менять свою высоту и ширину в реальном времени.

## **Документация компонента для разработчиков и дизайнеров**

Ниже представлен структурированный стандарт документирования компонента MessageBubble.

### **1\. Анатомия компонента**

Компонент состоит из следующих элементов:

* **Контейнер (Bubble):** Основная форма с заливкой.  
* **Текстовое содержимое:** Тело сообщения с поддержкой rich text.  
* **Хвост (Tail):** Визуальный указатель на автора.  
* **Метаданные:** Статус доставки (sent, delivered, read), время отправки.  
* **Вложения:** Слот для медиаконтента (изображения, файлы, аудио).

### **2\. Стили и состояния (Дизайн-токены)**

| Токен | Значение (Default) | Описание |
| :---- | :---- | :---- |
| bubble-radius-max | 18px | Радиус для одиночных сообщений и внешних углов |
| bubble-radius-min | 4px | Радиус для стыкующихся углов в кластерах |
| color-bg-outbound | primary-600 | Фон исходящих сообщений (Salesforce/Apple) |
| color-bg-inbound | neutral-100 | Фон входящих сообщений (Salesforce/Apple) |
| spacing-inner | 12px \\text{ (vertical)}, 16px \\text{ (horizontal)} | Внутренние отступы контента |
| spacing-between-groups | 16px | Дистанция между репликами разных авторов |

### **3\. Техническая спецификация (Web/React)**

* **Контейнер:** Используйте display: flex с flex-direction: column для списка.  
* **Выравнивание:** Исходящие — align-self: flex-end, входящие — align-self: flex-start.  
* **CSS Properties:**

.message-bubble { max-width: 70%; word-wrap: break-word; overflow-wrap: break-word; /\* \*/ position: relative; } \`\`\`

### **4\. Техническая спецификация (Mobile/Flutter/Native)**

* **Оптимизация:** Применяйте ItemDecoration для отрисовки хвостов без создания дополнительных View.  
* **Жесты:** Интегрируйте GestureDetector с поддержкой горизонтального сдвига для ответа.  
* **Haptics:** Вызывайте HapticFeedback.lightImpact() при активации свайпа.

## **Саммари**

Проектирование баблов сообщений — это дисциплина, находящаяся на стыке микротипографики и сложной системной логики. Успешная реализация зависит от того, насколько точно система учитывает контекст общения. Ключевые выводы исследования:

* **Гештальт-принципы** являются основой для группировки сообщений; правильные отступы важнее, чем подписи имен.  
* **Логика кластеризации** через динамические радиусы скругления создает визуальный ритм и упрощает сканирование диалога.  
* **Доступность** обеспечивается правильным выбором ARIA-ролей (log, status) и управлением фокусом, что делает чат пригодным для использования со скринридерами.  
* **Производительность** требует внедрения виртуализации списков и грамотной работы с переполнением текстовых блоков.  
* **AI-трансформация** требует от дизайн-систем новых визуальных индикаторов для обозначения машинного разума и процесса генерации контента.

## **Чеклист для проверки компонента**

### **Для дизайнеров**

* \[ \] Соблюдается ли визуальное различие между входящими и исходящими сообщениями (цвет, выравнивание)?  
* \[ \] Описаны ли все 4 состояния скругления углов для кластеров (single, top, middle, bottom)?  
* \[ \] Соответствуют ли радиусы скругления правилу вложенности (Radius\_{outer} \= Radius\_{inner} \+ Padding)?  
* \[ \] Предусмотрено ли отображение различных типов контента (текст, изображение, файл, аудио)?  
* \[ \] Есть ли визуальный индикатор набора текста (typing indicator)?  
* \[ \] Протестирован ли интерфейс в темной теме и при больших размерах шрифта (Dynamic Type)?

### **Для разработчиков**

* \[ \] Используется ли overflow-wrap: break-word для предотвращения поломки макета длинными словами?  
* \[ \] Список сообщений обернут в role="log" с установленным aria-live="polite"?  
* \[ \] Реализована ли виртуализация списка для обеспечения 60fps при прокрутке?  
* \[ \] Псевдоэлементы или пути (paths) хвостов корректно инвертируются для входящих/исходящих?  
* \[ \] Отрабатывают ли мобильные жесты (свайп для ответа) с тактильным откликом?  
* \[ \] Синхронизированы ли ARIA-атрибуты (например, aria-expanded) с состоянием раскрывающихся блоков?

### **Общие требования**

* \[ \] Тон и голос (Tone and Voice) сообщений соответствуют бренду (дружелюбный vs официальный).  
* \[ \] Контрастность текста и фона бабла соответствует уровню WCAG AA (минимум 4.5:1).  
* \[ \] Система корректно работает в RTL-режимах (смена направления текста и зеркальное отражение хвостов).

#### **Источники**

1\. Graphic Design Principles: Grouping and Proximity \- The Noun Project Blog, https://blog.thenounproject.com/grouping-and-proximity-in-graphic-design-the-art-of-visual-organization/ 2\. The Basics: Proximity Principle. UI design is significantly influenced… | by Yolqin Alimov | UX Planet, https://uxplanet.org/the-basics-proximity-principle-ae0bdebeabc0 3\. Gestalt Principles : Exploring the Principle of Proximity in UI Design | by Zifa \- Medium, https://medium.com/@fathirziyadalbiaroza/gestalt-principles-exploring-the-principle-of-proximity-in-ui-design-806cc11a43dd 4\. 7 principles of a design system, https://www.designsystemscollective.com/7-principles-of-a-design-system-ea646a879c59 5\. Corner radius and elevation \- Mass.gov, https://www.mass.gov/info-details/corner-radius-and-elevation 6\. Corner radius \- Base design system \- Uber, https://base.uber.com/6d2425e9f/p/652959-corner-radius 7\. Building a consistent corner radius system in UI | by Alexandra Basova | Bootcamp \- Medium, https://medium.com/design-bootcamp/building-a-consistent-corner-radius-system-in-ui-1f86eed56dd3 8\. IOS Chat Bubbles: A Design Deep Dive \- Theindia, https://db.theindia.co.in/cyber-pulse/ios-chat-bubbles-a-design-deep-dive-1764804347 9\. Drawing Message Bubbles with Tails in Swift | by Kyle Haptonstall \- Medium, https://medium.com/@Khaptonstall/drawing-message-bubbles-with-tails-in-swift-d2a69bce58da 10\. How to create iOS chat bubbles in CSS \- Samuel Kraft, https://samuelkraft.com/blog/ios-chat-bubbles-css 11\. How to create chat bubbles like facebook Messenger \- Stack Overflow, https://stackoverflow.com/questions/42256877/how-to-create-chat-bubbles-like-facebook-messenger 12\. Customize Text Message Bubbles | Lightning Web Components \- Salesforce Developers, https://developer.salesforce.com/docs/service/messaging-web/guide/customize-text-message-bubble.html 13\. Overview of the Chat Component | Design System Kit \- Telerik.com, https://www.telerik.com/design-system/docs/components/chat/ 14\. Loaders / Patterns / Zendesk Garden, https://garden.zendesk.com/patterns/loaders/ 15\. Performance Optimization for Design System Components in No-Code Tools, https://robertcelt95.medium.com/performance-optimization-for-design-system-components-in-no-code-tools-4ad85e49613e 16\. I Built a WhatsApp Clone in React Native (And It Doesn't Suck) \- DEV Community, https://dev.to/nadim\_ch0wdhury/i-built-a-whatsapp-clone-in-react-native-and-it-doesnt-suck-23pc 17\. SVG vs CSS for Modern Web User Interfaces? \[closed\] \- UX Stack Exchange, https://ux.stackexchange.com/questions/12767/svg-vs-css-for-modern-web-user-interfaces 18\. Writing CSS in SVG to Create Beautiful and Light Web Animations \- DEV Community, https://dev.to/info\_generalhazedawn\_a3d/writing-css-in-svg-to-create-beautiful-and-light-web-animations-nmk 19\. How TailwindCSS helps you implement a design system (and why it can be better than CSS-in-JS solutions) \- Lisa Tassone, https://lisatassone.com/posts/how-tailwindcss-helps-you-implement-a-design-system 20\. Style Wars: Tailwind vs. CSS-in-JS in Design Systems Implementation \- Medium, https://medium.com/tetrisly/style-wars-tailwind-vs-css-in-js-in-design-systems-implementation-de6015ee2695 21\. overflow-wrap \- CSS | MDN \- Mozilla, https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/overflow-wrap 22\. CSS word-break vs word-wrap (Overflow Wrap) : What's the Difference \- GeeksforGeeks, https://www.geeksforgeeks.org/css/what-is-the-difference-between-word-break-break-all-versus-word-wrap-break-word-in-css/ 23\. How do you wrap text content in CSS? \- Refine, https://refine.dev/blog/css-text-wrap/ 24\. A complete guide to CSS word-wrap, overflow-wrap, and word-break \- LogRocket Blog, https://blog.logrocket.com/guide-css-word-wrap-overflow-wrap-word-break/ 25\. ARIA: log role \- MDN Web Docs \- Mozilla, https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/log\_role 26\. ARIA live regions \- MDN \- Mozilla, https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Guides/Live\_regions 27\. How to Use ARIA Alert Effectively \- The A11Y Collective, https://www.a11y-collective.com/blog/aria-alert/ 28\. Notifications \- Inclusive Components, https://inclusive-components.design/notifications/ 29\. Coding web applications using advanced ARIA techniques | Mass.gov, https://www.mass.gov/info-details/coding-web-applications-using-advanced-aria-techniques 30\. Best Practices for Digital and Document Accessibility | Support, https://www.ala.org/support/IT-staff-resources/best-practices-accessibility 31\. Screen Reader-Friendly Code: Best Practices \- UXPin, https://www.uxpin.com/studio/blog/screen-reader-friendly-code-best-practices/ 32\. Gestures \- SAP, https://www.sap.com/design-system/fiori-design-web/v1-136/foundations/interaction/gestures 33\. Swipe gesture material design \- java \- Stack Overflow, https://stackoverflow.com/questions/55093711/swipe-gesture-material-design 34\. New features available with iOS 17\. \- Apple, https://www.apple.com/mideast/ios/ios-17/a/pdf/iOS\_All\_New\_Features.pdf 35\. Chat Messaging \- Flutter (v5) \- GetStream.io, https://getstream.io/chat/docs/sdk/flutter/v5/customization/custom-widgets/customize\_message\_widget/ 36\. Twitter Clients in 2014: An Exploration of Tweetbot, Twitterrific, and Twitter for iOS, https://www.macstories.net/stories/twitter-clients-in-2014/ 37\. Swipe to refresh \- Patterns \- Material Design, https://m1.material.io/patterns/swipe-to-refresh.html 38\. Overview | Carbon AI Chat \- Carbon Design System, https://chat.carbondesignsystem.com/tag/latest/docs/documents/Overview.html 39\. Chat change log \- Base design system \- Uber, https://base.uber.com/6d2425e9f/p/586062-chat-change-log 40\. Taps, drags, and other gestures \- Flutter documentation, https://docs.flutter.dev/ui/interactivity/gestures 41\. Advanced Flutter UI: How to Build a Chat App with Custom Message Bubbles \- Maxim Gorin, https://maxim-gorin.medium.com/advanced-flutter-ui-how-to-build-a-chat-app-with-custom-message-bubbles-4f90282b8be0