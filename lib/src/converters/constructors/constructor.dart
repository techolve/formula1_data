class Constructor {
  final String constructorsId;
  final String url;
  final String name;
  final String nationality;

  const Constructor({
    required this.constructorsId,
    required this.url,
    required this.name,
    required this.nationality,
  });

  factory Constructor.fromMap(dynamic map) {
    return Constructor(
      constructorsId: map["constructorId"],
      url: map["url"],
      name: map["name"],
      nationality: map["nationality"],
    );
  }

  @override
  String toString() {
    return "Constructors(constructorsId: $constructorsId, url: $url, name: $name, nationality: $nationality)";
  }
}
