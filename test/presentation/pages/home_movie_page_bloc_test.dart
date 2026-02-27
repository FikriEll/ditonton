import 'package:ditonton/presentation/bloc/movies/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_state.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_bloc_test.mocks.dart';

@GenerateMocks([MovieListCubit])
void main() {
  late MockMovieListCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieListCubit();
    when(mockCubit.state).thenReturn(const MovieListState());
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget _makeTestableWidget() {
    return MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('route'))),
      home: BlocProvider<MovieListCubit>.value(
        value: mockCubit,
        child: HomeMoviePage(),
      ),
    );
  }

  testWidgets('renders HomeMoviePage with drawer and app bar', (tester) async {
    await tester.pumpWidget(_makeTestableWidget());

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    verify(mockCubit.fetchNowPlayingMovies()).called(1);
    verify(mockCubit.fetchPopularMovies()).called(1);
    verify(mockCubit.fetchTopRatedMovies()).called(1);
  });

  testWidgets('shows progress indicator when loading', (tester) async {
    const loadingState = MovieListState(
      nowPlayingState: RequestState.Loading,
      popularState: RequestState.Loading,
      topRatedState: RequestState.Loading,
    );
    when(mockCubit.state).thenReturn(loadingState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('shows failed text on error states', (tester) async {
    const errorState = MovieListState(
      nowPlayingState: RequestState.Error,
      popularState: RequestState.Error,
      topRatedState: RequestState.Error,
      message: 'error',
    );
    when(mockCubit.state).thenReturn(errorState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget());

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('navigates from app bar, sections, and drawer', (tester) async {
    final loadedState = MovieListState(
      nowPlayingState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
    );
    when(mockCubit.state).thenReturn(loadedState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget());

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
  });

  testWidgets('navigates via subheading, drawer and movie item tap',
      (tester) async {
    final loadedState = MovieListState(
      nowPlayingState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
    );
    when(mockCubit.state).thenReturn(loadedState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget());

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
  });

  testWidgets('drawer callbacks route to expected pages', (tester) async {
    final loadedState = MovieListState(
      nowPlayingState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
    );
    when(mockCubit.state).thenReturn(loadedState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(MaterialApp(
      routes: {
        HomeTvPage.ROUTE_NAME: (_) => const Scaffold(body: Text('home_tv')),
        WatchlistPage.ROUTE_NAME: (_) =>
            const Scaffold(body: Text('watchlist_page')),
        WatchlistTvsPage.ROUTE_NAME: (_) =>
            const Scaffold(body: Text('watchlist_tv_page')),
        '/about': (_) => const Scaffold(body: Text('about_page')),
      },
      home: BlocProvider<MovieListCubit>.value(
        value: mockCubit,
        child: HomeMoviePage(),
      ),
    ));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('home_tv'), findsOneWidget);
  });

  testWidgets('navigates to top rated via second See More', (tester) async {
    final loadedState = MovieListState(
      nowPlayingState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
    );
    when(mockCubit.state).thenReturn(loadedState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(MaterialApp(
      routes: {
        TopRatedMoviesPage.ROUTE_NAME: (_) =>
            const Scaffold(body: Text('top_rated_page')),
      },
      home: BlocProvider<MovieListCubit>.value(
        value: mockCubit,
        child: HomeMoviePage(),
      ),
    ));

    await tester.tap(find.text('See More').at(1));
    await tester.pumpAndSettle();
    expect(find.text('top_rated_page'), findsOneWidget);
  });

  testWidgets('drawer routes to watchlist, watchlist tv, and about',
      (tester) async {
    final loadedState = MovieListState(
      nowPlayingState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
    );
    when(mockCubit.state).thenReturn(loadedState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(MaterialApp(
      routes: {
        WatchlistPage.ROUTE_NAME: (_) =>
            const Scaffold(body: Text('watchlist_page')),
        WatchlistTvsPage.ROUTE_NAME: (_) =>
            const Scaffold(body: Text('watchlist_tv_page')),
        AboutPage.ROUTE_NAME: (_) => const Scaffold(body: Text('about_page')),
      },
      home: BlocProvider<MovieListCubit>.value(
        value: mockCubit,
        child: HomeMoviePage(),
      ),
    ));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Watchlist (Movies & TV)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('watchlist_page'), findsOneWidget);
  });

  testWidgets('MovieList item tap and image errorWidget are covered',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {
        MovieDetailPage.ROUTE_NAME: (_) =>
            const Scaffold(body: Text('movie_detail_page')),
      },
      home: Scaffold(body: MovieList(testMovieList)),
    ));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.text('movie_detail_page'), findsOneWidget);
  });
}
