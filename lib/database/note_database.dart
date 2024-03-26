import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app1/models/note.dart'; // Pastikan path ini benar

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${NoteFields.description} (
        ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${NoteFields.isImportant} INTEGER NOT NULL,
        ${NoteFields.number} INTEGER NOT NULL,
        ${NoteFields.title} TEXT NOT NULL,
        ${NoteFields.description} TEXT NOT NULL,
        ${NoteFields.time} TEXT NOT NULL
      )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await database;
    final id = await db.insert(NoteFields.description, note.toJson());
    return note.copyC(id: id); // Perubahan di sini
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query(NoteFields.description);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> getNoteById(int id) async {
    final db = await database;
    final result = await db.query(
      NoteFields.description,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Note.fromJson(result.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> deleteNoteById(int id) async {
    final db = await database;
    return await db.delete(
      NoteFields.description,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      NoteFields.description,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }
}
