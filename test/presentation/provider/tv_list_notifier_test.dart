import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTvs,
  GetPopularTvs,
  GetTopRatedTvs,
])
void main() {
  late TvListNotifier notifier;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late int listenerCallCount;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    listenerCallCount = 0;

    notifier = TvListNotifier(
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    )..addListener(() {
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

  group('On The Air TVs', () {
    test('should change state to loading when fetching', () {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));

      notifier.fetchOnTheAirTvs();

      expect(notifier.onTheAirState, RequestState.Loading);
    });

    test('should set data when fetch success', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));

      await notifier.fetchOnTheAirTvs();

      expect(notifier.onTheAirState, RequestState.Loaded);
      expect(notifier.onTheAirTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should set error message when fetch fails', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await notifier.fetchOnTheAirTvs();

      expect(notifier.onTheAirState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Popular TVs', () {
    test('should change state to loading when fetching', () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));

      notifier.fetchPopularTvs();

      expect(notifier.popularTvsState, RequestState.Loading);
    });

    test('should set data when fetch success', () async {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));

      await notifier.fetchPopularTvs();

      expect(notifier.popularTvsState, RequestState.Loaded);
      expect(notifier.popularTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should set error message when fetch fails', () async {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await notifier.fetchPopularTvs();

      expect(notifier.popularTvsState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Top Rated TVs', () {
    test('should change state to loading when fetching', () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));

      notifier.fetchTopRatedTvs();

      expect(notifier.topRatedTvsState, RequestState.Loading);
    });

    test('should set data when fetch success', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));

      await notifier.fetchTopRatedTvs();

      expect(notifier.topRatedTvsState, RequestState.Loaded);
      expect(notifier.topRatedTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should set error message when fetch fails', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await notifier.fetchTopRatedTvs();

      expect(notifier.topRatedTvsState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
