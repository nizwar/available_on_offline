import 'model.dart';

class MovieItem extends Model {
  String popularity;
  String voteCount;
  String posterPath;
  int id;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  String title;
  String voteAverage;
  String overview;
  String releaseDate;

  MovieItem({
    this.popularity,
    this.voteCount,
    this.posterPath,
    this.id,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  factory MovieItem.fromJson(Map<String, dynamic> json) => MovieItem(
        popularity: json["popularity"] == null ? null : json["popularity"].toString(),
        voteCount: json["vote_count"] == null ? null : json["vote_count"].toString(),
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        id: json["id"] == null ? null : int.parse(json["id"].toString()),
        backdropPath: json["backdrop_path"] == null ? null : json["backdrop_path"],
        originalLanguage: json["original_language"] == null ? null : json["original_language"],
        originalTitle: json["original_title"] == null ? null : json["original_title"],
        title: json["title"] == null ? null : json["title"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"].toString(),
        overview: json["overview"] == null ? null : json["overview"],
        releaseDate: json["release_date"] == null ? null : json["release_date"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "popularity": popularity == null ? null : popularity,
        "vote_count": voteCount == null ? null : voteCount,
        "poster_path": posterPath == null ? null : posterPath,
        "id": id == null ? null : id,
        "backdrop_path": backdropPath == null ? null : backdropPath,
        "original_language": originalLanguage == null ? null : originalLanguage,
        "original_title": originalTitle == null ? null : originalTitle,
        "title": title == null ? null : title,
        "vote_average": voteAverage == null ? null : voteAverage,
        "overview": overview == null ? null : overview,
        "release_date": releaseDate == null ? null : releaseDate,
      };
}
