import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../dummy_data/dummy_objects.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      when(mockDatabaseHelper.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testTvTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      when(mockDatabaseHelper.insertWatchlistTv(testTvTable))
          .thenThrow(Exception());

      final call = dataSource.insertWatchlist(testTvTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      when(mockDatabaseHelper.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTvTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      when(mockDatabaseHelper.removeWatchlistTv(testTvTable))
          .thenThrow(Exception());

      final call = dataSource.removeWatchlist(testTvTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Tv Detail From DB', () {
    const tId = 100;

    test('should return Tv Table when data is found', () async {
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => testTvMap);

      final result = await dataSource.getTvById(tId);

      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getTvById(tId);

      expect(result, null);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TvTable from database', () async {
      when(mockDatabaseHelper.getWatchlistTvs())
          .thenAnswer((_) async => [testTvMap]);

      final result = await dataSource.getWatchlistTvs();

      expect(result, [testTvTable]);
    });
  });
}
