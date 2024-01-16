import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskbuddy/api/api.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';
import 'package:taskbuddy/api/responses/chats/message_response.dart';
import 'package:taskbuddy/cache/account_cache.dart';

class MessagesModel extends ChangeNotifier {
  int _incomingOffset = 0;
  int _outgoingOffset = 0;
  
  bool _hasMoreIncoming = true;
  bool _hasMoreOutgoing = true;

  bool _loadingOutgoing = true;
  bool _loadingIncoming = true;

  List<ChannelResponse> _incomingMessages = [];
  List<ChannelResponse> _outgoingMessages = [];

  List<ChannelResponse> get incomingMessages => _incomingMessages;
  List<ChannelResponse> get outgoingMessages => _outgoingMessages;

  bool get loadingIncoming => _loadingIncoming;
  bool get loadingOutgoing => _loadingOutgoing;

  bool get hasMoreIncoming => _hasMoreIncoming;
  bool get hasMoreOutgoing => _hasMoreOutgoing;

  set incomingOffset(int value) {
    _incomingOffset = value;
    notifyListeners();
  }

  set outgoingOffset(int value) {
    _outgoingOffset = value;
    notifyListeners();
  }

  set hasMoreIncoming(bool value) {
    _hasMoreIncoming = value;
    notifyListeners();
  }

  set hasMoreOutgoing(bool value) {
    _hasMoreOutgoing = value;
    notifyListeners();
  }

  set outgoingMessages(List<ChannelResponse> value) {
    _outgoingMessages = value;
    notifyListeners();
  }

  set incomingMessages(List<ChannelResponse> value) {
    _incomingMessages = value;
    notifyListeners();
  }

  Future<void> readFromCache() async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    var incomingMessages = await storage.read(key: 'incomingMessages');

    if (incomingMessages != null) {
      _incomingMessages = (incomingMessages as List<dynamic>).map((e) => ChannelResponse.fromJson(e)).toList();
    }

    var outgoingMessages = await storage.read(key: 'outgoingMessages');

    if (outgoingMessages != null) {
      _outgoingMessages = (outgoingMessages as List<dynamic>).map((e) => ChannelResponse.fromJson(e)).toList();
    }

