import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? iconColor;
  final bool showBackground;
  final Color? backgroundColor;
  final bool useColorFilter;

  const AppLogo({
    required this.size,
    this.iconColor,
    required this.showBackground,
    this.backgroundColor,
    required this.useColorFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final widget = _buildLogoImage();

    if (showBackground) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(size),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2,
              offset: const Offset(0, 2.0),
            ),
          ],
        ),
        child: Center(child: widget),
      );
    }

    return widget;
  }

  Widget _buildLogoImage() {
    try {
      return Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        // Use colorFilter for uncolored logo/icon
        colorBlendMode: useColorFilter ? BlendMode.srcIn : null,
        color: useColorFilter ? iconColor : null,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.book, size: size, color: iconColor ?? Colors.black);
        },
      );
    } catch (e) {
      return Icon(Icons.book, size: size, color: iconColor ?? Colors.black);
    }
  }
}
