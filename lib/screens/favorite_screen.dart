import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lat_responsi_124240017_si_c/providers/favorite_provider.dart';
import 'package:lat_responsi_124240017_si_c/screens/detail_screen.dart';
import 'package:lat_responsi_124240017_si_c/widgets/character_tile.dart';
import 'package:lat_responsi_124240017_si_c/widgets/state_views.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, fav, _) {
        final items = fav.favorites;

        if (items.isEmpty) {
          return const EmptyView(
            icon: Icons.favorite_border,
            message: 'Belum ada karakter favorit.\nTambahkan dari halaman Characters.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final c = items[i];
            return Dismissible(
              key: ValueKey(c.id),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                fav.remove(c.id);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('${c.name} berhasil dihapus dari favorit'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: Colors.amber,
                      onPressed: () => fav.add(c),
                    ),
                  ));
              },
              child: CharacterTile(
                character: c,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => DetailScreen(character: c)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
