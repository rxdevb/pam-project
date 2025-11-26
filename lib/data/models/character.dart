import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? race;

  @HiveField(3)
  final String? gender;

  @HiveField(4)
  final String? birth;

  @HiveField(5)
  final String? death;

  @HiveField(6)
  final String? realm;

  @HiveField(7)
  final String? wikiUrl;

  Character({
    required this.id,
    required this.name,
    this.race,
    this.gender,
    this.birth,
    this.death,
    this.realm,
    this.wikiUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['_id'] as String,
      name: json['name'] as String,
      race: json['race'] as String?,
      gender: json['gender'] as String?,
      birth: json['birth'] as String?,
      death: json['death'] as String?,
      realm: json['realm'] as String?,
      wikiUrl: json['wikiUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'race': race,
      'gender': gender,
      'birth': birth,
      'death': death,
      'realm': realm,
      'wikiUrl': wikiUrl,
    };
  }
}
