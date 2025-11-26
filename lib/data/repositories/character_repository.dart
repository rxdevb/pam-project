import '../models/character.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../../core/services/firebase_service.dart';

class CharacterRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;
  final FirebaseService _firebaseService;

  CharacterRepository(this._apiService, this._localStorageService, this._firebaseService);

  Future<List<Character>> getCharacters({
    int page = 1,
    int limit = 20,
    String? query,
  }) async {
    try {
      final characters = await _apiService.getCharacters(
        page: page,
        limit: limit,
        query: query,
      );

      await _localStorageService.saveCharacters(characters);

      return characters;
    } catch (e, stackTrace) {
      await _firebaseService.recordError(e, stackTrace, reason: 'Nie udało się pobrać postaci z API');

      if (query != null && query.isNotEmpty) {
        return _localStorageService.searchCharacters(query);
      }
      return _localStorageService.getCharacters();
    }
  }

  Future<List<String>> getQuotes(String characterId) async {
    try {
      return await _apiService.getQuotes(characterId);
    } catch (e, stackTrace) {
      await _firebaseService.recordError(e, stackTrace, reason: 'Nie udało się pobrać cytatów dla $characterId');
      return [];
    }
  }
}
