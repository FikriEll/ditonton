import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:ditonton/data/models/tv_season_model.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('GenreModel fromJson toJson toEntity', () {
    final model = GenreModel.fromJson({'id': 1, 'name': 'Action'});
    expect(model.toJson(), {'id': 1, 'name': 'Action'});
    expect(model.toEntity().name, 'Action');
  });

  test('TvSeasonModel fromJson toJson toEntity', () {
    final model = TvSeasonModel.fromJson({
      'id': 10,
      'name': 'Season 1',
      'overview': 'ov',
      'episode_count': 8,
      'poster_path': '/a',
      'season_number': 1,
      'air_date': '2024-01-01',
    });

    expect(model.toJson()['id'], 10);
    expect(model.toEntity().seasonNumber, 1);
  });

  test('TvModel fromJson handles origin_country null and toEntity', () {
    final model = TvModel.fromJson({
      'backdrop_path': '/a',
      'genre_ids': [1, 2],
      'id': 100,
      'original_name': 'Original',
      'overview': 'overview',
      'popularity': 3,
      'poster_path': '/b',
      'first_air_date': '2023-01-01',
      'name': 'Name',
      'vote_average': 7.1,
      'vote_count': 11,
      'origin_country': null,
    });

    expect(model.originCountry, isEmpty);
    expect(model.toJson()['id'], 100);
    expect(model.toEntity().name, 'Name');
  });

  test('TvResponse fromJson and toJson', () {
    final response = TvResponse.fromJson({
      'results': [
        {
          'backdrop_path': '/a',
          'genre_ids': [1],
          'id': 1,
          'original_name': 'Original',
          'overview': 'overview',
          'popularity': 1,
          'poster_path': '/p',
          'first_air_date': '2023-01-01',
          'name': 'Name',
          'vote_average': 7,
          'vote_count': 10,
          'origin_country': ['US'],
        }
      ]
    });

    expect(response.tvList.length, 1);
    expect(response.toJson()['results'], isNotEmpty);
  });

  test('TvDetailResponse fromJson handles null seasons/runtime and toEntity',
      () {
    final response = TvDetailResponse.fromJson({
      'backdrop_path': '/a',
      'first_air_date': '2023-01-01',
      'genres': [
        {'id': 1, 'name': 'Action'}
      ],
      'id': 1,
      'name': 'Name',
      'number_of_episodes': 10,
      'number_of_seasons': 1,
      'overview': 'overview',
      'poster_path': '/p',
      'vote_average': 7,
      'vote_count': 10,
      'seasons': null,
      'episode_run_time': null,
    });

    expect(response.seasons, isEmpty);
    expect(response.episodeRunTime, isEmpty);
    expect(response.toJson()['id'], 1);
    expect(response.toEntity().name, 'Name');
  });

  test('TvTable fromEntity/fromMap/toJson/toEntity', () {
    final fromEntity = TvTable.fromEntity(testTvDetail);
    final fromMap = TvTable.fromMap(testTvMap);

    expect(fromEntity.id, testTvDetail.id);
    expect(fromMap.toJson()['name'], 'TV Title');
    expect(fromMap.toEntity().name, 'TV Title');
  });
}
