# Zada feature architecture

Treat `lib/features/test_feature/` as the live source of truth. The expected base
topology is:

```text
lib/features/<feature_name>/
|-- <feature_name>.dart
|-- data/
|   |-- data_sources/<feature_name>_remote_datasource.dart
|   |-- models/<feature_name>_model.dart
|   `-- repositories/<feature_name>_repository_imp.dart
|-- domain/
|   |-- repositories/<feature_name>_repository.dart
|   `-- use_cases/<feature_name>_usecase.dart
`-- presentation/
    |-- blocs/
    |   |-- <feature_name>_bloc.dart
    |   |-- <feature_name>_event.dart
    |   `-- <feature_name>_state.dart
    `-- pages/<feature_name>_page.dart
```

## Layer contracts

- Data source: declare an abstract remote contract and an `Impl` class using the
  repository's `ApiHelperMixin`, `RepositoryHelperMixin`, `Failure`, and
  `Either` conventions.
- Model: represent the actual remote payload and provide the required mapping
  factories, matching adjacent feature conventions.
- Repository: place the abstract contract in `domain/repositories` and its `Imp`
  implementation in `data/repositories`; delegate remote work through the data
  source.
- Use case: extend the repository's `UseCase<Result, Params>` abstraction. Use
  `NoParams` when appropriate; otherwise define meaningful immutable params.
- Bloc: extend `Bloc<FeatureEvent, BaseBlocState>`, emit shared loading/error
  states, and expose a feature-specific success state.
- Page: extend `BaseStatefulWidget` and `BaseStatefullState`, and consume the Bloc
  through the project's `BaseBloc` pattern when the page is state-driven.
- Barrel: export every public production file from `<feature_name>.dart`, then
  export that barrel from `lib/imports.dart`.

## Naming and integration

- Convert `order_history` to `OrderHistory` for type prefixes.
- Prefer meaningful operation names such as `fetchOrders`, `LoadOrders`, and
  `OrdersLoaded` over template placeholder names.
- Match the repository's existing suffixes exactly: `RemoteDataSource`,
  `Repository`, `RepositoryImp`, `UseCase`, `Bloc`, `Event`, `State`, and `Page`.
- Register dependencies in `lib/core/services/service_locator.dart` in dependency
  order: data source, repository, use case(s), then Bloc.
- Add a provider in `lib/bloc_providers_init.dart` only if the Bloc must be
  available from the application's global provider list.
- Add route constants and `GoRoute` entries in `lib/core/routes/routes.dart` only
  when navigation to the new page is part of the requested feature.

## Explicit exclusion

This architecture reference covers production code only. Do not create, edit, or
run tests while using this skill.
