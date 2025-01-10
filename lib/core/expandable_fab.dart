import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ExpandableFAB extends StatefulWidget {
  const ExpandableFAB({
    super.key,
    this.initialOpen,
    this.distance = 72,
    required this.faceIcon,
    required this.children,
    this.onParentLongPressed,
    this.onParentDoubleTapped,
  });

  final bool? initialOpen;
  final double distance;
  final Widget faceIcon;
  final List<ActionButton> children;
  final VoidCallback? onParentLongPressed;
  final VoidCallback? onParentDoubleTapped;

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
        _showOverlay();
      } else {
        _controller.reverse();
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Menu items
            Positioned(
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(-widget.distance, -56*3), // Offset the menu upward
                child: SizedBox(
                  width: widget.distance + 56*3,
                  height: widget.distance + 56*3,
                  child: AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: _buildExpandingActionButtons(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // 1 item -> perpendicular
  // 2 items -> 60-120 arc
  // 3 items -> 30-90-150 arc
  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    switch (count) {
      case 1:
        children.add(_ExpandingActionButton(
            directionInDegrees: 90,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[0]));
        break;

      case 2:
        children.add(_ExpandingActionButton(
            directionInDegrees: 60,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[0]));
        children.add(_ExpandingActionButton(
            directionInDegrees: 120,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[1]));
        break;
      case 3:
        children.add(_ExpandingActionButton(
            directionInDegrees: 30,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[0]));
        children.add(_ExpandingActionButton(
            directionInDegrees: 90,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[1]));
        children.add(_ExpandingActionButton(
            directionInDegrees: 120,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[2]));
        break;
      default:
        break;
    }
    return children;
  }

  Widget _buildFaceButton() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 100),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 100),
          child: PlatformIconButton(
              onPressed: _toggle,
              color: Theme.of(context).colorScheme.tertiary,
              padding: EdgeInsets.zero,
              cupertino: (_, __) => CupertinoIconButtonData(
                  borderRadius: BorderRadius.circular(32), minSize: 56),
              material: (_, __) => MaterialIconButtonData(
                    padding: EdgeInsets.all(16),
                    iconSize: 24,
                  ),
              icon: GestureDetector(
                  onLongPress: widget.onParentLongPressed,
                  onDoubleTap: widget.onParentDoubleTapped,
                  child: widget.faceIcon)),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return PlatformIconButton(
      padding: EdgeInsets.zero,
      cupertino: (_, __) => CupertinoIconButtonData(
          borderRadius: BorderRadius.circular(32), minSize: 56),
      material: (_, __) => MaterialIconButtonData(
        padding: EdgeInsets.all(16),
        iconSize: 24,
      ),
      icon: Icon(
        PlatformIcons(context).clear,
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      color: Theme.of(context).colorScheme.inverseSurface,
      onPressed: _toggle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink, child: _open ? _buildCloseButton() : _buildFaceButton());
  }
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );

        return Positioned(
          right: maxDistance + offset.dx,
          bottom: maxDistance + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

// Example ActionButton class (you would need to implement this)
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PlatformIconButton(
      icon: icon,
      color: theme.colorScheme.primaryContainer,
      cupertino: (_, __) => CupertinoIconButtonData(
        color: theme.colorScheme.onPrimaryFixed,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(32)
      ),
      onPressed: onPressed,
    );
  }
}

