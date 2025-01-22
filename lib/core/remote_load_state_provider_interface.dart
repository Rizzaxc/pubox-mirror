import 'package:flutter/material.dart';

abstract class RemoteLoadStateProviderInterface extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> startLoading() async {
    _isLoading = true;
    notifyListeners();
  }
  Future<void> cancelLoading() async {
    _isLoading = false;
    notifyListeners();
  }

}
