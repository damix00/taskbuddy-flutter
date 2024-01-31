import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/widgets/navigation/blur_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_video_view/native_video_view.dart';

class AttachmentViewScreen extends StatelessWidget {
  final List<MessageAttachment> attachments;
  final int index;

  const AttachmentViewScreen({
    Key? key,
    required this.attachments,
    this.index = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BlurAppbar.appBar(
        child: AppbarTitle(l10n.attachments)
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        controller: PageController(
          initialPage: index
        ),
        itemBuilder: (context, i) {
          if (attachments[i].type == MessageAttachment.IMAGE) {
            return InteractiveViewer(
              child: Center(
                child: Hero(
                  tag: attachments[i].url,
                  child: CachedNetworkImage(
                    imageUrl: attachments[i].url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }

          else if (attachments[i].type == MessageAttachment.VIDEO) {
            return Center(
              child: InteractiveViewer(
                child: Hero(
                  tag: attachments[i].url,
                  child: NativeVideoView(
                    keepAspectRatio: true,
                    showMediaController: true,
                    onCreated: (controller) {
                      controller.setVideoSource(
                        attachments[i].url,
                        sourceType: VideoSourceType.network
                      );
                      controller.play();
                    },
                    onPrepared: (controller, info) {
                      controller.play();
                    },
                    onError: (controller, what, extra, message) {
                      print('Error: $what, $extra, $message');
                    },
                    onCompletion: (controller) {
                      controller.pause();
                    },
                  )
                ),
              ),
            );
          }

          return Container();
        }
      )
    );
  }
}