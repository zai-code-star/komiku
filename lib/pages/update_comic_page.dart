import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/comic.dart';
import '../services/database_service.dart';
import '../widgets/rating_widget.dart';
import 'package:intl/intl.dart';

class UpdateComicPage extends StatefulWidget {
  final Comic comic;

  const UpdateComicPage({Key? key, required this.comic}) : super(key: key);

  @override
  _UpdateComicPageState createState() => _UpdateComicPageState();
}

class _UpdateComicPageState extends State<UpdateComicPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _releaseDateController;
  late TextEditingController _authorController;
  double _rating = 0;
  List<String> _categories = ['Action', 'Adventure', 'Fantasy', 'Horror', 'Romance'];
  List<String> _selectedCategories = [];
  DateTime? _selectedDate;
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.comic.title);
    _descriptionController = TextEditingController(text: widget.comic.description);
    _releaseDateController = TextEditingController(text: widget.comic.releaseDate);
    _authorController = TextEditingController(text: widget.comic.author);
    _rating = widget.comic.rating ?? 0;
    _selectedCategories = widget.comic.categories;
    _imagePaths = List.from(widget.comic.images);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _releaseDateController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePaths[index] = pickedFile.path;
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _imagePaths = pickedFiles.map((file) => file.path).toList();
      });
    }
  }

  void _updateComic() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedComic = Comic(
        id: widget.comic.id,
        title: _titleController.text,
        description: _descriptionController.text,
        releaseDate: _releaseDateController.text,
        author: _authorController.text,
        categories: _selectedCategories,
        images: _imagePaths,
        rating: _rating,
        
      );
      await DatabaseService().updateComic(updatedComic);
      Navigator.pop(context);
    }
  }

  void _deleteComic() async {
    if (widget.comic.id != null) {
      await DatabaseService().deleteComic(widget.comic.id!);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Comic ID is null')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(      
      backgroundColor: Colors.greenAccent,
      title: const Text('Update Komik',
      style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Judul'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Description
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskirpsi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Release Date Picker
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _releaseDateController,
                    decoration: const InputDecoration(labelText: 'Tanggal Rilis'),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                          _releaseDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a release date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Author
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Pengarang'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an author';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Categories
              const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: _categories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: _selectedCategories.contains(category),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    selectedColor: Colors.greenAccent,
                    labelStyle: const TextStyle(color: Colors.black),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Images
              const Text('Gambar', style: TextStyle(fontWeight: FontWeight.bold)),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _imagePaths.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        File(_imagePaths[index]),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _pickImage(index),
                        ),
                      ),
                    ],
                  );
                },
              ),
              TextButton(
                onPressed: _pickImages,
                child: const Text('Ganti Semua Gambar'),
              ),
              // Rating Widget
              RatingWidget(
                onRatingSelected: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Update and Delete Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _updateComic,
                    child: const Text('Update Komik'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteComic,
                    child: const Text('Delete Komik'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
