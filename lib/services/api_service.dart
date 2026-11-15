import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lat_responsi_124240017_si_c/models/character.dart';
import 'package:lat_responsi_124240017_si_c/models/episode.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const Duration _timeout = Duration(seconds: 15);

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final res = await http.get(uri).timeout(_timeout);
      if (res.statusCode == 404) return {'notFound': true};
      if (res.statusCode != 200) {
        throw Exception('Server error (${res.statusCode})');
      }
      return jsonDecode(res.body) as Map<String, dynamic>;
    } on Exception catch (e) {
      if (e.toString().startsWith('Exception: Server error')) rethrow;
      throw Exception(
          'Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  Future<CharacterPage> fetchCharacters({
    int page = 1,
    String status = '',
    String name = '',
  }) async {
    final params = <String, String>{'page': '$page'};
    if (status.isNotEmpty) params['status'] = status;
    if (name.isNotEmpty) params['name'] = name;

    final uri =
        Uri.parse('$baseUrl/character').replace(queryParameters: params);
    final data = await _get(uri);

    if (data['notFound'] == true) return CharacterPage([], false);

    final list = (data['results'] as List)
        .map((e) => Character.fromJson(e as Map<String, dynamic>))
        .toList();
    final hasNext = data['info']?['next'] != null;
    return CharacterPage(list, hasNext);
  }

  Future<Character> fetchCharacterDetail(int id) async {
    final data = await _get(Uri.parse('$baseUrl/character/$id'));
    if (data['notFound'] == true) throw Exception('Karakter tidak ditemukan');
    return Character.fromJson(data);
  }

  Future<List<Episode>> fetchEpisodes() async {
    final result = <Episode>[];
    String? next = '$baseUrl/episode';
    while (next != null) {
      final data = await _get(Uri.parse(next));
      if (data['notFound'] == true) break;
      result.addAll((data['results'] as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>)));
      next = data['info']?['next'] as String?;
    }
    return result;
  }
}
