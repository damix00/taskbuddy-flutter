import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/verify_phone/first_page.dart';
import 'package:taskbuddy/widgets/overlays/required_actions/verify_phone/second_page.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({Key? key}) : super(key: key);

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  int _index = 0;

  void _onContinue() {
    setState(() {
      _index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollbarSingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
      child: [
        VerifyPhoneFirstPage(onContinue: _onContinue,),
        const VerifyPhoneSecondPage(),
      ][_index]
    ));
  }
}
