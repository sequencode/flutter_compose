# Flutter Compose

**Flutter Compose** is a package designed to streamline the creation and management of reusable components within Flutter applications. It introduces a new approach to widget composition, emphasizing the separation of concerns between component logic and widget rendering.

**Key concepts:**

- **Composable:** A `Composable` object represents a reusable component that can be attached to a `ComposeWidget` instance. It provides lifecycle methods (`onInit`, `onDispose`) and access to the `BuildContext`. By calling `notifyListeners`, it can trigger a rebuild of the associated `ComposeWidget`.
- **Use:** The `Use` interface provides a way to attach `Composable` objects to a `ComposeWidget` instance.
- **ComposeWidget:** A custom widget that extends `Widget` and utilizes the `Use` interface to manage `Composable` objects.

# Usage

1. **Create a Composable:** Define a class that extends `Composable` and implements the necessary methods. In the provided example, `ValueNotifierComposable` is a `Composable` that manages a `ValueNotifier` object.

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

2. **Make it available to the Use instance:** Create an extension method on the `Use` interface to provide a convenient way to attach the `Composable` object. The `valueNotifier` extension method in the example allows you to create a `ValueNotifierComposable` directly from the `Use` instance.

```dart
extension ValueNotifierComposableExtension on Use {
  ValueNotifier<T> valueNotifier<T>(T value) {
    return attach(ValueNotifierComposable(value));
  }
}
```

3. **Create ComposeWidget and access the Composable:** Create a `ComposeWidget` and access the `Composable` object within its `build` method. In the example, `CounterWidget` uses the `valueNotifier` extension method to create a `ValueNotifierComposable` and then accesses its `ValueNotifier` object to display and update a counter value.


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

**Benefits of Flutter Compose:**

- **Enhanced reusability:** `Composable` objects can be easily reused across different parts of your application.
- **Improved maintainability:** By separating component logic from widget rendering, your code becomes more modular and easier to understand and maintain.
- **Simplified state management:** `Composable` objects can handle their own state management, reducing the complexity of managing state within your widgets.


**Additional notes:**

- The `ValueNotifierComposable` example demonstrates how to use a `ValueNotifier` to manage state within a `Composable`. You can customize this approach to suit your specific use cases.
- Flutter Compose offers flexibility in how you structure your `Composable` objects and integrate them into your application's architecture.