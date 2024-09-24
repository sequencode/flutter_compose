part of '../flutter_compose.dart';

abstract class Use {
  T attach<T>(Composable<T> composable);
}
