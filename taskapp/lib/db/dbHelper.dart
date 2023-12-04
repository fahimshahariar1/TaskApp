import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DbHelper{
  static Database? db;
  static final int version = 1;
  static final String tableName ="task";

  static Future<void>initDb()async {

    if(db != null){
      return;
    }
    try{
      String path = await getDatabasesPath() + "task.db";
      db = await openDatabase(path, version: version, onCreate: (db, version){
        
        return db.execute("CREATE TABEL $tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title STRING, note TEXT,date STRING,"
            "remind INTEGER, repeat STRING,"
            "color INTEGER,"
            "isCompleted INTEGER)",
        );
      }
      );
    }catch (e){

    }
  }

  static Future<int?> insert(Task? task)async{
    return await db?.insert(tableName, task!.toJson())??1;
  }

}