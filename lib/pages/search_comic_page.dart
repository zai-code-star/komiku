import 'package:flutter/material.dart';
import '../models/comic.dart';
import '../services/database_service.dart';
import '../widgets/comic_card.dart';

class SearchComicPage extends StatefulWidget {
  const SearchComicPage({Key? key}) : super(key: key);

  @override
  _SearchComicPageState createState() => _SearchComicPageState();
}

class _SearchComicPageState extends State<SearchComicPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Comic> _comics = [];
  bool _isLoading = false;

  void _searchComics() async {
    setState(() {
      _isLoading = true;
    });
    final comics = await DatabaseService().getComics();
    setState(() {
      _comics = comics
          .where((comic) => comic.title.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
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
          'Cari Komik',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan judul komik',
                labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchComics();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
              onChanged: (value) {
                _searchComics();
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _comics.isEmpty
                        ? const Center(child: Text('Komik tidak ditemukan', style: TextStyle(fontSize: 18, color: Colors.grey)))
                        : ListView.builder(
                            itemCount: _comics.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ComicCard(comic: _comics[index]),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
