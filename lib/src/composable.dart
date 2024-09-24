part of '../flutter_compose.dart';

abstract class Composable<T> extends ChangeNotifier
    with DiagnosticableTreeMixin {
  Composable([this.props]);

  BuildContext? _context;
  BuildContext get context => _context!;

  final List<Object?>? props;

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

  @override
  int get hashCode {
    if (props != null && props!.isNotEmpty) {
      return Object.hashAll(props!);
    }
    return super.hashCode;
  }

  @mustCallSuper
  void onInit() {}

  @mustCallSuper
  void onDispose() {
    dispose();
  }

  @override
  @protected
  void dispose() {
    super.dispose();
  }

  T build();
}
