---
title: "Nielsen's 10 Usability Heuristics"
type: heuristic
category: foundations
status: seed
version: "0.1.0"
created: 2026-02-27
updated: 2026-02-27
freshness: current
freshness_checked: 2026-02-27
tags: [type/heuristic, category/foundations]
related_components: []
related_patterns: []
---

# Nielsen's 10 Usability Heuristics

## Маппинг на CoreDS

| # | Эвристика | Компоненты | Токены | Паттерны |
|---|-----------|-----------|--------|----------|
| 1 | Visibility of system status | [[loading]], [[toast]], [[progress-bar]] | [[motion]] | [[loading-states]] |
| 2 | Match between system and real world | [[icon]], [[button]] | [[typography]] | [[naming-conventions]] |
| 3 | User control and freedom | [[dialog]], [[toast]] | — | [[undo-rollback]] |
| 4 | Consistency and standards | Все компоненты | Все токены | [[convergence-framework]] |
| 5 | Error prevention | [[input]], [[form-field]] | [[color#error]] | [[form-validation]] |
| 6 | Recognition rather than recall | [[tab-bar]], [[breadcrumbs]] | — | [[tab-bar]], [[search]] |
| 7 | Flexibility and efficiency of use | [[keyboard-shortcuts]] | — | [[power-user-patterns]] |
| 8 | Aesthetic and minimalist design | — | [[spacing]], [[typography]] | [[content-hierarchy]] |
| 9 | Help users recognize errors | [[input]], [[toast]] | [[color#error]] | [[error-handling]] |
| 10 | Help and documentation | [[tooltip]], [[empty-state]] | — | [[onboarding]] |

> **TODO:** Раскрыть каждую эвристику подробно, добавить примеры нарушений
