import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  TopRatedMoviesCubit({required this.getTopRatedMovies})
      : super(const TopRatedMoviesState());

  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchTopRatedMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (movies) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          movies: movies,
        ),
      ),
    );
  }
}
