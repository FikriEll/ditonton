import 'package:ditonton/common/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('constants are initialized', () {
    expect(BASE_IMAGE_URL, contains('image.tmdb.org'));
    expect(kColorScheme.primary, isNotNull);
    expect(kTextTheme.bodyMedium, isNotNull);
    expect(kDrawerTheme.backgroundColor, isNotNull);
  });
}
