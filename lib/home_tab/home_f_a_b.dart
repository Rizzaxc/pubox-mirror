import 'package:flutter/material.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {}, // open fullscreen modal
        onDoubleTap: () {}, // reload
        child: FloatingActionButton(
          onPressed: () {}, // open submenu
          shape: const CircleBorder(),
          backgroundColor: Colors.green.shade600,
          child: Icon(Icons.search, color: Colors.white),
        ));
  }
}
