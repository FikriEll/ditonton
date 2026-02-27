import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_state.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesCubit])
void main() {
  late MockTopRatedMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedMoviesCubit();
    when(mockCubit.fetchTopRatedMovies()).thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    const state = TopRatedMoviesState(state: RequestState.Loading);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final state =
        TopRatedMoviesState(state: RequestState.Loaded, movies: testMovieList);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const state =
        TopRatedMoviesState(state: RequestState.Error, message: 'Error message');
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
