import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_state.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {
  MovieSearchCubit({required this.searchMovies})
      : super(const MovieSearchState());

  final SearchMovies searchMovies;

  Future<void> fetchMovieSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await searchMovies.execute(query);
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
