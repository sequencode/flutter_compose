part of '../flutter_compose.dart';

final class Node extends LinkedListEntry<Node> {
  Node(this.entry);

  final Composable entry;
}
