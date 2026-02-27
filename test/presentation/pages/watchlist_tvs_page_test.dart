import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_state.dart';
import 'package:ditonton/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tvs_page_test.mocks.dart';

@GenerateMocks([WatchlistTvCubit])
void main() {
  late MockWatchlistTvCubit mockCubit;

  setUp(() {
    mockCubit = MockWatchlistTvCubit();
    when(mockCubit.fetchWatchlistTvs()).thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    const state = WatchlistTvState(state: RequestState.Loading);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    const state = WatchlistTvState(state: RequestState.Loaded, tvs: []);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const state =
        WatchlistTvState(state: RequestState.Error, message: 'Error message');
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display tv cards and didPopNext refetch',
      (WidgetTester tester) async {
    final state = WatchlistTvState(state: RequestState.Loaded, tvs: [testTv]);
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(const WatchlistTvsPage()));
    expect(find.text('TV Title'), findsOneWidget);

    final pageState = tester.state(find.byType(WatchlistTvsPage)) as dynamic;
    pageState.didPopNext();
    verify(mockCubit.fetchWatchlistTvs()).called(2);
  });
}
