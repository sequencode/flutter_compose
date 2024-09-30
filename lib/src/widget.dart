part of '../flutter_compose.dart';

/// A widget that functions like a StatelessWidget but can call Composables.
abstract class ComposeWidget extends Widget {
  /// Creates a [ComposeWidget].
  const ComposeWidget({super.key});

  /// Similar to the build method of a StatelessWidget, but here you can call Composables.
  @protected
  Widget build(BuildContext context);

  /// Creates a [ComposeElement] to manage this widget's composition.
  @override
  ComposeElement createElement() => ComposeElement(this);
}

/// An element that manages the composition of a [ComposeWidget].
class ComposeElement extends ComponentElement {
  /// Creates a [ComposeElement] for the given [ComposeWidget].
  ComposeElement(ComposeWidget super.widget);

  /// The linked list of nodes in this composition.
  @protected
  final nodes = LinkedList<Node>();

  /// The current node being processed during the build process.
  @protected
  Node? currentNode;

  /// Returns this element.
  ComposeElement get element => this;

  /// The currently active [ComposeElement] during the build process.
  static ComposeElement? currentElement;

  /// Attaches a Composable to this element.
  T attach<T>(Composable<T> composable) {
    if (currentNode == null) {
      addNode(composable);
    }

    if (currentNode?.entry.runtimeType != composable.runtimeType) {
      unlinkRemainingNodes();
      addNode(composable);
    }

    if (composable.props != null && currentNode?.entry != composable) {
      replaceNode(composable);
    }

    final build = currentNode!.entry.build();
    currentNode = currentNode?.next;
    return build;
  }

  /// Adds a new node for the given Composable.
  @protected
  void addNode(Composable composable) {
    final node = Node(composable);

    nodes.add(node);

    node.entry
      .._context = element
      ..onInit()
      ..addListener(markNeedsBuild);

    currentNode = node;
  }

  /// Unlinks and disposes of all remaining nodes in the list.
  @protected
  void unlinkRemainingNodes() {
    while (currentNode != null) {
      final previousNode = currentNode;
      currentNode = currentNode?.next;
      previousNode?.entry.onDispose();
      previousNode?.unlink();
    }
  }

  /// Replaces the current node with a new node for the given composable.
  @protected
  void replaceNode(Composable composable) {
    final previous = currentNode?.previous;
    currentNode!.entry.onDispose();
    currentNode!.unlink();

    final node = Node(composable);
    node.entry
      .._context = element
      ..onInit()
      ..addListener(markNeedsBuild);

    if (previous == null) {
      nodes.addFirst(node);
      currentNode = nodes.first;
    } else {
      previous.insertAfter(node);
      currentNode = previous.next;
    }
  }

  /// Unmounts this element and disposes of all nodes.
  @override
  void unmount() {
    while (nodes.isNotEmpty) {
      nodes.first.entry.onDispose();
      nodes.first.unlink();
    }
    super.unmount();
  }

  /// Builds the widget tree for this element.
  @override
  @protected
  Widget build() {
    currentElement = this;
    final build = (widget as ComposeWidget).build(element);
    currentElement = null;
    unlinkRemainingNodes();
    currentNode = nodes.isEmpty ? null : nodes.first;

    return build;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    assert(() {
      for (final node in nodes) {
        properties.add(DiagnosticableTreeNode(value: node.entry, style: null));
      }
      return true;
    }());
    super.debugFillProperties(properties);
  }
}

/// Attaches a composable to the current [ComposeElement].
T attach<T>(Composable<T> composable) {
  assert(
    ComposeElement.currentElement != null,
    'Call composables only inside the ComposeWidget build method',
  );
  return ComposeElement.currentElement!.attach(composable);
}
