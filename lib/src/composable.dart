part of '../flutter_compose.dart';

/// A base class for composable components.
///
/// Composables are reusable building blocks for creating user interfaces.
/// They take optional properties (props) as input and return a value
/// (determined by the generic type `T`) that can be used to construct
/// or configure the UI.
///
/// Composables are similar to functions that produce values used in
/// UI construction, allowing you to break down complex UIs into smaller,
/// manageable pieces.
///
/// They have a `build` method that returns a value of type `T`, which
/// might be used by other composables or widgets to build the final UI.
abstract class Composable<T> extends ChangeNotifier
    with DiagnosticableTreeMixin {
  /// Creates a new composable component.
  ///
  /// The [props] parameter is optional. If provided, it will be used to determine equality
  /// with other composable components.
  Composable([this.props]);

  /// The build context for this composable component.
  BuildContext? _context;

  /// The build context for this composable component.
  BuildContext get context => _context!;

  /// The properties for this composable component.
  final List<Object?>? props;

  /// Compares this composable component to another object.
  ///
  /// Returns true if the other object is a composable component and has the same properties.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Composable || props == null || other.props == null) {
      return false;
    }
    if (props!.length != other.props!.length) return false;

    for (var i = 0; i < props!.length; i++) {
      final prop1 = props![i];
      final prop2 = other.props![i];

      if (prop1 is List && prop2 is List) {
        if (!listEquals(prop1, prop2)) return false;
      } else if (prop1 is Set && prop2 is Set) {
        if (!setEquals(prop1, prop2)) return false;
      } else if (prop1 is Map && prop2 is Map) {
        if (!mapEquals(prop1, prop2)) return false;
      } else if (prop1 != prop2) {
        return false;
      }
    }
    return true;
  }

  /// Returns a hash code for this composable component.
  @override
  int get hashCode {
    if (props != null && props!.isNotEmpty) {
      return Object.hashAll(props!);
    }
    return super.hashCode;
  }

  /// Called when this composable component is initialized.
  @mustCallSuper
  void onInit() {}

  /// Called when this composable component is disposed.
  @mustCallSuper
  void onDispose() {
    dispose();
  }

  /// Disposes of this composable component.
  @override
  @protected
  void dispose() {
    super.dispose();
  }

  /// Builds the value for this composable component.
  ///
  /// The return type `T` is determined by the generic type of the `Composable` class.
  /// The returned value might be used by other composables or widgets to
  /// build the final UI.
  T build();
}
