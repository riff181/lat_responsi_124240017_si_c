import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lat_responsi_124240017_si_c/models/character.dart';
import 'package:lat_responsi_124240017_si_c/providers/favorite_provider.dart';
import 'package:lat_responsi_124240017_si_c/services/api_service.dart';
import 'package:lat_responsi_124240017_si_c/theme/app_theme.dart';
import 'package:lat_responsi_124240017_si_c/widgets/state_views.dart';

class DetailScreen extends StatefulWidget {
  final Character character;
  const DetailScreen({super.key, required this.character});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _api = ApiService();
  late Future<Character> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchCharacterDetail(widget.character.id);
  }

  void _retry() {
    setState(() => _future = _api.fetchCharacterDetail(widget.character.id));
  }

  Future<void> _toggleFavorite(Character c) async {
    final fav = context.read<FavoriteProvider>();
    final added = await fav.toggle(c);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(added
            ? '${c.name} ditambahkan ke favorit'
            : '${c.name} dihapus dari favorit'),
      ));
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    color: AppTheme.brown, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: AppTheme.darkBrown)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, fav, _) {
              final isFav = fav.isFavorite(widget.character.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white),
                onPressed: () => _toggleFavorite(widget.character),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Character>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString().replaceFirst('Exception: ', ''),
              onRetry: _retry,
            );
          }
          final c = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    c.image,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      width: 220,
                      height: 220,
                      child: Icon(Icons.person,
                          size: 80, color: AppTheme.softBrown),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(c.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown)),
                const SizedBox(height: 16),
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppTheme.softBrown),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 90,
                              child: Text('Status',
                                  style: TextStyle(
                                      color: AppTheme.brown,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Icon(Icons.circle,
                                size: 12,
                                color: AppTheme.statusColor(c.status)),
                            const SizedBox(width: 6),
                            Text(c.status,
                                style: const TextStyle(
                                    color: AppTheme.darkBrown)),
                          ],
                        ),
                        const Divider(),
                        _row('Species', c.species),
                        const Divider(),
                        _row('Gender', c.gender),
                        const Divider(),
                        _row('Origin', c.originName),
                        const Divider(),
                        _row('Location', c.locationName),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<FavoriteProvider>(
                  builder: (context, fav, _) {
                    final isFav = fav.isFavorite(c.id);
                    return FilledButton.icon(
                      onPressed: () => _toggleFavorite(c),
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFav
                          ? 'Hapus dari Favorite'
                          : 'Tambah ke Favorite'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
