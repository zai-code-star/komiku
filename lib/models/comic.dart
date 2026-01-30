class Comic {
  final int? id;
  final String title;
  final String description;
  final String releaseDate;
  final String author;
  final List<String> categories; // Changed from single category to list
  final List<String> images;
  final double? rating;

  Comic({
    this.id,
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.author,
    required this.categories, // Changed to List<String>
    required this.images,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'releaseDate': releaseDate,
      'author': author,
      'categories': categories.join(','), // Storing categories as a comma-separated string
      'images': images.join(','), // Storing images as a comma-separated string
      'rating': rating,
    };
  }
// Add the copyWith method
  Comic copyWith({
    int? id,
    String? title,
    String? author,
    String? releaseDate,
    String? description,
    List<String>? categories,
    List<String>? images,
    double? rating,
  }) {
    return Comic(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      releaseDate: releaseDate ?? this.releaseDate,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      images: images ?? this.images,
      rating: rating ?? this.rating,
    );
  }

  factory Comic.fromMap(Map<String, dynamic> map) {
    return Comic(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      releaseDate: map['releaseDate'],
      author: map['author'],
      categories: map['categories'].split(','), // Splitting the comma-separated string back into a list
      images: map['images'].split(','), // Splitting the comma-separated string back into a list
      rating: map['rating'],
    );
  }

  // Method to calculate the average rating
  static double calculateAverageRating(List<double> ratings) {
    if (ratings.isEmpty) return 0.0;
    double total = ratings.fold(0, (sum, rating) => sum + rating);
    return total / ratings.length;
  }
}
