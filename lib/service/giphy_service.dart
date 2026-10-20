import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GiphyService {
  Future<Map<String, dynamic>?> getGif(
    String search, {
    required String fallback,
  }) async {
    final key = dotenv.env['GIPHY_API_KEY']?.trim() ?? '';
    if (key.isEmpty) {
      throw Exception('Configure o GIPHY_API_KEY no arquivo .env.');
    }

    for (final query in {search.trim(), fallback.trim()}) {
      if (query.isEmpty) continue;
      final gif = await _search(query, key);
      if (gif != null) return gif;
    }
    return null;
  }

  Future<Map<String, dynamic>?> _search(String search, String key) async {
    final uri = Uri.https('api.giphy.com', '/v1/gifs/search', {
      'api_key': key,
      'q': search,
      'limit': '1',
      'rating': 'g',
      'lang': 'en',
    });
    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 20));
    } on http.ClientException {
      throw Exception('Não foi possível acessar a Giphy. Confira sua conexão.');
    } on TimeoutException {
      throw Exception('A busca do GIF demorou demais. Tente novamente.');
    }
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Chave da Giphy inválida ou sem autorização.');
    }
    if (response.statusCode == 429) {
      throw Exception(
        'Limite de consultas da Giphy atingido. Tente mais tarde.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('A API de GIFs retornou o erro ${response.statusCode}.');
    }
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final gifs = decoded['data'] as List<dynamic>? ?? [];
    return gifs.isEmpty ? null : gifs.first as Map<String, dynamic>;
  }
}
