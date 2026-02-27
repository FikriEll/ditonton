import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class TvListState extends Equatable {
  const TvListState({
    this.onTheAirState = RequestState.Empty,
    this.popularState = RequestState.Empty,
    this.topRatedState = RequestState.Empty,
    this.onTheAirTvs = const [],
    this.popularTvs = const [],
    this.topRatedTvs = const [],
    this.message = '',
  });

  final RequestState onTheAirState;
  final RequestState popularState;
  final RequestState topRatedState;
  final List<Tv> onTheAirTvs;
  final List<Tv> popularTvs;
  final List<Tv> topRatedTvs;
  final String message;

  TvListState copyWith({
    RequestState? onTheAirState,
    RequestState? popularState,
    RequestState? topRatedState,
    List<Tv>? onTheAirTvs,
    List<Tv>? popularTvs,
    List<Tv>? topRatedTvs,
    String? message,
  }) {
    return TvListState(
      onTheAirState: onTheAirState ?? this.onTheAirState,
      popularState: popularState ?? this.popularState,
      topRatedState: topRatedState ?? this.topRatedState,
      onTheAirTvs: onTheAirTvs ?? this.onTheAirTvs,
      popularTvs: popularTvs ?? this.popularTvs,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        onTheAirState,
        popularState,
        topRatedState,
        onTheAirTvs,
        popularTvs,
        topRatedTvs,
        message,
      ];
}
