import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    budget: 1000000,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://example.com',
    id: 1,
    imdbId: 'tt1234567',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    releaseDate: '2020-05-05',
    revenue: 2000000,
    runtime: 120,
    status: 'Released',
    tagline: 'Tagline',
    title: 'Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 1000,
  );

  final tMovieDetailEntity = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    releaseDate: '2020-05-05',
    runtime: 120,
    title: 'Title',
    voteAverage: 8.0,
    voteCount: 1000,
  );

  test('fromJson should return a valid model', () {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    final result = MovieDetailResponse.fromJson(jsonMap);
    expect(result.id, tMovieDetailModel.id);
    expect(result.title, tMovieDetailModel.title);
    expect(result.runtime, tMovieDetailModel.runtime);
    expect(result.genres.first.name, 'Action');
  });

  test('toJson should return proper map', () {
    final result = tMovieDetailModel.toJson();
    expect(result['id'], 1);
    expect(result['genres'], [
      {'id': 1, 'name': 'Action'}
    ]);
    expect(result['title'], 'Title');
    expect(result['vote_average'], 8.0);
  });

  test('toEntity should convert model to entity', () {
    final result = tMovieDetailModel.toEntity();
    expect(result, tMovieDetailEntity);
  });
}
