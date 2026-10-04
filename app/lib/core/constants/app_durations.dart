/// Timings used across the app, in one place so they stay consistent.
abstract final class AppDurations {
  /// Pause after the last keystroke before searching.
  static const Duration searchDebounce = Duration(milliseconds: 400);

  /// Time each featured movie stays on the home carousel.
  static const Duration carouselAutoPlay = Duration(seconds: 5);

  /// The circular theme reveal.
  static const Duration themeReveal = Duration(milliseconds: 650);

  /// The favorite heart's fill animation.
  static const Duration favoriteToggle = Duration(milliseconds: 180);

  /// How long the trailer player may take to load before offering YouTube.
  static const Duration trailerLoadTimeout = Duration(seconds: 6);

  /// Connect and receive timeouts for TMDB requests.
  static const Duration networkTimeout = Duration(seconds: 30);
}
