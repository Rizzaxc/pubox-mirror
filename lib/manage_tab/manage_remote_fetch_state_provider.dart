import 'package:flutter/material.dart';

class ManageRemoteLoadStateProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> startLoading() async {
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 1));
    isLoading = false;
    notifyListeners();
  }
}
