import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailNotifier notifier;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late int listenerCallCount;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    listenerCallCount = 0;

    notifier = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchListStatusTv,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;

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
  final tTvs = <Tv>[tTv];

  void arrangeSuccess() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvs));
  }

  group('Fetch Tv Detail', () {
    test('should get data from usecases', () async {
      arrangeSuccess();

      await notifier.fetchTvDetail(tId);

      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when started', () {
      arrangeSuccess();

      notifier.fetchTvDetail(tId);

      expect(notifier.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should set data when loaded successfully', () async {
      arrangeSuccess();

      await notifier.fetchTvDetail(tId);

      expect(notifier.tvState, RequestState.Loaded);
      expect(notifier.tv, testTvDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation state to error when failed', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      await notifier.fetchTvDetail(tId);

      expect(notifier.recommendationState, RequestState.Error);
      expect(notifier.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetWatchListStatusTv.execute(tId))
          .thenAnswer((_) async => true);

      await notifier.loadWatchlistStatus(tId);

      expect(notifier.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => true);

      await notifier.addWatchlist(testTvDetail);

      verify(mockSaveWatchlistTv.execute(testTvDetail));
      expect(notifier.watchlistMessage, 'Added to Watchlist');
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Removed'));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      await notifier.removeFromWatchlist(testTvDetail);

      verify(mockRemoveWatchlistTv.execute(testTvDetail));
      expect(notifier.watchlistMessage, 'Removed');
    });

    test('should update watchlist message when add failed', () async {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatusTv.execute(testTvDetail.id))
          .thenAnswer((_) async => false);

      await notifier.addWatchlist(testTvDetail);

      expect(notifier.watchlistMessage, 'Failed');
    });
  });
}
