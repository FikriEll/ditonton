import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/search_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_cubits_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTvs,
  GetPopularTvs,
  GetTopRatedTvs,
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  SearchTvs,
  GetWatchlistTvs,
])
void main() {
  group('TvListCubit', () {
    late MockGetOnTheAirTvs mockGetOnTheAirTvs;
    late MockGetPopularTvs mockGetPopularTvs;
    late MockGetTopRatedTvs mockGetTopRatedTvs;
    late TvListCubit cubit;

    setUp(() {
      mockGetOnTheAirTvs = MockGetOnTheAirTvs();
      mockGetPopularTvs = MockGetPopularTvs();
      mockGetTopRatedTvs = MockGetTopRatedTvs();
      cubit = TvListCubit(
        getOnTheAirTvs: mockGetOnTheAirTvs,
        getPopularTvs: mockGetPopularTvs,
        getTopRatedTvs: mockGetTopRatedTvs,
      );
    });

    test('fetchOnTheAirTvs success and failure', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      await cubit.fetchOnTheAirTvs();
      expect(cubit.state.onTheAirState, RequestState.Loaded);

      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchOnTheAirTvs();
      expect(cubit.state.onTheAirState, RequestState.Error);
    });

    test('fetchPopularTvs and fetchTopRatedTvs success', () async {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));

      await cubit.fetchPopularTvs();
      await cubit.fetchTopRatedTvs();

      expect(cubit.state.popularState, RequestState.Loaded);
      expect(cubit.state.topRatedState, RequestState.Loaded);
    });
  });

  group('PopularTvsCubit', () {
    test('fetch success and failure', () async {
      final mockGetPopularTvs = MockGetPopularTvs();
      final cubit = PopularTvsCubit(mockGetPopularTvs);

      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(testTvList));
      await cubit.fetchPopularTvs();
      expect(cubit.state.state, RequestState.Loaded);

      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchPopularTvs();
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('TopRatedTvsCubit', () {
    test('fetch success and failure', () async {
      final mockGetTopRatedTvs = MockGetTopRatedTvs();
      final cubit = TopRatedTvsCubit(getTopRatedTvs: mockGetTopRatedTvs);

      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      await cubit.fetchTopRatedTvs();
      expect(cubit.state.state, RequestState.Loaded);

      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchTopRatedTvs();
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('WatchlistTvCubit', () {
    test('fetch success and failure', () async {
      final mockGetWatchlistTvs = MockGetWatchlistTvs();
      final cubit = WatchlistTvCubit(getWatchlistTvs: mockGetWatchlistTvs);

      when(mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      await cubit.fetchWatchlistTvs();
      expect(cubit.state.state, RequestState.Loaded);

      when(mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchWatchlistTvs();
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('TvSearchCubit', () {
    test('search success and failure', () async {
      final mockSearchTvs = MockSearchTvs();
      final cubit = TvSearchCubit(searchTvs: mockSearchTvs);

      when(mockSearchTvs.execute('tv')).thenAnswer((_) async => Right(testTvList));
      await cubit.fetchTvSearch('tv');
      expect(cubit.state.state, RequestState.Loaded);

      when(mockSearchTvs.execute('tv'))
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchTvSearch('tv');
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('TvDetailCubit', () {
    late MockGetTvDetail mockGetTvDetail;
    late MockGetTvRecommendations mockGetTvRecommendations;
    late MockGetWatchListStatusTv mockGetWatchListStatus;
    late MockSaveWatchlistTv mockSaveWatchlist;
    late MockRemoveWatchlistTv mockRemoveWatchlist;
    late TvDetailCubit cubit;

    setUp(() {
      mockGetTvDetail = MockGetTvDetail();
      mockGetTvRecommendations = MockGetTvRecommendations();
      mockGetWatchListStatus = MockGetWatchListStatusTv();
      mockSaveWatchlist = MockSaveWatchlistTv();
      mockRemoveWatchlist = MockRemoveWatchlistTv();
      cubit = TvDetailCubit(
        getTvDetail: mockGetTvDetail,
        getTvRecommendations: mockGetTvRecommendations,
        getWatchListStatus: mockGetWatchListStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
      );
    });

    test('fetchTvDetail success and recommendation success', () async {
      when(mockGetTvDetail.execute(100)).thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(100))
          .thenAnswer((_) async => Right(testTvList));

      await cubit.fetchTvDetail(100);

      expect(cubit.state.tvState, RequestState.Loaded);
      expect(cubit.state.recommendationState, RequestState.Loaded);
      expect(cubit.state.tv, testTvDetail);
      expect(cubit.state.recommendations, testTvList);
    });

    test('fetchTvDetail failure', () async {
      when(mockGetTvDetail.execute(100))
          .thenAnswer((_) async => Left(ServerFailure('err')));
      when(mockGetTvRecommendations.execute(100))
          .thenAnswer((_) async => Right(testTvList));

      await cubit.fetchTvDetail(100);

      expect(cubit.state.tvState, RequestState.Error);
      expect(cubit.state.message, 'err');
    });

    test('fetchTvDetail recommendation failure', () async {
      when(mockGetTvDetail.execute(100)).thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(100))
          .thenAnswer((_) async => Left(ServerFailure('rec err')));

      await cubit.fetchTvDetail(100);

      expect(cubit.state.tvState, RequestState.Loaded);
      expect(cubit.state.recommendationState, RequestState.Error);
      expect(cubit.state.message, 'rec err');
    });

    test('watchlist actions', () async {
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(100)).thenAnswer((_) async => true);

      await cubit.addWatchlist(testTvDetail);
      expect(cubit.state.watchlistMessage, 'Added to Watchlist');
      expect(cubit.state.isAddedToWatchlist, true);

      await cubit.removeFromWatchlist(testTvDetail);
      expect(cubit.state.watchlistMessage, 'Removed from Watchlist');
    });

    test('watchlist action failures and status false', () async {
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('db error')));
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('db remove error')));
      when(mockGetWatchListStatus.execute(100)).thenAnswer((_) async => false);

      await cubit.addWatchlist(testTvDetail);
      expect(cubit.state.watchlistMessage, 'db error');
      expect(cubit.state.isAddedToWatchlist, false);

      await cubit.removeFromWatchlist(testTvDetail);
      expect(cubit.state.watchlistMessage, 'db remove error');
    });
  });
}
