import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskbuddy/api/responses/chats/channel_response.dart';

class MessagesModel extends ChangeNotifier {
  int _incomingOffset = 0;
  int _outgoingOffset = 0;

  List<ChannelResponse> _incomingMessages = [];
  List<ChannelResponse> _outgoingMessages = [];

  List<ChannelResponse> get incomingMessages => _incomingMessages;
  List<ChannelResponse> get outgoingMessages => _outgoingMessages;

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

  Future<void> fetchIncomingMessages() async {
    // TODO Fetch incoming messages from API
  }

  Future<void> fetchOutgoingMessages() async {
    // TODO: Fetch outgoing messages from API
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

  void addIncomingMessage(ChannelResponse message) {
    _incomingMessages.add(message);
    notifyListeners();
  }

  void addOutgoingMessage(ChannelResponse message) {
    _outgoingMessages.add(message);
    notifyListeners();
  }

  void clearIncomingMessages() {
    _incomingMessages.clear();
    notifyListeners();
  }

  void clearOutgoingMessages() {
    _outgoingMessages.clear();
    notifyListeners();
  }

  void clearAllMessages() {
    _incomingMessages.clear();
    _outgoingMessages.clear();
    notifyListeners();
  }

  void removeIncomingChannel(ChannelResponse channel) {
    _incomingMessages.remove(channel);
    notifyListeners();
  }

  void removeOutgoingChannel(ChannelResponse channel) {
    _outgoingMessages.remove(channel);
    notifyListeners();
  }

  void removeChannel(ChannelResponse channel) {
    _incomingMessages.remove(channel);
    _outgoingMessages.remove(channel);
    notifyListeners();
  }

  void updateChannel(ChannelResponse channel) {
    int index = _incomingMessages.indexWhere((element) => element.uuid == channel.uuid);
    if (index != -1) {
      _incomingMessages[index] = channel;
    }
    notifyListeners();
  }
}