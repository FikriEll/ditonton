import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_state.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_state.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_state.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_state.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_state.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tvs_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tvs_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_detail_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('movie states copyWith', () {
    final list = const MovieListState().copyWith(
      nowPlayingState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
      message: 'ok',
    );
    expect(list.nowPlayingMovies, testMovieList);

    final detail = const MovieDetailState().copyWith(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: testMovieList,
      isAddedToWatchlist: true,
      watchlistMessage: 'added',
      message: 'ok',
    );
    expect(detail.movie, testMovieDetail);

    expect(
      const MovieSearchState().copyWith(
        state: RequestState.Loaded,
        result: testMovieList,
        message: 'ok',
      ),
      MovieSearchState(
        state: RequestState.Loaded,
        result: testMovieList,
        message: 'ok',
      ),
    );

    expect(
      const PopularMoviesState().copyWith(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: 'ok',
      ),
      PopularMoviesState(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: 'ok',
      ),
    );

    expect(
      const TopRatedMoviesState().copyWith(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: 'ok',
      ),
      TopRatedMoviesState(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: 'ok',
      ),
    );

    expect(
      const WatchlistMovieState().copyWith(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: 'ok',
      ),
      WatchlistMovieState(
        state: RequestState.Loaded,
        movies: testMovieList,
        message: 'ok',
      ),
    );
  });

  test('tv states copyWith', () {
    final list = const TvListState().copyWith(
      onTheAirState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      onTheAirTvs: testTvList,
      popularTvs: testTvList,
      topRatedTvs: testTvList,
      message: 'ok',
    );
    expect(list.onTheAirTvs, testTvList);

    final detail = const TvDetailState().copyWith(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: testTvDetail,
      recommendations: testTvList,
      isAddedToWatchlist: true,
      watchlistMessage: 'added',
      message: 'ok',
    );
    expect(detail.tv, testTvDetail);

    expect(
      const TvSearchState().copyWith(
        state: RequestState.Loaded,
        result: testTvList,
        message: 'ok',
      ),
      TvSearchState(
        state: RequestState.Loaded,
        result: testTvList,
        message: 'ok',
      ),
    );

    expect(
      const PopularTvsState().copyWith(
        state: RequestState.Loaded,
        tvs: testTvList,
        message: 'ok',
      ),
      PopularTvsState(
        state: RequestState.Loaded,
        tvs: testTvList,
        message: 'ok',
      ),
    );

    expect(
      const TopRatedTvsState().copyWith(
        state: RequestState.Loaded,
        tvs: testTvList,
        message: 'ok',
      ),
      TopRatedTvsState(
        state: RequestState.Loaded,
        tvs: testTvList,
        message: 'ok',
      ),
    );

    expect(
      const WatchlistTvState().copyWith(
        state: RequestState.Loaded,
        tvs: testTvList,
        message: 'ok',
      ),
      WatchlistTvState(
        state: RequestState.Loaded,
        tvs: testTvList,
        message: 'ok',
      ),
    );
  });
}
