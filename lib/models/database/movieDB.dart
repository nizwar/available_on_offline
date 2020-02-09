import 'package:available_on_offline/models/database/databaseEngine.dart';
import 'package:available_on_offline/models/movieItem.dart';
import 'package:sqflite/sqlite_api.dart';

class MovieDB extends DatabaseEngine<MovieItem> {
  MovieDB(Database database) : super(database, "movies");
}
