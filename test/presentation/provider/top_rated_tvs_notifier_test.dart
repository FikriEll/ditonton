import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tvs_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvsNotifier notifier;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late int listenerCallCount;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    listenerCallCount = 0;
    notifier = TopRatedTvsNotifier(getTopRatedTvs: mockGetTopRatedTvs)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(
    adult: null,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: '2020-01-01',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
    originCountry: const ['US'],
  );
  final tTvList = <Tv>[tTv];

  test('should change state to loading when fetching', () async {
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Right(tTvList));

    notifier.fetchTopRatedTvs();

    expect(notifier.state, RequestState.Loading);
  });

  test('should set data and notify listeners on success', () async {
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Right(tTvList));

    await notifier.fetchTopRatedTvs();

    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvs, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should set error message on failure', () async {
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Failed')));

    await notifier.fetchTopRatedTvs();

    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Failed');
    expect(listenerCallCount, 2);
  });
}
