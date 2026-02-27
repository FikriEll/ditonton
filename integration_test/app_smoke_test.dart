import 'package:ditonton/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts and shows Ditonton title', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    expect(find.textContaining('Ditonton'), findsWidgets);
  });
}
