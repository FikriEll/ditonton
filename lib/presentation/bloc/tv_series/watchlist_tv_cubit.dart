import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_state.dart';

class WatchlistTvCubit extends Cubit<WatchlistTvState> {
  WatchlistTvCubit({required this.getWatchlistTvs})
      : super(const WatchlistTvState());

  final GetWatchlistTvs getWatchlistTvs;

  Future<void> fetchWatchlistTvs() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvs) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          tvs: tvs,
        ),
      ),
    );
  }
}
