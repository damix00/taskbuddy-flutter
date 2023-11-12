import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _LoadingIOS extends StatelessWidget {
  const _LoadingIOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 135, sigmaY: 135),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: const BorderRadius.all(Radius.circular(4))
          ),
          child: const CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key? key}) : super(key: key);
  
  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LoadingOverlay(),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useSafeArea: false
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // prevent the user from closing the dialog
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Platform.isIOS ? const _LoadingIOS() : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}