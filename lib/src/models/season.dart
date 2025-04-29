class Season {
  final int year;
  final String url;

  Season({
    required this.year,
    required this.url,
  });

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
