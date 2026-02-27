import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('TvCard renders and navigates to detail page', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == TvDetailPage.ROUTE_NAME) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('TV Detail Route')),
            );
          }
          return MaterialPageRoute(
            builder: (_) => Scaffold(body: TvCard(testTv)),
          );
        },
      ),
    );

    expect(find.text('TV Title'), findsOneWidget);
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
  });
}
