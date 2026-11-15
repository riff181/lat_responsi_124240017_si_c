class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String originName;
  final String locationName;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.originName,
    required this.locationName,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'] as int,
        name: json['name'] ?? '-',
        status: json['status'] ?? 'unknown',
        species: json['species'] ?? '-',
        gender: json['gender'] ?? '-',
        image: json['image'] ?? '',
        originName: json['origin']?['name'] ?? '-',
        locationName: json['location']?['name'] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'species': species,
        'gender': gender,
        'image': image,
        'origin': {'name': originName},
        'location': {'name': locationName},
      };
}

class CharacterPage {
  final List<Character> characters;
  final bool hasNext;
  CharacterPage(this.characters, this.hasNext);
}
