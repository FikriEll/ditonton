import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tvs_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvsNotifier notifier;
  late MockGetPopularTvs mockGetPopularTvs;
  late int listenerCallCount;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    notifier = PopularTvsNotifier(mockGetPopularTvs)
      ..addListener(() {
        listenerCallCount += 1;
      });
    listenerCallCount = 0;
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
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(tTvList));

    notifier.fetchPopularTvs();

    expect(notifier.state, RequestState.Loading);
  });

  test('should set data and notify listeners on success', () async {
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(tTvList));

    await notifier.fetchPopularTvs();

    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvs, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should set error message on failure', () async {
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Failed')));

    await notifier.fetchPopularTvs();

    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Failed');
    expect(listenerCallCount, 2);
  });
}
