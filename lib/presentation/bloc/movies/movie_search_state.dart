import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class MovieSearchState extends Equatable {
  const MovieSearchState({
    this.state = RequestState.Empty,
    this.result = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> result;
  final String message;

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? result,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      result: result ?? this.result,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, result, message];
}
