import 'package:news_app_clean_arch/features/daily_news/domain/entities/article.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.url,
    required super.urlToImage,
    required super.publishedAt, required super.author, required super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      author: json['author'] ?? '',
      content: json['content'] ?? '',
    );
  }
}