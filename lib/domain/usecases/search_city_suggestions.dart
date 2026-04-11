import '../entity/city_suggestion.dart';
import '../repository/weather_repository.dart';

final class SearchCitySuggestions {
  const SearchCitySuggestions(this._repository);

  final WeatherRepository _repository;

  Future<List<CitySuggestion>> call(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return <CitySuggestion>[];
    return _repository.searchCitySuggestions(trimmed);
  }
}
