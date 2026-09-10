---
name: create-feature
description: Create or scaffold a Flutter feature in this Zada repository using the same clean-architecture layers, directory layout, naming conventions, barrel exports, base classes, and coding patterns as lib/features/test_feature. Use when asked to add, generate, scaffold, or implement a new feature or feature module. Never create tests; test generation belongs to a separate skill.
---

# Create Feature

Create a production feature under `lib/features/` using
`lib/features/test_feature/` as the authoritative structural and architectural
reference. Adapt behavior to the user's requirements instead of blindly copying
the placeholder implementation.

## Workflow

1. Read every handwritten Dart file under `lib/features/test_feature/` before
   editing. Also inspect one nearby real feature when requirements resemble it.
2. Read [references/architecture.md](references/architecture.md).
3. Determine the feature name and requested behavior from the prompt and codebase.
   Use `snake_case` for directories and files and `UpperCamelCase` for types.
4. Create the feature at `lib/features/<feature_name>/` with the same layer and
   file topology as `test_feature` unless the requested behavior clearly requires
   additional production files such as params, widgets, or multiple use cases.
5. Implement real request/response models, data-source methods, repository
   contracts and implementations, use cases, Bloc events and states, and pages
   from the user's requirements. Do not retain placeholder names such as
   `getMyFeature`, `number`, `exampleURL`, or `Submit Complaint` unless explicitly
   requested.
6. Create or update the feature barrel file and export it from `lib/imports.dart`,
   following the repository's existing generated-style ordering and formatting.
7. Add service-locator registrations, global Bloc providers, or routes only when
   the feature needs those integrations to satisfy the request. Follow the exact
   patterns already used in the corresponding integration file.
8. Format all changed Dart files. Run `dart analyze` on the changed production
   files, then fix errors introduced by the work.
9. Report created files, integrations changed, and validation results.

## Hard constraints

- Never create files under `test/`, `integration_test/`, or any test directory.
- Never create files whose names end in `_test.dart`.
- Never add test dependencies, fixtures, mocks, test commands, or test-only code.
- Do not run tests as part of this skill. Use formatting and static analysis for
  validation.
- Preserve unrelated user changes and avoid rewriting generated Dart files.
- Re-read the current `test_feature` before each use; it is the source of truth if
  this skill's architecture reference becomes stale.

## Scope decisions

- If only a feature name is supplied, scaffold the complete `test_feature`
  production topology with clearly marked, compiling placeholders tailored to
  that name.
- If API contracts or UI behavior are supplied, implement them throughout all
  layers instead of producing generic placeholders.
- If essential product behavior cannot be inferred safely, ask one concise
  question; otherwise proceed using repository conventions.
- Do not add optional layers or abstractions that are absent from both
  `test_feature` and the requested behavior.
