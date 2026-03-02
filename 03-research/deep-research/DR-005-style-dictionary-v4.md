---
title: "Dr 005 Style Dictionary V4"
type: "research"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/research"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Deep research: DR-005-style-dictionary-v4"
---

# Архитектура и техническая реализация мультиплатформенных дизайн-систем на базе Style Dictionary версии 4 и спецификации DTCG 2025.10

Процесс индустриализации цифрового дизайна за последнее десятилетие прошел путь от разрозненных UI-китов до сложных программно-архитектурных комплексов, известных как дизайн-системы. В центре этой эволюции находится концепция дизайн-токенов — атомарных единиц стилистической информации, которые позволяют синхронизировать визуальный язык между различными технологическими стеками. Выход четвертой версии Style Dictionary и утверждение спецификации Design Tokens Community Group (DTCG) версии 2025.10 знаменуют собой переход к новому этапу зрелости инструментов, обеспечивая нативную поддержку асинхронности, строгую типизацию и стандартизированный формат обмена данными. Данный отчет представляет собой исчерпывающее техническое руководство по проектированию и внедрению конвейера сборки токенов, ориентированного на современные требования веб-разработки и нативных мобильных платформ (iOS и Android).

## Глава 1. Теоретический фундамент и стандарт DTCG 2025.10

Стандартизация формата дизайн-токенов стала критической необходимостью в условиях фрагментации инструментов проектирования и разработки. Спецификация DTCG 2025.10 предлагает унифицированную структуру JSON-файлов, где ключевыми элементами являются свойства `$value`, `$type` и `$description`. Этот стандарт позволяет инструментам однозначно интерпретировать семантику токена, отделяя его значение от метаданных.

В Style Dictionary v4 реализована первоклассная поддержка этого стандарта, что позволяет избежать сложной предварительной обработки файлов, полученных из таких инструментов, как Figma через плагины (например, Tokens Studio). Использование префикса `$` гарантирует отсутствие конфликтов с пользовательскими ключами групп токенов.

### Сравнительный анализ структур данных

Для понимания глубины изменений необходимо рассмотреть различия между классическим форматом Style Dictionary и актуальным стандартом DTCG в представлении различных типов данных.

|**Характеристика**|**Style Dictionary v3 (Classic)**|**DTCG 2025.10 (Standard)**|
|---|---|---|
|Определение значения|`value`|`$value`|
|Определение типа|`type`|`$type`|
|Описание назначения|`comment`|`$description`|
|Группировка свойств|Произвольные вложенные объекты|Строгая иерархия с поддержкой `$extensions`|
|Алиасы (ссылки)|`{color.base.blue}`|`{color.base.blue}`|

Важнейшим аспектом спецификации является обработка композитных токенов, таких как типографика или тени. В отличие от простых значений, композитные токены в `$value` содержат объект с набором свойств, каждое из которых может иметь свой собственный тип. Style Dictionary v4 вводит механизм `expand`, который позволяет автоматически разворачивать такие объекты в плоские структуры для платформ, не поддерживающих сложные типы данных, например, для CSS Custom Properties.

## Глава 2. Архитектура уровней токенов

Эффективная дизайн-система строится на иерархическом принципе организации данных. Трехуровневая модель (Primitive, Semantic, Component) является индустриальным стандартом, обеспечивающим баланс между гибкостью и поддерживаемостью системы.

### Уровень Primitive (Базовые токены)

На этом уровне определяются "сырые" значения, не привязанные к контексту использования. Это палитры цветов, шкалы размеров, значения прозрачности и временные интервалы анимаций. Прямое использование примитивов в коде компонентов считается антипаттерном, так как это лишает систему гибкости при смене визуального языка.

### Уровень Semantic (Семантические токены)

Семантический уровень является мостом между примитивами и их функциональным назначением. Именно здесь реализуется логика темизации. Например, токен `color.background.primary` в светлой теме может ссылаться на примитив `color.blue.100`, а в темной — на `color.blue.900`. Такая структура позволяет изменять цветовую схему всего интерфейса, не затрагивая описание компонентов.

### Уровень Component (Компонентные токены)

