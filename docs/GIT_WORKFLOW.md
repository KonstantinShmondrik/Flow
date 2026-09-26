# Flow — Git Workflow

## 1. Main Branch

`main` is the primary branch.

It should always contain code that builds successfully and passes the
relevant automated tests.

Direct pushes to `main` are not allowed.

---

## 2. Issue-Driven Development

Every meaningful change starts with a GitHub Issue.

An Issue should define:

- goal;
- context;
- acceptance criteria.

Agents must not implement unspecified work.

---

## 3. Branches

All work is performed in a dedicated branch created from `main`.

Branch naming convention:

    feature/<issue>-<short-description>
    fix/<issue>-<short-description>
    refactor/<issue>-<short-description>
    test/<issue>-<short-description>
    docs/<issue>-<short-description>
    chore/<issue>-<short-description>

Examples:

    feature/24-create-task
    fix/42-task-validation
    refactor/51-planning-domain

---

## 4. Implementation

Before implementation, an AI agent should:

1. read the relevant project documentation;
2. read the GitHub Issue;
3. inspect the existing implementation;
4. identify relevant ADRs;
5. propose an implementation plan.

The agent should not begin significant implementation when the
requirements are ambiguous.

---

## 5. Commits

Commits should be:

- focused;
- understandable;
- related to the current Issue.

Commit messages use Conventional Commit style.

Examples:

    feat: add task creation
    fix: prevent empty task titles
    test: add task validation tests
    refactor: simplify task mapping
    docs: update architecture documentation

---

## 6. Pull Requests

Completed work is submitted through a Pull Request.

A Pull Request should contain:

- summary;
- important implementation details;
- testing performed;
- related Issue.

The PR should normally correspond to one Issue or one clearly defined
piece of work.

---

## 7. Review

Before merge, verify:

- acceptance criteria;
- tests;
- architecture;
- concurrency;
- accessibility;
- error handling;
- security;
- performance where relevant;
- absence of unrelated changes.

AI-generated code is reviewed with the same standards as human-written
code.

---

## 8. Merge

Feature branches are merged into `main` using Squash and Merge.

The resulting commit should represent the completed Issue.

---

## 9. Scope Control

Agents must not introduce unrelated refactoring while implementing
an Issue.

If broader changes are required, they should be proposed separately.

---

## 10. Failed Implementations

If an implementation takes an incorrect architectural direction,
the branch may be discarded and recreated from `main`.

Agents should prefer reversible changes over increasingly complex fixes
to an incorrect approach.

---

## 11. Releases

Release management will be defined later when the product reaches a
stage where release automation and versioning become relevant.
