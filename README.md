# Flutter Compose

**Inspired by Vue Composables, Flutter Compose streamlines the creation and management of reusable components in Flutter applications.**

By encapsulating stateful logic and separating concerns, Flutter Compose helps you build more modular, maintainable, and efficient Flutter apps.

**Key features:**

* **Reusable components:** Create and reuse `Composable` objects to encapsulate complex logic and improve code organization.
* **Simplified state management:** Manage state within `Composable` objects, reducing boilerplate and making your code easier to understand.
* **Improved code structure:** Separate component logic from widget rendering for better maintainability and testability.
* **Enhanced flexibility:** Customize your `Composable` objects to fit your specific needs and project requirements.

**Usage:**

1. **Create a Composable:** Define a class that extends `Composable` and implements the necessary methods. The optional super constructor list can be used to specify properties that should
  be compared for equality checks. This is useful for ensuring that Composables are updated correctly during hot reload.

```dart
class ValueNotifierComposable<T> extends Composable<ValueNotifier<T>> {
  ValueNotifierComposable(this.value) : super([value]);

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

2. **Create a function to attach the Composable using the global `attach` method:** Define a function that takes the required parameters and uses the `attach` method to attach the `Composable`.


```dart
  ValueNotifier<T> valueNotifier<T>(T value) {
    return attach(ValueNotifierComposable(value));
  }
```

3. **Create ComposeWidget and access the Composable:** Call the function from step 2 within your `ComposeWidget`'s `build` method to access the `Composable` object.

```dart
class CounterWidget extends ComposeWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = valueNotifier(0);

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

**Important Note:**

Composables are designed to be called in a deterministic order. Avoid assigning Composables within loops or conditional statements, as this can lead to unexpected behavior and potential bugs. Ensure that your Composables are always accessed in the same order within your `ComposeWidget`.

**Additional notes:**

- The `ValueNotifierComposable` example demonstrates how to use a `ValueNotifier` to manage state within a `Composable`. You can customize this approach to suit your specific use cases.
- Flutter Compose offers flexibility in how you structure your `Composable` objects and integrate them into your application's architecture.