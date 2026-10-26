---
id: <path/from/plan/root>
title: <short human title>
status: draft
depends_on: []
neighbors: []
parent_hash: null
updated: <YYYY-MM-DD>
---

## Context

<Compressed context handed down from the parent: the relevant slice of the
overall idea, the interfaces/constraints this node must respect. NOT the full
upstream plan — only what this node needs to stay consistent with its
neighbors.>

## Summary

<Filled in once status is done/resolved. The actual conclusion/decision for
this node — what a sibling or the coordinator needs to know without opening
this node's own children.>

## Options

<Only present when status is ambiguous or resolved-from-ambiguous. A table:>

| Option | Pros | Cons |
|---|---|---|
| A: ... | ... | ... |
| B: ... | ... | ... |

Recommendation (if any): ...
Verdict: <filled in by user, via coordinator, once resolved>
Verdict reason: ...

## Children

<List of child node ids, only if this node has been split. Empty if leaf.>

- <child-id> — <one-line topic> — status: <status>
