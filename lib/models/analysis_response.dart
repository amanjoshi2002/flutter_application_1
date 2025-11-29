class AnalysisResponse {
  final List<Argument> arguments;
  final int debateId;
  final List<String> evidence;
  final String judgeStatement;
  final String message;
  final String source;
  final String summary;
  final String verdict;

  AnalysisResponse({
    required this.arguments,
    required this.debateId,
    required this.evidence,
    required this.judgeStatement,
    required this.message,
    required this.source,
    required this.summary,
    required this.verdict,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      arguments: (json['arguments'] as List<dynamic>)
          .map((arg) => Argument.fromJson(arg as Map<String, dynamic>))
          .toList(),
      debateId: json['debate_id'] as int,
      evidence: (json['evidence'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      judgeStatement: json['judge_statement'] as String,
      message: json['message'] as String,
      source: json['source'] as String,
      summary: json['summary'] as String,
      verdict: json['verdict'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arguments': arguments.map((arg) => arg.toJson()).toList(),
      'debate_id': debateId,
      'evidence': evidence,
      'judge_statement': judgeStatement,
      'message': message,
      'source': source,
      'summary': summary,
      'verdict': verdict,
    };
  }
}

class Argument {
  final String argument;
  final String speaker;

  Argument({
    required this.argument,
    required this.speaker,
  });

  factory Argument.fromJson(Map<String, dynamic> json) {
    return Argument(
      argument: json['argument'] as String,
      speaker: json['speaker'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'argument': argument,
      'speaker': speaker,
    };
  }
}
