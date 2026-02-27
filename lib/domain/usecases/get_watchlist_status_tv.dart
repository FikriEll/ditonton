import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListStatusTv {
  GetWatchListStatusTv(this.repository);

  final TvRepository repository;

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlist(id);
  }
}
