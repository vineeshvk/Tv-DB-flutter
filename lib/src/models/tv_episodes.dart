class EpisodeModel {
  final String airDate;
  final int episodeNo, id;
  final String name;

  EpisodeModel({this.airDate, this.episodeNo, this.id, this.name});

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
        airDate: json["air_date"],
        episodeNo: json["episode_number"],
        name: json["name"]);
  }
}

class TvEpisodesModel {
  final List<EpisodeModel> episodes;

  TvEpisodesModel({this.episodes});

  factory TvEpisodesModel.fromJson(List json) {
    final episodes = json?.map((item) => EpisodeModel.fromJson(item))?.toList();
    return TvEpisodesModel(episodes: episodes);
  }
}
