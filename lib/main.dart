import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lat_responsi_124240017_si_c/providers/favorite_provider.dart';
import 'package:lat_responsi_124240017_si_c/screens/login_screen.dart';
import 'package:lat_responsi_124240017_si_c/screens/main_screen.dart';
import 'package:lat_responsi_124240017_si_c/services/session_service.dart';
import 'package:lat_responsi_124240017_si_c/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteProvider()..load(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data == true ? const MainScreen() : const LoginScreen();
      },
    );
  }
}
