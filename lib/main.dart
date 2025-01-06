import 'package:flutter/material.dart';
import 'package:musicplayer/models/playlist_provider.dart';
import 'package:musicplayer/pages/home_page.dart';
import 'package:musicplayer/themes/theme_provider.dart';
//import 'package:musicplayer/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          theme: themeProvider.themeData,
        );
      },
    );
  }
}
