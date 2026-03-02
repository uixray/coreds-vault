---
title: "Figma Identical Vectors Search and Selection"
type: "guide"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/guide"
  - "platform/web"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Guide for finding and selecting identical vectors in Figma"
---

# **Архитектурный анализ механизмов обхода дерева узлов и алгоритмического сопоставления геометрических данных в среде Figma**

Проблема идентификации и массового выбора идентичных графических объектов, не связанных через систему компонентов, представляет собой одну из наиболее значимых когнитивных и технических нагрузок в профессиональном проектировании интерфейсов. В современных рабочих процессах дизайнеры часто сталкиваются с ситуацией, когда большое количество векторов с идентичной геометрией распределено по документу без использования инстансов, что делает невозможным их одновременное редактирование стандартными средствами навигации по библиотекам.1 Данное исследование посвящено глубокому разбору механизмов обхода дерева узлов (node tree traversal) и алгоритмам сравнения геометрических путей (path comparison) для решения задачи поиска дубликатов векторов, основываясь на внутреннем устройстве API Figma и современных методах обработки векторных данных.

## **Структурная организация документа и иерархия узлов SceneNode**

Для реализации эффективного механизма поиска идентичных векторов необходимо понимать иерархическую структуру документа Figma. Документ организован в виде направленного ациклического графа, который для большинства операций поиска интерпретируется как дерево.3 В корне находится Document, содержащий один или несколько PageNode. Каждая страница является контейнером для объектов первого уровня, таких как FrameNode, GroupNode, SectionNode или индивидуальные VectorNode.

Механизм обхода этого дерева требует понимания типов узлов, составляющих сцену. Все объекты, отображаемые на холсте, наследуются от базового интерфейса SceneNode.4 При поиске идентичных векторов критически важно уметь фильтровать узлы, которые не содержат геометрической информации, чтобы минимизировать вычислительные затраты.

### **Категоризация узлов по геометрическим свойствам**

| Тип узла | Геометрическое описание | Возможность прямого сравнения |
| :---- | :---- | :---- |
| VectorNode | Содержит массивы vectorPaths и vectorNetwork. | Высокая; основной объект для анализа геометрии. |
| BooleanOperationNode | Результат логических операций (Union, Subtract и др.). | Средняя; требует вычисления результирующего пути. |
| TextPathNode | Текст, размещенный вдоль векторного пути. | Низкая; геометрия зависит от параметров шрифта. |
| RectangleNode | Специализированный вектор с параметрами скругления углов. | Высокая; может быть нормализован до обычного вектора. |
| EllipseNode | Вектор, описываемый параметрами дуги или круга. | Высокая; эффективно сравнивается через параметры радиусов. |

В контексте запроса пользователя, где векторы не являются компонентами и имеют заливку (fill), основным объектом интереса является VectorNode.4 Этот узел хранит информацию о вершинах, сегментах и, что наиболее важно для векторов с заливкой, о регионах (regions), определяющих внутреннее пространство фигуры.5

## **Механизмы обхода дерева:findAll и findAllWithCriteria**

Поиск идентичных объектов начинается с процесса обхода дерева (traversal). В Figma API предусмотрено несколько стратегий обхода, выбор которых напрямую влияет на производительность плагина или скрипта, особенно в документах, содержащих десятки тысяч слоев.6

### **Методология глубокого поиска**

Стандартный метод findAll выполняет полный обход поддерева, начиная с заданного узла (например, figma.currentPage), используя алгоритм поиска в глубину (pre-order traversal).7 Для каждого обнаруженного узла вызывается функция обратного вызова, которая проверяет соответствие заданным условиям. В случае поиска идентичных векторов, эта функция должна проверять геометрическое сходство с эталоном.

Однако, использование findAll в больших файлах может привести к существенным задержкам. Более оптимизированным решением является findAllWithCriteria, позволяющий на уровне ядра API отфильтровать узлы по типу, например, types:.6 Это исключает из процесса обработки тысячи текстовых слоев, групп и фреймов, значительно ускоряя обход.

### **Проблематика производительности при обходе**

При работе с документами профессионального уровня необходимо учитывать, что каждый вызов свойств узла через API может инициировать процессы десериализации данных. Для оптимизации процесса поиска рекомендуется следующая стратегия:

1. Сначала ограничить выборку текущей страницей (currentPage), так как поиск по всему документу (figma.root) требует загрузки всех страниц в память.1  
2. Использовать свойство figma.skipInvisibleInstanceChildren \= true, чтобы не тратить ресурсы на анализ скрытых элементов внутри компонентов, если это допустимо бизнес-логикой.6  
3. Применять многоступенчатую фильтрацию: сначала по типу узла, затем по габаритам (bounding box), и только в последнюю очередь по сложным данным vectorPaths.

