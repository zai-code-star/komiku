import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/category_page.dart';
import 'pages/comic_list_page.dart';
import 'pages/add_comic_page.dart';
import 'pages/search_comic_page.dart';
import 'pages/splash_screen.dart'; // Tambahkan ini
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provider untuk User
      ],
      child: MaterialApp(
        title: 'Komiku',
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(), // Rute SplashScreen
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/categories': (context) => CategoryPage(),
          '/comics': (context) => const ComicListPage(),
          '/addComic': (context) => const AddComicPage(),
          '/searchComic': (context) => const SearchComicPage(),
          '/listComic': (context) => const ComicListPage(),
        },
      ),
    );
  }
}
