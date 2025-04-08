library;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

final supabase = Supabase.instance.client;

const genericErrorMessage = 'Something happened. Please try again.';

extension ContextExtension on BuildContext {
  void showToast(String message, {ToastificationType type = ToastificationType.success}) {
    toastification.show(
      margin: const EdgeInsets.fromLTRB(16, 48, 16, 8),
      type: type,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      description: Text(message),
      showProgressBar: false,
    );
  }
}

/// A dialog page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}

/// A bottom sheet page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class BottomSheetPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final bool isScrollControlled;
  final String? barrierLabel;
  final AnimationStyle? sheetAnimationStyle;
  final BoxConstraints? constrains;
  final bool useSafeArea;
  final WidgetBuilder builder;

  const BottomSheetPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.isDismissible = true,
    this.enableDrag = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.isScrollControlled = true,
    this.sheetAnimationStyle,
    this.constrains,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
        settings: this,
        isScrollControlled: isScrollControlled,
        builder: builder,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        constraints: constrains,
        anchorPoint: anchorPoint,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        sheetAnimationStyle: sheetAnimationStyle,
      );
}

class CupertinoModalPopupPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String barrierLabel;
  final bool semanticsDismissible;
  final WidgetBuilder builder;
  final ImageFilter? filter;

  const CupertinoModalPopupPage(
      {required this.builder,
      this.anchorPoint,
      this.barrierColor = kCupertinoModalBarrierColor,
      this.barrierDismissible = true,
      this.barrierLabel = "Dismiss",
      this.semanticsDismissible = true,
      this.filter,
      super.key});

  @override
  Route<T> createRoute(BuildContext context) => CupertinoModalPopupRoute<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      filter: filter,
      semanticsDismissible: semanticsDismissible,
      settings: this);
}
