import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/character.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: AppConstants.baseUrl,
          headers: {
            'Authorization': 'Bearer ${AppConstants.apiToken}',
          },
        ));

  Future<List<Character>> getCharacters({
    int page = 1,
    int limit = 20,
    String? query,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit,
        'page': page,
      };

      if (query != null && query.isNotEmpty) {
        queryParams['name'] = '/$query/i';
      }

      final response = await _dio.get('/character', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> docs = response.data['docs'];
        return docs.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Nie udało się pobrać postaci: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Nie udało się pobrać postaci: $e');
    }
  }

  Future<List<String>> getQuotes(String characterId) async {
    try {
      print('Pobieranie cytatów dla characterId: $characterId');
      final response = await _dio.get('/character/$characterId/quote');
      
      print('Status odpowiedzi cytatów: ${response.statusCode}');
      print('Dane odpowiedzi cytatów: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> docs = response.data['docs'];
        final quotes = docs.map((json) => json['dialog'] as String).toList();
        print('Przetworzone cytaty: $quotes');
        return quotes;
      } else {
        print('Nie udało się pobrać cytatów. Status: ${response.statusCode}');
        throw Exception('Nie udało się pobrać cytatów: ${response.statusCode}');
      }
    } catch (e) {
      print('Błąd podczas pobierania cytatów: $e');
      return [];
    }
  }
}
