class QuoteModel {
  final String content;
  final String author;

  QuoteModel({
    required this.content,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] ?? 'Keep going, you are doing great!',
      author: json['author'] ?? 'Unknown',
    );
  }

  factory QuoteModel.empty() {
    return QuoteModel(content: 'Loading your motivation...', author: '');
  }
}
