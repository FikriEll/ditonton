import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailState extends Equatable {
  const TvDetailState({
    this.tvState = RequestState.Empty,
    this.recommendationState = RequestState.Empty,
    this.tv,
    this.recommendations = const [],
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
    this.message = '',
  });

  final RequestState tvState;
  final RequestState recommendationState;
  final TvDetail? tv;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;

  TvDetailState copyWith({
    RequestState? tvState,
    RequestState? recommendationState,
    TvDetail? tv,
    List<Tv>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return TvDetailState(
      tvState: tvState ?? this.tvState,
      recommendationState: recommendationState ?? this.recommendationState,
      tv: tv ?? this.tv,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        tvState,
        recommendationState,
        tv,
        recommendations,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}
