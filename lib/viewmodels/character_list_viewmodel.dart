import 'package:flutter/foundation.dart';
import '../data/models/character.dart';
import '../data/repositories/character_repository.dart';
import '../core/services/firebase_service.dart';

class CharacterListViewModel extends ChangeNotifier {
  final CharacterRepository _repository;
  final FirebaseService _firebaseService;

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _page = 1;
  bool _hasMore = true;
  String? _currentQuery;

  CharacterListViewModel(this._repository, this._firebaseService);

  Future<void> loadCharacters({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _characters = [];
      _hasMore = true;
      _currentQuery = null;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCharacters = await _repository.getCharacters(
        page: _page,
        query: _currentQuery,
      );

      if (newCharacters.isEmpty) {
        _hasMore = false;
      } else {
        _characters.addAll(newCharacters);
        _page++;
      }
      
      if (refresh) {
        await _firebaseService.logEvent(name: 'view_character_list');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    _page = 1;
    _characters = [];
    _hasMore = true;
    
    await _firebaseService.logEvent(
      name: 'search_character',
      parameters: {'query': query},
    );
    
    await loadCharacters();
  }

  void clearSearch() {
    _currentQuery = null;
    loadCharacters(refresh: true);
  }

  Character? getRandomCharacter() {
    if (_characters.isEmpty) return null;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % _characters.length;
    return _characters[randomIndex];
  }
}
