import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/comic.dart';
import '../widgets/comic_card.dart';
import '../widgets/drawer_widget.dart';
import '../pages/comic_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Comic>> _comics;

  @override
  void initState() {
    super.initState();
    _comics = DatabaseService().getComics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          'Komiku',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const DrawerWidget(),
      body: FutureBuilder<List<Comic>>(
        future: _comics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.sentiment_dissatisfied, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'Belum ada Komik, Silahkan input komik!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            final comics = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: ListView.builder(
                itemCount: comics.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Space at the top of the list
                    return const SizedBox(height: 20);
                  }
                  final comic = comics[index - 1];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the UpdateComicPage when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComicDetailPage(comic: comic),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: SizedBox(
                        height: 150, // Tinggi card
                        width: double.infinity, // Lebar card mengikuti lebar layar
                        child: ComicCard(comic: comic),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
