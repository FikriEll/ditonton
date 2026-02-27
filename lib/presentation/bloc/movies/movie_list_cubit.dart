import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState());

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchNowPlayingMovies() async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading));
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: data,
        ),
      ),
    );
  }

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(popularState: RequestState.Loading));
    final result = await getPopularMovies.execute();
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
          popularMovies: data,
        ),
      ),
    );
  }

  Future<void> fetchTopRatedMovies() async {
    emit(state.copyWith(topRatedState: RequestState.Loading));
    final result = await getTopRatedMovies.execute();
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
          topRatedMovies: data,
        ),
      ),
    );
  }
}
