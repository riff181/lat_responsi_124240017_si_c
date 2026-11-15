import 'package:flutter/material.dart';

import 'package:lat_responsi_124240017_si_c/models/episode.dart';
import 'package:lat_responsi_124240017_si_c/services/api_service.dart';
import 'package:lat_responsi_124240017_si_c/theme/app_theme.dart';
import 'package:lat_responsi_124240017_si_c/widgets/state_views.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  final _api = ApiService();
  late Future<List<Episode>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchEpisodes();
  }

  void _retry() => setState(() => _future = _api.fetchEpisodes());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Episode>>(
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
        final episodes = snapshot.data!;
        if (episodes.isEmpty) {
          return const EmptyView(
              icon: Icons.movie_outlined, message: 'Tidak ada episode');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: episodes.length,
          itemBuilder: (context, i) {
            final e = episodes[i];
            return Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.softBrown),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.softBrown,
                  child: Text('${e.id}',
                      style: const TextStyle(color: AppTheme.darkBrown)),
                ),
                title: Text(e.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown)),
                subtitle: Text(e.airDate),
                trailing: Text(e.code,
                    style: const TextStyle(color: AppTheme.brown)),
              ),
            );
          },
        );
      },
    );
  }
}
