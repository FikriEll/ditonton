import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvNotifier notifier;
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  late int listenerCallCount;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    notifier = WatchlistTvNotifier(getWatchlistTvs: mockGetWatchlistTvs)
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

  test('should change state to loading when fetching watchlist', () async {
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => Right(tTvList));

    notifier.fetchWatchlistTvs();

    expect(notifier.watchlistState, RequestState.Loading);
  });

  test('should return tv list when data is gotten successfully', () async {
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => Right(tTvList));

    await notifier.fetchWatchlistTvs();

    expect(notifier.watchlistState, RequestState.Loaded);
    expect(notifier.watchlistTvs, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should set error message when fetch fails', () async {
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => Left(DatabaseFailure('Failed')));

    await notifier.fetchWatchlistTvs();

    expect(notifier.watchlistState, RequestState.Error);
    expect(notifier.message, 'Failed');
    expect(listenerCallCount, 2);
  });
}
