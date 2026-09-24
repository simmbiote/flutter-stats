# Flutter Stats Constitution

## Core Principles

### I. Specification Before Implementation
Every user-facing change starts with a feature specification in the active feature directory. The specification must describe user value, prioritized user stories, acceptance scenarios, and explicit out-of-scope behavior before planning or implementation begins.

### II. Small, Testable Increments
Work is planned and implemented as independently verifiable user stories. Each story has a clear completion test, and tasks identify the files and contracts they change. Prefer the smallest design that satisfies the approved specification.

### III. Flutter and Dart Quality
Use the repository's configured Flutter and Dart tooling. Keep null safety enabled, follow `dart format`, address analyzer errors, and preserve the existing widget and state-management conventions. New dependencies require a documented reason in the implementation plan.

### IV. Tests Protect Behavior
Acceptance scenarios drive tests at the narrowest useful level: pure Dart tests for domain logic, widget tests for UI behavior, and integration tests for critical end-to-end flows. A change is not complete while its specified behavior is untested or its existing tests fail.

### V. Accessible, Responsive UX
Every UI story must account for semantics, keyboard or platform navigation where applicable, readable contrast, loading, empty, error, and success states, and small-screen layouts. Accessibility and responsive behavior are part of acceptance, not polish deferred beyond the feature.

## Technical Constraints

- Feature artifacts live under the active feature directory selected by Spec Kit.
- The source of truth for behavior is `spec.md`; `plan.md` records implementation decisions and `tasks.md` records executable work.
- Secrets, generated build output, and machine-local state must not be committed.

## Development Workflow

1. Create or select a feature context.
2. Write and clarify `spec.md`.
3. Produce `plan.md`, including architecture, dependencies, testing, and risks.
4. Generate dependency-ordered `tasks.md`.
5. Implement in story order, validating each story independently.
6. Run formatting, analysis, and relevant tests before review.

## Governance

This constitution governs feature specifications, plans, tasks, implementation, and review. Any exception must be recorded in the feature's plan with its rationale and impact. Amendments require updating this document and its version metadata; existing feature artifacts remain governed by the version under which they were approved unless explicitly migrated.

**Version**: 1.0.0 | **Ratified**: 2026-09-24 | **Last Amended**: 2026-09-24
