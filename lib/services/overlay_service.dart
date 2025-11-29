import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  static final OverlayService _instance = OverlayService._internal();
  factory OverlayService() => _instance;
  OverlayService._internal();

  bool _isOverlayActive = false;

  /// Check if overlay permission is granted
  Future<bool> checkPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  /// Request overlay permission
  Future<bool> requestPermission() async {
    final bool? result = await FlutterOverlayWindow.requestPermission();
    return result ?? false;
  }

  /// Show the hover ball overlay
  Future<void> showOverlay() async {
    if (_isOverlayActive) {
      return;
    }

    final hasPermission = await checkPermission();
    if (!hasPermission) {
      final granted = await requestPermission();
      if (!granted) {
        return;
      }
    }

    await FlutterOverlayWindow.showOverlay(
      height: 100,
      width: 100,
      alignment: OverlayAlignment.centerRight,
      visibility: NotificationVisibility.visibilityPublic,
      flag: OverlayFlag.defaultFlag,
      enableDrag: true,
    );

    _isOverlayActive = true;
  }

  /// Hide the hover ball overlay
  Future<void> hideOverlay() async {
    if (_isOverlayActive) {
      await FlutterOverlayWindow.closeOverlay();
      _isOverlayActive = false;
    }
  }

  /// Share data with overlay
  Future<void> shareDataWithOverlay(Map<String, dynamic> data) async {
    await FlutterOverlayWindow.shareData(data);
  }

  bool get isOverlayActive => _isOverlayActive;
}