## **Геометрическая идентичность: VectorPath против VectorNetwork**

Определение "идентичности" векторов — задача более сложная, чем простое сравнение строковых имен или цветовых кодов, которые, как отметил пользователь, могут быть некорректными или отсутствовать.4 В Figma геометрия представлена двумя основными структурами.

### **Структура VectorPath**

VectorPath — это упрощенное представление геометрии, максимально приближенное к формату SVG. Оно описывается строкой команд (data) и правилом намотки (windingRule).9 Примеры команд включают M (MoveTo), L (LineTo), C (CubicBezier) и Z (ClosePath). Для большинства задач поиска дубликатов сравнение этих строк является достаточным условием идентичности.

![][image1]  
Если два вектора имеют одинаковые строки data, это гарантирует, что их формы конгруэнтны в их локальных координатах.4 Важно понимать, что координаты в vectorPaths являются относительными по отношению к позиции самого объекта на холсте. Это означает, что два идентичных значка, расположенных в разных частях страницы, будут иметь одинаковые значения в поле data.4

### **Продвинутая модель VectorNetwork**

Для более глубокого анализа используется VectorNetwork. В отличие от путей, представляющих собой последовательные цепи сегментов, векторные сети позволяют описывать сложные графы, где в одной вершине могут сходиться более двух сегментов.5

Векторная сеть состоит из:

* **Vertices (Вершины)**: Массив объектов с координатами ![][image2] и ![][image3].5  
* **Segments (Сегменты)**: Соединения между вершинами с указанием касательных (tangentStart, tangentEnd) для кривых Безье.5  
* **Regions (Регионы)**: Замкнутые области, образованные сегментами, которые могут иметь собственную заливку.5

Для пользователя, ищущего векторы с заливкой, именно массив regions является ключевым. Если у двух векторов идентичны наборы сегментов и вершин, но различаются регионы, они будут выглядеть по-разному (например, один будет иметь внутреннюю "дырку", а другой — нет).

## **Алгоритмическое сопоставление и нормализация данных**

Прямое сравнение строк vectorPaths.data может дать ложноотрицательный результат, если пути были созданы в разное время или с использованием разных инструментов. Для достижения 100% точности требуется нормализация геометрических данных перед сравнением.10

### **Этапы нормализации геометрии**

1. **Приведение к абсолютному виду**: Перевод всех относительных команд (например, строчных букв m, l в SVG) в абсолютные координаты (M, L).11  
2. **Сегментация кривых**: Конвертация всех дуг (arcs) и квадратичных кривых в кубические кривые Безье. Это обеспечивает единый формат данных для любого типа кривизны.11  
3. **Округление координат**: Из-за особенностей вычислений с плавающей запятой, координаты могут незначительно различаться (например, ![][image4] и ![][image5]). Внедрение допуска (tolerance) в пределах ![][image6] пикселя позволяет игнорировать такие микро-различия.10  
4. **Сортировка подобъектов**: Если вектор состоит из нескольких независимых контуров (compound path), порядок их записи в массиве vectorPaths может быть произвольным. Для сравнения необходимо отсортировать эти пути по их площади или координатам начальных точек.

| Параметр сравнения | Метод проверки | Вес в алгоритме |
| :---- | :---- | :---- |
| Число сегментов | vectorNetwork.segments.length | Низкий (первичный фильтр) |
| Габариты (BBox) | node.width, node.height | Средний |
| Хеш данных пути | MD5(normalize(vectorPath.data)) | Высокий (основной критерий) |
| Правило заполнения | windingRule | Критический для заливок |

## **Нативные инструменты Figma и их ограничения**

В интерфейсе Figma присутствуют функции быстрого выделения, но они не всегда решают специфическую задачу поиска по геометрии.13

### **Функция "Select all with same..."**

Эта функция доступна через главное меню (Edit \> Select all with same...) или через панель быстрого поиска (Cmd+/). Она позволяет выбирать объекты с одинаковой заливкой (fill), обводкой (stroke), эффектами или шрифтами.3 Однако, как справедливо заметил пользователь, если цель — выделить векторы именно по форме, а не по цвету, этот инструмент бесполезен. Если в документе есть сто разных иконок одного цвета, "Select all with same fill" выделит их все, что не поможет изолировать только одну конкретную форму.13

### **Инструмент "Select matching layers"**

