import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String? ?? '',
      publishedAt: json['publishedAt'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}