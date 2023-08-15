import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/screens/signin/welcome/first_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/second_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/third_screen.dart';
import 'package:taskbuddy/widgets/input/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      // setState(() {
      //   if (_selectedPage == 2) {
      //     _selectedPage = 0;
      //   } else {
      //     _selectedPage++;
      //   }
      // });
      // _controller.animateToPage(_selectedPage,
      //     duration: const Duration(seconds: 1), curve: Curves.easeInOutCirc);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 600,
                width: double.infinity,
                child: PageView(
                  onPageChanged: (page) {
                    setState(() {
                      _selectedPage = page;
                    });
                  },
                  controller: _controller,
                  pageSnapping: true,
                  children: const [
                    WelcomeFirstScreen(),
                    WelcomeSecondScreen(),
                    WelcomeThirdScreen(),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  PageViewDotIndicator(
                    currentItem: _selectedPage,
                    size: const Size(10, 10),
                    count: 3,
                    unselectedColor: Theme.of(context).colorScheme.surface,
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
                  const _WelcomeButtons(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeButtons extends StatelessWidget {
  const _WelcomeButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Button(
              child: Text(
                AppLocalizations.of(context)!.registerBtn,
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {}),
          const SizedBox(
            height: 15,
          ),
          Button(
            onPressed: () {},
            type: ButtonType.outlined,
            child: Text(AppLocalizations.of(context)!.loginBtn),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }
}
