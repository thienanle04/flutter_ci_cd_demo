import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_env.dart';
import '../../../domain/entity/city_suggestion.dart';
import '../notifiers/weather_state.dart';
import '../stores/i_weather_store.dart';
import '../widgets/weather_card.dart';

final class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

final class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _suggestDebounce;

  static const Duration _suggestDebounceDelay = Duration(milliseconds: 350);

  @override
  void dispose() {
    _suggestDebounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _scheduleSuggestions(IWeatherStore store, String text) {
    _suggestDebounce?.cancel();
    _suggestDebounce = Timer(_suggestDebounceDelay, () {
      if (!mounted) return;
      unawaited(store.searchCitySuggestions(text));
    });
  }

  Future<void> _onSuggestionTap(
    IWeatherStore store,
    CitySuggestion suggestion,
  ) async {
    FocusScope.of(context).unfocus();
    _controller.text = suggestion.displayLabel;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
    await store.fetchByCoordinates(
      suggestion.latitude,
      suggestion.longitude,
      displayCityName: suggestion.displayLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<IWeatherStore>();
    final hasApiKey = AppEnv.openWeatherApiKey.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather (CI/CD Demo)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Observer(
            builder: (_) {
              final state = store.state;
              final suggestions = store.citySuggestions;
              final showSuggestions =
                  hasApiKey &&
                  suggestions.isNotEmpty &&
                  state is! WeatherLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      labelText: 'City name',
                      hintText: 'e.g. London',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      if (!hasApiKey) return;
                      _scheduleSuggestions(store, value);
                    },
                    onSubmitted: store.fetchByCity,
                  ),
                  if (store.citySuggestionsLoading) ...<Widget>[
                    const SizedBox(height: 8),
                    const LinearProgressIndicator(minHeight: 2),
                  ],
                  if (showSuggestions) ...<Widget>[
                    const SizedBox(height: 4),
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                      clipBehavior: Clip.antiAlias,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: suggestions.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            final CitySuggestion s = suggestions[index];
                            return ListTile(
                              dense: true,
                              title: Text(s.displayLabel),
                              onTap: () => _onSuggestionTap(store, s),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => store.fetchByCity(_controller.text),
                          icon: const Icon(Icons.search),
                          label: const Text('Get weather'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!hasApiKey)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'No API key found. Please provide OPENWEATHER_API_KEY.',
                      ),
                    ),
                  Expanded(child: _StateView(state: state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _StateView extends StatelessWidget {
  const _StateView({required this.state});

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      WeatherInitial() => const Center(
        child: Text('Search for a city to begin'),
      ),
      WeatherLoading() => const Center(child: CircularProgressIndicator()),
      WeatherSuccess(:final weather) => ListView(
        children: <Widget>[WeatherCard(weather: weather)],
      ),
      WeatherError(:final message) => Center(
        child: Text(
          'Error: $message',
          key: const Key('weather_error_text'),
          textAlign: TextAlign.center,
        ),
      ),
    };
  }
}
