
# Flow — Roadmap

## Phase 0 — Product & Engineering Foundation

Goal:

Define the product and establish the AI-agent development process.

Deliverables:

- Product specification
- Product vision
- Personas
- Engineering rules
- Definition of Done
- AI agent rules
- Repository structure
- Initial architecture
- Git workflow

Status: Completed

---

## Phase 1 — Application Foundation

Status: Completed

Goal:

Create the initial iOS application architecture.

Technology focus:

- Swift 6
- SwiftUI
- Observation
- Swift Concurrency
- dependency injection
- design system

Deliverables:

- application shell;
- navigation;
- feature structure;
- dependency container;
- basic design system;
- test infrastructure.

---

## Phase 2 — Local Domain

Status: In Progress

Goal:

Build the core planner without AI.

Technology focus:

- SwiftData
- domain modeling
- repositories
- application operations
- Swift Testing

Deliverables:

- Task;
- Project;
- TimeBlock;
- Task scheduling policy;
- CRUD operations;
- domain validation;
- tests.

---

## Phase 3 — Planning Engine

Goal:

Build deterministic planning logic before introducing AI.

The Planning Engine is deterministic and independent of AI. It should be
able to:

- find available time;
- treat fixed commitments as Tasks whose scheduled TimeBlocks are not
  moved automatically;
- schedule flexible Tasks;
- detect conflicts;
- calculate available time and remaining capacity;
- propose schedule changes, including moving and rescheduling Tasks.

Planning changes are returned as temporary proposals, validated before
application, and applied only after explicit user acceptance. The Planning
Engine does not directly access persistence.

AI must not be required for core planning.

---

## Phase 4 — Foundation Models

Goal:

Introduce on-device AI.

Technology focus:

- Foundation Models
- structured generation
- @Generable
- prompt design
- model availability handling
- AI evaluation

Initial capabilities:

- natural-language task creation;
- task extraction;
- task breakdown.

---

## Phase 5 — AI Planning Agent

Goal:

Allow AI to interact with the domain through controlled tools.

Tools:

- getTasks
- getSchedule
- findFreeTime
- createTask
- updateTask
- moveTask
- completeTask
- proposeSchedule

AI must never directly access persistence.

---

## Phase 6 — System Integration

Goal:

Integrate Flow into the Apple ecosystem.

Technology:

- App Intents
- Shortcuts
- Siri
- Spotlight

---

## Phase 7 — Widgets & Live Activities

Technology:

- WidgetKit
- App Intents
- ActivityKit

Deliverables:

- Today widget;
- upcoming task widget;
- interactive completion;
- Focus Session Live Activity.

---

## Phase 8 — Cloud Sync

Technology:

- CloudKit
- SwiftData sync

Goals:

- multi-device synchronization;
- offline support;
- conflict handling.

---

## Phase 9 — AI Evaluation & Product Analytics

Goals:

- create AI evaluation datasets;
- measure structured output accuracy;
- measure planning quality;
- measure feature usage;
- identify failure cases.

---

## Phase 10 — Beta

Goals:

- TestFlight;
- crash monitoring;
- accessibility;
- performance;
- privacy review;
- onboarding;
- feedback collection.

---

## Phase 11 — Release

Goals:

- App Store metadata;
- screenshots;
- release notes;
- final testing;
- App Store submission.

---

## Future

Potential features:

- Calendar integration;
- location-based planning;
- Apple Watch;
- iPad;
- macOS;
- advanced AI planning;
- long-term personal insights.
