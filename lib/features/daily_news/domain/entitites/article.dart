import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String? title;
  final String? author;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt; // Tarihi String olarak tutmak UI'da biçimlendirmeyi kolaylaştırır
  final String? content;

  const ArticleEntity({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
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