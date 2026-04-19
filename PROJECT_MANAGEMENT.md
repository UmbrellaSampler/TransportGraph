## Project Management Model

This document defines the general GitHub project management structure for GraphCreator3D.

## Purpose

- Define how epics, tasks, and sub-tasks are represented in GitHub.
- Define how milestones and labels map work to phases.
- Keep planning rules stable while implementation details evolve.

## Source of Truth

- Project scope and release criteria are defined in README.
- Work execution is tracked in GitHub Issues and GitHub Project.
- This document defines process and taxonomy only.

## Work Hierarchy

- Epic:
	- One high-level objective within exactly one phase.
	- Must include scope boundaries and acceptance criteria.
	- Labeled with `kind:epic`.
	- Must be assigned to one phase milestone and one Project `Phase` field value.
- Task:
	- Implementable work item under one epic.
	- Must include objective and acceptance criteria.
	- Labeled with `kind:task`.
	- Must be assigned to one phase milestone and one Project `Phase` field value.
- Sub-task:
	- Independently tracked child item under one task.
	- Use only when separate ownership or status tracking is needed.
	- Labeled with `kind:subtask`.
	- Must be assigned to one phase milestone and one Project `Phase` field value.

## Milestone Model

- Use one milestone per implementation phase:
	- `v0.1-P1 Data Model and Format`
	- `v0.1-P2 Editor Core`
	- `v0.1-P3 Terrain Authoring`
	- `v0.1-P4 Multimodal and Validation`
	- `v0.1-P5 UX and Query API`
	- `v0.1-P6 Quality Demo Release`

## Phase to Scope Mapping

- `P1` maps to README checklist section `A`.
- `P2` maps to README checklist section `B`.
- `P3` maps to README checklist section `C`.
- `P4` maps to README checklist sections `D` and `E`.
- `P5` maps to README checklist sections `F` and `G`.
- `P6` maps to README checklist sections `H`, `I`, and `J`.

## Label Taxonomy

Type labels
- `kind:epic`
- `kind:task`
- `kind:subtask`
- `kind:bug`
- `kind:decision`

Change labels (cross-cutting dimension for issues and PRs)
- `change:feat`
- `change:fix`
- `change:chore`
- `change:docs`
- `change:refac`
- `change:test`

> Change labels are orthogonal to hierarchy labels. A Task can also be labeled as `change:chore`.

> Phase is not tracked via labels. It is a Project field on the board.

Area labels
- `area:data-model`
- `area:serialization`
- `area:editor`
- `area:terrain`
- `area:validation`
- `area:rendering`
- `area:api`
- `area:testing`
- `area:docs`

Priority labels
- `priority:Critical`
- `priority:Important`
- `priority:Low`

> Status is not tracked via labels. It is tracked as a Project field — see GitHub Project Usage below.

## GitHub Project Usage

- Use one GitHub Project for Version 0.1 execution.
- Labels are the canonical classification system for permanent issue taxonomy.
- Mutable workflow state is tracked as a Project field, not a label.

Required Project fields:

| Field    | Type          | Values |
|----------|---------------|--------|
| Status   | Single select | `New`, `Ready`, `In Progress`, `In Review`, `Blocked`, `Done` |
| Phase    | Single select | `Phase-1` through `Phase-6` |
| Kind     | Single select | `Epic`, `Task`, `Sub-task`, `Bug`, `Decision` |
| Area     | Single select | matches `area:*` labels |
| Priority | Single select | `Critical`, `Important`, `Low` |
| Size     | Single select | `XS`, `S`, `M`, `L` |

## Operating Rules

- Every issue must belong to exactly one phase milestone.
- Every task must have a parent epic.
- Every sub-task must have a parent task.
- No issue moves to `In Progress` without acceptance criteria written in the issue body.
- `Blocked` status requires blocker details in the issue body.
- `Done` status requires a merge reference or explicit no-code justification.

## CLI Issue Creation (Markdown-Safe)

- Prefer `gh issue create --body-file` and `gh issue edit --body-file` for multi-section markdown.
- Avoid long inline `--body` one-liners for headings and checklists; they are easy to break in shell quoting.

Recommended workflow:

```bash
cat > /tmp/issue.md <<'EOF'
## Objective
Short objective sentence.

## Parent Epic
- #10 Epic title

## Acceptance Criteria
- [ ] First criterion
- [ ] Second criterion

## Notes
Optional notes.
EOF

gh issue create \
	--title "[Task] Your task title" \
	--body-file /tmp/issue.md \
	--label "kind:task" \
	--label "area:data-model" \
	--label "priority:Important" \
	--milestone "v0.1-P1 Data Model and Format"
```

Update existing issue body safely:

```bash
gh issue edit 11 --body-file /tmp/issue.md
```

## Branch Naming Convention

- Use intent-based branch prefixes for all work branches.
- Recommended prefixes:
	- `feat/` for new functionality
	- `fix/` for bug fixes
	- `chore/` for maintenance, tooling, and process updates
	- `docs/` for documentation-only changes
	- `refac/` for structural code changes without behavior changes
	- `test/` for test-only work
- For each branch prefix above, use the matching `change:*` label on issues and PRs.
- Include issue reference or short scope after the prefix.
	- Example: `feat/11-schema-v0-identity-rules`

Release prefix policy:

- `release/` is reserved for release preparation and stabilization branches.
- `release/*` branches are protected branches.
- No direct pushes to `release/*`; changes must go through pull requests.
- Only maintainers should create or manage `release/*` branches.

## Decision Tracking

- Architecture and process decisions are tracked as issues labeled `kind:decision`.
- Decision issues must include:
	- Context
	- Options considered
	- Chosen option
	- Consequences

## Documentation Boundary

- This document must not contain dedicated backlogs of tasks or sub-tasks.
- Concrete epics, tasks, and sub-tasks are created and managed in GitHub Issues.
