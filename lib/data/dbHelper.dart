import 'package:contacs_app/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Contact.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE contact(id INTEGER PRIMARY KEY,name TEXT,phoneNumber TEXT,avatar TEXT)");
  }

  Future<List<Contact>> getContacts() async {
    var dbClient = await db;
    var result = await dbClient.query("Contact", orderBy: "name");
    return result.map((data) => Contact.toObject(data)).toList();
  }

  Future<int> insertContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.insert("Contact", contact.toMap());
  }

  Future<int> updateContact(Contact contact) async {
    var dbClient = await db;
    return await dbClient.update("Contact", contact.toMap(),
        where: "id=?", whereArgs: [contact.id]);
  }

  Future<void> removeContact(int id) async {
    var dbClient = await db;
    return await dbClient.delete("Contact", where: "id=?", whereArgs: [id]);
  }
}