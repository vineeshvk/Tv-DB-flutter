import 'package:dio/dio.dart';
import 'package:tv_db/src/constants/api.dart';
import 'package:tv_db/src/models/tv_seasons.dart';

class TvSeasonsProvider {
  final dio = Dio();

  Future<TvSeasonsModel> getSeasons(int tvId) async {
    try {
      final response =
          await dio.get('$api_url/$tvId?api_key=$api_key&language=en-US');
      final seasons = TvSeasonsModel.fromJson(response.data["seasons"]);

      return seasons;
    } catch (e) {
      return null;
    }
  }
}
