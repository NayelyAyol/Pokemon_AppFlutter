class Pokemon {
  final int id;
  final String name;
  final String image;
  final int height;
  final int weight;
  final int baseExperience;
  final int order;
  final List types;
  final List abilities;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.order,
    required this.types,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['sprites']?['front_default'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      baseExperience: json['base_experience'] ?? 0,
      order: json['order'] ?? 0,
      types: json['types'] ?? [],
      abilities: json['abilities'] ?? [],
    );
  }
}