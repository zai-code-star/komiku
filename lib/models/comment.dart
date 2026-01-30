class Comment {
  final int? id;
  final int comicId;
  final String username;
  final String comment;
  final DateTime date;
  final double? rating;

  Comment({
    this.id,
    required this.comicId,
    required this.username,
    required this.comment,
    required this.date,
    required this.rating,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comicId': comicId,
      'username': username,
      'comment': comment,
      'date': date.toIso8601String(),
      'rating': rating,

    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      comicId: map['comicId'],
      username: map['username'],
      comment: map['comment'],
      date: DateTime.parse(map['date']),
      rating: map['rating'],

    );
  }
}
