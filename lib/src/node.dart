part of '../flutter_compose.dart';

/// A node in the list of composables.
final class Node extends LinkedListEntry<Node> {
  /// Creates a node with the given entry.
  Node(this.entry);

  /// The composable associated with this node.
  final Composable entry;
}
