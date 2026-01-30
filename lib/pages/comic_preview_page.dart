import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ComicPreviewPage extends StatelessWidget {
  final List<String> images;

  const ComicPreviewPage({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Komik'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: images.map((image) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
