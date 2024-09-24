# Flutter Compose

Flutter Compose is a flexible framework for building reusable, composable components within Flutter apps.

# Usage

### Create a Composable

```dart
class ValueNotifierComposable<T> extends Composable<ValueNotifier<T>> {
  ValueNotifierComposable(this.value);

  final T value;
  late final ValueNotifier<T> notifier;

  @override
  void onInit() {
    notifier = ValueNotifier(value);
    notifier.addListener(notifyListeners);
    super.onInit();
  }

  @override
  void onDispose() {
    notifier.removeListener(notifyListeners);
    super.onDispose();
  }

  @override
  ValueNotifier<T> build() => notifier;
}
```

### Make it available to the Use instance

```dart
extension ValueNotifierComposableExtension on Use {
  ValueNotifier<T> valueNotifier<T>(T value) {
    return attach(ValueNotifierComposable(value));
  }
}
```

### Create ComposeWidget and access the Composable

```dart
class CounterWidget extends ComposeWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, Use use) {
    final counter = use.valueNotifier(0);

    return Scaffold(
      body: Center(
        child: Text('${counter.value}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.value++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```