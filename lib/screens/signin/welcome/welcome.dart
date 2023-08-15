import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:taskbuddy/screens/signin/welcome/first_screen.dart';
import 'package:taskbuddy/utils/constants.dart';
import 'package:taskbuddy/widgets/button.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: PageView(
                    onPageChanged: (page) {
                      setState(() {
                        _selectedPage = page;
                      });
                    },
                    controller: _controller,
                    pageSnapping: true,
                    children: [
                      const WelcomeFirstScreen(),
                      Container(
                        color: Colors.blue,
                      ),
                      Container(
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 30,),
                    PageViewDotIndicator(
                      currentItem: _selectedPage,
                      size: const Size(10, 10),
                      count: 3,
                      unselectedColor: Constants.secondaryBgColor,
                      selectedColor: Constants.primaryColor,
                    ),
                    const _WelcomeButtons(),
                  ],
                )
              ],
            ),
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
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Button(
              child: const Text(
                'Registrirajte se',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {}),
          SizedBox(
            height: 15,
          ),
          Button(
            child: Text('Prijavite se'),
            onPressed: () {},
            type: ButtonType.outlined,
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }
}
