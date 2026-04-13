import 'package:flutter_ci_cd_demo/domain/entity/city_suggestion.dart';
import 'package:flutter_ci_cd_demo/domain/repository/weather_repository.dart';
import 'package:flutter_ci_cd_demo/domain/usecases/search_city_suggestions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockRepository extends Mock implements WeatherRepository {}

void main() {
  late _MockRepository repository;
  late SearchCitySuggestions useCase;

  setUp(() {
    repository = _MockRepository();
    useCase = SearchCitySuggestions(repository);
  });

  test(
    'returns empty list without calling repository when query is short',
    () async {
      expect(await useCase.call(''), isEmpty);
      expect(await useCase.call('a'), isEmpty);
      expect(await useCase.call(' x '), isEmpty);
      verifyNever(() => repository.searchCitySuggestions(any()));
    },
  );

  test(
    'delegates trimmed query to repository when length is at least 2',
    () async {
      const suggestions = <CitySuggestion>[
        CitySuggestion(
          name: 'London',
          state: null,
          countryCode: 'GB',
          countryName: 'United Kingdom',
          latitude: 51.5,
          longitude: -0.12,
        ),
      ];
      when(
        () => repository.searchCitySuggestions('Lon'),
      ).thenAnswer((_) async => suggestions);

      final result = await useCase.call('  Lon  ');

      expect(result, suggestions);
      verify(() => repository.searchCitySuggestions('Lon')).called(1);
    },
  );
}
