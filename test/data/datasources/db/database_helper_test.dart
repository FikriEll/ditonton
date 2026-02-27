import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String databasePath;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = await getDatabasesPath();
    databasePath = '$path/ditonton.db';
  });

  tearDown(() async {
    await DatabaseHelper.resetForTesting();
    await deleteDatabase(databasePath);
  });

  test('factory returns singleton instance', () {
    final first = DatabaseHelper();
    final second = DatabaseHelper();
    expect(identical(first, second), isTrue);
  });

  test('creates database and performs movie watchlist CRUD', () async {
    final helper = DatabaseHelper();

    final db = await helper.database;
    expect(db, isNotNull);

    final insertResult = await helper.insertWatchlist(testMovieTable);
    expect(insertResult, 1);

    final movie = await helper.getMovieById(testMovieTable.id);
    expect(movie, isNotNull);
    expect(movie!['title'], testMovieTable.title);

    final movies = await helper.getWatchlistMovies();
    expect(movies.length, 1);

    final deleteResult = await helper.removeWatchlist(testMovieTable);
    expect(deleteResult, 1);

    final deletedMovie = await helper.getMovieById(testMovieTable.id);
    expect(deletedMovie, isNull);
  });

  test('creates database and performs tv watchlist CRUD', () async {
    final helper = DatabaseHelper();

    final insertResult = await helper.insertWatchlistTv(testTvTable);
    expect(insertResult, 100);

    final tv = await helper.getTvById(testTvTable.id);
    expect(tv, isNotNull);
    expect(tv!['name'], testTvTable.name);

    final tvs = await helper.getWatchlistTvs();
    expect(tvs.length, 1);

    final deleteResult = await helper.removeWatchlistTv(testTvTable);
    expect(deleteResult, 1);

    final deletedTv = await helper.getTvById(testTvTable.id);
    expect(deletedTv, isNull);
  });

  test('runs migration from v1 to v2 and creates tv watchlist table', () async {
    final oldDb = await openDatabase(
      databasePath,
      version: 1,
      singleInstance: false,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE watchlist (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT
          );
        ''');
      },
    );
    await oldDb.close();

    final helper = DatabaseHelper();
    await helper.database;

    final insertResult = await helper.insertWatchlistTv(testTvTable);
    expect(insertResult, 100);
  });
}
