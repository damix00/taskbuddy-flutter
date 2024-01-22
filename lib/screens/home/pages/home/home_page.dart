import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/misc_cache.dart';
import 'package:taskbuddy/screens/home/pages/home/first_time.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/screens/posts/post.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';

class HomePageAppbar extends StatelessWidget {
  const HomePageAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppbarTitle(l10n.suggested)
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  bool _firstTime = true;
  
  List<PostResultsResponse> _posts = [];

  Future<void> _init() async {
  }

  Future<void> _markFirstTime() async {
    await MiscCache.setFirstTimeScroll(true);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _firstTime = await MiscCache.getFirstTimeScroll();
      
      setState(() {});

      _init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _posts.length + (_loading ? 1 : 0) + (_firstTime ? 0 : 1),
      itemBuilder: (context, index) {
        if (!_firstTime && index == 0) {
          return const FirstTime();
        }

        if (!_firstTime) {
          index--;
        }

        if (!_firstTime && index == 1) {
          _markFirstTime();
        }

        if (_loading && index == _posts.length) {
          return const Center(
            child: CrossPlatformLoader(),
          );
        }

        return PostLayout(
          post: _posts[index],
        );
      },
    );
  }
}