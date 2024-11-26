import 'package:flutter/material.dart';

class HealthFAB extends StatelessWidget {
  const HealthFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {},
        onDoubleTap: () {},
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green.shade600,
          shape: const CircleBorder(),
          child: Icon(Icons.sync, color: Colors.white),
        ));  }
}
