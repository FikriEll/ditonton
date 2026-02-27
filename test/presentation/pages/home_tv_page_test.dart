import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_list_state.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.mocks.dart';

@GenerateMocks([TvListCubit])
void main() {
  late MockTvListCubit mockCubit;

  setUp(() {
    mockCubit = MockTvListCubit();
    when(mockCubit.fetchOnTheAirTvs()).thenAnswer((_) async {});
    when(mockCubit.fetchPopularTvs()).thenAnswer((_) async {});
    when(mockCubit.fetchTopRatedTvs()).thenAnswer((_) async {});
  });

  testWidgets('HomeTvPage renders appbar and drawer items', (tester) async {
    final state = TvListState(
      onTheAirState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      onTheAirTvs: [],
      popularTvs: [],
      topRatedTvs: [],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(home: const HomeTvPage()),
      ),
    );

    expect(find.text('Ditonton - TV'), findsOneWidget);
    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsWidgets);
    expect(find.text('Top Rated'), findsWidgets);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Watchlist (Movies & TV)'), findsOneWidget);
  });

  testWidgets('HomeTvPage shows loading indicators', (tester) async {
    const state = TvListState(
      onTheAirState: RequestState.Loading,
      popularState: RequestState.Loading,
      topRatedState: RequestState.Loading,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(home: const HomeTvPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('HomeTvPage shows error messages', (tester) async {
    const state = TvListState(
      onTheAirState: RequestState.Error,
      popularState: RequestState.Error,
      topRatedState: RequestState.Error,
      message: 'error state',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(home: const HomeTvPage()),
      ),
    );

    expect(find.text('error state'), findsNWidgets(3));
  });

  testWidgets('HomeTvPage triggers navigation actions', (tester) async {
    final state = TvListState(
      onTheAirState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      onTheAirTvs: testTvList,
      popularTvs: testTvList,
      topRatedTvs: testTvList,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('route')),
          ),
          home: const HomeTvPage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
  });

  testWidgets('HomeTvPage taps drawer, section and list item navigation',
      (tester) async {
    final state = TvListState(
      onTheAirState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      onTheAirTvs: testTvList,
      popularTvs: testTvList,
      topRatedTvs: testTvList,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('route')),
          ),
          home: const HomeTvPage(),
        ),
      ),
    );

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();
    expect(find.text('route'), findsOneWidget);
  });

  testWidgets('HomeTvPage drawer navigations work', (tester) async {
    final state = TvListState(
      onTheAirState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      onTheAirTvs: testTvList,
      popularTvs: testTvList,
      topRatedTvs: testTvList,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          routes: {
            '/home': (_) => const Scaffold(body: Text('home_movie_page')),
            WatchlistPage.ROUTE_NAME: (_) =>
                const Scaffold(body: Text('watchlist_page')),
            WatchlistTvsPage.ROUTE_NAME: (_) =>
                const Scaffold(body: Text('watchlist_tv_page')),
            AboutPage.ROUTE_NAME: (_) =>
                const Scaffold(body: Text('about_page')),
          },
          home: const HomeTvPage(),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Movies'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('home_movie_page'), findsOneWidget);
  });

  testWidgets('HomeTvPage see more navigations for popular/top rated',
      (tester) async {
    final state = TvListState(
      onTheAirState: RequestState.Loaded,
      popularState: RequestState.Loaded,
      topRatedState: RequestState.Loaded,
      onTheAirTvs: testTvList,
      popularTvs: testTvList,
      topRatedTvs: testTvList,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvListCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          routes: {
            PopularTvsPage.ROUTE_NAME: (_) =>
                const Scaffold(body: Text('popular_tv_page')),
            TopRatedTvsPage.ROUTE_NAME: (_) =>
                const Scaffold(body: Text('top_rated_tv_page')),
          },
          home: const HomeTvPage(),
        ),
      ),
    );

    await tester.tap(find.text('See More').at(1));
    await tester.pumpAndSettle();
    expect(find.text('popular_tv_page'), findsOneWidget);
  });

  testWidgets('TvList item tap is covered', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          TvDetailPage.ROUTE_NAME: (_) =>
              const Scaffold(body: Text('tv_detail_page')),
        },
        home: Scaffold(body: TvList(testTvList)),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.text('tv_detail_page'), findsOneWidget);
  });
}
