import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_cubits_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
  SearchMovies,
  GetWatchlistMovies,
])
void main() {
  group('MovieListCubit', () {
    late MockGetNowPlayingMovies mockGetNowPlayingMovies;
    late MockGetPopularMovies mockGetPopularMovies;
    late MockGetTopRatedMovies mockGetTopRatedMovies;
    late MovieListCubit cubit;

    setUp(() {
      mockGetNowPlayingMovies = MockGetNowPlayingMovies();
      mockGetPopularMovies = MockGetPopularMovies();
      mockGetTopRatedMovies = MockGetTopRatedMovies();
      cubit = MovieListCubit(
        getNowPlayingMovies: mockGetNowPlayingMovies,
        getPopularMovies: mockGetPopularMovies,
        getTopRatedMovies: mockGetTopRatedMovies,
      );
    });

    test('fetchNowPlayingMovies success', () async {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      await cubit.fetchNowPlayingMovies();
      expect(cubit.state.nowPlayingState, RequestState.Loaded);
      expect(cubit.state.nowPlayingMovies, testMovieList);
    });

    test('fetchNowPlayingMovies failure', () async {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('failed')));
      await cubit.fetchNowPlayingMovies();
      expect(cubit.state.nowPlayingState, RequestState.Error);
      expect(cubit.state.message, 'failed');
    });

    test('fetchPopularMovies and fetchTopRatedMovies success', () async {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      await cubit.fetchPopularMovies();
      await cubit.fetchTopRatedMovies();
      expect(cubit.state.popularState, RequestState.Loaded);
      expect(cubit.state.topRatedState, RequestState.Loaded);
    });
  });

  group('PopularMoviesCubit', () {
    test('fetch success and failure', () async {
      final mockGetPopularMovies = MockGetPopularMovies();
      final cubit = PopularMoviesCubit(mockGetPopularMovies);

      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      await cubit.fetchPopularMovies();
      expect(cubit.state.state, RequestState.Loaded);

      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchPopularMovies();
      expect(cubit.state.state, RequestState.Error);
      expect(cubit.state.message, 'err');
    });
  });

  group('TopRatedMoviesCubit', () {
    test('fetch success and failure', () async {
      final mockGetTopRatedMovies = MockGetTopRatedMovies();
      final cubit = TopRatedMoviesCubit(getTopRatedMovies: mockGetTopRatedMovies);

      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      await cubit.fetchTopRatedMovies();
      expect(cubit.state.state, RequestState.Loaded);

      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchTopRatedMovies();
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('WatchlistMovieCubit', () {
    test('fetch success and failure', () async {
      final mockGetWatchlistMovies = MockGetWatchlistMovies();
      final cubit = WatchlistMovieCubit(getWatchlistMovies: mockGetWatchlistMovies);

      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      await cubit.fetchWatchlistMovies();
      expect(cubit.state.state, RequestState.Loaded);

      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchWatchlistMovies();
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('MovieSearchCubit', () {
    test('search success and failure', () async {
      final mockSearchMovies = MockSearchMovies();
      final cubit = MovieSearchCubit(searchMovies: mockSearchMovies);

      when(mockSearchMovies.execute('spider'))
          .thenAnswer((_) async => Right(testMovieList));
      await cubit.fetchMovieSearch('spider');
      expect(cubit.state.state, RequestState.Loaded);

      when(mockSearchMovies.execute('spider'))
          .thenAnswer((_) async => Left(ServerFailure('err')));
      await cubit.fetchMovieSearch('spider');
      expect(cubit.state.state, RequestState.Error);
    });
  });

  group('MovieDetailCubit', () {
    late MockGetMovieDetail mockGetMovieDetail;
    late MockGetMovieRecommendations mockGetMovieRecommendations;
    late MockGetWatchListStatus mockGetWatchListStatus;
    late MockSaveWatchlist mockSaveWatchlist;
    late MockRemoveWatchlist mockRemoveWatchlist;
    late MovieDetailCubit cubit;

    setUp(() {
      mockGetMovieDetail = MockGetMovieDetail();
      mockGetMovieRecommendations = MockGetMovieRecommendations();
      mockGetWatchListStatus = MockGetWatchListStatus();
      mockSaveWatchlist = MockSaveWatchlist();
      mockRemoveWatchlist = MockRemoveWatchlist();
      cubit = MovieDetailCubit(
        getMovieDetail: mockGetMovieDetail,
        getMovieRecommendations: mockGetMovieRecommendations,
        getWatchListStatus: mockGetWatchListStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
      );
    });

    test('fetchMovieDetail success and recommendation success', () async {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right(testMovieList));

      await cubit.fetchMovieDetail(1);

      expect(cubit.state.movieState, RequestState.Loaded);
      expect(cubit.state.recommendationState, RequestState.Loaded);
      expect(cubit.state.movie, testMovieDetail);
      expect(cubit.state.recommendations, testMovieList);
    });

    test('fetchMovieDetail failure', () async {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('err')));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right(testMovieList));

      await cubit.fetchMovieDetail(1);

      expect(cubit.state.movieState, RequestState.Error);
      expect(cubit.state.message, 'err');
    });

    test('fetchMovieDetail recommendation failure', () async {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('rec err')));

      await cubit.fetchMovieDetail(1);

      expect(cubit.state.movieState, RequestState.Loaded);
      expect(cubit.state.recommendationState, RequestState.Error);
      expect(cubit.state.message, 'rec err');
    });

    test('watchlist actions', () async {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);

      await cubit.addWatchlist(testMovieDetail);
      expect(cubit.state.watchlistMessage, 'Added to Watchlist');
      expect(cubit.state.isAddedToWatchlist, true);

      await cubit.removeFromWatchlist(testMovieDetail);
      expect(cubit.state.watchlistMessage, 'Removed from Watchlist');
    });

    test('watchlist action failures and status false', () async {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('db error')));
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('db remove error')));
      when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => false);

      await cubit.addWatchlist(testMovieDetail);
      expect(cubit.state.watchlistMessage, 'db error');
      expect(cubit.state.isAddedToWatchlist, false);

      await cubit.removeFromWatchlist(testMovieDetail);
      expect(cubit.state.watchlistMessage, 'db remove error');
    });
  });
}
