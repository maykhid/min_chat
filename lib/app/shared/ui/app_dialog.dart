import 'dart:ui';

import 'package:flutter/material.dart';

class AppDialog {

  // pop dialog
  static void showAppDialog(
    BuildContext context,
    Widget widget, [
    Color? backgroundColor,
  ]) {
    showDialog<void>(
      barrierColor: Colors.transparent,
      context: context,
      // barrierDismissible: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ), // blurs the area underneath the modal
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: widget,
          ),
        ),
      ),
    );
  }
}
