import 'package:flutter/material.dart';

class OpenSourceLicenses extends StatelessWidget {
  const OpenSourceLicenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Source Licenses'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Licenses'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Flutter Gallery',
                applicationVersion: 'April 2020',
              );
            },
          ),
        ],
      ),
    );
  }
}
