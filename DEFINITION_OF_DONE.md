# Flow — Definition of Done

A task is considered Done only when all applicable criteria are satisfied.

## Product

- [ ] The implementation satisfies the issue requirements.
- [ ] All acceptance criteria are satisfied.
- [ ] Edge cases identified in the issue have been handled.
- [ ] User-facing behavior is understandable.

## Code

- [ ] Code follows project architecture.
- [ ] Existing architectural boundaries are preserved.
- [ ] No unnecessary abstractions were introduced.
- [ ] No force unwraps are introduced.
- [ ] No compiler warnings are introduced.
- [ ] No unnecessary dependencies are introduced.
- [ ] Swift Concurrency is used appropriately.
- [ ] Main-actor isolation is correct.
- [ ] Memory ownership is correct.

## Domain

- [ ] Business logic is not implemented in SwiftUI Views.
- [ ] Domain logic does not depend on SwiftData.
- [ ] AI does not directly modify persistence.
- [ ] Input is validated before persistence.

## Testing

- [ ] Unit tests exist for new business logic.
- [ ] Regression tests exist for bug fixes.
- [ ] Relevant integration tests exist.
- [ ] AI behavior has evaluation coverage when applicable.
- [ ] UI tests are added only for important user flows.

## SwiftUI

- [ ] Views remain reasonably small.
- [ ] State ownership is explicit.
- [ ] Observation is used appropriately.
- [ ] Accessibility labels/traits are provided where necessary.
- [ ] Dynamic Type is supported.
- [ ] Dark Mode is supported.

## AI

- [ ] AI output is structured where possible.
- [ ] AI output is validated.
- [ ] AI failure is handled.
- [ ] Model unavailability is handled.
- [ ] AI cannot perform unauthorized mutations.
- [ ] Important changes require user confirmation.

## Documentation

- [ ] Public architectural decisions are documented.
- [ ] ADR is updated if architecture changed.
- [ ] Relevant README/documentation is updated.

## Git

- [ ] Changes are committed on the appropriate branch.
- [ ] Commit messages are meaningful.
- [ ] PR description explains the change.
- [ ] CI passes.

## Review

- [ ] AI code review completed.
- [ ] Human review completed.
- [ ] All review comments resolved or explicitly accepted.

---

## Definition of Done Principle

"Compiles" is not equivalent to "Done".

A feature is Done only when its behavior, architecture, tests and documentation meet the project's standards.
