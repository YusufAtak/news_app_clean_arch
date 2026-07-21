import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String title;
  final String author;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  const ArticleEntity({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  @override
  List<Object?> get props => [
        title,
        author,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      ];
}