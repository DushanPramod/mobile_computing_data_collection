import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'data.mdl.dart';

class DB{
  Future<Database> initDB() async{
    return openDatabase(
      join(await getDatabasesPath(), 'MYDB.db'),
      onCreate: (db, version) {
        db.execute("""
        CREATE TABLE SubmitForm(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        formId TEXT NOT NULL,
        title TEXT NOT NULL,
        userId TEXT NOT NULL,
        createdDate TEXT NOT NULL,
        updatedDate TEXT NOT NULL
        )
        """);

        return db.execute("""
        CREATE TABLE SubmitFormData(
        submitFormId INTEGER NOT NULL,
        fieldName TEXT NOT NULL,
        data TEXT NOT NULL
        )
        """);
      },
      version: 1,
    );
  }

  Future<void> deleteTable() async {
    final Database db = await initDB();
    await db.delete('SubmitForm');
    await db.delete('SubmitFormData');
  }


  Future<void> insertForm(DbFormMdl form) async {
    final Database db = await initDB();
    await db.insert('SubmitForm', form.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertFormData(DbFormDataMdl formData) async {
    final Database db = await initDB();
    await db.insert('SubmitFormData', formData.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<DbFormMdl>> getForms() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('SubmitForm');

    return List.generate(maps.length, (i) {
      return DbFormMdl(
        id: maps[i]['id'],
        formId: maps[i]['formId'],
        title: maps[i]['title'],
        userId: maps[i]['userId'],
        createdDate: maps[i]['createdDate'],
        updatedDate: maps[i]['updatedDate'],
      );
    });
  }


  Future<List<DbFormDataMdl>> getFormData(int submitFormId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('SubmitFormData', where: 'submitFormId = ?', whereArgs: [submitFormId]);

    return List.generate(maps.length, (i) {
      return DbFormDataMdl(
          submitFormId: maps[i]['submitFormId'],
          fieldName: maps[i]['fieldName'],
          data: maps[i]['data']
      );
    });
  }
}