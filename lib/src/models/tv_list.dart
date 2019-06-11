class TvModel {
  final String posterPath, overview, name;
  final double vote;
  final List<String> genres;
  final int id;

  TvModel(
      {this.id,
      this.posterPath,
      this.overview,
      this.name,
      this.vote,
      this.genres});

  factory TvModel.fromJson(Map<String, dynamic> json) {
    List genreIds = json["genre_ids"];
    List<String> genres = [];

    genreIds.forEach((id) {
      String genre = GENRE_LIST[id];
      if (genre != null) genres.add(genre);
    });

    return TvModel(
        id: json["id"],
        posterPath: json["poster_path"],
        overview: json["overview"],
        vote: json["vote_average"].toDouble(),
        name: json["name"],
        genres: genres);
  }
}

class TvListModel {
  List<TvModel> shows;

  TvListModel({this.shows});

  factory TvListModel.fromJson(List<dynamic> json) {
    final shows = json?.map((show) => TvModel.fromJson(show)) ?? [];
    return TvListModel(shows: shows.toList());
  }

  appendShows(List<TvModel> data) {
    shows.addAll(data);
  }
}

const GENRE_LIST = {
  10759: "Action & Adventure",
  16: "Animation",
  35: "Comedy",
  80: "Crime",
  99: "Documentary",
  18: "Drama",
  10751: "Family",
  10762: "Kids",
  9648: "Mystery",
  10763: "News",
  10764: "Reality",
  10765: "Sci-Fi & Fantasy",
  10766: "Soap",
  10767: "Talk",
  10768: "War & Politics",
  37: "Western"
};
