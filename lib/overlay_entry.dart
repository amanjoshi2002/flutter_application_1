import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'services/api_service.dart';

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayApp());
}

class OverlayApp extends StatefulWidget {
  const OverlayApp({Key? key}) : super(key: key);

  @override
  State<OverlayApp> createState() => _OverlayAppState();
}

class _OverlayAppState extends State<OverlayApp> {
  bool _isLoading = false;
  String? _statusMessage;
  final ApiService _apiService = ApiService();

  Future<void> _handleTap() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = "Reading clipboard...";
      });

      // Read clipboard
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final clipboardText = clipboardData?.text;
      
      if (clipboardText == null || clipboardText.isEmpty) {
        setState(() {
          _isLoading = false;
          _statusMessage = "No text found. Copy text first.";
        });
        
        // Hide message after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _statusMessage = null;
            });
          }
        });
        return;
      }

      setState(() {
        _statusMessage = "Analyzing...\nThis may take up to 2 minutes";
      });

      // Call API
      final result = await _apiService.analyzeMessage(clipboardText);

      // Send result back to main app
      await FlutterOverlayWindow.shareData({
        'action': 'analysis_complete',
        'result': result.toJson(),
      });

      // Close overlay to show main app
      await FlutterOverlayWindow.closeOverlay();
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error: ${e.toString()}";
      });
      
      // Hide error after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _statusMessage = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: _isLoading ? null : _handleTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isLoading
                    ? [Colors.orange, Colors.deepOrange]
                    : [Colors.blue, Colors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 40,
                        ),
                ),
                if (_statusMessage != null)
                  Positioned(
                    bottom: -60,
                    left: -100,
                    right: -100,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusMessage!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
