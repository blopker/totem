import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totem/theme/index.dart';

class ThemedControlButton extends StatelessWidget {
  const ThemedControlButton(
      {Key? key,
      required this.label,
      required this.svgImage,
      this.onPressed,
      this.enabled = true,
      this.imageColor,
      this.backgroundColor,
      this.size = 40})
      : super(key: key);
  final String label;
  final String svgImage;
  final bool enabled;
  final double size;
  final Color? imageColor;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).themeColors;
    return InkWell(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: onPressed != null ? 1.0 : 0.2,
            child: Container(
              width: size,
              height: size,
              decoration: ShapeDecoration(
                color: backgroundColor ?? themeColors.controlButtonBackground,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgImage,
                  color: imageColor,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            constraints: const BoxConstraints(
              minWidth: 80,
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
