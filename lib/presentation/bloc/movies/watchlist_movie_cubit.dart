import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_state.dart';

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  WatchlistMovieCubit({required this.getWatchlistMovies})
      : super(const WatchlistMovieState());

  final GetWatchlistMovies getWatchlistMovies;

  Future<void> fetchWatchlistMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getWatchlistMovies.execute();
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
