import 'package:flutter/material.dart';

class OverlayMapButton extends StatelessWidget {
  final bool buttonActive;
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final String semanticLabel;
  final double iconSize;

  const OverlayMapButton({
    super.key,
    required this.buttonActive,
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.size = 52,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      child: ClipOval(
        child: Material(
          color: buttonActive ? Colors.black : Colors.white,
          child: Semantics(
            label: semanticLabel,
            button: true,
            enabled: true,
            child: InkWell(
              onTap: onTap?.call,
              splashColor: Colors.grey,
              child: SizedBox(
                width: size,
                height: size,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: buttonActive ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
