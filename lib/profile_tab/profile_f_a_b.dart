import 'package:flutter/material.dart';

class ProfileFAB extends StatelessWidget {
  const ProfileFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {},
        onDoubleTap: () {},
        child: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          backgroundColor: Colors.green.shade600,
          child: Icon(Icons.check, color: Colors.white),
        ));
  }
}
