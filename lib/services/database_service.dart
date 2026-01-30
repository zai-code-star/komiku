import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/comic.dart';
import '../models/user.dart';
import '../models/comment.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();
  factory DatabaseService() => _instance;

  Database? _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'komiku.db'),
      onCreate: (db, version) async {
        // Tabel untuk pengguna
        await db.execute('''CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )''');
        // Tabel untuk komik
        await db.execute('''CREATE TABLE comics (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            releaseDate TEXT,
            author TEXT,
            categories TEXT,
            images TEXT,
            rating REAL
          )''');
        // Tabel untuk komentar
        await db.execute('''CREATE TABLE comments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            comicId INTEGER,
            username TEXT,
            comment TEXT,
            date TEXT,
            rating REAL,
            FOREIGN KEY(comicId) REFERENCES comics(id)
          )''');
        // Insert a default admin user
        await db.insert('users', User(username: 'admin', password: 'admin').toMap());
      },
      version: 1,
    );
  }

  // Get all comics
  Future<List<Comic>> getComics() async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query('comics');
    return List.generate(maps.length, (i) => Comic.fromMap(maps[i]));
  }

  // Get comics by category
  Future<List<Comic>> getComicsByCategory(String category) async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query(
      'comics',
      where: 'categories LIKE ?',
      whereArgs: ['%$category%'],
    );
    return List.generate(maps.length, (i) => Comic.fromMap(maps[i]));
  }

  // Insert a new comic
  Future<void> insertComic(Comic comic) async {
    if (_database == null) {
      await initDatabase();
    }
    await _database!.insert('comics', comic.toMap());
  }

  // Update an existing comic
  Future<void> updateComic(Comic comic) async {
    if (_database == null) {
      await initDatabase();
    }
    await _database!.update(
      'comics',
      comic.toMap(),
      where: 'id = ?',
      whereArgs: [comic.id],
    );
  }

  // Delete a comic
  Future<void> deleteComic(int id) async {
    if (_database == null) {
      await initDatabase();
    }
    await _database!.delete(
      'comics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get a user by username and password
  Future<User?> getUser(String username, String password) async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Search comics by title
  Future<List<Comic>> searchComicsByTitle(String title) async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query(
      'comics',
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );
    return List.generate(maps.length, (i) => Comic.fromMap(maps[i]));
  }

  // Insert a new comment
  Future<void> insertComment(Comment comment) async {
    if (_database == null) {
      await initDatabase();
    }
    await _database!.insert('comments', comment.toMap());
    await updateComicRating(comment.comicId); // Perbarui rating komik
  }

  // Get all comments for a specific comic
  Future<List<Comment>> getCommentsForComic(int comicId) async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query(
      'comments',
      where: 'comicId = ?',
      whereArgs: [comicId],
    );
    return List.generate(maps.length, (i) => Comment.fromMap(maps[i]));
  }

  // Get all comments
  Future<List<Comment>> getAllComments() async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query('comments');
    return List.generate(maps.length, (i) => Comment.fromMap(maps[i]));
  }

  // Update the average rating for a comic
  Future<void> updateComicRating(int comicId) async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.rawQuery(
      'SELECT AVG(rating) as averageRating FROM comments WHERE comicId = ?',
      [comicId],
    );
    final double averageRating = maps.first['averageRating'] ?? 0.0;
    await _database!.update(
      'comics',
      {'rating': averageRating},
      where: 'id = ?',
      whereArgs: [comicId],
    );
  }

  // Get the rating of a specific comic
  Future<double?> getComicRating(int comicId) async {
    if (_database == null) {
      await initDatabase();
    }
    final List<Map<String, dynamic>> maps = await _database!.query(
      'comics',
      columns: ['rating'],
      where: 'id = ?',
      whereArgs: [comicId],
    );
    if (maps.isNotEmpty) {
      return maps.first['rating'] as double?;
    }
    return null;
  }
}
