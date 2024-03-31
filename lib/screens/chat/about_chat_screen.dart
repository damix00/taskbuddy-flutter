import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/posts/post_results_response.dart';
import 'package:taskbuddy/screens/post/post_screen.dart';
import 'package:taskbuddy/utils/dates.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:taskbuddy/widgets/screens/chat/about_chat/about_chat_location.dart';
import 'package:taskbuddy/widgets/ui/platforms/scrollbar_scroll_view.dart';
import 'package:taskbuddy/widgets/ui/post_card/post_card.dart';
import 'package:taskbuddy/widgets/ui/sizing.dart';
import 'package:taskbuddy/widgets/ui/tiles/account_tile.dart';
import 'package:taskbuddy/widgets/ui/visual/divider.dart';

class AboutChatScreen extends StatelessWidget {
  final ChannelResponse channel;

  const AboutChatScreen({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(
          l10n.aboutThisChat
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ScrollbarSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizing.horizontalPadding),
          child: AboutChatContent(channel: channel)
        ),
      )
    );
  }
}

class AboutChatContent extends StatelessWidget {
  final ChannelResponse channel;

  const AboutChatContent({Key? key, required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    double padding = MediaQuery.of(context).padding.top;

    String status;
    Color? statusColor;

    switch (channel.status) {
      case ChannelStatus.PENDING:
        status = l10n.pending;
        break;
      case ChannelStatus.ACCEPTED:
        status = l10n.accepted;
        statusColor = Theme.of(context).colorScheme.primary;
        break;
      case ChannelStatus.REJECTED:
        status = l10n.rejected;
        statusColor = Theme.of(context).colorScheme.error;
        break;
      case ChannelStatus.COMPLETED:
        status = l10n.completed;
        statusColor = Colors.green;
        break;
      case ChannelStatus.CANCELLED:
        status = l10n.cancelled;
        break;
      default:
        status = l10n.pending;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: padding + Sizing.horizontalPadding),
        Text(
          l10n.account,
          style: Theme.of(context).textTheme.displaySmall
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AccountTile(
            account: channel.otherUserAccount,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            l10n.postTitle,
            style: Theme.of(context).textTheme.displaySmall
          ),
        ),
        Touchable(
          onTap: () => Navigator.of(context).pushNamed(
            "/post",
            arguments: PostScreenArguments(
              post: PostResultsResponse.fromPostOnlyResponse(channel.post, channel.postCreator),
            )
          ),
          child: PostCard(
            padding: false,
            post: PostResultsResponse.fromPostOnlyResponse(channel.post, channel.postCreator),
          ),
        ),
        const CustomDivider(padding: Sizing.horizontalPadding,),
        Text(
          l10n.negotiatedPrice,
          style: Theme.of(context).textTheme.displaySmall
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "€${channel.negotiatedPrice}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            )
          ),
        ),
        Text(
          l10n.negotiatedDate,
          style: Theme.of(context).textTheme.displaySmall
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            Dates.formatDate(channel.negotiatedDate),
            style: Theme.of(context).textTheme.bodyMedium
          ),
        ),
        Text(
          l10n.jobStatus,
          style: Theme.of(context).textTheme.displaySmall
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            status,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: statusColor
            )
          ),
        ),
        const CustomDivider(padding: Sizing.horizontalPadding,),
        AboutChatLocation(channel: channel),
      ],
    );
  }
}
