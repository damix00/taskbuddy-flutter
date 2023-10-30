import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _LoadingIOS extends StatelessWidget {
  const _LoadingIOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.all(Radius.circular(4))
      ),
      child: const CupertinoActivityIndicator(),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Platform.isIOS ? const _LoadingIOS() : const CircularProgressIndicator(),
      ),
    );
  }
}