import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodie_finder/widgets/profile_option_tile.dart';
import 'package:foodie_finder/widgets/section_header.dart';

void main() {
  testWidgets('SectionHeader shows title and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Recommended',
            subtitle: 'Based on your taste',
          ),
        ),
      ),
    );

    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('Based on your taste'), findsOneWidget);
  });

  testWidgets('SectionHeader hides empty subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionHeader(title: 'Favorites')),
      ),
    );

    expect(find.text('Favorites'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('SectionHeader renders optional action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Orders',
            action: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );

    expect(find.text('Orders'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('ProfileOptionTile shows title and icons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileOptionTile(
            icon: Icons.person,
            title: 'Edit profile',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Edit profile'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });

  testWidgets('ProfileOptionTile calls onTap once per tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileOptionTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => taps++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Settings'));

    expect(taps, 1);
  });
}
