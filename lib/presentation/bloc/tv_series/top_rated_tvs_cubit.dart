import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tvs_state.dart';

class TopRatedTvsCubit extends Cubit<TopRatedTvsState> {
  TopRatedTvsCubit({required this.getTopRatedTvs})
      : super(const TopRatedTvsState());

  final GetTopRatedTvs getTopRatedTvs;

  Future<void> fetchTopRatedTvs() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedTvs.execute();
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
