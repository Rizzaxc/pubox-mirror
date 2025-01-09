import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

@immutable
class ExpandableFAB extends StatefulWidget {
  const ExpandableFAB({
    super.key,
    this.initialOpen,
    this.distance = 72,
    required this.faceIcon,
    required this.children,
    this.onParentLongPressed,
    this.onParentDoubleTapped,
  }) : assert(children.length >= 1 && children.length <= 3);

  final bool? initialOpen;
  final double distance;
  final Widget faceIcon;
  final List<Widget> children;

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
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_open) {
      // TODO: only this allows children to be tapped
      return SizedBox.expand(
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            _buildTapToCloseFAB(),
            ..._buildExpandingActionButtons(),
          ],
        ),
      );
    } else {
      return _buildTapToOpenFAB();
    }
  }

  Widget _buildTapToCloseFAB() {
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
            directionInDegrees: 150,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[2]));
        break;
      default:
        break;
    }
    return children;
  }

  Widget _buildTapToOpenFAB() {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      transform: Matrix4.diagonal3Values(
        _open ? 0.7 : 1.0,
        _open ? 0.7 : 1.0,
        1.0,
      ),
      duration: const Duration(milliseconds: 250),
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
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
    );
  }
}

@immutable
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
          // 180 north of the face widget
        directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
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

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.onTertiaryFixedVariant,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.tertiaryContainer,
      ),
    );
  }
}
