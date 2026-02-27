import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_state.dart';

class TvSearchCubit extends Cubit<TvSearchState> {
  TvSearchCubit({required this.searchTvs}) : super(const TvSearchState());

  final SearchTvs searchTvs;

  Future<void> fetchTvSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await searchTvs.execute(query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          result: data,
        ),
      ),
    );
  }
}
