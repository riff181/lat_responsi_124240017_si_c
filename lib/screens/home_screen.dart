import 'package:flutter/material.dart';

import 'package:lat_responsi_124240017_si_c/models/character.dart';
import 'package:lat_responsi_124240017_si_c/screens/detail_screen.dart';
import 'package:lat_responsi_124240017_si_c/services/api_service.dart';
import 'package:lat_responsi_124240017_si_c/theme/app_theme.dart';
import 'package:lat_responsi_124240017_si_c/widgets/character_tile.dart';
import 'package:lat_responsi_124240017_si_c/widgets/state_views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = ApiService();
  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();

  final List<Character> _items = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loading = false;
  String? _error;
  String _status = ''; // '' = semua
  String _query = '';
  int _reqId = 0;

  static const _filters = {
    'All': '',
    'Alive': 'alive',
    'Dead': 'dead',
    'Unknown': 'unknown',
  };

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200 &&
          !_loading &&
          _hasMore &&
          _error == null) {
        _load();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool reset = false}) async {
    final id = ++_reqId;
    setState(() {
      if (reset) {
        _items.clear();
        _page = 1;
        _hasMore = true;
      }
      _error = null;
      _loading = true;
    });

    try {
      final result = await _api.fetchCharacters(
          page: _page, status: _status, name: _query);
      if (!mounted || id != _reqId) return;
      setState(() {
        _items.addAll(result.characters);
        _hasMore = result.hasNext;
        _page++;
        _loading = false;
      });
    } catch (e) {
      if (!mounted || id != _reqId) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _setFilter(String status) {
    if (_status == status) return;
    _status = status;
    _load(reset: true);
  }

  void _search(String value) {
    _query = value.trim();
    _load(reset: true);
  }

  Widget _buildBody() {
    if (_items.isEmpty) {
      if (_loading) return const Center(child: CircularProgressIndicator());
      if (_error != null) {
        return ErrorView(message: _error!, onRetry: () => _load(reset: true));
      }
      return const EmptyView(
        icon: Icons.search_off,
        message: 'Karakter tidak ditemukan',
      );
    }

    final showFooter = _loading || _error != null;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: _items.length + (showFooter ? 1 : 0),
      itemBuilder: (context, i) {
        if (i >= _items.length) {
          if (_error != null) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(_error!, textAlign: TextAlign.center),
                  TextButton(
                    onPressed: () => _load(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final c = _items[i];
        return CharacterTile(
          character: c,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DetailScreen(character: c)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            controller: _searchCtrl,
            textInputAction: TextInputAction.search,
            onSubmitted: _search,
            decoration: InputDecoration(
              hintText: 'Cari karakter...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchCtrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        _search('');
                      },
                    ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: _filters.entries.map((e) {
              final selected = _status == e.value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(e.key),
                  selected: selected,
                  selectedColor: AppTheme.brown,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppTheme.darkBrown,
                  ),
                  checkmarkColor: Colors.white,
                  onSelected: (_) => _setFilter(e.value),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }
}
