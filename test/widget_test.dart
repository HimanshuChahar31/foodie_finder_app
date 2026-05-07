import 'package:flutter_test/flutter_test.dart';

import 'package:foodie_finder/main.dart';

void main() {
  testWidgets('shows login choices on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Foodie Finder'), findsOneWidget);
    expect(find.text('Choose how you want to continue'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Email'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
