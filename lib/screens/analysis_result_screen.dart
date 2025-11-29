import 'package:flutter/material.dart';
import '../models/analysis_response.dart';

class AnalysisResultScreen extends StatelessWidget {
  final AnalysisResponse analysis;

  const AnalysisResultScreen({Key? key, required this.analysis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Analysis Result'),
        backgroundColor: const Color(0xFF1D1E33),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verdict Card
            _buildVerdictCard(),
            const SizedBox(height: 20),

            // Summary Card
            _buildSummaryCard(),
            const SizedBox(height: 20),

            // Evidence Section
            _buildEvidenceSection(),
            const SizedBox(height: 20),

            // Arguments Section
            _buildArgumentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerdictCard() {
    final isScam = analysis.verdict.toUpperCase() == 'SCAM';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isScam
              ? [Colors.red.shade700, Colors.red.shade900]
              : [Colors.green.shade700, Colors.green.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isScam ? Colors.red : Colors.green).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isScam ? Icons.warning_rounded : Icons.check_circle_rounded,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            analysis.verdict.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            analysis.message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, color: Colors.blue.shade300),
              const SizedBox(width: 8),
              const Text(
                'Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            analysis.summary,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection() {
    if (analysis.evidence.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade300),
              const SizedBox(width: 8),
              const Text(
                'Key Evidence',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analysis.evidence.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildArgumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.forum, color: Colors.purple.shade300),
            const SizedBox(width: 8),
            const Text(
              'Debate Arguments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...analysis.arguments.asMap().entries.map((entry) {
          final index = entry.key;
          final argument = entry.value;
          final isScamAnalyst = argument.speaker == 'Scam Analyst';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isScamAnalyst
                    ? Colors.red.withOpacity(0.3)
                    : Colors.green.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isScamAnalyst
                            ? Colors.red.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        argument.speaker,
                        style: TextStyle(
                          color: isScamAnalyst ? Colors.red.shade300 : Colors.green.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Round ${(index ~/ 2) + 1}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _formatArgument(argument.argument),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                if (argument.argument.length > 500)
                  TextButton(
                    onPressed: () {
                      // Show full argument in dialog
                    },
                    child: const Text('Read more'),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatArgument(String argument) {
    // Remove the "Round X:" prefix and clean up formatting
    String formatted = argument.replaceFirst(RegExp(r'Round \d+:\s*'), '');
    formatted = formatted.replaceAll('═', '');
    formatted = formatted.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return formatted.trim();
  }
}
