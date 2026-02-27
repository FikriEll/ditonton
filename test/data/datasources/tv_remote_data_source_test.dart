import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get on the air tvs', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/on_the_air_tv.json')))
        .tvList;

    test('should return list of TV Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/on_the_air_tv.json'), 200));

      final result = await dataSource.getOnTheAirTvs();

      expect(result, equals(tTvList));
    });

    test('should throw a ServerException when the response code is other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getOnTheAirTvs();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get popular tvs', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/popular_tv.json')))
        .tvList;

    test('should return list of tvs when response is success (200)', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular_tv.json'), 200));

      final result = await dataSource.getPopularTvs();

      expect(result, tTvList);
    });

    test('should throw a ServerException when the response code is other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTvs();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get top rated tvs', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tv.json')))
        .tvList;

    test('should return list of tvs when response code is 200 ', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200));

      final result = await dataSource.getTopRatedTvs();

      expect(result, tTvList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTvs();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    const tId = 100;
    final tTvDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));

      final result = await dataSource.getTvDetail(tId);

      expect(result, equals(tTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvDetail(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tTvList = TvResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    const tId = 100;

    test('should return list of TV Model when the response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));

      final result = await dataSource.getTvRecommendations(tId);

      expect(result, equals(tTvList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvRecommendations(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tvs', () {
    final tSearchResult = TvResponse.fromJson(
            json.decode(readJson('dummy_data/search_tv.json')))
        .tvList;
    const tQuery = 'spiderman';

    test('should return list of tvs when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/search_tv.json'), 200));

      final result = await dataSource.searchTvs(tQuery);

      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTvs(tQuery);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
