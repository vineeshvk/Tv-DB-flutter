import 'package:tv_db/src/models/tv_seasons.dart';
import 'package:tv_db/src/providers/tv_seasons.dart';

class TvSeasonsRepository {
  TvSeasonsProvider tvSeasonsProvider = TvSeasonsProvider();

  Future<TvSeasonsModel> getSeasons(int tvId) async {
    final seasons = await tvSeasonsProvider.getSeasons(tvId);
    return seasons;
  }
}
