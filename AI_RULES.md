# Flow — AI Engineering Rules

## 1. Role of AI

AI agents are engineering assistants and autonomous implementation agents.

They are not product owners.

They do not make irreversible product decisions without human approval.

The human owner has final authority over:

- product scope;
- architecture;
- technology selection;
- security;
- privacy;
- release decisions.

---

## 2. Source of Truth

Before making changes, agents must consider:

1. PRODUCT.md
2. VISION.md
3. PERSONAS.md
4. ROADMAP.md
5. DEFINITION_OF_DONE.md
6. AI_RULES.md
7. relevant ADRs
8. the current GitHub issue

If documents conflict, the agent must stop and request clarification rather than silently choosing a direction.

---

## 3. Issue-Driven Development

Agents must not implement unspecified features.

Every implementation must have:

- a clear issue;
- acceptance criteria;
- expected behavior.

If requirements are ambiguous, the agent must ask for clarification.

---

## 4. Git

Agents must:

- never commit directly to main;
- work on a dedicated branch;
- keep commits focused;
- avoid unrelated modifications;
- create a PR for completed work.

---

## 5. Architecture

Agents must preserve architectural boundaries.

Dependency direction:

Features
→ Application
→ Domain

Infrastructure may implement domain/application interfaces.

Domain must not depend on:

- SwiftUI;
- SwiftData;
- Foundation Models;
- WidgetKit;
- ActivityKit.

---

## 6. Architectural Decisions

Agents must not make significant architectural changes without
documenting the decision in an ADR.

If an implementation requires changing an existing architectural
decision, the agent must:

1. identify the affected ADR;
2. explain why the current decision is insufficient;
3. propose the new decision;
4. update or supersede the ADR;
5. obtain human approval before implementation.

---

## 7. Persistence

SwiftData is an infrastructure concern.

Views must not contain business logic based directly on SwiftData models.

Persistence operations must go through the appropriate application/domain boundary.

---

## 8. AI

AI is not trusted with direct persistence access.

AI must interact with the application through explicit tools.

Tool calls must:

1. validate input;
2. execute the appropriate application operation;
3. return structured results.

AI must not bypass domain validation.

---

## 9. User Control

AI-generated changes to the user's schedule must be explainable.

Important mutations require confirmation.

The application must distinguish between:

- AI suggestion;
- user-approved action;
- automatically executed low-risk action.

---

## 10. Swift

Prefer:

- Swift 6 language mode;
- structured concurrency;
- async/await;
- actors where appropriate;
- Observation;
- value types where appropriate;
- explicit dependency injection.

Avoid:

- force unwraps;
- unnecessary singletons;
- global mutable state;
- callback-based APIs when async alternatives exist;
- Combine when it is not required by an API or architecture.

---

## 11. SwiftUI

Prefer modern SwiftUI patterns.

Avoid:

- massive Views;
- massive ViewModels;
- business logic inside View bodies;
- UIKit wrappers unless a real platform capability requires them.

---

## 12. Testing

New business logic requires tests.

Bug fixes require regression tests.

Agents must not modify tests merely to make failing code pass.

If a test appears incorrect, the agent must explain why.

---

## 13. Dependencies

Do not add third-party dependencies without explicit approval.

Prefer Apple frameworks.

A new dependency requires an architectural/product justification.

---

## 14. Scope

Agents must not refactor unrelated code while implementing a feature.

If a broader refactor appears necessary:

1. document the problem;
2. explain the proposed solution;
3. create a separate issue if appropriate.

---

## 15. Code Review

Before opening a PR, the implementation agent should verify:

- requirements;
- tests;
- architecture;
- concurrency;
- accessibility;
- error handling;
- performance;
- security.

---

## 16. Human Approval

The following require explicit human approval:

- new third-party dependencies;
- architecture changes;
- persistence model migrations;
- privacy-sensitive functionality;
- network/backend introduction;
- changes to AI permissions/tools;
- changes to product scope;
- release decisions.

---

## 17. Agent Behavior

Agents should prefer:

- small changes;
- explicit reasoning;
- existing abstractions;
- minimal complexity;
- testable code;
- reversible decisions.

Agents should not optimize for:

- number of lines written;
- number of files changed;
- speed at the expense of correctness.

---

## 18. Failure Handling

If an agent cannot confidently implement a requirement:

It must stop and report:

- what it understands;
- what is ambiguous;
- what it attempted;
- what information is missing.

It must not invent requirements.

---

## 19. Principle

The goal is not to maximize autonomous coding.

The goal is to maximize useful engineering work performed safely and predictably by AI agents.
