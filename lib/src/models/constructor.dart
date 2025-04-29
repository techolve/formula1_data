class Constructor {
  final String constructorId;
  final String url;
  final String name;
  final String nationality;

  Constructor({
    required this.constructorId,
    required this.url,
    required this.name,
    required this.nationality,
  });

  factory Constructor.fromJson(Map<String, dynamic> json) {
    return Constructor(
      constructorId: json['constructorId'],
      url: json['url'],
      name: json['name'],
      nationality: json['nationality'],
    );
  }

  @override
  String toString() {
    return 'Constructor(constructorId: $constructorId, url: $url, name: $name, nationality: $nationality)';
  }
}
