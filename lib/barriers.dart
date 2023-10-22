import 'package:flutter/material.dart';

// 障害物
class MyBarrier extends StatelessWidget {
  const MyBarrier({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[400],
          border: Border.all(width: 10, color: Colors.green[700]!)),
    );
  }
}
