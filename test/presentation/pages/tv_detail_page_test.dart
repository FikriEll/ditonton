import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_detail_state.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailCubit])
void main() {
  late MockTvDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockTvDetailCubit();
    when(mockCubit.fetchTvDetail(any)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(any)).thenAnswer((_) async {});
    when(mockCubit.addWatchlist(any)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(any)).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Watchlist button should display add icon when tv not added',
      (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: testTvDetail,
      recommendations: const [],
      isAddedToWatchlist: false,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
  });

  testWidgets('Watchlist button should display check icon when tv added',
      (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: testTvDetail,
      recommendations: const [],
      isAddedToWatchlist: true,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Watchlist button should display Snackbar when added',
      (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: testTvDetail,
      recommendations: [],
      isAddedToWatchlist: false,
      watchlistMessage: 'Added to Watchlist',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Watchlist button should display AlertDialog when add failed',
      (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: testTvDetail,
      recommendations: [],
      isAddedToWatchlist: false,
      watchlistMessage: 'Failed',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('shows loading indicator state', (WidgetTester tester) async {
    const loadingState = TvDetailState(tvState: RequestState.Loading);
    when(mockCubit.state).thenReturn(loadingState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error text state', (WidgetTester tester) async {
    const errorState = TvDetailState(
      tvState: RequestState.Error,
      message: 'error',
    );
    when(mockCubit.state).thenReturn(errorState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));
    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Watchlist button should remove when tv already added',
      (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: testTvDetail,
      recommendations: const [],
      isAddedToWatchlist: true,
      watchlistMessage: 'Removed from Watchlist',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(mockCubit.removeFromWatchlist(any)).called(1);
  });

  testWidgets('shows recommendation loading and error states',
      (WidgetTester tester) async {
    final loadingState = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loading,
      tv: testTvDetail,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(loadingState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    final errorState = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Error,
      tv: testTvDetail,
      recommendations: const [],
      message: 'tv rec error',
    );
    when(mockCubit.state).thenReturn(errorState);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 100)));
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('calls fetch detail and watchlist status on initState',
      (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Empty,
      tv: testTvDetail,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 101)));
    await tester.pump();

    verify(mockCubit.fetchTvDetail(101)).called(1);
    verify(mockCubit.loadWatchlistStatus(101)).called(1);
  });

  testWidgets('hides seasons section when seasons is empty',
      (WidgetTester tester) async {
    final tvWithoutSeasons = TvDetail(
      backdropPath: 'backdropPath',
      firstAirDate: null,
      genres: [Genre(id: 1, name: 'Action')],
      id: 200,
      name: 'TV Empty Season',
      numberOfEpisodes: 0,
      numberOfSeasons: 0,
      overview: 'Overview TV',
      posterPath: 'posterPath',
      voteAverage: 8.0,
      voteCount: 100,
      seasons: const [],
      episodeRunTime: const [50],
    );
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Empty,
      tv: tvWithoutSeasons,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 200)));

    expect(find.text('Seasons'), findsNothing);
  });

  testWidgets('navigates to another tv detail when recommendation tapped',
      (WidgetTester tester) async {
    final tvWithoutSeasons = TvDetail(
      backdropPath: 'backdropPath',
      firstAirDate: '2021-09-17',
      genres: [Genre(id: 1, name: 'Action')],
      id: 100,
      name: 'TV Title',
      numberOfEpisodes: 10,
      numberOfSeasons: 0,
      overview: 'Overview TV',
      posterPath: 'posterPath',
      voteAverage: 8.0,
      voteCount: 100,
      seasons: const [],
      episodeRunTime: const [50],
    );
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      tv: tvWithoutSeasons,
      recommendations: [testTv],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvDetailCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: const TvDetailPage(id: 100),
          onGenerateRoute: (settings) {
            if (settings.name == TvDetailPage.ROUTE_NAME) {
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => Scaffold(body: Text('tv-$id')),
              );
            }
            return null;
          },
        ),
      ),
    );

    final recommendationItem = find.descendant(
      of: find.byType(ListView).last,
      matching: find.byType(InkWell),
    );
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -300),
    );
    await tester.pump();
    await tester.tap(recommendationItem.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('tv-100'), findsOneWidget);
  });

  testWidgets('back button pops to previous page', (WidgetTester tester) async {
    final state = TvDetailState(
      tvState: RequestState.Loaded,
      recommendationState: RequestState.Empty,
      tv: testTvDetail,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<TvDetailCubit>.value(
                    value: mockCubit,
                    child: const TvDetailPage(id: 100),
                  ),
                ),
              );
            },
            child: const Text('open-detail'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open-detail'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('open-detail'), findsOneWidget);
  });

}
