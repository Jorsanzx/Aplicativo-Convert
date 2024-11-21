import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

Map<int, String> scripts = {
  1: ''' CREATE TABLE usuarios (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome CHAR(50) NOT NULL UNIQUE,
  email CHAR(50) NOT NULL UNIQUE,
  senha CHAR(16) NOT NULL
  );
'''
};

class SqliteDatabase {
  static Database? db;

  Future<Database> obterDataBase() async {
    if (db == null) {
      return await iniciarBancoDeDados();
    } else {
      return db!;
    }
  }

  // Inicia o banco de dados e roda o Map script caso tenha feita alteração, serve também para roda o script pela primeira vez
  Future<Database> iniciarBancoDeDados() async {
    var db = openDatabase(path.join(await getDatabasesPath(), 'database.db'),
        version: scripts.length, onCreate: (Database db, int version) async {
      for (var i = 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        print(scripts[i]!);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        print(scripts[i]!);
      }
    });
    return db;
  }
}
