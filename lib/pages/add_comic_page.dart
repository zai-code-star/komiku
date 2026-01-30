import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import intl package
import '../models/comic.dart';
import '../services/database_service.dart';

class AddComicPage extends StatefulWidget {
  const AddComicPage({Key? key}) : super(key: key);

  @override
  _AddComicPageState createState() => _AddComicPageState();
}

class _AddComicPageState extends State<AddComicPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _authorController = TextEditingController();
  final _imagePaths = <String>[];

  final List<String> _categories = ['Action', 'Adventure', 'Fantasy', 'Horror', 'Romance'];
  final Set<String> _selectedCategories = {};
  DateTime? _selectedDate;

  final ImagePicker _picker = ImagePicker();

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    }
  }

  void _addComic() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _selectedCategories.isEmpty ||
        _selectedDate == null ||
        _imagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final comic = Comic(
      title: _titleController.text,
      description: _descriptionController.text,
      releaseDate: DateFormat('yyyy-MM-dd').format(_selectedDate!), // Format date
      author: _authorController.text,
      categories: _selectedCategories.toList(),
      images: _imagePaths,
      rating: null,
    );

    await DatabaseService().insertComic(comic);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comic added successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          'Tambah Komik',
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
  child: ListView(
    children: [
      _buildTextField(_titleController, 'Judul'),
      const SizedBox(height: 16), // Tambahkan jarak setelah Title
      _buildTextField(_descriptionController, 'Deskripsi'),
      const SizedBox(height: 16), // Tambahkan jarak setelah Description
      _buildTextField(_authorController, 'Nama Pengarang'),
      const SizedBox(height: 16), // Tambahkan jarak setelah Author
      const Text(
        'Pilih Kategori:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      _buildCategoryChips(),
      const SizedBox(height: 16),
      _buildDatePicker(),
      const SizedBox(height: 16),
      const Text(
        'Gambar:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      _buildImagePreview(),
      const SizedBox(height: 16),
      _buildAddImageButton(),
      const SizedBox(height: 16),
      _buildAddComicButton(),
    ],
  ),
),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
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
    );
  }

  Widget _buildDatePicker() {
    return Row(
      children: [
        TextButton(
          onPressed: _pickDate,
          child: const Text(
            'Tanggal Rilis',
            style: TextStyle(color: Colors.greenAccent),
          ),
        ),
        if (_selectedDate != null)
          Text(
            DateFormat('yyyy-MM-dd').format(_selectedDate!),
            style: const TextStyle(fontSize: 16),
          ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Wrap(
      spacing: 8,
      children: _imagePaths.map((path) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(path),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddImageButton() {
    return ElevatedButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.image),
      label: const Text('Tambah Gambar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildAddComicButton() {
    return ElevatedButton(
      onPressed: _addComic,
      child: const Text('Tambah Komik'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
