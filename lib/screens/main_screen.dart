import 'package:flutter/material.dart';

import 'package:lat_responsi_124240017_si_c/screens/episode_screen.dart';
import 'package:lat_responsi_124240017_si_c/screens/favorite_screen.dart';
import 'package:lat_responsi_124240017_si_c/screens/home_screen.dart';
import 'package:lat_responsi_124240017_si_c/screens/login_screen.dart';
import 'package:lat_responsi_124240017_si_c/services/session_service.dart';
import 'package:lat_responsi_124240017_si_c/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _titles = ['Rick & Morty', 'Favorites', 'Episodes'];
  final _pages = const [HomeScreen(), FavoriteScreen(), EpisodeScreen()];

  Future<void> _logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppTheme.brown,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Characters'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_fill), label: 'Episodes'),
        ],
      ),
    );
  }
}
