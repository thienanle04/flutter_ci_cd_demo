import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../data/services/open_weather_service.dart';
import '../repository/weather_repository.dart';
import '../usecases/get_current_weather_by_city.dart';
import '../usecases/get_current_weather_by_coordinates.dart';
import '../usecases/search_city_suggestions.dart';
import '../../presentation/weather/stores/weather_store.dart';
import '../../core/config/app_env.dart';
import '../../core/networking/dio_client.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Core
  sl.registerLazySingleton<Dio>(
    () => DioClient.create(
      baseUrl: AppEnv.openWeatherBaseUrl,
      apiKey: AppEnv.openWeatherApiKey,
    ),
  );

  // Data
  sl.registerLazySingleton<OpenWeatherService>(
    () => OpenWeatherService(sl<Dio>()),
  );
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => OpenWeatherRemoteDataSource(service: sl<OpenWeatherService>()),
  );

  // Domain
  sl.registerLazySingleton<WeatherRepository>(
    () =>
        WeatherRepositoryImpl(remoteDataSource: sl<WeatherRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCurrentWeatherByCity>(
    () => GetCurrentWeatherByCity(sl<WeatherRepository>()),
  );
  sl.registerLazySingleton<GetCurrentWeatherByCoordinates>(
    () => GetCurrentWeatherByCoordinates(sl<WeatherRepository>()),
  );
  sl.registerLazySingleton<SearchCitySuggestions>(
    () => SearchCitySuggestions(sl<WeatherRepository>()),
  );

  // Presentation
  sl.registerFactory<WeatherStore>(
    () => WeatherStore(
      sl<GetCurrentWeatherByCity>(),
      sl<GetCurrentWeatherByCoordinates>(),
      sl<SearchCitySuggestions>(),
    ),
  );
}
