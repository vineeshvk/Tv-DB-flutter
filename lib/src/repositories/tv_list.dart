import 'package:tv_db/src/models/tv_list.dart';
import 'package:tv_db/src/providers/tv_list.dart';

class TvListRepository {
  TvListProvider tvListProvider = TvListProvider();

  Future<TvListModel> getShows(int page, String type) {
    return tvListProvider.getShows(page, type);
  }
}
