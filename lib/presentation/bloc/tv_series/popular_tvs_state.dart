import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class PopularTvsState extends Equatable {
  const PopularTvsState({
    this.state = RequestState.Empty,
    this.tvs = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Tv> tvs;
  final String message;

  PopularTvsState copyWith({
    RequestState? state,
    List<Tv>? tvs,
    String? message,
  }) {
    return PopularTvsState(
      state: state ?? this.state,
      tvs: tvs ?? this.tvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, tvs, message];
}
