import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tvs_state.dart';

class PopularTvsCubit extends Cubit<PopularTvsState> {
  PopularTvsCubit(this.getPopularTvs) : super(const PopularTvsState());

  final GetPopularTvs getPopularTvs;

  Future<void> fetchPopularTvs() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularTvs.execute();
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
