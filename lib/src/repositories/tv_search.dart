import 'package:tv_db/src/models/tv_list.dart';
import 'package:tv_db/src/providers/tv_search.dart';

class TvSearchRepository {
  final tvSearchProvider = TvSearchProvider();

  Future<TvListModel> getSearch(String query) async {
    final shows = await tvSearchProvider.getSearch(query);
    return shows;
  }
}
