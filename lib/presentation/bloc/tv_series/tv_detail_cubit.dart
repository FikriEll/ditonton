import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_detail_state.dart';

class TvDetailCubit extends Cubit<TvDetailState> {
  TvDetailCubit({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  Future<void> fetchTvDetail(int id) async {
    emit(state.copyWith(tvState: RequestState.Loading));
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);

    await detailResult.fold(
      (failure) async => emit(
        state.copyWith(
          tvState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tv) async {
        emit(
          state.copyWith(
            tvState: RequestState.Loading,
            recommendationState: RequestState.Loading,
            tv: tv,
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
              tvState: RequestState.Loaded,
            ),
          ),
          (tvs) => emit(
            state.copyWith(
              recommendationState: RequestState.Loaded,
              recommendations: tvs,
              tvState: RequestState.Loaded,
            ),
          ),
        );
      },
    );
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (message) => emit(state.copyWith(watchlistMessage: message)),
    );
    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
