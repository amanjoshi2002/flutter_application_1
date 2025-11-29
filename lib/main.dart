import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'services/overlay_service.dart';
import 'screens/analysis_result_screen.dart';
import 'models/analysis_response.dart';

@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayWidget(),
  ));
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TruthCourt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TruthCourt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final OverlayService _overlayService = OverlayService();
  bool _isOverlayActive = false;
  AnalysisResponse? _latestAnalysis;

  @override
  void initState() {
    super.initState();
    _checkOverlayPermission();
    _listenToOverlayData();
  }

  Future<void> _checkOverlayPermission() async {
    final hasPermission = await _overlayService.checkPermission();
    setState(() {
      _isOverlayActive = hasPermission && _overlayService.isOverlayActive;
    });
  }

  void _listenToOverlayData() {
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data['action'] == 'analysis_complete') {
        final resultMap = data['result'] as Map<String, dynamic>;
        final analysis = AnalysisResponse.fromJson(resultMap);
        setState(() {
          _latestAnalysis = analysis;
        });
        
        // Navigate to result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisResultScreen(analysis: analysis),
          ),
        );
      }
    });
  }

  Future<void> _toggleOverlay() async {
    if (_isOverlayActive) {
      await _overlayService.hideOverlay();
      setState(() {
        _isOverlayActive = false;
      });
    } else {
      await _overlayService.showOverlay();
      setState(() {
        _isOverlayActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF1D1E33),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'TruthCourt',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Fact-check messages with AI-powered analysis',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'How to use:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStep('1', 'Enable the hover ball below'),
                    _buildStep('2', 'Copy any text message'),
                    _buildStep('3', 'Tap the floating ball'),
                    _buildStep('4', 'Wait for analysis (up to 2 min)'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _toggleOverlay,
                icon: Icon(_isOverlayActive ? Icons.visibility_off : Icons.visibility),
                label: Text(
                  _isOverlayActive ? 'Hide Hover Ball' : 'Show Hover Ball',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: _isOverlayActive ? Colors.orange : Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              if (_latestAnalysis != null) ...[
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AnalysisResultScreen(analysis: _latestAnalysis!),
                      ),
                    );
                  },
                  child: const Text('View Latest Analysis'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({Key? key}) : super(key: key);

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  bool _isLoading = false;
  String? _statusMessage;

  Future<void> _handleTap() async {
    // This will be implemented with clipboard reading
    setState(() {
      _isLoading = true;
      _statusMessage = "Feature coming soon!";
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _isLoading ? null : _handleTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Container(
            width: 80,
            height: 80,
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 35,
                  ),
          ),
        ),
      ),
    );
  }
}
