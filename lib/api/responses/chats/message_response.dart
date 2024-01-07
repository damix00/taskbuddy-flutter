import 'dart:convert';

class MessageSender {
  String UUID;
  String username;
  String firstName;
  String lastName;
  String profilePicture;
  bool isMe;

  MessageSender({
    required this.UUID,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.isMe,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      UUID: json['uuid'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'] ?? "",
      isMe: json['is_me'],
    );
  }

  String toJson() {
    return jsonEncode({
      "uuid": UUID,
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "profile_picture": profilePicture,
      "is_me": isMe,
    });
  }
}

class RequestMessageType {
  static const int LOCATION = 0;
  static const int PRICE = 1;
  static const int DATE = 2;
  static const int PHONE_NUMBER = 3;
  static const int DEAL = 4;
}

class MessageRequest {
  static int PENDING = 0;
  static int ACCEPTED = 1;
  static int DECLINED = 2;

  int status;
  int type;

  MessageRequest({
    required this.status,
    required this.type,
  });

  String toJson() {
    return jsonEncode({
      "status": status,
    });
  }
}

class MessageAttachment {
  static int IMAGE = 0;
  static int VIDEO = 1;
  static int AUDIO = 2;
  static int DOCUMENT = 3;

  int type;
  String url;

  MessageAttachment({
    required this.type,
    required this.url,
  });

  String toJson() {
    return jsonEncode({
      "type": type,
      "url": url,
    });
  }
}

class MessageResponse {
  MessageSender sender;
  String UUID;
  String channelUUID;
  bool deleted;
  String message;
  MessageRequest? request;
  List<MessageAttachment> attachments;
  DateTime createdAt;
  bool edited;
  DateTime? editedAt;
  bool seen;
  DateTime? seenAt;

  MessageResponse({
    required this.sender,
    required this.UUID,
    required this.channelUUID,
    required this.deleted,
    required this.message,
    required this.request,
    required this.attachments,
    required this.createdAt,
    required this.edited,
    required this.editedAt,
    required this.seen,
    required this.seenAt,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      sender: MessageSender.fromJson(json['sender']),
      UUID: json['uuid'],
      channelUUID: json['channel_uuid'],
      deleted: json['deleted'],
      message: json['message'],
      request: json['request'] != null
          ? MessageRequest(
              status: json['request']['status'],
              type: json['request']['type'],
            )
          : null,
      attachments: json['attachments']
          .map<MessageAttachment>((attachment) => MessageAttachment(
                type: attachment['type'],
                url: attachment['url'],
              ))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      edited: json['edited'],
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'])
          : null,
      seen: json['seen'],
      seenAt: json['seen_at'] != null ? DateTime.parse(json['seen_at']) : null,
    );
  }

  String toJson() {
    return jsonEncode({
      "sender": sender.toJson(),
      "uuid": UUID,
      "deleted": deleted,
      "message": message,
      "request": request,
      "attachments": attachments.map((attachment) => attachment.toJson()),
      "created_at": createdAt.toIso8601String(),
      "edited": edited,
      "edited_at": editedAt?.toIso8601String(),
      "seen": seen,
      "seen_at": seenAt?.toIso8601String(),
    });
  }

  MessageResponse clone() {
    return MessageResponse(
      sender: sender,
      UUID: UUID,
      channelUUID: channelUUID,
      deleted: deleted,
      message: message,
      request: request,
      attachments: attachments,
      createdAt: createdAt,
      edited: edited,
      editedAt: editedAt,
      seen: seen,
      seenAt: seenAt,
    );
  }
}
