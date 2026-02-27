import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_state.dart';

class TvListCubit extends Cubit<TvListState> {
  TvListCubit({
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(const TvListState());

  final GetOnTheAirTvs getOnTheAirTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  Future<void> fetchOnTheAirTvs() async {
    emit(state.copyWith(onTheAirState: RequestState.Loading));
    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          onTheAirState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          onTheAirState: RequestState.Loaded,
          onTheAirTvs: data,
        ),
      ),
    );
  }

  Future<void> fetchPopularTvs() async {
    emit(state.copyWith(popularState: RequestState.Loading));
    final result = await getPopularTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          popularState: RequestState.Loaded,
          popularTvs: data,
        ),
      ),
    );
  }

  Future<void> fetchTopRatedTvs() async {
    emit(state.copyWith(topRatedState: RequestState.Loading));
    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          topRatedState: RequestState.Loaded,
          topRatedTvs: data,
        ),
      ),
    );
  }
}
