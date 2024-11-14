import 'package:flutter/material.dart';

class ManageTab extends StatefulWidget {
  const ManageTab({super.key});

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Manage Tab'),
    );
  }
}
