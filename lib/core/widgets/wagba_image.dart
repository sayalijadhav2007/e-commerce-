import 'package:flutter/material.dart';

class WagbaImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const WagbaImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = path.startsWith('http');
    final image = isNetwork
        ? Image.network(
            path,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.white10,
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.white54),
              );
            },
          )
        : Image.asset(
            path,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.white10,
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.white54),
              );
            },
          );

    if (borderRadius == null) {
      return image;
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: image,
    );
  }
}
