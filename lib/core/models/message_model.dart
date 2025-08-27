import 'web_search_result_model.dart';

enum MessageType { user, assistant }

class Message {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isStreaming;
  final bool hasError;
  final WebSearchResult? webSearchResult; // Added this field

  const Message({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isStreaming = false,
    this.hasError = false,
    this.webSearchResult, // Added to constructor
  });

  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isStreaming,
    bool? hasError,
    WebSearchResult? webSearchResult,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
      hasError: hasError ?? this.hasError,
      webSearchResult: webSearchResult ?? this.webSearchResult,
    );
  }

  Map<String, String> toApiFormat() {
    return {
      'role': type == MessageType.user ? 'user' : 'assistant',
      'content': content,
    };
  }

  factory Message.user(String content) {
    return Message(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );
  }

  factory Message.assistant(String content, {bool isStreaming = false}) {
    return Message(
      id: 'assistant_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      isStreaming: isStreaming,
    );
  }

  factory Message.error(String content) {
    return Message(
      id: 'error_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      hasError: true,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json, Map<String, dynamic> metadata) {
    WebSearchResult? webSearchResult;
    if (metadata['webSearchResult'] != null) {
      webSearchResult = WebSearchResult.fromJson(metadata['webSearchResult']);
    }

    return Message(
      id: json['id'],
      content: json['content'],
      type: json['role'] == 'user' ? MessageType.user : MessageType.assistant,
      timestamp: DateTime.parse(json['created_at']),
      hasError: json['hasError'] ?? false,
      webSearchResult: webSearchResult,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// The WebSearchMessage class has been removed as its functionality
// is now merged into the main Message class.