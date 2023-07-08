import 'package:flutter/material.dart';

void showModalG(
  BuildContext context, {
  required Widget child,
}) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child,
          SizedBox(height: 14),
        ],
      );
    },
  );
}
