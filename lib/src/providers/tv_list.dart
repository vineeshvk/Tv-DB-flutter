import 'package:dio/dio.dart';
import 'package:tv_db/src/constants/api.dart';
import 'package:tv_db/src/models/tv_list.dart';

class TvListProvider {
  final Dio dio = Dio();

  Future<TvListModel> getShows(int page, String type) async {
    try {
      final response = await dio
          .get('$api_url/$type?api_key=$api_key&language=en-US&page=$page');

      final shows = TvListModel.fromJson(response.data["results"]);
      return shows;
    } catch (e) {
      return null;
    }
  }
}
