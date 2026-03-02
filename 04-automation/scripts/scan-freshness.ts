/**
 * scan-freshness.ts
 *
 * Скрипт проверки актуальности заметок vault.
 * Сканирует frontmatter, сравнивает freshness_checked с правилами,
 * генерирует отчёт.
 *
 * Запуск: npm run scan:freshness
 *
 * TODO: Реализовать в Фазе 6 Pattern Library / Фазе 8 CoreDS
 */

import * as fs from 'fs';
import * as path from 'path';
// import matter from 'gray-matter';  // Парсинг frontmatter
// import { glob } from 'glob';       // Поиск файлов

// Путь к правилам актуальности
const RULES_PATH = path.join(__dirname, '../config/freshness-rules.json');

// Директории для сканирования
const SCAN_DIRS = [
  '01-design-system',
  '02-patterns',
];

/**
 * Алгоритм:
 * 1. Загрузить правила из freshness-rules.json
 * 2. Найти все .md файлы в SCAN_DIRS
 * 3. Для каждого файла:
 *    a. Прочитать frontmatter (gray-matter)
 *    b. Определить категорию по пути или frontmatter.category
 *    c. Найти правило для этой категории
 *    d. Сравнить freshness_checked + period с текущей датой
 *    e. Если просрочено — пометить как stale/outdated
 * 4. Сгенерировать отчёт: freshness-report.md
 * 5. Опционально: обновить frontmatter в файлах (freshness: stale)
 */

console.log('⏳ scan-freshness: TODO — реализовать в Фазе 6/8');
console.log('📋 См. patterns-spec.md раздел 9 для спецификации');
