import 'package:dio/dio.dart';
import 'package:tv_db/src/constants/api.dart';
import 'package:tv_db/src/models/tv_episodes.dart';

class TvEpisodesProvider {
  final dio = Dio();

  Future<TvEpisodesModel> getEpisodes(int tvId, int seasonNo) async {
    try {
      final response = await dio.get(
          "$api_url/$tvId/season/$seasonNo?api_key=$api_key&language=en-US");

      final episodes = TvEpisodesModel.fromJson(response.data["episodes"]);

      return episodes;
    } catch (e) {
      return null;
    }
  }
}
