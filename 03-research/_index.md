---
title: "Research — Map of Content"
type: moc
created: 2026-02-27
updated: 2026-02-27
---

# 🔬 Research

## Deep Research Backlog

| ID | Тема | Приоритет | Для | Статус |
|----|------|-----------|-----|--------|
| DR-001 | Naming conventions audit | P0 | Tokens | ⏳ Pending |
| DR-002 | Platform token mapping | P0 | Tokens | ⏳ Pending |
| DR-003 | Accessibility token patterns | P0 | Tokens | ⏳ Pending |
| DR-004 | DTCG 2025.10 deep dive | P0 | Tokens | ⏳ Pending |
| DR-005 | Style Dictionary v4 config | P0 | Tokens | ⏳ Pending |
| DR-006 | Color system engineering | P1 | Foundation | ⏳ Pending |
| DR-007 | Typography scale systems | P1 | Foundation | ⏳ Pending |
| DR-008 | Figma Variables architecture | P0 | Figma | ⏳ Pending |
| DR-009 | Tokens Studio workflow | P1 | Figma | ⏳ Pending |
| DR-010 | Multi-brand theming | P1 | Theming | ⏳ Pending |
| DR-011 | Framework decision matrix | P2 | Code | ⏳ Pending |
| DR-012 | UX heuristics → DS mapping | P0 | Patterns | ⏳ Pending |
| DR-013 | Cognitive psychology for UI | P1 | Patterns | ⏳ Pending |
| DR-014 | Platform divergence matrix | P0 | Patterns | ⏳ Pending |
| DR-015 | Responsive spatial system | P1 | Patterns | ⏳ Pending |
| DR-016 | AI UX patterns catalog 2025 | P0 | Patterns | ⏳ Pending |
| DR-017 | Agentic UX framework | P1 | Patterns | ⏳ Pending |
| DR-018 | AI + Traditional UI integration | P1 | Patterns | ⏳ Pending |

## Завершённые исследования

```dataview
TABLE source_tool, freshness
FROM "03-research/deep-research"
WHERE type = "research" AND status = "stable"
SORT research_id ASC
```
