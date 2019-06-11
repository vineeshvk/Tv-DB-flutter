import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:tv_db/src/models/tv_list.dart';
import 'package:tv_db/src/repositories/tv_search.dart';

class TvSearchBloc {
  final tvSearchRepository = TvSearchRepository();
  final _searchSubject = BehaviorSubject<TvListModel>();

  Future<void> getSearch(String query) async {
    final shows = await tvSearchRepository.getSearch(query);
    _searchSubject.sink.add(shows);
  }

  ValueObservable<TvListModel> get searchSubject => _searchSubject.stream;

  dispose() {
    _searchSubject.close();
  }
}

final searchBloc = TvSearchBloc();
