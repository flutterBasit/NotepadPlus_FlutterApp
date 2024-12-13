import 'package:note_pad/Models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  // Initializing the database
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Notes.db');
    var db = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  // Creating the table
  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes(Id INTEGER PRIMARY KEY AUTOINCREMENT, Image TEXT, Title TEXT NOT NULL, Description TEXT NOT NULL, DateAndTime TEXT NOT NULL)");
  }

  // Handling database upgrades
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("ALTER TABLE notes ADD COLUMN Image TEXT");
    }
  }

  // Insert a new note
  Future<NotesModel> insert(NotesModel notesmodel) async {
    var dbClient = await db;
    await dbClient!.insert('notes', notesmodel.toMap());
    return notesmodel;
  }

  // Get the list of notes
  Future<List<NotesModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> QueryResult =
        await dbClient!.query('notes');
    return QueryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  // Delete a note
  Future<int> Delete(int id) async {
    var dbClient = await db;
    return dbClient!.delete('notes', where: 'Id = ?', whereArgs: [id]);
  }

  // Update a note
  Future<int> update(NotesModel notesmodel) async {
    var dbClient = await db;
    return await dbClient!.update('notes', notesmodel.toMap(),
        where: 'Id = ?', whereArgs: [notesmodel.Id]);
  }
}
