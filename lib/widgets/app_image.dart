import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String source;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AppImage({
    super.key,
    required this.source,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  bool get _isNetworkImage =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return Image.network(
        source,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    return Image.asset(
      source,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
