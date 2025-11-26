import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';
import '../models/character.dart';

class LocalStorageService {
  Box<Character>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CharacterAdapter());
    _box = await Hive.openBox<Character>(AppConstants.hiveBoxName);
  }

  Future<void> saveCharacters(List<Character> characters) async {
    if (_box == null) await init();
    final map = {for (var c in characters) c.id: c};
    await _box!.putAll(map);
  }

  List<Character> getCharacters() {
    if (_box == null) return [];
    return _box!.values.toList();
  }
  
  List<Character> searchCharacters(String query) {
    if (_box == null) return [];
    return _box!.values.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
