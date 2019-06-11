import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv_db/src/models/tv_list.dart';
import 'package:tv_db/src/repositories/tv_list.dart';

class TvListBloc {
  final String type;
  TvListModel _shows = TvListModel(shows: []);
  final _repository = TvListRepository();
  final _tvSubject = BehaviorSubject<TvListModel>();

  TvListBloc({@required this.type});

  Future<void> getShows(int page) async {
    final response = await _repository.getShows(page, type);
    if (response == null) {
      _tvSubject.sink.addError("Oops Something went wrong");
    } else {
      _shows.appendShows(response.shows);
      _tvSubject.sink.add(_shows);
    }
  }

  ValueObservable<TvListModel> get tvSubject => _tvSubject.stream;

  dispose() {
    _tvSubject.close();
  }
}

final popularBloc = TvListBloc(type: "popular");
final topRatedBloc = TvListBloc(type: "top_rated");
final todayBloc = TvListBloc(type: "on_the_air");
