import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lat_responsi_124240017_si_c/models/character.dart';
import 'package:lat_responsi_124240017_si_c/providers/favorite_provider.dart';
import 'package:lat_responsi_124240017_si_c/theme/app_theme.dart';

class CharacterTile extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterTile({super.key, required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.softBrown),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ClipOval(
          child: Image.network(
            character.image,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.softBrown,
              child: Icon(Icons.person, color: AppTheme.brown),
            ),
          ),
        ),
        title: Text(
          character.name,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: AppTheme.darkBrown),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.circle,
                size: 10, color: AppTheme.statusColor(character.status)),
            const SizedBox(width: 6),
            Text(character.status),
          ],
        ),
        trailing: Consumer<FavoriteProvider>(
          builder: (context, fav, _) {
            final isFav = fav.isFavorite(character.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : AppTheme.brown,
              ),
              onPressed: () => fav.toggle(character),
            );
          },
        ),
      ),
    );
  }
}
