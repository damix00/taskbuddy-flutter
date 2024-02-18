import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/screens/signin/welcome/first_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/second_screen.dart';
import 'package:taskbuddy/screens/signin/welcome/third_screen.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/input/touchable/buttons/button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller =
      PageController(); // A controller for handling page navigation
  int _selectedPage = 0; // The currently selected page index
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Set up a periodic timer to switch pages every 10 seconds
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      try {
        setState(() {
          // Change the selected page index
          if (_selectedPage == 2) {
            _selectedPage = 0;
          } else {
            _selectedPage++;
          }
        });

        // Animate to the newly selected page using the controller
        _controller.animateToPage(
          _selectedPage,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOutCirc,
        );
      }
      // Catch any errors that may occur when the user is not on the page
      catch (_) {}
    });
  }

  @override
  void dispose() {
    // Dispose of the page controller to prevent memory leaks
    _controller.dispose();

    // Cancel the timer to prevent errors
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollbarSingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTapDown: (details) {
                  // Stop the timer when the user taps down
                  timer.cancel();
                },
                child: SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: PageView(
                    onPageChanged: (page) {
                      // Update the selected page index when the user manually changes pages
                      setState(() {
                        _selectedPage = page;
                      });
                    },
                    controller:
                        _controller, // Pass the controller for managing page changes
                    pageSnapping: true,
                    children: const [
                      WelcomeFirstScreen(),
                      WelcomeSecondScreen(),
                      WelcomeThirdScreen(),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  PageViewDotIndicator(
                    currentItem:
                        _selectedPage, // Current selected page for indicator
                    size: const Size(10, 10),
                    count: 3, // Total number of pages
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
          // Login button
          Button(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            type: ButtonType.outlined,
            child: Text(AppLocalizations.of(context)!.loginBtn),
          ),
          // Add some vertical spacing between the buttons
          const SizedBox(
            height: 15,
          ),
          // Register button
          Button(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: ButtonText(AppLocalizations.of(context)!.registerBtn)
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }
}
