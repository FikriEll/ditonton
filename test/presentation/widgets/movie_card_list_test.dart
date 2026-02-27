import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard renders and navigates to detail page', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.ROUTE_NAME) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Movie Detail Route')),
            );
          }
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: MovieCard(testMovie)),
          );
        },
      ),
    );

    expect(find.text('Spider-Man'), findsOneWidget);
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
  });
}
