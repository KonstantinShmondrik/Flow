# Flow — Product Specification

## 1. Product

**Flow** is an AI-assisted personal planning application for iOS.

Flow helps users turn intentions, tasks, and constraints into a realistic daily plan.

The product is not primarily a task manager or a chatbot.

Its core purpose is:

> Help the user decide what to do, when to do it, and what to move when circumstances change.

---

## 2. Problem

Traditional todo applications make users responsible for planning.

Users must manually:

- create tasks;
- estimate duration;
- decide priorities;
- find available time;
- arrange tasks on a timeline;
- reschedule unfinished work;
- reconcile tasks with existing commitments.

This becomes increasingly difficult as the number of tasks and constraints grows.

Flow should reduce this planning overhead.

---

## 3. Product Principle

The user remains in control.

AI proposes actions and plans.

The application validates and applies changes.

The AI must never silently make important changes to the user's plan.

The user should always be able to understand and approve significant AI-generated changes.

---

## 4. Core User Flow

The primary workflow is:

1. User captures an intention or task.
2. Flow interprets the input.
3. Flow converts it into structured domain data.
4. User reviews or accepts the result.
5. Flow considers tasks, constraints and available time.
6. Flow proposes a realistic schedule.
7. User accepts or modifies the plan.
8. When circumstances change, Flow can propose a revised plan.

Example:

> "Tomorrow morning call the dentist for about 30 minutes."

Flow should understand:

- task title;
- target date;
- approximate time period;
- estimated duration.

It should then create a structured task rather than merely display an AI-generated text response.

---

## 5. Target Platform

Initial platform:

- iPhone
- iOS 26+

The project intentionally targets modern Apple APIs.

Backward compatibility with older iOS versions is not an initial goal.

---

## 6. MVP

The MVP must support:

### Tasks

- create task;
- edit task;
- delete task;
- complete task;
- set priority;
- set duration;
- set due date;
- add notes.

### Inbox

Users can quickly capture unstructured tasks.

Example:

> "Buy groceries and call dentist tomorrow."

### Today

The user can see:

- scheduled tasks;
- unscheduled tasks;
- completed tasks;
- available time.

### Planning

The user can:

- schedule a task;
- move a task;
- change duration;
- reschedule a task.

### AI

The MVP AI capabilities are:

1. Natural-language task creation.
2. Task breakdown.
3. Daily planning.
4. Rescheduling suggestions.

AI output must be structured and validated before being processed by application operations.

---

## 7. Post-MVP

Potential capabilities:

- Foundation Models tool calling;
- AI weekly review;
- calendar integration;
- CloudKit synchronization;
- widgets;
- interactive widgets;
- Live Activities;
- App Intents;
- Siri;
- Shortcuts;
- Spotlight;
- location-based reminders;
- Apple Watch;
- iPad;
- Mac;
- advanced analytics.

Post-MVP features must not influence the architecture of the MVP unless there is a clear architectural reason.

---

## 8. Main Screens

The initial application contains:

### Today

The user's current daily plan.

### Inbox

Quickly captured tasks that have not yet been fully organized.

### Plan

Timeline/calendar-oriented planning interface.

### Projects

Groups of related tasks.

### AI

AI-assisted planning and task management.

### Settings

User preferences and application configuration.

---

## 9. Core Domain

Primary entities:

- Task
- Project
- TimeBlock
- DailyPlan
- UserPreferences

The domain layer must remain independent from SwiftData and SwiftUI.

---

## 10. AI Architecture

AI is an assistant, not the application architecture.

The intended flow is:

User input
→ AI interpretation
→ structured result
→ Application operation
→ Domain validation
→ persistence

AI must never directly modify persistence.

AI tools must invoke application operations.

---

## 11. Technology Direction

The project intentionally uses modern Apple technologies.

Primary technologies:

- Swift 6
- SwiftUI
- Observation
- Swift Concurrency
- SwiftData
- Foundation Models
- App Intents
- WidgetKit
- ActivityKit
- UserNotifications
- CloudKit
- Swift Testing
- AppIntentsTesting
- Xcode Cloud

Technologies are introduced incrementally.

A technology must have a concrete product or learning purpose.

---

## 12. Engineering Goal

The project is also an experiment in AI-agent-driven software development.

AI agents may participate in:

- product analysis;
- architecture;
- implementation;
- testing;
- code review;
- documentation;
- release preparation.

Humans remain responsible for product decisions and final acceptance.

---

## 13. Success Criteria

The product is successful when:

1. A user can capture tasks quickly.
2. The user can understand what needs to be done today.
3. The user can create a realistic plan.
4. The user can adapt the plan when circumstances change.
5. AI reduces planning effort without taking control away from the user.
6. The application remains understandable and maintainable as features grow.

The engineering experiment is successful when:

1. AI agents can implement well-defined issues reliably.
2. Agents can work within documented architectural constraints.
3. Automated tests catch regressions.
4. Code review agents can identify meaningful problems.
5. Human intervention remains focused on decisions rather than routine implementation.
