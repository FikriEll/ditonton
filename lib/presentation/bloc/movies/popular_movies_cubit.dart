import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_state.dart';

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit(this.getPopularMovies) : super(const PopularMoviesState());

  final GetPopularMovies getPopularMovies;

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularMovies.execute();
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
