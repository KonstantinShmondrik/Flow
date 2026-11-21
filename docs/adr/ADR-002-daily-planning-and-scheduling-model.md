# ADR-002: Daily Planning and Scheduling Model

## Status

Accepted

## Date

2026-11-21

## Context

Flow needs a clear boundary between persisted planning data, a view of a
day's plan, and proposed schedule changes. Tasks can represent both work
the user can schedule and commitments that should not be moved
automatically. Planning must remain deterministic and preserve the user's
control over changes.

## Decision

The Domain owns Tasks, Projects, TimeBlocks, and each Task's scheduling
policy. The Application assembles a derived `DailyPlan` read model and
coordinates planning operations. The Planning Engine produces temporary
`PlanProposal` values; proposals are validated and require explicit user
acceptance before Application operations apply their changes.

### Task scheduling policy

`Task` owns a `SchedulingPolicy` with two initial cases:

- `flexible` — the Planning Engine may automatically move the Task's
  scheduled TimeBlocks;
- `fixed` — the Planning Engine must not automatically move the Task's
  scheduled TimeBlocks.

The default policy is `flexible`. A user may still manually edit or move
a fixed Task. A due date is a deadline and does not make a Task fixed.
The policy determines whether the Planning Engine may automatically move
the Task; it does not create a TimeBlock or assign a time. A `TimeBlock`
defines the actual scheduled time interval, so a fixed Task has a specific
scheduled time only when it has an associated TimeBlock. All TimeBlocks
associated with a Task follow its policy; TimeBlock has no independent
policy or override.

### Fixed commitments

Appointments, meetings, scheduled calls, and similar commitments are
represented as `Task` instances with the `fixed` scheduling policy.
The MVP does not introduce a separate `CalendarEvent` entity.
`TimeBlock` remains associated with its Task through `TaskID`; a fixed
policy alone does not assign the commitment a scheduled time.

### DailyPlan

`DailyPlan` is an Application-level derived read model, not an independent
Domain entity or separately persisted source of truth. The Application
assembles it from relevant Tasks, TimeBlocks, available time, and relevant
user preferences.

### PlanProposal

`PlanProposal` is a temporary Planning Engine result describing a possible
arrangement of Tasks and TimeBlocks. It does not directly modify persisted
data. It must be validated, and its changes are applied only after the
user explicitly accepts the proposal.

### Planning Engine responsibilities

The Planning Engine is deterministic and independent of AI. It performs
planning calculations and produces proposals, including schedule changes.
It does not directly access persistence. Application operations
coordinate planning, validate proposals, and apply accepted changes.

### AI integration

AI may request planning operations through the Application. It cannot
directly modify persistence or bypass proposal validation and explicit
user acceptance.

## Alternatives Considered

### Persist DailyPlan as a separate Domain entity

Not selected. It would duplicate Tasks and TimeBlocks as a second source
of truth. The Application can assemble the day view from relevant data.

### Represent commitments as CalendarEvent

Not selected for the MVP. Fixed commitments are Tasks with a fixed
scheduling policy, using the existing Task and TimeBlock relationship.

### Put scheduling policy on TimeBlock

Not selected. In the MVP, all TimeBlocks for a Task follow the policy
owned by that Task, so a per-TimeBlock policy or override is unnecessary.

### Let AI apply planning changes directly

Not selected. Planning remains deterministic and independent of AI, and
schedule changes require validation and explicit user acceptance.

## Consequences

### Positive

- Tasks and TimeBlocks remain the source data from which the daily view
  is assembled.
- Fixed commitments use the same Task model as actionable work.
- Planning calculations can be tested independently of AI and persistence.
- Proposed changes are validated and remain under user control.

### Negative

- The Application must assemble the DailyPlan read model and coordinate
  proposal validation and application.
- Schedule changes require an explicit proposal and acceptance flow.

## Future Considerations

The MVP does not include `PlanSnapshot`, `DailyReview`, planning history,
analytics based on historical plans, `CalendarEvent`, or per-TimeBlock
scheduling policy overrides. These may be considered later if concrete
product requirements justify them.

## Related Documents

- `PRODUCT.md`
- `ROADMAP.md`
- `docs/adr/ADR-001-architecture.md`
- `AI_RULES.md`
