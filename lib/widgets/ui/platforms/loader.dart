import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossPlatformLoader extends StatelessWidget {
  const CrossPlatformLoader({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const Center(child: CircularProgressIndicator());
    }

    return const Center(child: CupertinoActivityIndicator());
  }
}