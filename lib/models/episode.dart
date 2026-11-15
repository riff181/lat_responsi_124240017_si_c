class Episode {
  final int id;
  final String name;
  final String airDate;
  final String code;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.code,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json['id'] as int,
        name: json['name'] ?? '-',
        airDate: json['air_date'] ?? '-',
        code: json['episode'] ?? '',
      );
}
