import 'package:flutter/material.dart';

class ManageFAB extends StatelessWidget {
  const ManageFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {},
        onDoubleTap: () {},
        child: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          backgroundColor: Colors.green.shade600,
          child: Icon(Icons.add_sharp, color: Colors.white),
        ));
  }
}
