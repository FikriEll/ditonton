import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_season_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvModel = TvModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2],
    id: 100,
    originalName: 'Original Name',
    overview: 'Overview TV',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: '2021-09-17',
    name: 'TV Title',
    voteAverage: 8,
    voteCount: 100,
    originCountry: const ['US'],
  );

  final tTv = Tv(
    adult: null,
    backdropPath: 'backdropPath',
    genreIds: [1, 2],
    id: 100,
    originalName: 'Original Name',
    overview: 'Overview TV',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: '2021-09-17',
    name: 'TV Title',
    voteAverage: 8,
    voteCount: 100,
    originCountry: const ['US'],
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  final tTvDetailResponse = TvDetailResponse(
    backdropPath: 'backdropPath',
    firstAirDate: '2021-09-17',
    genres: [],
    id: 100,
    name: 'TV Title',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    overview: 'Overview TV',
    posterPath: 'posterPath',
    voteAverage: 8,
    voteCount: 100,
    seasons: const [
      TvSeasonModel(
        id: 1001,
        name: 'Season 1',
        overview: 'Season Overview',
        episodeCount: 10,
        posterPath: 'posterPath',
        seasonNumber: 1,
        airDate: '2021-09-17',
      ),
    ],
    episodeRunTime: const [50],
  );

  group('On The Air Tvs', () {
    test('should return tv list when call to remote data source is success',
        () async {
      when(mockRemoteDataSource.getOnTheAirTvs())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getOnTheAirTvs();

      verify(mockRemoteDataSource.getOnTheAirTvs());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return server failure when call to remote data source fails',
        () async {
      when(mockRemoteDataSource.getOnTheAirTvs()).thenThrow(ServerException());

      final result = await repository.getOnTheAirTvs();

      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device not connected to internet',
        () async {
      when(mockRemoteDataSource.getOnTheAirTvs())
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getOnTheAirTvs();

      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Detail', () {
    const tId = 100;

    test('should return Tv data when the call is successful', () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvDetailResponse);

      final result = await repository.getTvDetail(tId);

      expect(result, equals(Right(tTvDetailResponse.toEntity())));
    });

    test('should return server failure when the call is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(ServerException());

      final result = await repository.getTvDetail(tId);

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when network is unavailable',
        () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTvDetail(tId);

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Popular and Top Rated Tvs', () {
    test('should return popular tv list when remote call succeeds', () async {
      when(mockRemoteDataSource.getPopularTvs())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTvs();

      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return server failure on popular tv failure', () async {
      when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());

      final result = await repository.getPopularTvs();

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return top rated tv list when remote call succeeds', () async {
      when(mockRemoteDataSource.getTopRatedTvs())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTopRatedTvs();

      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return connection failure on top rated failure', () async {
      when(mockRemoteDataSource.getTopRatedTvs())
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTopRatedTvs();

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Recommendations and Search', () {
    test('should return tv recommendations when remote call succeeds',
        () async {
      when(mockRemoteDataSource.getTvRecommendations(100))
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTvRecommendations(100);

      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return server failure when recommendations fail', () async {
      when(mockRemoteDataSource.getTvRecommendations(100))
          .thenThrow(ServerException());

      final result = await repository.getTvRecommendations(100);

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return searched tv list when remote call succeeds', () async {
      when(mockRemoteDataSource.searchTvs('query'))
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.searchTvs('query');

      expect(result.getOrElse(() => []), tTvList);
    });

    test('should return connection failure when search fails', () async {
      when(mockRemoteDataSource.searchTvs('query'))
          .thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.searchTvs('query');

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Watchlist', () {
    test('should return watchlist status true when tv is found', () async {
      when(mockLocalDataSource.getTvById(100))
          .thenAnswer((_) async => testTvTable);

      final result = await repository.isAddedToWatchlist(100);

      expect(result, true);
    });

    test('should save to watchlist when call to datasource is success',
        () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return database failure when save watchlist fails', () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException('db error'));

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('db error')));
    });

    test(
        'should throw unknown exception when save watchlist fails unexpectedly',
        () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(Exception('unknown'));

      expect(
        () => repository.saveWatchlist(testTvDetail),
        throwsA(isA<Exception>()),
      );
    });

    test('should remove from watchlist when call to datasource is success',
        () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Right('Removed from Watchlist'));
    });

    test('should return database failure when remove watchlist fails',
        () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException('db remove error'));

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure('db remove error')));
    });

    test('should return watchlist status false when tv is not found', () async {
      when(mockLocalDataSource.getTvById(100)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(100);

      expect(result, false);
    });

    test('should return watchlist tv list from local data source', () async {
      when(mockLocalDataSource.getWatchlistTvs())
          .thenAnswer((_) async => [testTvTable]);

      final result = await repository.getWatchlistTvs();

      expect(result.getOrElse(() => []), [testWatchlistTv]);
    });
  });
}
