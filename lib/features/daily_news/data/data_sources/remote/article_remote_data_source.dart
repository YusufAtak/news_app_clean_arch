import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_clean_arch/features/daily_news/data/models/article.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getNewsArticles();
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final http.Client client;
  
  ArticleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArticleModel>> getNewsArticles() async {
    final apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
    final uri = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> articlesJson = jsonResponse['articles'];

      return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
    } else {
      throw Exception('API isteği başarısız oldu: ${response.statusCode}');
    }

  }
}