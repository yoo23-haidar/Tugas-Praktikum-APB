import 'package:flutter_test/flutter_test.dart';
import 'package:barber_staff_app/main.dart';

void main() {
  testWidgets('StaffApp renders dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const StaffApp());
    expect(find.text('STAFF DASHBOARD'), findsOneWidget);
  });
}
