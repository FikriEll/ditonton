import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailCubit])
void main() {
  late MockMovieDetailCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieDetailCubit();
    when(mockCubit.fetchMovieDetail(any)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(any)).thenAnswer((_) async {});
    when(mockCubit.addWatchlist(any)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(any)).thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: [],
      isAddedToWatchlist: false,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: [],
      isAddedToWatchlist: true,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: [],
      isAddedToWatchlist: false,
      watchlistMessage: 'Added to Watchlist',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: [],
      isAddedToWatchlist: false,
      watchlistMessage: 'Failed',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('shows loading indicator state', (WidgetTester tester) async {
    const loadingState = MovieDetailState(movieState: RequestState.Loading);
    when(mockCubit.state).thenReturn(loadingState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error text state', (WidgetTester tester) async {
    const errorState = MovieDetailState(
      movieState: RequestState.Error,
      message: 'error',
    );
    when(mockCubit.state).thenReturn(errorState);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Watchlist button should remove when movie already added',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: const [],
      isAddedToWatchlist: true,
      watchlistMessage: 'Removed from Watchlist',
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(mockCubit.removeFromWatchlist(any)).called(1);
  });

  testWidgets('shows recommendation loading and error states',
      (WidgetTester tester) async {
    final loadingRecommendation = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loading,
      movie: testMovieDetail,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(loadingRecommendation);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    final errorRecommendation = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Error,
      movie: testMovieDetail,
      recommendations: const [],
      message: 'rec error',
    );
    when(mockCubit.state).thenReturn(errorRecommendation);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    expect(find.byType(Text), findsWidgets);
  });

  testWidgets('calls fetch detail and watchlist status on initState',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Empty,
      movie: testMovieDetail,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 42)));
    await tester.pump();

    verify(mockCubit.fetchMovieDetail(42)).called(1);
    verify(mockCubit.loadWatchlistStatus(42)).called(1);
  });

  testWidgets('shows empty recommendation branch and minute-only duration',
      (WidgetTester tester) async {
    final shortRuntimeMovie = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 2,
      originalTitle: 'short',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 50,
      title: 'short',
      voteAverage: 7.0,
      voteCount: 1,
    );
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Empty,
      movie: shortRuntimeMovie,
      recommendations: const [],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 2)));

    expect(find.text('50m'), findsOneWidget);
  });

  testWidgets('navigates to another movie detail when recommendation tapped',
      (WidgetTester tester) async {
    final state = MovieDetailState(
      movieState: RequestState.Loaded,
      recommendationState: RequestState.Loaded,
      movie: testMovieDetail,
      recommendations: [testMovie],
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<MovieDetailCubit>.value(
        value: mockCubit,
        child: MaterialApp(
          home: MovieDetailPage(id: 1),
          onGenerateRoute: (settings) {
            if (settings.name == MovieDetailPage.ROUTE_NAME) {
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => Scaffold(body: Text('movie-$id')),
              );
            }
            return null;
          },
        ),
      ),
    );

    final recommendationItem = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(InkWell),
    );
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -400),
    );
    await tester.pump();
    await tester.tap(recommendationItem.first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('movie-557'), findsOneWidget);
  });

}
