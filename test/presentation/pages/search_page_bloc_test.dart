import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_cubit.dart';
import 'package:ditonton/presentation/bloc/movies/movie_search_state.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_page_bloc_test.mocks.dart';

@GenerateMocks([MovieSearchCubit])
void main() {
  late MockMovieSearchCubit mockCubit;

  setUp(() {
    mockCubit = MockMovieSearchCubit();
    when(mockCubit.fetchMovieSearch(any)).thenAnswer((_) async {});
  });

  testWidgets('SearchPage submit triggers cubit and shows results',
      (tester) async {
    final state = MovieSearchState(
      state: RequestState.Loaded,
      result: testMovieList,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<MovieSearchCubit>.value(
        value: mockCubit,
        child: MaterialApp(home: SearchPage()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'spider');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(mockCubit.fetchMovieSearch('spider')).called(1);
    expect(find.byType(ListView), findsOneWidget);
  });
}
