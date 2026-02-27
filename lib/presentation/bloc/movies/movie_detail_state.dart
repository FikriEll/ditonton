import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.movieState = RequestState.Empty,
    this.recommendationState = RequestState.Empty,
    this.movie,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
  });

  final RequestState movieState;
  final RequestState recommendationState;
  final MovieDetail? movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;

  MovieDetailState copyWith({
    RequestState? movieState,
    RequestState? recommendationState,
    MovieDetail? movie,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return MovieDetailState(
      movieState: movieState ?? this.movieState,
      recommendationState: recommendationState ?? this.recommendationState,
      movie: movie ?? this.movie,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        movieState,
        recommendationState,
        movie,
        recommendations,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}
