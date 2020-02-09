import 'package:available_on_offline/models/database/databaseEngine.dart';
import 'package:available_on_offline/models/database/movieDB.dart';
import 'package:available_on_offline/models/movieItem.dart';
import 'package:available_on_offline/resources/Environment.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart';

class MoviesHttp {
  static Future<List<MovieItem>> getDiscover(int page) async {
    // try {
    MovieDB movieDB = MovieDB(await DatabaseEngine.initDB());
    var resp = await HttpConnection.doConnection(
      Env.endpoint + "discover/movie",
      body: {"api_key": Env.key, "page": page.toString()},
    );
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      List raw = resp.content.asJson()["results"];
      return raw.map((item) {
        var movieItem = MovieItem.fromJson(item);
        movieDB.insertData(movieItem);
        return movieItem;
      }).toList();
    }
    // } catch (e) {
    //   print(e);
    // }
  }
}
