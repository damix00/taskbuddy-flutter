import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskbuddy/widgets/input/touchable/other_touchables/touchable.dart';

enum CurrentAttachmentType {
  IMAGE,
  VIDEO,
  AUDIO,
  FILE
}

class CurrentAttachment {
  final XFile file;
  final CurrentAttachmentType type;

  CurrentAttachment(this.file, this.type);
}

class AttachmentsDiplay extends StatelessWidget {
  final List<CurrentAttachment> attachments;
  final Function(List<CurrentAttachment>) onAttachmentsChanged;

  const AttachmentsDiplay({
    Key? key,
    required this.attachments,
    required this.onAttachmentsChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: attachments[index].type == CurrentAttachmentType.IMAGE
                      ? Image.file(
                          File(attachments[index].file.path),
                          fit: BoxFit.cover,
                        )
                      : attachments[index].type == CurrentAttachmentType.VIDEO
                        ? Container(
                            color: Theme.of(context).colorScheme.primary,
                            child: Center(
                              child: Icon(
                                Icons.videocam_outlined,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.primary,
                            child: Center(
                              child: Icon(
                                Icons.insert_drive_file_outlined,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                  ),
                  
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Touchable(
                      onTap: () {
                        List<CurrentAttachment> newAttachments = attachments;
                        newAttachments.removeAt(index);
                        onAttachmentsChanged(newAttachments);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }
}