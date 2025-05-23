import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationWrapper extends StatefulWidget {
  final Widget child;
  final bool hasUnsavedChanges;

  const ExitConfirmationWrapper({
    super.key,
    required this.child,
    this.hasUnsavedChanges = false,
  });

  @override
  State<ExitConfirmationWrapper> createState() =>
      _ExitConfirmationWrapperState();
}

class _ExitConfirmationWrapperState extends State<ExitConfirmationWrapper> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, val) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(context);
        if (shouldExit ?? false) {
          if (context.mounted) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop(); // Exit the app
            }
          }
        }
      },
      child: widget.child,
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menutup applikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('keluar'),
          ),
        ],
      ),
    );
  }
}
