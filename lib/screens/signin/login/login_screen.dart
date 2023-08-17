import 'package:flutter/material.dart';
import 'package:taskbuddy/widgets/appbar/blur_appbar.dart';
import 'package:taskbuddy/widgets/input/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/input/text_input.dart';
import 'package:taskbuddy/widgets/input/touchable/button.dart';
import 'package:taskbuddy/widgets/input/touchable/link_text.dart';
import 'package:taskbuddy/widgets/ui/gradient_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BlurAppbar.appBar(),
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context)
                  .size
                  .height, // Set minimum height to the screen height
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ScreenTitle(),
                SizedBox(
                  height: 26,
                ),
                _LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GradientText(AppLocalizations.of(context)!.loginTitle,
              gradient: GradientText.getDefaultGradient(context)),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.loginDesc,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextInput(label: AppLocalizations.of(context)!.email, hint: 'latinary@example.com'),
          const SizedBox(height: 12,),
          TextInput(label: AppLocalizations.of(context)!.password, hint: 'coolpassword123', obscureText: true,),
          const SizedBox(height: 26),
          Button(
            child: Text(
              AppLocalizations.of(context)!.loginBtn,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {}
          ),
          const SizedBox(height: 12,),
          LinkText(text: 'Forgot password?', onTap: () {}),
          const SizedBox(height: 6,),
          LinkText(text: "Don't have an account?", onTap: () {}),
        ],
      ),
    );
  }
}
