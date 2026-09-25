# ADR-001: Application Architecture

## Status

Accepted

## Date

2026-09-25

## Context

Flow is a learning project designed to explore modern iOS development,
software engineering practices, and AI-agent-driven development.

The architecture must:

- provide clear boundaries between UI, product operations, domain logic,
  and external technologies;
- support modern Swift and SwiftUI development;
- keep business logic independent from UI and persistence frameworks;
- allow AI capabilities to interact with the application safely;
- make the codebase understandable and predictable for AI agents;
- provide sufficient structure for testing without introducing unnecessary
  complexity;
- allow the architecture to evolve as the product grows.

The author already has practical experience with UIKit, MVVM, VIPER,
Coordinator and Combine. Therefore, Flow should intentionally explore
a different architectural approach rather than reproduce these patterns.

## Decision

Flow will use a **feature-oriented architecture with explicit
Application, Domain, and Infrastructure boundaries**.

The initial logical structure will be:

    Flow
    ├── App
    ├── Features
    ├── Application
    ├── Domain
    ├── Infrastructure
    └── Shared

### Features

Features represent user-facing product capabilities.

Examples:

- Today
- Inbox
- Planning
- Projects
- Settings

Features contain SwiftUI views and feature-specific state.

Modern Swift Observation will be used for feature state where appropriate.

The project will not use a mandatory classical MVVM structure.

Feature models may use `@Observable` to manage UI state and coordinate
application operations, but business rules must not be implemented
inside feature models or SwiftUI views.

### Application

The Application layer represents operations performed by the product.

Examples:

- CreateTask
- CompleteTask
- MoveTask
- PlanDay
- RescheduleTask

Application operations coordinate domain logic and required dependencies.

Application operations are the primary entry point for product actions
from both the user interface and AI capabilities.

The Application layer must not depend on SwiftUI.

### Domain

The Domain layer contains the core concepts and business rules of Flow.

Examples:

- Task
- Project
- DailyPlan
- Schedule
- PlanningRules

Domain models should use standard Swift types and must remain independent
of UI, persistence, and AI frameworks.

The Domain layer must not depend on:

- SwiftUI;
- SwiftData;
- Foundation Models;
- WidgetKit;
- ActivityKit;
- CloudKit.

Repository or service contracts may be defined at the Domain/Application
boundary when they represent a genuine application requirement.

### Infrastructure

Infrastructure contains implementations of external technologies and
framework-specific concerns.

Examples:

- SwiftData persistence;
- Foundation Models integration;
- CloudKit;
- system notifications;
- other Apple platform services.

Infrastructure implements the contracts required by the Application
or Domain layers.

The rest of the application must not depend on Infrastructure
implementation details.

## Feature State

The project will use modern Swift Observation rather than adopting
classical MVVM as a mandatory architectural pattern.

A feature may contain an `@Observable` model responsible for:

- UI state;
- handling user intents;
- invoking Application operations;
- presenting loading and error states.

Feature models must not contain core business rules.

Business rules belong in the Domain layer or appropriate Application
operations.

## AI Architecture

AI capabilities are treated as infrastructure capabilities.

AI must not access persistence directly.

AI interactions with the application must pass through explicit
application-level tools or operations.

The intended flow is:

    AI
     ↓
    AI Tool
     ↓
    Application Operation
     ↓
    Domain
     ↓
    Infrastructure

The same Application operations should be usable by both UI-driven
actions and AI-driven actions where appropriate.

This ensures that AI cannot bypass domain validation or application
rules.

## Persistence

SwiftData will be used as the initial persistence technology.

SwiftData models are infrastructure models and must not become the
Domain model by default.

Where separation is required, Domain models and persistence models will
be mapped at the Infrastructure boundary.

Repositories will be introduced where they provide a meaningful
abstraction between application/domain requirements and persistence.

Repositories will not be created mechanically for every entity or
operation.

## Dependency Injection

Dependencies will be explicitly provided rather than accessed through
unnecessary global state or singletons.

The application composition root will be responsible for constructing
and connecting implementations.

Features should receive the Application operations they require rather
than constructing Infrastructure dependencies themselves.

## Modularity

The initial implementation will use a single Xcode application target
with clear logical boundaries.

Swift Packages will not be introduced solely to mirror the logical
folder structure.

Physical modularization will be introduced when a module provides a
concrete benefit such as:

- enforcing architectural boundaries;
- improving testability;
- reducing build impact;
- establishing a meaningful ownership boundary;
- isolating a reusable component.

The architecture should therefore remain capable of evolving toward
multiple Swift Packages without requiring a fundamental redesign.

## Dependency Direction

The intended dependency direction is:

    Features
        ↓
    Application
        ↓
    Domain

Infrastructure implements the contracts required by Application or
Domain.

The Domain must remain independent of Infrastructure.

Conceptually:

    ┌──────────────────────────┐
    │        Features         │
    │   SwiftUI + Observation │
    └────────────┬─────────────┘
                 │
                 ▼
    ┌──────────────────────────┐
    │       Application        │
    │      Product Operations  │
    └────────────┬─────────────┘
                 │
                 ▼
    ┌──────────────────────────┐
    │          Domain          │
    │ Models + Business Rules  │
    └────────────┬─────────────┘
                 │
                 ▲
                 │
    ┌──────────────────────────┐
    │      Infrastructure      │
    │ SwiftData / AI / System  │
    └──────────────────────────┘

## Alternatives Considered

### Classical MVVM

Not selected as the primary architectural pattern.

The author already has practical MVVM experience, while Flow is intended
to provide exposure to a different approach.

Modern Swift Observation provides suitable mechanisms for managing
feature state without requiring a ViewModel abstraction for every view.

### VIPER

Not selected.

The author already has practical VIPER experience, and reproducing it
would provide limited additional learning value for this project.

### The Composable Architecture

Not selected for the initial implementation.

TCA is a valid architectural approach, but adopting it would introduce
a third-party architectural framework into a project whose primary goal
is to explore modern Apple technologies and AI-agent-driven development.

### Immediate multi-package architecture

Not selected.

The project will begin with a single application target and logical
boundaries. Physical modules will be introduced when they provide a
concrete benefit.

## Consequences

### Positive

- Clear separation between product operations, business rules and
  infrastructure.
- Business logic can be tested independently from SwiftUI and SwiftData.
- AI and UI can use the same application operations.
- AI cannot directly bypass domain validation.
- Modern SwiftUI and Observation can be used without forcing classical
  MVVM.
- The architecture provides learning value beyond the author's existing
  UIKit/MVVM/VIPER experience.
- The codebase has explicit boundaries that are easier for AI agents
  to understand and follow.
- The architecture can evolve toward physical modularization later.

### Negative

- The architecture introduces more structure than a simple SwiftUI app.
- Domain and persistence models may require mapping.
- Application operations introduce additional types and files.
- Some abstractions may prove unnecessary as the product evolves.
- Maintaining architectural boundaries requires discipline and testing.

## Rules for Future Changes

Significant changes to this architecture require a new ADR or an update
to this decision.

Agents must not silently introduce:

- a new architectural pattern;
- direct persistence access from Features;
- business logic inside SwiftUI views;
- direct AI access to persistence;
- unnecessary global state;
- new physical modules;

without following the architectural decision process defined in
`AI_RULES.md`.

## Related Documents

- `PRODUCT.md`
- `VISION.md`
- `AI_RULES.md`
- `DEFINITION_OF_DONE.md`
