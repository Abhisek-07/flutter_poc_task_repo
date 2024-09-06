import 'package:flutter/material.dart';
import 'package:music_app/providers/theme_notifier.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 83, 173, 219),
  brightness: Brightness.light,
);

final kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 2, 10, 44),
  brightness: Brightness.dark,
);

final lightTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: kColorScheme,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: kColorScheme.background,
  appBarTheme: AppBarTheme(backgroundColor: kColorScheme.primaryContainer),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

final darkTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: kDarkColorScheme,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: kDarkColorScheme.background,
  appBarTheme: AppBarTheme(backgroundColor: kDarkColorScheme.primaryContainer),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themedata = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Music Player',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themedata.thememode,
      home: const HomeScreen(),
    );
  }
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
