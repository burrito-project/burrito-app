import 'package:flutter/material.dart';

class OverlayMapButton extends StatelessWidget {
  final bool colorActive;
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final String semanticLabel;
  final double iconSize;
  final Color? accentColor;

  const OverlayMapButton({
    super.key,
    required this.colorActive,
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.size = 52,
    this.iconSize = 32,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    Color accentColor = this.accentColor ?? Colors.black87;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accentColor, width: 1.5),
      ),
      child: ClipOval(
        child: Material(
          color: colorActive ? accentColor : Colors.white,
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
                  color: colorActive ? Colors.white : accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
