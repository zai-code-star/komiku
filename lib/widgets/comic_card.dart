import 'dart:io';
import 'package:flutter/material.dart';
import '../models/comic.dart';
import '../pages/comic_detail_page.dart';

class ComicCard extends StatelessWidget {
  final Comic comic;

  const ComicCard({Key? key, required this.comic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComicDetailPage(comic: comic),
            ),
          );
        },
        child: Row(
          children: [
            // Gambar Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: comic.images.isNotEmpty
                  ? Image.file(
                      File(comic.images.first),
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/${comic.categories.isNotEmpty ? comic.categories.first.toLowerCase() : 'default'}.png',
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),
            // Informasi Komik
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Komik
                    Text(
                      comic.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Deskripsi Singkat
                    Text(
                      comic.description ?? 'No description available.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Rating
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (comic.rating?.round() ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
