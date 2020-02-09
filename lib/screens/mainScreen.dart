import 'package:available_on_offline/https/moviesHttp.dart';
import 'package:available_on_offline/models/database/databaseEngine.dart';
import 'package:available_on_offline/models/database/movieDB.dart';
import 'package:available_on_offline/models/movieItem.dart';
import 'package:available_on_offline/resources/Environment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MovieDB _movieDB;
  int _page = 1;
  List<MovieItem> _items = [];
  bool _loading = true;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _initDB();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TheMovieDB"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: _refresh,
        onLoading: () async {
          _page++;
          _initDB();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(),
          child: _loading
              ? Container(
                  alignment: Alignment.center,
                  height: 250,
                  child: CircularProgressIndicator(),
                )
              : _items.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      height: 250,
                      child: Text("Something happen!"),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _items.map((item) {
                        print(item);
                        return ListTile(
                          title: Text(
                            item.title,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            item.overview,
                            maxLines: 3,
                          ),
                          leading: CachedNetworkImage(
                            imageUrl: Env.img780 + item.backdropPath.toString() ?? "",
                            width: 100,
                            errorWidget: (context, url, obj) {
                              return Image.network(
                                "https://bostonparkingspaces.com/wp-content/themes/classiera/images/nothumb/nothumb270x180.png",
                                width: 100,
                                fit: BoxFit.cover,
                              );
                            },
                            placeholder: (context, url) {
                              return Container(
                                width: 100,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
        ),
      ),
    );
  }

  Future _getMovieDB() async {
    return await MoviesHttp.getDiscover(_page);
  }

  void _refresh() async {
    _refreshController.refreshCompleted();
    setState(() {
      _loading = true;
    });
    _page = 1;
    _items.clear();
    _movieDB.deleteData();
    if ((await _getMovieDB()) != null) {
      _initDB();
      return;
    }
  }

  void _initDB() async {
    if (_movieDB == null) _movieDB = MovieDB(await DatabaseEngine.initDB());
    var raw = await _movieDB.getData(start: (_page - 1) * 10, limit: 10);
    if (raw.length == 0) {
      if (await _getMovieDB() != null) {
        _initDB();
        return;
      } else {
        _refresh();
        return;
      }
    } else {
      _items = List.from(_items ?? [])..addAll(raw ?? []);
    }
    setState(() {
      _loading = false;
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }
}
