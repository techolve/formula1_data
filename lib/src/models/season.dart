/// Represents a Formula 1 season.
///
/// This class contains information about a specific Formula 1 season,
/// including the year and the URL to the season's Wikipedia page.
class Season {
  /// The year of the season.
  final int year;

  /// The URL to the season's Wikipedia page.
  final String url;

  /// Creates a new [Season] instance.
  ///
  /// [year] is the year of the season.
  /// [url] is the URL to the season's Wikipedia page.
  Season({
    required this.year,
    required this.url,
  });

  /// Creates a [Season] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'season': A string representing the year
  /// - 'url': A string representing the URL to the season's Wikipedia page
  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      year: int.parse(json['season']),
      url: json['url'],
    );
  }

  @override
  String toString() {
    return 'Season(year: $year, url: $url)';
  }
}
