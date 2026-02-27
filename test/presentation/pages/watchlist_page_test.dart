import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_state.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieCubit, WatchlistTvCubit])
void main() {
  late MockWatchlistMovieCubit mockMovieCubit;
  late MockWatchlistTvCubit mockTvCubit;

  setUp(() {
    mockMovieCubit = MockWatchlistMovieCubit();
    mockTvCubit = MockWatchlistTvCubit();
    when(mockMovieCubit.fetchWatchlistMovies()).thenAnswer((_) async {});
    when(mockTvCubit.fetchWatchlistTvs()).thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMovieCubit>.value(value: mockMovieCubit),
        BlocProvider<WatchlistTvCubit>.value(value: mockTvCubit),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Movies tab should show list when data loaded',
      (WidgetTester tester) async {
    const movieState = WatchlistMovieState(state: RequestState.Loaded, movies: []);
    const tvState = WatchlistTvState(state: RequestState.Loaded, tvs: []);
    when(mockMovieCubit.state).thenReturn(movieState);
    when(mockTvCubit.state).thenReturn(tvState);
    when(mockMovieCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockTvCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('TV tab should show list when data loaded',
      (WidgetTester tester) async {
    const movieState = WatchlistMovieState(state: RequestState.Loaded, movies: []);
    const tvState = WatchlistTvState(state: RequestState.Loaded, tvs: []);
    when(mockMovieCubit.state).thenReturn(movieState);
    when(mockTvCubit.state).thenReturn(tvState);
    when(mockMovieCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockTvCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Should show message when error on movies tab',
      (WidgetTester tester) async {
    const movieState =
        WatchlistMovieState(state: RequestState.Error, message: 'Error message');
    const tvState = WatchlistTvState(state: RequestState.Loading);
    when(mockMovieCubit.state).thenReturn(movieState);
    when(mockTvCubit.state).thenReturn(tvState);
    when(mockMovieCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockTvCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Shows card items when movie and tv watchlist not empty',
      (WidgetTester tester) async {
    final movieState =
        WatchlistMovieState(state: RequestState.Loaded, movies: [testMovie]);
    final tvState = WatchlistTvState(state: RequestState.Loaded, tvs: [testTv]);
    when(mockMovieCubit.state).thenReturn(movieState);
    when(mockTvCubit.state).thenReturn(tvState);
    when(mockMovieCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockTvCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
    expect(find.text('Spider-Man'), findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('TV Title'), findsOneWidget);
  });

  testWidgets('Shows fallback message on empty states and tv error tab',
      (WidgetTester tester) async {
    const movieEmptyState = WatchlistMovieState(state: RequestState.Empty);
    const tvErrorState =
        WatchlistTvState(state: RequestState.Error, message: 'tv error');
    when(mockMovieCubit.state).thenReturn(movieEmptyState);
    when(mockTvCubit.state).thenReturn(tvErrorState);
    when(mockMovieCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockTvCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
    expect(find.text('No watchlist'), findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('tv error'), findsOneWidget);
  });

  testWidgets('didPopNext should refetch movie and tv watchlist',
      (WidgetTester tester) async {
    const movieState = WatchlistMovieState(state: RequestState.Loaded, movies: []);
    const tvState = WatchlistTvState(state: RequestState.Loaded, tvs: []);
    when(mockMovieCubit.state).thenReturn(movieState);
    when(mockTvCubit.state).thenReturn(tvState);
    when(mockMovieCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockTvCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistPage()));
    final state =
        tester.state(find.byType(WatchlistPage)) as dynamic;
    state.didPopNext();

    verify(mockMovieCubit.fetchWatchlistMovies()).called(2);
    verify(mockTvCubit.fetchWatchlistTvs()).called(2);
  });
}
