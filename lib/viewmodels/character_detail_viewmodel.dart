import 'package:flutter/material.dart';
import '../data/repositories/character_repository.dart';
import '../core/services/firebase_service.dart';

class CharacterDetailViewModel extends ChangeNotifier {
  final CharacterRepository _repository;
  final FirebaseService _firebaseService;

  List<String> _quotes = [];
  List<String> get quotes => _quotes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CharacterDetailViewModel(this._repository, this._firebaseService);

  Future<void> loadQuotes(String characterId) async {
    _isLoading = true;
    _quotes = [];
    notifyListeners();

    try {
      await _firebaseService.logEvent(
        name: 'view_character_detail',
        parameters: {'character_id': characterId},
      );

      _quotes = await _repository.getQuotes(characterId);
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
