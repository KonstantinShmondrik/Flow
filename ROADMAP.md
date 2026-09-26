
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

Goal:

Build the core planner without AI.

Technology focus:

- SwiftData
- domain modeling
- repositories
- use cases
- Swift Testing

Deliverables:

- Task;
- Project;
- TimeBlock;
- DailyPlan;
- CRUD operations;
- domain validation;
- tests.

---

## Phase 3 — Planning Engine

Goal:

Build deterministic planning logic before introducing AI.

The planning engine should be able to:

- find available time;
- schedule tasks;
- detect conflicts;
- move tasks;
- calculate remaining capacity;
- reschedule tasks.

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
