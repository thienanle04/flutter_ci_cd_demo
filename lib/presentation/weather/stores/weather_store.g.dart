// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WeatherStore on _WeatherStore, Store {
  late final _$stateAtom = Atom(name: '_WeatherStore.state', context: context);

  @override
  WeatherState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(WeatherState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$citySuggestionsAtom = Atom(
    name: '_WeatherStore.citySuggestions',
    context: context,
  );

  @override
  ObservableList<CitySuggestion> get citySuggestions {
    _$citySuggestionsAtom.reportRead();
    return super.citySuggestions;
  }

  @override
  set citySuggestions(ObservableList<CitySuggestion> value) {
    _$citySuggestionsAtom.reportWrite(value, super.citySuggestions, () {
      super.citySuggestions = value;
    });
  }

  late final _$citySuggestionsLoadingAtom = Atom(
    name: '_WeatherStore.citySuggestionsLoading',
    context: context,
  );

  @override
  bool get citySuggestionsLoading {
    _$citySuggestionsLoadingAtom.reportRead();
    return super.citySuggestionsLoading;
  }

  @override
  set citySuggestionsLoading(bool value) {
    _$citySuggestionsLoadingAtom.reportWrite(
      value,
      super.citySuggestionsLoading,
      () {
        super.citySuggestionsLoading = value;
      },
    );
  }

  late final _$searchCitySuggestionsAsyncAction = AsyncAction(
    '_WeatherStore.searchCitySuggestions',
    context: context,
  );

  @override
  Future<void> searchCitySuggestions(String query) {
    return _$searchCitySuggestionsAsyncAction.run(
      () => super.searchCitySuggestions(query),
    );
  }

  late final _$fetchByCityAsyncAction = AsyncAction(
    '_WeatherStore.fetchByCity',
    context: context,
  );

  @override
  Future<void> fetchByCity(String cityName) {
    return _$fetchByCityAsyncAction.run(() => super.fetchByCity(cityName));
  }

  late final _$fetchByCoordinatesAsyncAction = AsyncAction(
    '_WeatherStore.fetchByCoordinates',
    context: context,
  );

  @override
  Future<void> fetchByCoordinates(
    double latitude,
    double longitude, {
    String? displayCityName,
  }) {
    return _$fetchByCoordinatesAsyncAction.run(
      () => super.fetchByCoordinates(
        latitude,
        longitude,
        displayCityName: displayCityName,
      ),
    );
  }

  late final _$_WeatherStoreActionController = ActionController(
    name: '_WeatherStore',
    context: context,
  );

  @override
  void clearCitySuggestions() {
    final _$actionInfo = _$_WeatherStoreActionController.startAction(
      name: '_WeatherStore.clearCitySuggestions',
    );
    try {
      return super.clearCitySuggestions();
    } finally {
      _$_WeatherStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
citySuggestions: ${citySuggestions},
citySuggestionsLoading: ${citySuggestionsLoading}
    ''';
  }
}