Компонентные токены описывают стили конкретных элементов управления, таких как кнопки, поля ввода или карточки. Они наследуют значения от семантических токенов. Например, `button.primary.background` ссылается на `color.interactive.primary`. Это обеспечивает консистентность: если меняется интерактивный цвет системы, меняются и все зависимые компоненты.

## Глава 3. Полная конфигурация Style Dictionary v4 (config.ts)

Переход Style Dictionary на архитектуру ES-модулей требует использования расширения `.ts` или `.js` с типом `module` в `package.json`. Асинхронная инициализация через конструктор `new StyleDictionary()` позволяет выполнять сложные операции подготовки данных перед началом трансформации.

Ниже представлена полная реализация конфигурационного файла, написанная на TypeScript, которая учитывает специфику мультиплатформенной сборки и использование формата DTCG 2025.10.

TypeScript

```
import StyleDictionary from 'style-dictionary';
import { Config } from 'style-dictionary/types';
import { registerTransforms } from './hooks/transforms';
import { registerFormats } from './hooks/formats';

/**
 * Регистрация пользовательских хуков (трансформов и форматов).
 * В v4 все расширения рекомендуется группировать в объекте hooks.
 */
registerTransforms(StyleDictionary);
registerFormats(StyleDictionary);

/**
 * Генерация конфигурации для конкретного бренда и темы.
 * Style Dictionary v4 поддерживает асинхронные конфигурации.
 */
export async function createConfig(brand: string, theme: string): Promise<Config> {
  return {
    // Пути к исходным файлам токенов в формате DTCG 2025.10
    // Примитивы подключаются всегда, семантика фильтруется по теме
    source: [
      `tokens/primitives/**/*.json`,
      `tokens/brands/${brand}/semantic/${theme}.json`,
      `tokens/brands/${brand}/components/**/*.json`
    ],

    // Механизм expand для композитных токенов (Typography, Shadow)
    // Позволяет трансформировать внутренние части объекта (например, px в rem)
    expand: {
      include: ['typography', 'shadow', 'border'],
      typesMap: {
        fontSize: 'dimension',
        lineHeight: 'dimension',
        gap: 'dimension',
        padding: 'dimension',
        borderWidth: 'dimension'
      }
    },

    platforms: {
      /**
       * Платформа Web: CSS Custom Properties
       */
      css: {
        transformGroup: 'css', // Базовая группа трансформов
        transforms:,
        buildPath: `dist/web/${brand}/`,
        files:
      },

      /**
       * Платформа iOS: Swift (UIKit + SwiftUI)
       */
      ios: {
        transformGroup: 'ios-swift',
        transforms:,
        buildPath: `dist/ios/${brand}/`,
        files:,
              outputReferences: true
            }
          }
        ]
      },

      /**
       * Платформа Android: Kotlin (Jetpack Compose)
       */
      android: {
        transformGroup: 'compose',
        transforms:,
        buildPath: `dist/android/${brand}/`,
        files:
      }
    }
  };
}
```

## Глава 4. Реализация кастомных трансформов

Трансформы в Style Dictionary 4 определяют логику преобразования каждого отдельного значения токена. Ключевым нововведением версии является использование свойства `token.$type` для сопоставления (matching) вместо устаревшей структуры CTI (Category/Type/Item).

### Трансформация цвета (Color)

Современный веб-дизайн стремится к использованию пространства OKLCH, которое обеспечивает более естественное восприятие яркости и насыщенности. Для мобильных платформ требуются специфические конструкторы.

TypeScript

```
// Web: OKLCH
// Пример DTCG значения: { "$type": "color", "$value": "#ff0000" }
StyleDictionary.registerTransform({
  name: 'color/css/oklch',
  type: 'value',
  filter: (token) => token.$type === 'color',
  transform: (token) => {
    // В реальной реализации здесь может быть библиотека типа culori для конвертации
    // Для примера возвращаем HEX, если конвертация не требуется
    return token.$value; 
  }
});

// iOS: UIColor
StyleDictionary.registerTransform({
  name: 'color/swift/uicolor',
  type: 'value',
  filter: (token) => token.$type === 'color',
  transform: (token) => {
    // Предполагается, что на входе HEX или RGB
    // Выход: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    return `UIColor(red: ${token.attributes.rgb.r / 255}, green: ${token.attributes.rgb.g / 255},... )`;
  }
});
```

