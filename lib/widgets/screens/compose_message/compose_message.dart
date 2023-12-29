import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/chat_screen.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/ui/feedback/snackbars.dart';
import 'package:taskbuddy/widgets/ui/platforms/bottom_sheet.dart';
import 'package:taskbuddy/widgets/ui/platforms/loader.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComposeMessageSheet extends StatefulWidget {
  final PostResultsResponse post;
  final double height;

  const ComposeMessageSheet({Key? key, required this.post, required this.height}) : super(key: key);

  @override
  State<ComposeMessageSheet> createState() => _ComposeMessageSheetState();
}

class _ComposeMessageSheetState extends State<ComposeMessageSheet> {
  bool _loading = true;
  bool _sending = false;
  final TextEditingController _textController = TextEditingController();

  Future<void> _init() async {
    String token = (await AccountCache.getToken())!;

    var channel = await Api.v1.channels.getChannelFromPost(token, postUUID: widget.post.UUID);

    
    if (channel.ok && channel.data != null) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => ChatScreen(
            channel: channel.data!
          ),
        ),
      );
    }

    else {
      setState(() {
        _loading = false;
      });
    }

  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  List<Widget> getChildren(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    
    return [
      // This is the "appbar"
      // It's shown on the top of the bottom sheet
      Container(
        height: Sizing.appbarHeight,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close button
            Touchable(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurface
                ),
              ),
            ),
            // The appbar
            Expanded(
              child: ChatScreenAppbar(
                profilePicture: widget.post.user.profilePicture,
                title: widget.post.title,
                price: widget.post.price.toString(),
                firstName: widget.post.user.firstName,
                lastName: widget.post.user.lastName
              ),
            ),
          ],
        )
      ),
      // Initiate conversation text
      Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          l10n.initiateConversation,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      // Padding
      // Because this doesn't support the Spacer widget, we have to use a SizedBox
      SizedBox(height: widget.height - Sizing.appbarHeight - 128 - MediaQuery.of(context).padding.bottom,),
      // Text input
      Container(
        height: 44,
        width: MediaQuery.of(context).size.width - 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text input
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: l10n.typeAMessage,
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Send button
            Touchable(
              disabled: _sending,
              onTap: () async {
                if (_textController.text.isEmpty) {
                  return;
                }

                setState(() {
                  _sending = true;
                });

                String token = (await AccountCache.getToken())!;

                var channel = await Api.v1.channels.initiateConversation(
                  token,
                  postUUID: widget.post.UUID,
                  message: _textController.text
                );

                setState(() {
                  _sending = false;
                });

                if (channel.ok && channel.data != null) {
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (context) => ChatScreen(
                        channel: channel.data!
                      ),
                    ),
                  );
                }

                else {
                  SnackbarPresets.error(
                    context,
                    l10n.somethingWentWrong
                  );

                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.send,
                      size: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: widget.height,
        child: BottomSheetBase(
          backgroundColor: Theme.of(context).colorScheme.background,
          topBarColor: _loading ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surface,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          scrollable: false,
          children: [
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CrossPlatformLoader(),
              )
            
            else
              ...getChildren(context)
          ]
        ),
      ),
    );
  }
}