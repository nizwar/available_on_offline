import 'package:available_on_offline/models/model.dart';
import 'package:available_on_offline/models/movieItem.dart'; 
import 'package:sqflite/sqflite.dart';

abstract class DatabaseEngine<T extends Model> {
  final Database database;
  final String table;

  DatabaseEngine(this.database, this.table);

  // DatabaseEngine({@required this.context, @required this.database, @required this.table});

  Future<List<T>> getData({int start = 0, int limit = 10}) async {
    return database.query(table, limit: limit, offset: start).then((_) {
      if (T.toString() == "MovieItem") return _.map((item) => MovieItem.fromJson(item)).toList().cast<T>();
      return _.toList().cast<T>();
    });
  }

  Future<int> insertData(T data) async {
    return await database.insert(table, data.toJson());
  }

  Future<int> deleteData({T data}) async {
    return await database.delete(table, where: data != null ? "id = ?" : null, whereArgs: data != null ? data.toJson()["id"] : null);
  }

  static Future<Database> initDB() async {
    Database output = await openDatabase(await getDatabasesPath() + "/movieDB", onCreate: (db, version) {
      db.execute("""
      CREATE TABLE movies (
        id TEXT PRIMARY KEY,
        popularity TEXT,
        vote_count TEXT,
        backdrop_path TEXT,
        poster_path TEXT,
        original_language TEXT,
        original_title TEXT,
        title TEXT,
        vote_average TEXT,
        overview TEXT,
        release_date TEXT
      );
    """);
    }, version: 2);

    return output;
  }
}