### Размеры (Dimension)

Трансформация размеров требует понимания базовой плотности пикселей. Математически переход от пикселей к относительным единицам выражается формулой:

$$\text{Value}_{\text{rem}} = \frac{\text{Value}_{\text{px}}}{\text{BaseFontSize}}$$

Где $\text{BaseFontSize}$ обычно равен 16.

TypeScript

```
StyleDictionary.registerTransform({
  name: 'dimension/web/rem',
  type: 'value',
  filter: (token) => token.$type === 'dimension',
  transform: (token) => {
    const base = 16;
    return `${parseFloat(token.$value) / base}rem`;
  }
});

StyleDictionary.registerTransform({
  name: 'dimension/kotlin/dp',
  type: 'value',
  filter: (token) => token.$type === 'dimension',
  transform: (token) => `${parseFloat(token.$value)}.dp`
});
```

### Композитные токены: Типографика и Тени

Композитные токены в DTCG представляют собой объекты. Например, Shadow содержит `color`, `offsetX`, `offsetY`, `blur` и `spread`. Для CSS нам нужно объединить их в строку `box-shadow`, а для Swift — в инициализатор структуры.

TypeScript

```
// CSS Shadow Shorthand
StyleDictionary.registerTransform({
  name: 'shadow/css/shorthand',
  type: 'value',
  filter: (token) => token.$type === 'shadow',
  transform: (token) => {
    const shadows = Array.isArray(token.$value)? token.$value : [token.$value];
    return shadows.map(s => `${s.offsetX}px ${s.offsetY}px ${s.blur}px ${s.spread}px ${s.color}`).join(', ');
  }
});

// Kotlin TextStyle (Compose)
StyleDictionary.registerTransform({
  name: 'typography/kotlin/textstyle',
  type: 'value',
  filter: (token) => token.$type === 'typography',
  transform: (token) => {
    const { fontSize, fontWeight, fontFamily } = token.$value;
    return `TextStyle(fontSize = ${fontSize}.sp, fontWeight = FontWeight(${fontWeight}), fontFamily = FontFamily("${fontFamily}"))`;
  }
});
```

## Глава 5. Кастомные форматы и сохранение ссылок (outputReferences)

Форматы определяют структуру результирующего файла. Опция `outputReferences` позволяет сохранять связи между токенами, что критически важно для создания масштабируемых систем с поддержкой рантайм-темизации.

### Особенности работы outputReferences

|**Платформа**|**Механизм ссылок**|**Ограничения**|
|---|---|---|
|CSS|`var(--variable-name)`|Требует наличия базового токена в DOM|
|Swift|Обращение к `static let` свойствам|Порядок объявления имеет значение (Define-before-use)|
|Kotlin|Прямые ссылки на `val` внутри объекта|Требует правильной последовательности инициализации|

Для реализации ссылок в кастомных форматах используются утилиты `usesReferences` и `getReferences` из пакета `style-dictionary/utils`.

TypeScript

```
// Кастомный формат для Swift Struct
StyleDictionary.registerFormat({
  name: 'ios-swift/themed-struct',
  format: async ({ dictionary, options, file }) => {
    const header = await StyleDictionary.utils.fileHeader({ file });
    const content = dictionary.allTokens.map(token => {
      let value = JSON.stringify(token.value);
      
      // Проверка на наличие ссылки в оригинальном значении DTCG
      if (options.outputReferences && StyleDictionary.utils.usesReferences(token.original.$value)) {
        const refs = StyleDictionary.utils.getReferences(token.original.$value, dictionary.tokens);
        // Заменяем разрешенное значение на имя ссылочного токена
        refs.forEach(ref => {
          value = value.replace(JSON.stringify(ref.value), ref.name);
        });
      }
      
      return `  public static let ${token.name}: CGFloat = ${value}`;
    }).join('\n');

    return `${header}import UIKit\n\npublic struct ${options.className} {\n${content}\n}`;
  }
});
```

