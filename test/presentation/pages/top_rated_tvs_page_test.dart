import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tvs_state.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tvs_page_test.mocks.dart';

@GenerateMocks([TopRatedTvsCubit])
void main() {
  late MockTopRatedTvsCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedTvsCubit();
    when(mockCubit.fetchTopRatedTvs()).thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvsCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    const state = TopRatedTvsState(state: RequestState.Loading);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final state = TopRatedTvsState(state: RequestState.Loaded, tvs: testTvList);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.text('TV Title'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const state = TopRatedTvsState(state: RequestState.Error, message: 'Error message');
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
