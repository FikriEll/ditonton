import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class TvSearchState extends Equatable {
  const TvSearchState({
    this.state = RequestState.Empty,
    this.result = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Tv> result;
  final String message;

  TvSearchState copyWith({
    RequestState? state,
    List<Tv>? result,
    String? message,
  }) {
    return TvSearchState(
      state: state ?? this.state,
      result: result ?? this.result,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, result, message];
}
