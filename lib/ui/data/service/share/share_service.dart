import 'dart:async';
import 'package:share_handler/share_handler.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;

  ShareService._internal();

  final handler = ShareHandler.instance;

  final _controller = StreamController.broadcast();

  Stream get stream => _controller.stream;

  void init() {
    handler.sharedMediaStream.listen((media) {
      _controller.add(media);
    });

    handler.getInitialSharedMedia().then((media) {
      if (media != null) {
        _controller.add(media);
      }
    });
  }
}