Инструмент "Выбор соответствующих слоев" (Alt \+ Ctrl \+ A) предназначен в первую очередь для работы с компонентами и их инстансами на разных фреймах.2 Он ищет слои с одинаковыми именами и иерархическим положением. В ситуации, когда векторы являются "просто разными векторами" без четкой структуры именования, данный инструмент не сможет обеспечить необходимую точность поиска по геометрии.1

## **Решение проблемы через экосистему плагинов**

Поскольку нативные средства ограничены, наиболее эффективным способом решения задачи пользователя является использование специализированных плагинов, которые расширяют логику селекции.1

### **Плагин Similayer: Анализ возможностей**

Similayer — один из самых популярных инструментов для расширенного выбора объектов в Figma.1 Он позволяет выбирать слои на основе огромного количества параметров, включая те, что недоступны в нативном меню.

Преимущества Similayer для данной задачи:

* Возможность выбора по конкретным геометрическим размерам (Width, Height).  
* Фильтрация по наличию определенных типов заливок.17  
* Возможность комбинировать условия (например, "тип — вектор" \+ "ширина — 24px" \+ "прозрачность — 100%").

Тем не менее, даже Similayer может не обладать функцией "сравнение по хешу пути" (path data hash) в стандартном наборе фильтров. Если формы объектов крайне сложны и имеют одинаковые габариты, но разную внутреннюю структуру, может потребоваться более специализированное решение.1

### **Альтернативные утилиты и AI-поиск**

Существуют плагины, специализирующиеся на поиске дубликатов, такие как "Select Layers" или специализированные менеджеры дизайн-систем.18 Кроме того, новейшие функции Figma AI, такие как "Find similar designs", начинают использовать визуальное сходство и векторные эмбеддинги для поиска похожих элементов.20 Хотя они ориентированы на поиск компонентов в библиотеках, их алгоритмическая база в будущем может позволить находить геометрические дубликаты даже при наличии незначительных искажений.20

## **Практическая реализация алгоритма поиска (Scripting)**

Для пользователя, обладающего навыками работы с Figma API или использующего плагин "Console", можно предложить логическую структуру скрипта, который выполнит задачу поиска идентичных векторов по геометрии.

### **Архитектура скрипта поиска**

Процесс разделяется на три фазы: инициация, фильтрация и селекция.

**Фаза 1: Инициация**

Скрипт считывает параметры выделенного объекта (seed node). Если выделено несколько объектов, берется первый. Из него извлекается массив vectorPaths.

JavaScript

const selection \= figma.currentPage.selection;  
if (selection.length \=== 0 |

| selection.type\!== 'VECTOR') {  
    figma.notify("Пожалуйста, выберите векторный объект");  
    return;  
}  
const targetPaths \= selection.vectorPaths;  
const targetData \= JSON.stringify(targetPaths); // Простой хеш геометрии

**Фаза 2: Глобальный обход дерева**

Скрипт инициирует поиск по всей странице. Чтобы избежать проблем с производительностью, используется findAllWithCriteria.

JavaScript

const candidates \= figma.currentPage.findAllWithCriteria({  
    types:  
});

**Фаза 3: Геометрическое сравнение**

Для каждого кандидата проверяется соответствие эталонному хешу. На этом этапе также можно добавить проверку заливки, если это критично для пользователя.

JavaScript

const matches \= candidates.filter(node \=\> {  
    // Проверка геометрии  
    const currentData \= JSON.stringify(node.vectorPaths);  
    const isGeometryMatch \= (currentData \=== targetData);  
      
    // Дополнительная проверка на наличие заливки (если нужно)  
    const hasFill \= node.fills && node.fills.length \> 0;  
      
    return isGeometryMatch && hasFill;  
});

