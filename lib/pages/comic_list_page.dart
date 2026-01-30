import 'dart:io';
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../widgets/loading_widget.dart';
import '../models/comic.dart';
import '../pages/update_comic_page.dart';

class ComicListPage extends StatefulWidget {
  const ComicListPage({Key? key}) : super(key: key);

  @override
  _ComicListPageState createState() => _ComicListPageState();
}

class _ComicListPageState extends State<ComicListPage> {
  List<Comic> _comics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComics();
  }

  void _loadComics() async {
    final comics = await DatabaseService().getComics();
    setState(() {
      _comics = comics;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          'Kelola Komik',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _comics.length,
                itemBuilder: (context, index) {
                  final comic = _comics[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: comic.images.isNotEmpty
                          ? (File(comic.images[0]).existsSync()
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(comic.images[0]),
                                    width: 50,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    comic.images[0],
                                    width: 50,
                                    height: 75,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 50);
                                    },
                                  ),
                                ))
                          : const Icon(Icons.image_not_supported, size: 50),
                      title: Text(
                        comic.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rating: ${comic.rating?.toStringAsFixed(1) ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kategori: ${comic.categories.join(', ')}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateComicPage(comic: comic),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
