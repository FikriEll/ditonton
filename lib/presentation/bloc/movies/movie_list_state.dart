import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class MovieListState extends Equatable {
  const MovieListState({
    this.nowPlayingState = RequestState.Empty,
    this.popularState = RequestState.Empty,
    this.topRatedState = RequestState.Empty,
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.message = '',
  });

  final RequestState nowPlayingState;
  final RequestState popularState;
  final RequestState topRatedState;
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final String message;

  MovieListState copyWith({
    RequestState? nowPlayingState,
    RequestState? popularState,
    RequestState? topRatedState,
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    String? message,
  }) {
    return MovieListState(
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularState: popularState ?? this.popularState,
      topRatedState: topRatedState ?? this.topRatedState,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        nowPlayingState,
        popularState,
        topRatedState,
        nowPlayingMovies,
        popularMovies,
        topRatedMovies,
        message,
      ];
}
