import 'dart:io';
import 'package:flutter/material.dart';
import '../models/comic.dart';
import '../services/database_service.dart';
import '../pages/comic_detail_page.dart';

class ComicGridPage extends StatelessWidget {
  final String category;

  const ComicGridPage({Key? key, required this.category}) : super(key: key);

  Future<List<Comic>> fetchComicsByCategory() async {
    return await DatabaseService().getComicsByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Komik: $category')),
      body: FutureBuilder<List<Comic>>(
        future: fetchComicsByCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada komik dalam kategori ini.'));
          }

          final comics = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Tambahkan padding horizontal
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah kolom dalam grid
                crossAxisSpacing: 16, // Jarak horizontal antar item
                mainAxisSpacing: 16, // Jarak vertikal antar item
                childAspectRatio: 0.7, // Rasio aspek untuk item grid
              ),
              itemCount: comics.length,
              itemBuilder: (context, index) {
                final comic = comics[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComicDetailPage(comic: comic),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: comic.images.isNotEmpty
                              ? Image.file(
                                  File(comic.images.first),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Image.asset(
                                  'assets/images/default.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            comic.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Rating: ${comic.rating?.toStringAsFixed(1) ?? 'N/A'}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
