# Flutter Stats

This project uses a specification-first workflow powered by Spec Kit and OpenCode.

## Development Workflow

Run the commands in this order for each feature:

1. `/speckit.specify <feature idea>` creates the feature specification.
2. `/speckit.clarify` resolves ambiguity in the specification.
3. `/speckit.plan` records the technical approach and testing strategy.
4. `/speckit.tasks` generates dependency-ordered implementation tasks.
5. `/speckit.implement` executes the approved tasks.
6. `/speckit.analyze` checks consistency across the feature artifacts.

The project constitution is in `.specify/memory/constitution.md`. Feature artifacts are stored in the active feature directory, normally under `specs/`.

## Local Feature Context

When no Git branch is available, set the feature directory explicitly before running scripts:

```sh
export SPECIFY_FEATURE_DIRECTORY="$PWD/specs/001-feature-name"
```

Spec Kit persists that selection in `.specify/feature.json` when a workflow command creates or selects a feature. That file is machine-local and should not be committed.

## Quality Gates

Before review, the implementation should pass `dart format`, `flutter analyze`, and the relevant `flutter test` targets. The feature's acceptance scenarios and task checklist are the completion record.# flutter-stats
