import 'package:rxdart/rxdart.dart';
import 'package:tv_db/src/models/tv_seasons.dart';
import 'package:tv_db/src/repositories/tv_episodes.dart';
import 'package:tv_db/src/repositories/tv_seasons.dart';

class TvSeasonsBloc {
  final _tvSeasonsRepository = TvSeasonsRepository();
  final _seasonSubject = BehaviorSubject<TvSeasonsModel>();
  int _tvId;

  Future<void> getSeason(int tvId) async {
    if (tvId != _tvId) {
      _tvId = tvId;
      _seasonSubject.sink.add(null);

      final seasons = await _tvSeasonsRepository.getSeasons(tvId);
      seasons.seasons.asMap().forEach((index, season) async {
        final episodes =
            await TvEpisodesRepository().getEpisodes(tvId, season.seasonNo);
        seasons.seasons[index].episodes = episodes;
      });
      _seasonSubject.sink.add(seasons);
    }
  }

  ValueObservable<TvSeasonsModel> get seasonSubject => _seasonSubject.stream;

  dispose() {
    _seasonSubject.close();
  }
}

final seasonsBloc = TvSeasonsBloc();
