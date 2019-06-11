import 'package:tv_db/src/models/tv_episodes.dart';

class SeasonModel {
  final DateTime airDate;
  final int episodeCount, seasonNo;
  final String name;
  TvEpisodesModel episodes;

  SeasonModel(
      {this.episodes,
      this.airDate,
      this.episodeCount,
      this.name,
      this.seasonNo});

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
        airDate: DateTime.parse(json["air_date"]),
        episodeCount: json["episode_count"],
        seasonNo: json["season_number"],
        name: json["name"]);
  }
}

class TvSeasonsModel {
  final List<SeasonModel> seasons;

  TvSeasonsModel({this.seasons});

  factory TvSeasonsModel.fromJson(List<dynamic> json) {
    final seasons = json.map((item) => SeasonModel.fromJson(item)).toList();
    return TvSeasonsModel(seasons: seasons);
  }
}

/*
"air_date": "1985-12-30",
      "episode_count": 6,
      "id": 2328143,
      "name": "Season 1",
      "overview": "",
      "poster_path": "/bisvcIK9xIE0whLvPb2hQpfbfw9.jpg",
      "season_number": 1
 */
