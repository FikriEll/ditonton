import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_search_state.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_tv_page_bloc_test.mocks.dart';

@GenerateMocks([TvSearchCubit])
void main() {
  late MockTvSearchCubit mockCubit;

  setUp(() {
    mockCubit = MockTvSearchCubit();
    when(mockCubit.fetchTvSearch(any)).thenAnswer((_) async {});
  });

  testWidgets('SearchTvPage submit triggers cubit and shows results',
      (tester) async {
    final state = TvSearchState(
      state: RequestState.Loaded,
      result: testTvList,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      BlocProvider<TvSearchCubit>.value(
        value: mockCubit,
        child: MaterialApp(home: const SearchTvPage()),
      ),
    );

    await tester.enterText(find.byType(TextField), 'tv');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(mockCubit.fetchTvSearch('tv')).called(1);
    expect(find.byType(ListView), findsOneWidget);
  });
}
