import 'package:tv_db/src/models/tv_episodes.dart';
import 'package:tv_db/src/providers/tv_episodes.dart';

class TvEpisodesRepository {
  final TvEpisodesProvider tvEpisodesProvider = TvEpisodesProvider();

  Future<TvEpisodesModel> getEpisodes(int tvId, int seasonNo) async {
    final episodes = await tvEpisodesProvider.getEpisodes(tvId, seasonNo);
    return episodes;
  }
}
