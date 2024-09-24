import 'package:flutter/material.dart';
import 'package:flutter_compose/flutter_compose.dart';
import 'package:flutter_test/flutter_test.dart';

class TestApp extends StatelessWidget {
  const TestApp(this.builder, {super.key});

  final Widget Function(BuildContext context, Use use) builder;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestComposeWidget(builder),
    );
  }
}

class TestComposeWidget extends ComposeWidget {
  const TestComposeWidget(this.builder, {super.key});

  final Widget Function(BuildContext context, Use use) builder;

  @override
  Widget build(BuildContext context, Use use) {
    return MaterialApp(home: builder(context, use));
  }
}

extension TestUseExtension on Use {
  ValueNotifier<int> testNotifier(int initialValue) {
    return attach(TestValueNotifierComposable(initialValue));
  }

  int testHash<T>(T value) {
    return attach(TestHashComposable(value));
  }
}

class TestValueNotifierComposable<T> extends Composable<ValueNotifier<T>> {
  TestValueNotifierComposable(this.initialValue) : super([initialValue]);

  final T initialValue;
  late final ValueNotifier<T> notifier;

  @override
  void onInit() {
    notifier = ValueNotifier(initialValue);
    notifier.addListener(notifyListeners);
    super.onInit();
  }

  @override
  void onDispose() {
    notifier.dispose();
    super.onDispose();
  }

  @override
  ValueNotifier<T> build() => notifier;
}

class TestHashComposable<T> extends Composable<int> {
  TestHashComposable(this.value) : super([value]);

  final T value;

  @override
  int build() => hashCode;
}

void main() {
  group('Compose test', () {
    testWidgets('Test composable on init', (widgetTester) async {
      late ValueNotifier<int> notifier;

      await widgetTester.pumpWidget(TestApp((context, use) {
        notifier = use.testNotifier(0);

        return Text(notifier.value.toString());
      }));

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Test composable on dispose', (widgetTester) async {
      late ValueNotifier<int> notifier;

      await widgetTester.pumpWidget(TestApp((context, use) {
        notifier = use.testNotifier(0);

        return Container();
      }));

      await widgetTester.pumpWidget(Container());

      expect(() {
        notifier.addListener(() {});
      }, throwsFlutterError);
    });

    testWidgets('Test composable on change', (widgetTester) async {
      late ValueNotifier<int> notifier;

      await widgetTester.pumpWidget(TestApp((context, use) {
        notifier = use.testNotifier(0);

        return Text(notifier.value.toString());
      }));

      expect(find.text('0'), findsOneWidget);

      notifier.value++;

      await widgetTester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Test composable hash override', (widgetTester) async {
      late int hash1;
      late int hash2;
      late int hash3;

      await widgetTester.pumpWidget(TestApp((context, use) {
        hash1 = use.testHash(0);
        hash2 = use.testHash(0);
        hash3 = use.testHash(1);

        return Container();
      }));

      expect(hash1 == hash2, true);
      expect(hash1 == hash3, false);
    });
  });
}