## Глава 6. Организация многофайлового вывода и темизация

Разделение токенов по категориям (colors.css, spacing.css) и темам (light.css, dark.css) позволяет оптимизировать доставку стилей в веб-приложениях и улучшить читаемость кода в нативных приложениях.

### Стратегия фильтрации

Фильтрация осуществляется через свойство `filter` в объекте `file`. Вы можете использовать `matcher` для проверки типа токена или его пути в файловой системе.

TypeScript

```
// Разделение по категориям в конфигурации
files: [
  {
    destination: 'colors.css',
    format: 'css/variables',
    filter: (token) => token.$type === 'color'
  },
  {
    destination: 'typography.css',
    format: 'css/variables',
    filter: (token) => token.$type === 'typography'
  }
]
```

## Глава 7. Сценарии сборки и автоматизация

В версии 4 Style Dictionary методы сборки стали асинхронными, что требует изменения подхода к написанию build-скриптов. Вместо прямого использования CLI рекомендуется создавать JS/TS обертку для управления сложными параметрами брендирования.

### build-tokens.ts

TypeScript

```
import StyleDictionary from 'style-dictionary';
import { createConfig } from './config.js';

async function runBuild() {
  const args = process.argv.slice(2);
  const brandArg = args.find(a => a.startsWith('--brand='))?.split('=') |

| 'default';
  const themeArg = args.find(a => a.startsWith('--theme='))?.split('=') |

| 'light';

  const config = await createConfig(brandArg, themeArg);
  const sd = new StyleDictionary(config);
  
  await sd.buildAllPlatforms();
}

runBuild().catch(console.error);
```

### Настройка package.json

JSON

```
{
  "type": "module",
  "scripts": {
    "build:tokens": "node build-tokens.js",
    "build:theme": "node build-tokens.js --theme=dark",
    "watch": "nodemon --watch tokens -e json --exec 'npm run build:tokens'"
  }
}
```

## Глава 8. Ошибки, подводные камни и диагностика

Внедрение Style Dictionary v4 сопряжено с рядом технических нюансов, игнорирование которых может привести к нарушению консистентности системы.

### Несовместимость форматов

Style Dictionary v4 строго разделяет "классический" формат и стандарт DTCG. Использование ключа `value` (без префикса `$`) в файлах, предназначенных для обработки как DTCG, может привести к тому, что парсер проигнорирует такие токены или сочтет их невалидными.

### Значимость порядка трансформов

Трансформы выполняются последовательно в массиве `transforms`. Если первый трансформ изменяет `token.value` из объекта в строку (например, для тени), то второй трансформ, ожидающий объект для работы с цветом тени, завершится с ошибкой.

**Пример правильной последовательности:**

1. **Attribute Transforms**: Обогащение метаданными.
    
2. **Name Transforms**: Формирование имени токена.
    
3. **Value Transforms**: Преобразование данных от атомарных к сложным.
    

### Диагностика неразрешенных ссылок

Одной из самых частых проблем является ситуация, когда токен `semantic` ссылается на примитив, который был отфильтрован из текущей сборки. Style Dictionary v4 выводит подробные предупреждения о таких случаях. Для диагностики рекомендуется использовать флаг `--verbose` в CLI или включать логгирование в Node API.

## Заключение

Переход на Style Dictionary v4 и стандарт DTCG 2025.10 является фундаментальным шагом к созданию по-настоящему интероперабельных дизайн-систем. Использование асинхронных хуков, строгой типизации и продвинутых механизмов работы со ссылками (`outputReferences`) позволяет разработчикам строить гибкие и производительные конвейеры поставки стилей.

Ключевым преимуществом новой версии является ее готовность к будущим изменениям спецификаций и поддержка сложных композитных типов данных, что делает Style Dictionary незаменимым инструментом в арсенале современной продуктовой команды. Тщательное планирование архитектуры уровней токенов и грамотная настройка трансформов обеспечивают долгосрочную жизнеспособность системы и легкость ее масштабирования на новые платформы и бренды.