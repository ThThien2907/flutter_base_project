import 'package:flutter/material.dart';

class PrimaryAnimatedPressableWidget extends StatefulWidget {
  const PrimaryAnimatedPressableWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final bool enabled;

  @override
  State<PrimaryAnimatedPressableWidget> createState() =>
      _PrimaryAnimatedPressableWidgetState();
}

class _PrimaryAnimatedPressableWidgetState
    extends State<PrimaryAnimatedPressableWidget> {
  bool _pressed = false;

  bool get _isEnabled => widget.enabled && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: _isEnabled ? () => setState(() => _pressed = false) : null,
      onTapUp: _isEnabled ? (_) => setState(() => _pressed = false) : null,
      onTap: _isEnabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
