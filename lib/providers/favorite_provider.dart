import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lat_responsi_124240017_si_c/models/character.dart';

class FavoriteProvider extends ChangeNotifier {
  static const _key = 'favorites';

  final List<Character> _favorites = [];
  List<Character> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(int id) => _favorites.any((c) => c.id == id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _favorites
      ..clear()
      ..addAll(raw.map((s) =>
          Character.fromJson(jsonDecode(s) as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, _favorites.map((c) => jsonEncode(c.toJson())).toList());
  }

  Future<bool> toggle(Character c) async {
    final added = !isFavorite(c.id);
    if (added) {
      _favorites.add(c);
    } else {
      _favorites.removeWhere((e) => e.id == c.id);
    }
    notifyListeners();
    await _save();
    return added;
  }

  Future<void> add(Character c) async {
    if (isFavorite(c.id)) return;
    _favorites.add(c);
    notifyListeners();
    await _save();
  }

  Future<void> remove(int id) async {
    _favorites.removeWhere((e) => e.id == id);
    notifyListeners();
    await _save();
  }
}
