import 'package:flutter/material.dart';
import '../models/comic.dart';
import '../models/comment.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/database_service.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; 
import 'package:cached_network_image/cached_network_image.dart';
import '../pages/comic_preview_page.dart';

class ComicDetailPage extends StatelessWidget {
  final Comic comic;

  const ComicDetailPage({Key? key, required this.comic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _commentController = TextEditingController();
    final username = Provider.of<UserProvider>(context).username; // Get logged-in username

    void _submitComment() async {
      final commentText = _commentController.text.trim();
      final double defaultRating = 0.0; // Default rating value

        if (commentText.isNotEmpty && username != null && username!.isNotEmpty) { // Null check for username
        final newComment = Comment(
          comicId: comic.id ?? 0,
          username: username, // Use the logged-in username
          comment: commentText,
          date: DateTime.now(),
          rating: defaultRating,
        );

        await DatabaseService().insertComment(newComment);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terimakasih Atas Komentar Anda')),
        );
        _commentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to comment')),
        );
      }
    }

    Widget _buildComicImage(String imagePath) {
      if (File(imagePath).existsSync()) {
        // Display local image if exists
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
        );
      } else {
        // Fallback to network image or placeholder
        return CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
        );
      }
    }
void _showFullScreenImages(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        child: Builder(
          builder: (context) {
            // Mengambil ukuran layar
            final screenSize = MediaQuery.of(context).size;
            // Menentukan lebar dan tinggi dialog
            final dialogWidth = screenSize.width * 0.9; // 90% dari lebar layar
            final dialogHeight = dialogWidth * 1.5; // Tinggi disesuaikan dengan lebar (rasio 1:1.5)

            return Container(
              width: dialogWidth,
              height: dialogHeight,
              child: PageView.builder(
                scrollDirection: Axis.vertical, // Set the scroll direction to vertical
                itemCount: comic.images.length,
                itemBuilder: (context, index) {
                  return _buildComicImage(comic.images[index]);
                },
              ),
            );
          },
        ),
      );
    },
  );
}


    return Scaffold(
      appBar: AppBar(
        title: Text(comic.title),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(
              height: 250,
              child: GestureDetector(
                onTap: () => _showFullScreenImages(context),
                child: PageView.builder(
                  itemCount: comic.images.length,
                  itemBuilder: (context, index) {
                    return _buildComicImage(comic.images[index]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              comic.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Pengarang: ${comic.author}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            Text(
              'Tanggal Rilis: ${comic.releaseDate}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Text('Deskirpsi:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(comic.description),
            const SizedBox(height: 20),
            Text('Kategori:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: comic.categories
                  .map((category) => Chip(label: Text(category)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Rating:', style: const TextStyle(fontWeight: FontWeight.bold)),
            RatingBar.builder(
              initialRating: comic.rating ?? 0.0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) async {
                if (username != null && username.isNotEmpty) {
                  final newComment = Comment(
                    comicId: comic.id ?? 0,
                    username: username,
                    comment: 'Telah memberi rating',
                    date: DateTime.now(),
                    rating: rating,
                  );
                  await DatabaseService().insertComment(newComment);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terimakasih Telah Memberi Rating')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please log in to rate')),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text('Komentar:', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Tulis Komentar',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitComment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: const Text('Kirim Komentar'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Comment>>(
              future: DatabaseService().getCommentsForComic(comic.id ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Belum ada komentar.');
                } else {
                  final comments = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: comments.map((comment) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 4,
                        child: ListTile(
                          title: Text(comment.username),
                          subtitle: Text(comment.comment),
                          trailing: Text(DateFormat('yyyy-MM-dd').format(comment.date.toLocal())),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
