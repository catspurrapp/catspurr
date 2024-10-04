import 'package:flutter/material.dart';

class PaddingIcon extends StatelessWidget {
  const PaddingIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        size: 32,
        color: Colors.white54,
      ),
    );
  }
}
