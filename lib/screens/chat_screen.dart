import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';
import 'package:taskbuddy/screens/profile/profile_screen.dart';
import 'package:taskbuddy/state/providers/messages.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/input/with_state/pfp_input.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:taskbuddy/widgets/screens/chat/chat_layout.dart';

class ChatScreenAppbar extends StatelessWidget {
  final String profilePicture;
  final String title;
  final String price;
  final String firstName;
  final String lastName;

  const ChatScreenAppbar({
    Key? key,
    required this.profilePicture,
    required this.title,
    required this.price,
    required this.firstName,
    required this.lastName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: ProfilePictureDisplay(
            size: 32,
            iconSize: 20,
            profilePicture: profilePicture
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    " • €$price",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900
                    )
                  )
                ],
              ),
              Text(
                "${firstName} ${lastName}",
                style: Theme.of(context).textTheme.labelSmall
              )
            ],
          ),
        ),
        const SizedBox(width: 24,)
      ],
    );
  }
}

class ChatScreen extends StatefulWidget {
  final ChannelResponse? channel;
  final String? channelUuid;

  const ChatScreen({
    Key? key,
    this.channel,
    this.channelUuid
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChannelResponse? _channel;
  bool _loading = false;

  void _loadChannel() async {
    String token = (await AccountCache.getToken())!;

    var data = await Api.v1.channels.getChannelByUuid(token, widget.channelUuid!);

    if (data.ok) {
      setState(() {
        _channel = data.data;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _channel = widget.channel;

    // Assert that either channel or channelUuid is not null
    assert(widget.channelUuid != null || widget.channel != null);

    if (_channel == null) {
      MessagesModel model = Provider.of<MessagesModel>(context, listen: false);

      _channel = model.getChannelByUuid(widget.channelUuid!);

      if (_channel == null) {
        _loading = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadChannel();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BlurAppbar.appBar(
        child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Touchable(
          onTap: () => {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => ProfileScreen(
                account: _channel!.otherUserAccount
              ))
            )
          },
          child: ChatScreenAppbar(
            profilePicture: _channel!.otherUserAccount.profile.profilePicture,
            title: _channel!.post.title,
            price: _channel!.negotiatedPrice.toString(),
            firstName: _channel!.otherUserAccount.firstName,
            lastName: _channel!.otherUserAccount.lastName
          )
        )
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : ChatLayout(channel: _channel!)
    );
  }
}