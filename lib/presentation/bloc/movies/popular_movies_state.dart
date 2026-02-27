import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class PopularMoviesState extends Equatable {
  const PopularMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  PopularMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}
