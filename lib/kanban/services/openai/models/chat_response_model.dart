final class ChatResponseModel {
  final List<ChatChoice> choices;
  final ChatUsage usage;

  ChatResponseModel({
    required this.choices,
    required this.usage,
  });
}

final class ChatChoice {
  final ChatMessage message;
  final String finishReason;

  ChatChoice({
    required this.message,
    required this.finishReason,
  });
}

final class ChatMessage {
  final String role;
  final String content;
  final String? refusal;

  ChatMessage({
    required this.role,
    required this.content,
    required this.refusal,
  });
}

final class ChatUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  ChatUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });
}