figma.currentPage.selection \= matches;  
figma.notify(\`Найдено и выделено объектов: ${matches.length}\`);

Использование JSON.stringify для объектов vectorPaths является эффективным методом создания "отпечатка" геометрии, так как эти объекты содержат все необходимые данные о сегментах и правилах заполнения в стандартном порядке.21

## **Работа с визуальными исключениями и сложными случаями**

При поиске "одинаковых" векторов могут возникнуть ситуации, когда объекты выглядят идентично, но имеют разную структуру данных. Это часто происходит при импорте из других редакторов (Adobe Illustrator, Sketch) или после применения определенных операций.23

### **Влияние булевых групп и Flattening**

Если вектор является частью BooleanOperationNode (например, Union), его геометрия определяется суммой входящих в него путей.25 Для сравнения такого объекта с обычным вектором его необходимо либо временно "схлопнуть" (Flatten selection — Cmd+E), либо использовать свойство fillGeometry вместо vectorPaths.4

fillGeometry возвращает вычисленный массив путей, который представляет собой финальную видимую форму объекта после применения всех булевых операций и трансформаций.4 Это более надежный источник данных для сравнения визуально идентичных, но структурно разных объектов.

### **Обводки против заливок**

Пользователь указал, что его интересуют векторы с заливкой. Однако в Figma существует возможность превратить обводку (stroke) в путь (Outline Stroke — Cmd+Opt+O).27 После этой операции объект, который раньше был линией, становится замкнутым контуром с заливкой. Алгоритм поиска должен учитывать, что до выполнения Outline Stroke геометрия этих объектов будет принципиально разной, даже если визуально они совпадают.27

## **Стратегии оптимизации рабочего процесса**

Для минимизации возникновения проблемы "разрозненных идентичных векторов" в будущем, профессиональные стандарты проектирования рекомендуют ряд превентивных мер.

### **Систематизация через компоненты**

Основной причиной возникновения запроса пользователя является отсутствие системности в файле. Создание компонента из базового вектора позволяет использовать нативный метод getInstancesAsync() или свойство instances, которое мгновенно возвращает все копии объекта по всему документу.8

| Подход | Метод поиска | Скорость | Надежность |
| :---- | :---- | :---- | :---- |
| Компоненты | mainComponent.instances | Мгновенно | 100% |
| Геометрический поиск | findAll \+ сравнение путей | Зависит от размера файла | Высокая (при нормализации) |
| Поиск по стилям | Select all with same fill | Высокая | Низкая (выбирает лишнее) |

### **Организация через именование и плагины управления слоями**

Использование плагинов вроде "Rename It" позволяет быстро присвоить уникальные имена группам идентичных векторов, основываясь на их свойствах.16 В дальнейшем это упрощает выбор через стандартную панель поиска. Кроме того, регулярное использование функции "Flatten" для иконок помогает привести их к единой структуре VectorNode, что облегчает работу алгоритмов сравнения.26

## **Анализ эффективности пользовательских техник выделения**

Помимо автоматизированных скриптов, существуют "скрытые" функции интерфейса Figma, которые могут помочь в ручном или полуавтоматическом выборе.3

### **Выделение внутри групп и фреймов**

Часто идентичные векторы находятся глубоко внутри иерархии (например, иконки внутри кнопок, которые сами находятся внутри карточек). Чтобы не кликать дважды на каждый объект, можно использовать:

* **Cmd \+ Клик (Deep Select)**: Позволяет выбрать любой вложенный объект напрямую, игнорируя группировку.3  
* **Cmd \+ Drag (Marquee Selection)**: Позволяет выделить область, захватывая только те объекты, которые полностью попадают в рамку или находятся на определенном уровне вложенности.3  
* **Shift \+ Enter / Enter**: Позволяют перемещаться вверх и вниз по иерархии выделенных объектов, что удобно для массового переключения с иконок на их контейнеры.3

Эти техники в сочетании с плагином Similayer позволяют быстро сузить круг поиска до необходимых объектов, не прибегая к написанию кода.

## **Итоговые рекомендации по реализации механизма обхода**

Для решения проблемы пользователя — поиска всех идентичных векторов с заливкой на странице — наиболее эффективным и технологически обоснованным является следующий алгоритм:

1. **Выбор эталона**: Идентификация целевого вектора и извлечение его геометрического слепка через vectorPaths или fillGeometry.4  
2. **Обход с фильтрацией**: Использование findAllWithCriteria для сбора всех узлов типа VECTOR на текущей странице.6  
3. **Многоступенчатая валидация**:  
   * Проверка совпадения windingRule (важно для корректного отображения заливки).9  
   * Сравнение строкового представления данных путей.21  
   * Проверка наличия заливки (fills.length \> 0\) и игнорирование объектов, имеющих только обводку.4  
4. **Массовое выделение**: Обновление массива figma.currentPage.selection найденными объектами для последующего группового редактирования.

Данный подход обеспечивает максимальную точность, так как опирается на неизменяемые геометрические свойства объектов, а не на метаданные (имена, цвета), которые могут быть изменены в процессе работы. В долгосрочной перспективе переход к компонентной модели остается единственным способом избежать необходимости в подобном поиске, превращая разрозненные векторы в управляемую дизайн-систему.1

#### **Источники**

1. How do I select all of the matching variants that Figma highlights ..., дата последнего обращения: февраля 27, 2026, [https://forum.figma.com/ask-the-community-7/how-do-i-select-all-of-the-matching-variants-that-figma-highlights-36385](https://forum.figma.com/ask-the-community-7/how-do-i-select-all-of-the-matching-variants-that-figma-highlights-36385)  
2. Some way to select the objects that Figma identifies and highlights as similar, дата последнего обращения: февраля 27, 2026, [https://forum.figma.com/suggest-a-feature-11/some-way-to-select-the-objects-that-figma-identifies-and-highlights-as-similar-25697](https://forum.figma.com/suggest-a-feature-11/some-way-to-select-the-objects-that-figma-identifies-and-highlights-as-similar-25697)  
3. Select layers and objects – Figma Learn \- Help Center, дата последнего обращения: февраля 27, 2026, [https://help.figma.com/hc/en-us/articles/360040449873-Select-layers-and-objects](https://help.figma.com/hc/en-us/articles/360040449873-Select-layers-and-objects)  
4. VectorNode | Developer Docs, дата последнего обращения: февраля 27, 2026, [https://developers.figma.com/docs/plugins/api/VectorNode/](https://developers.figma.com/docs/plugins/api/VectorNode/)  
5. VectorNetwork \- Figma Developer Docs, дата последнего обращения: февраля 27, 2026, [https://developers.figma.com/docs/plugins/api/VectorNetwork/](https://developers.figma.com/docs/plugins/api/VectorNetwork/)  
6. findAllWithCriteria \- Figma Developer Docs, дата последнего обращения: февраля 27, 2026, [https://developers.figma.com/docs/plugins/api/properties/nodes-findallwithcriteria/](https://developers.figma.com/docs/plugins/api/properties/nodes-findallwithcriteria/)  
7. findAll | Developer Docs, дата последнего обращения: февраля 27, 2026, [https://developers.figma.com/docs/plugins/api/properties/nodes-findall/](https://developers.figma.com/docs/plugins/api/properties/nodes-findall/)  
8. Find all instance coming from the same component \- Figma Forum, дата последнего обращения: февраля 27, 2026, [https://forum.figma.com/ask-the-community-7/find-all-instance-coming-from-the-same-component-19824](https://forum.figma.com/ask-the-community-7/find-all-instance-coming-from-the-same-component-19824)  
9. VectorPath | Developer Docs, дата последнего обращения: февраля 27, 2026, [https://developers.figma.com/docs/plugins/api/VectorPath/](https://developers.figma.com/docs/plugins/api/VectorPath/)  
10. Compare two closed SVG paths in javascript \- Stack Overflow, дата последнего обращения: февраля 27, 2026, [https://stackoverflow.com/questions/75419492/compare-two-closed-svg-paths-in-javascript](https://stackoverflow.com/questions/75419492/compare-two-closed-svg-paths-in-javascript)  
11. How to normalize SVG path data (cross browser)? \- Stack Overflow, дата последнего обращения: февраля 27, 2026, [https://stackoverflow.com/questions/12977480/how-to-normalize-svg-path-data-cross-browser](https://stackoverflow.com/questions/12977480/how-to-normalize-svg-path-data-cross-browser)  
12. Intersection of 2 SVG Paths \- Stack Overflow, дата последнего обращения: февраля 27, 2026, [https://stackoverflow.com/questions/42070839/intersection-of-2-svg-paths](https://stackoverflow.com/questions/42070839/intersection-of-2-svg-paths)  
13. Select Similar | Figma Bites \- YouTube, дата последнего обращения: февраля 27, 2026, [https://www.youtube.com/watch?v=a3lDRIY\_LLQ](https://www.youtube.com/watch?v=a3lDRIY_LLQ)  
14. Figma Object Selection Tips | Envato Tuts+, дата последнего обращения: февраля 27, 2026, [https://webdesign.tutsplus.com/figma-object-selection-tips--cms-31983t](https://webdesign.tutsplus.com/figma-object-selection-tips--cms-31983t)  
15. 12 Figma plugins you'll need in 2025 | Muzli Blog, дата последнего обращения: февраля 27, 2026, [https://muz.li/blog/12-figma-plugins-youll-need-in-2025/](https://muz.li/blog/12-figma-plugins-youll-need-in-2025/)  
16. 8 Figma plugins for design system management \- LogRocket Blog, дата последнего обращения: февраля 27, 2026, [https://blog.logrocket.com/ux-design/8-figma-plugins-design-system-management/](https://blog.logrocket.com/ux-design/8-figma-plugins-design-system-management/)  
17. Effective Figma plugins for Design Systems that actually deliver results | by Vasil Hodzhev, дата последнего обращения: февраля 27, 2026, [https://medium.com/@vasilhodzhev/effective-figma-plugins-for-design-systems-that-actually-deliver-results-f4143e22edae](https://medium.com/@vasilhodzhev/effective-figma-plugins-for-design-systems-that-actually-deliver-results-f4143e22edae)  
18. 10 Reasons We Switched to Figma For Icon Design \- Blog Awesome, дата последнего обращения: февраля 27, 2026, [https://blog.fontawesome.com/figma-for-icon-design/](https://blog.fontawesome.com/figma-for-icon-design/)  
19. Awesome-Design-Tools/Awesome-Design-Plugins.md at master \- GitHub, дата последнего обращения: февраля 27, 2026, [https://github.com/goabstract/Awesome-Design-Tools/blob/master/Awesome-Design-Plugins.md](https://github.com/goabstract/Awesome-Design-Tools/blob/master/Awesome-Design-Plugins.md)  
20. Find assets and designs using AI – Figma Learn \- Help Center, дата последнего обращения: февраля 27, 2026, [https://help.figma.com/hc/en-us/articles/24037716110615-Find-assets-and-designs-using-AI](https://help.figma.com/hc/en-us/articles/24037716110615-Find-assets-and-designs-using-AI)  
21. How to Compare Objects for Equality in JavaScript? \- GeeksforGeeks, дата последнего обращения: февраля 27, 2026, [https://www.geeksforgeeks.org/javascript/how-to-compare-objects-for-equality-in-javascript/](https://www.geeksforgeeks.org/javascript/how-to-compare-objects-for-equality-in-javascript/)  
22. Page 2 of 22 \- Tutorials Guides for Linux, Windows and Developers \- Utho, дата последнего обращения: февраля 27, 2026, [https://utho.com/blog/page/2/](https://utho.com/blog/page/2/)  
23. Updating text/images across different artboard sizes. : r/AdobeIllustrator \- Reddit, дата последнего обращения: февраля 27, 2026, [https://www.reddit.com/r/AdobeIllustrator/comments/1l9f258/updating\_textimages\_across\_different\_artboard/](https://www.reddit.com/r/AdobeIllustrator/comments/1l9f258/updating_textimages_across_different_artboard/)  
24. Download Hundreds of Plugins \- Sketch, дата последнего обращения: февраля 27, 2026, [https://www.sketch.com/extensions/plugins/](https://www.sketch.com/extensions/plugins/)  
25. Boolean operations – Figma Learn \- Help Center, дата последнего обращения: февраля 27, 2026, [https://help.figma.com/hc/en-us/articles/360039957534-Boolean-operations](https://help.figma.com/hc/en-us/articles/360039957534-Boolean-operations)  
26. Figma Basics: How To INTERSECT SHAPES (Tutorial) \- YouTube, дата последнего обращения: февраля 27, 2026, [https://www.youtube.com/watch?v=uZHuTbF55cY](https://www.youtube.com/watch?v=uZHuTbF55cY)  
27. Convert strokes to vector paths – Figma Learn \- Help Center, дата последнего обращения: февраля 27, 2026, [https://help.figma.com/hc/en-us/articles/33052305733015-Convert-strokes-to-vector-paths](https://help.figma.com/hc/en-us/articles/33052305733015-Convert-strokes-to-vector-paths)  
28. I cannot for the life of me remember how to fill the negative spaces separate from the outline layer : r/AdobeIllustrator \- Reddit, дата последнего обращения: февраля 27, 2026, [https://www.reddit.com/r/AdobeIllustrator/comments/1lo30sa/i\_cannot\_for\_the\_life\_of\_me\_remember\_how\_to\_fill/](https://www.reddit.com/r/AdobeIllustrator/comments/1lo30sa/i_cannot_for_the_life_of_me_remember_how_to_fill/)  
29. ComponentNode | Developer Docs, дата последнего обращения: февраля 27, 2026, [https://developers.figma.com/docs/plugins/api/ComponentNode/](https://developers.figma.com/docs/plugins/api/ComponentNode/)  
30. Select only objects which are covered by the selection box \- Stack Overflow, дата последнего обращения: февраля 27, 2026, [https://stackoverflow.com/questions/75052257/select-only-objects-which-are-covered-by-the-selection-box](https://stackoverflow.com/questions/75052257/select-only-objects-which-are-covered-by-the-selection-box)

[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAsAAAAaCAYAAABhJqYYAAAAvklEQVR4XmNgGAUDARygmAPKFwZiNSBmhPLBAMTJAuKLQPwUiF8DcQIQvwXin0A8Ba4SCDKA+CCUDTLtHANEowIDRPNzqBwYgHTCrJIB4idAbAMV+wTEmVA5MOBBYrsA8T8gFkcSwwpYgHgNEP9Hl8AGpIH4ARD/RhID2SoA44CsA5m0B4hboewDMEkGiEdVYByQ4jtAbAXEt4D4CxBfh8qBFAVD2WAA8vEvBkgIBAGxCQMknEH8l1D5UUBHAADTniI11ql4UwAAAABJRU5ErkJggg==>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAZCAYAAAAIcL+IAAAAzUlEQVR4XmNgGAXUBrJArADEjGjiKGAHEAsB8VcgvookXg7E/4GYBcQRA2JbqARIEFnhVqgYGHBAaSUg/gfELjAJKP8JEh8M0oH4NBALIomBTAOZCgcgN6wB4klIYtwMEIWtSGIMxgwQj4BoGPAE4ucMECfBgT4Qf2JAKGQF4vkMEGthfoADTSD+ywBx/Ekg/saA6jEUAAoqSSD2YID4WBpZEhQTIEeD3AgDIJNvIfHBAOa7bVA+yAnvgdgMrgIJgKwCBc9MILZCkxsyAACyyyTeGhru5wAAAABJRU5ErkJggg==>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF0AAAAXCAYAAABpskPJAAADvklEQVR4Xu2YT4jNURTHz4Qi/xIl+TNlMSXKQkw2kphIJEwpdhY2VqYo2czCYiwkiZKarCjLacpCeWWjbE1KqbGyECIU+Xc+c39n3nln7n3vpZmUfp86vXfP/Z7fvffc3+937/2J1NTU1NT8z/So7YpOxzK122o31RaHuk6clhQ7KOXYeWrXJenWhzoDzV5JuiEp6xjLFUnX6qvKEXzbJGmGq3KONZLaos2BUBdZoLYpOiNX1d6r/VT7rXahtXqaD2qPXJn/+DqxQ5JueVXml1j8nni982q/pDURxKKxWOrQYV5HEhmPcawqkxCD//ioMygT66Een8X2qr2sfo37ap/VfkjK4SFXl6Vf7bjaBrXXkk/6IkkJ2O98/MdHXTseStJ5iB2T1lg6e8OVV6u9UNvsfGclaXyC0b2VVh3t0a5BO5T3OR99wOf7QNlPlvVhi/MBfb3myrvVjki6Gb5IF0k3eIRKScf3SlInDNOfcb4cdJBYD7H4LZZHnPKBaUXirtq42kJJGgYUNUAsOlhblc81q6dgDBNqqyRpJiWvIRYNjFbl+DqkH/FGAuvjrCSdwTfUljjfCrVnanecLwedbgQfsfgtlk7SWTrtuSzNyUZDTNSAn1ibwDjwk2qf1LZKOTloiEUDjaoceSN5f+m6RUpJJ9GNynzSS34P/lzSo582c0n3frsLowbwowObnDhw7+9GA+Qjl9ySv056s3qGvxsNlJJb8tdJb1bP8HejgVJyS/5ZSzqLCNu5huSTPi5poctBbLukEwssaKWkv5O070XTLunogIW2lFAWP/b47TT40QDrRC65c550YCF9orbU+VjhJ6S7hZRYD7H4/UL6VW37tCLBYSQupFED+ONCerRZPQU7pbiQ5jTExoW0xwQVTPCcJ32npBV7o/PRMQYR7zxOtP4Q8k1SrIdYf2dz6GEQ7B4Me8KsP2ieSqsG7Gky3fyqzM7HwwSPSkogmnuS1/gkn6jK7LY8+CaDD2Y16bnD0WFJjfvDBYcPfLecL3c4InZM2h+ObC/d6XCErtPhyF6FnQ5HDfm7w5HRddJtgYrGBDARxkFJF7xYGQPd4+qhV+272qngJ5brEccvsZF1kvb9HLl5zEncpRZFAg1toHssSeefLOCpeFAZ33zQcJdHqGesaPiPhifHwwQzEc/VRtQ+ysxvK7x+Y/6whpQ3GV1Dh/jYxbs2DrQTg5JiB6Qcy8cs+0i1MtQZaPol6UhWSUeyhqX9xzM0fZI0Q6HOQxu0RZu0XVNTU1NTU/Mv+ANe/k3m6/zpRAAAAABJRU5ErkJggg==>

[image5]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF0AAAAXCAYAAABpskPJAAAD90lEQVR4Xu2YT4jNURTHz4Qi/6Mkf0YWU6IsxGRjISYSC0wpdhY2VqYo2czCgoUkUVKTlYWllIXyYqNs/SmlxkIWQhRF+XM+c3/nvfM77973JrNQ+n3q9N4993vevff8/px7n0hDQ0NDw//MgNqO6HQsUruhdk1tfujrx3FJsaNSjp2ldkWSbk3oM9DskqQbk7KOtVyU9FtDVTuCb4skzXjVzrFS0liMORL6DOZl46GZU++uc0nto9pPtd9qZ+rdbT6pPXBtvuPrxzZJusVVm09i8Xvi751W+yX1RBCLxmLpQ4d5HQtnPcahqu0TwXd89Bm0ifXQj89iB9VeVZ8Gc7/p2o8k5TKusc2w2mG1tWpvJJ/0eZISsMf5+I6Pvl7cl6TzEHtX6rFM8qprr1B7qbbR+U5K0vgEo3svdR3jMa7BOLR3Ox9zwOfnQNtfLJvDJucD5nrZtblpefoMnp6vak+kc7Nl4REqJR3fa0mTMEx/wvlyMEFiPcTit1gmSXtvW5G4pXZPba50FhI1QCw6WFW1T3W6p2ANz9WWS9JMSl5DLBqYqNrxdcg87EaaLUmDec5Xvv3BX6NX0ll8S22B8y1Veyr1xyoHA7eCj1j8FsvEWAiJ9TBxu9hoiIka8BfWLmBc7FG1L2qbpXMBcxpi0UCrakfeSd3/Te2ta8OMkk6iW5X5pJf8Hvy5pEc/Y+aS7v12F0YN4EcHdnHiYr1/OhogH7mkl/wGryNqT3yFdtEkvdtfSm7Jb/AE078+dkSapHf7S8kt+Q2K8XR2dsWkU0TYErUkn3QrdDmI7ZV0K34UtFLSP6htkKTplXR0QKEtJZTixy6jlwa/7USoE7nklpI+KGk7uS74i5SSDhTSx2oLnY8Kz25gOoWUWA+x+H0hpRhtbSsSHEZiIY0awB8L6cFO9xTslGIhzWmIjYV0wAQVXOBc0rk52aMbS6R8Q07RK+nbJVVs/45iYiwi3nmcaP0h5LukWA+x/s5mL8si2D0Y9oTZfNCw7/UasKfJdLaFY/fg4QJPSEogmtuS1/gkH6na7LY8+CZdm/VygIpbyxfSnZ8avZKeOxwdkDS4r84cPvBdd77c4YjYWNmJ84cj20v3Oxyh63c4sldhv8NRS/7ucMSJmHc4ifdGPslrF1agosWAfZLuzrOVsdCdrh8G1X6oHQt+Yvk94vgkNrJa0r6fyfKYk7hzNUUCDWOgeyhJF//n4Km4Uxn/+aDhLo/Qz1rR8B1NvFu5wFyIZ2oX1D5LqjGG1aec8VqeMUyIP7t418aF9mNUUuyIlGP9n0bLQp+BZliSjmSVdCRrXHr/eYZmSJJmLPR5GIOxGJOxGxoaGhoaGv4FfwAOBFkIgMElmQAAAABJRU5ErkJggg==>

[image6]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAXCAYAAABu8J3cAAABaklEQVR4Xu2VvUoEQRCEO1A48Q9BEDETcwNBMDEQEUE00icwEHwBwccwuOC4xGcQwcBgwVAwMzQw0cBAEAwU/Km66T362plZTWU+KJat6Z6pPfZ6RQqFv7EPdaA9aNSt5ZiQ0NuW0NvEITTkTbIMPUOTes/rpfpNsIa1tpd72d516AH6gj6gChoz630uoE/nbUJn0IjzLVxjL2st3Iu9NXPQroTDTyUThEnvnDer/oHzLUcSamacf69+jMYglfOm1O8638JNWeM3vVY/RjIIjViQlG+pJB4k5ZMSxJMMwnkRO7AOcu58C/+2sQMr9VvOJ8kghE1XzptW/zcv67jzb9WPkQ3yBj06bxF6hZaMtwCtmvsVCb3zxiMvEnpjZIPEBtqO/BxonIp80no8pwYaa+xAs2SDkC0Jg+hYr0+Dyz1uoHdvSnh627s2uNz7VVnDgF7bpq4PP1j8cG1Aw24tB1949p5I6C0U/i/fm85wxjTPPyQAAAAASUVORK5CYII=>