    notifyListeners();
  }

  Future<void> saveToCache() async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    await storage.write(key: 'incomingMessages', value: _incomingMessages.map((e) => e.toJson()).toList().toString());
    await storage.write(key: 'outgoingMessages', value: _outgoingMessages.map((e) => e.toJson()).toList().toString());
  }

  Future<void> fetchIncoming() async {
    if (!_hasMoreIncoming) return;

    // Read the auth token
    String token = (await AccountCache.getToken())!;

    _loadingIncoming = true;
    notifyListeners();

    // Fetch incoming messages
    var incoming = await Api.v1.channels.getIncomingMessages(token, offset: _incomingOffset);
    
    if (incoming.ok) {
      if (incoming.data!.length < 20) {
        _hasMoreIncoming = false;
      } else {
        _incomingOffset += incoming.data!.length;
      }
      _incomingMessages.addAll(incoming.data!);
    }

    _loadingIncoming = false;
    notifyListeners();
  }

  Future<void> fetchOutgoing() async {
    if (!_hasMoreOutgoing) return;

    // Read the auth token
    String token = (await AccountCache.getToken())!;

    _loadingOutgoing = true;
    notifyListeners();

    // Fetch outgoing messages
    var outgoing = await Api.v1.channels.getOutgoingMessages(token, offset: _outgoingOffset);

    if (outgoing.ok) {
      if (outgoing.data!.length < 20) {
        _hasMoreOutgoing = false;
      } else {
        _outgoingOffset += outgoing.data!.length;
      }
      _outgoingMessages.addAll(outgoing.data!);
    }

    _loadingOutgoing = false;
    notifyListeners();
  }

  Future<void> fetchMessages() async {
    await fetchIncoming();
    await fetchOutgoing();
  }

  ChannelResponse? hasPost(String postUUID) {
    for (ChannelResponse channel in _incomingMessages) {
      if (channel.post.UUID == postUUID) {
        return channel;
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      if (channel.post.UUID == postUUID) {
        return channel;
      }
    }

    return null;
  }

  void addIncomingChannel(ChannelResponse channel) {
    if (_incomingMessages.indexWhere((element) => element.uuid == channel.uuid) == -1) {
      _incomingMessages.add(channel);
    }

    // Sort by last message time
    _incomingMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    notifyListeners();
  }

  void addOutgoingChannel(ChannelResponse channel) {
    if (_outgoingMessages.indexWhere((element) => element.uuid == channel.uuid) == -1) {
      _outgoingMessages.add(channel);
    }

    // Sort by last message time
    _outgoingMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

    notifyListeners();
  }

  void clear() {
    _incomingOffset = 0;
    _outgoingOffset = 0;
    _hasMoreIncoming = true;
    _hasMoreOutgoing = true;
    _loadingOutgoing = true;
    _loadingIncoming = true;
    _incomingMessages = [];
    _outgoingMessages = [];
    notifyListeners();
  }

  void setAsSeen(String uuid) {
    int index = _incomingMessages.indexWhere((element) => element.uuid == uuid);
    if (
      index != -1 &&
      _incomingMessages[index].lastMessages.last.sender != null &&
      !_incomingMessages[index].lastMessages.last.sender!.isMe
    ) {
      _incomingMessages[index].lastMessages.last.seen = true;
    }

    index = _outgoingMessages.indexWhere((element) => element.uuid == uuid);
    if (index != -1 &&
      _outgoingMessages[index].lastMessages.last.sender != null &&
      !_outgoingMessages[index].lastMessages.last.sender!.isMe
    ) {
      _outgoingMessages[index].lastMessages.last.seen = true;
    }
    notifyListeners();
  }
  
  void onMessage(String channelUuid, MessageResponse response) {
    for (ChannelResponse channel in _incomingMessages) {
      if (channel.uuid == channelUuid) {
        // Check if the message already exists
        if (channel.lastMessages.indexWhere((element) => element.UUID == response.UUID) == -1) {
          channel.lastMessages.add(response);
          channel.lastMessageTime = DateTime.now();
        }
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      if (channel.uuid == channelUuid) {
        // Check if the message already exists
        if (channel.lastMessages.indexWhere((element) => element.UUID == response.UUID) == -1) {
          channel.lastMessages.add(response);
          channel.lastMessageTime = DateTime.now();
        }
      }
    }

    notifyListeners();
  }

  void insertMessage(MessageResponse response, { bool notify = true }) {
    for (ChannelResponse channel in _incomingMessages) {
      if (channel.uuid == response.channelUUID) {
        // Check if the message already exists
        if (channel.lastMessages.indexWhere((element) => element.UUID == response.UUID) == -1) {
          channel.lastMessages.insert(0, response);
        }
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      if (channel.uuid == response.channelUUID) {
        // Check if the message already exists
        if (channel.lastMessages.indexWhere((element) => element.UUID == response.UUID) == -1) {
          channel.lastMessages.insert(0, response);
        }
      }
    }

    if (notify) {
      notifyListeners();
    }
  }

  void insertMessages(List<MessageResponse> responses) {
    for (MessageResponse response in responses) {
      insertMessage(response, notify: false);
    }

    notifyListeners();
  }

  void sortChannels() {
    _incomingMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    _outgoingMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    
    notifyListeners();
  }

  ChannelResponse? getChannelByUuid(String uuid) {
    for (ChannelResponse channel in _incomingMessages) {
      if (channel.uuid == uuid) {
        return channel;
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      if (channel.uuid == uuid) {
        return channel;
      }
    }

    return null;
  }

  void deleteMessage(String messageUuid) {
    for (ChannelResponse channel in _incomingMessages) {
      int index = channel.lastMessages.indexWhere((element) => element.UUID == messageUuid);

      if (index != -1) {
        channel.lastMessages[index].deleted = true;
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      int index = channel.lastMessages.indexWhere((element) => element.UUID == messageUuid);

      if (index != -1) {
        channel.lastMessages[index].deleted = true;
      }
    }

    notifyListeners();
  }

  void updateChannel(ChannelResponse channel) {
    int index = _incomingMessages.indexWhere((element) => element.uuid == channel.uuid);

    if (index != -1) {
      _incomingMessages[index] = channel;
    }

    index = _outgoingMessages.indexWhere((element) => element.uuid == channel.uuid);

    if (index != -1) {
      _outgoingMessages[index] = channel;
    }

    notifyListeners();
  }

  void updateMessage(MessageResponse message) {
    for (ChannelResponse channel in _incomingMessages) {
      int index = channel.lastMessages.indexWhere((element) => element.UUID == message.UUID);

      if (index != -1) {
        channel.lastMessages[index] = message;
      }
    }

    for (ChannelResponse channel in _outgoingMessages) {
      int index = channel.lastMessages.indexWhere((element) => element.UUID == message.UUID);

      if (index != -1) {
        channel.lastMessages[index] = message;
      }
    }

    notifyListeners();
  }
}