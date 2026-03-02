---
title: "Platform Mapping"
type: token
status: seed
version: "0.1.0"
created: 2026-02-27
updated: 2026-02-27
freshness: current
freshness_checked: 2026-02-27
tags: [type/token, cross-platform]
---

# Platform Mapping

Маппинг semantic tokens → платформенные значения.

| Semantic Token | CSS | Swift | Kotlin |
|----------------|-----|-------|--------|
| `space.gap.md` | `--space-gap-md: 16px` | `.gap(.md) // 16pt` | `SpaceGap.Md // 16.dp` |
| `typo.body.md.fontSize` | `--typo-body-md-font-size: 1rem` | `.body // 17pt` | `Typography.Body.fontSize // 16.sp` |
| `color.action.primary` | `--color-action-primary: #2563EB` | `.actionPrimary // UIColor` | `CoreDSColors.ActionPrimary` |

> **TODO:** Заполнить полную таблицу после DR-002 (Platform Token Mapping)
