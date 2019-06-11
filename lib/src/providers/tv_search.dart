import 'package:dio/dio.dart';
import 'package:tv_db/src/constants/api.dart';
import 'package:tv_db/src/models/tv_list.dart';

class TvSearchProvider {
  final dio = Dio();

  Future<TvListModel> getSearch(String query) async {
    try {
      final queryText = query.split(' ').join('%20');

      final response = await dio.get(
        "$search_url?api_key=$api_key&language=en-US&query=$queryText",
      );

      final shows = TvListModel.fromJson(response.data["results"]);
      return shows;
    } catch (e) {
      return null;
    }
  }
}
