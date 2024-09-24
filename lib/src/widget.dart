part of '../flutter_compose.dart';

abstract class ComposeWidget extends Widget {
  const ComposeWidget({super.key});

  @protected
  Widget build(BuildContext context, Use use);

  @override
  ComposeElement createElement() => ComposeElement(this);
}

class ComposeElement extends ComponentElement implements Use {
  ComposeElement(ComposeWidget super.widget);

  @protected
  final nodes = LinkedList<Node>();

  @protected
  Node? currentNode;

  ComposeElement get element => this;

  @protected
  Use get use => this;

  @override
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

  @protected
  void unlinkRemainingNodes() {
    while (currentNode != null) {
      final previousNode = currentNode;
      currentNode = currentNode?.next;
      previousNode?.entry.onDispose();
      previousNode?.unlink();
    }
  }

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

  @override
  void unmount() {
    while (nodes.isNotEmpty) {
      nodes.first.entry.onDispose();
      nodes.first.unlink();
    }
    super.unmount();
  }

  @override
  @protected
  Widget build() {
    final build = (widget as ComposeWidget).build(element, use);
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
