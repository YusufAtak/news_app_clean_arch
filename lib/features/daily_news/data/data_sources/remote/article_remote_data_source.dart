import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app_clean_arch/features/daily_news/data/models/article.dart';

abstract class ArticleRemoteDataSource {
 Future<List<ArticleModel>> getNewsArticles() async {
    print('1. API İSTEĞİ BAŞLATILDI...');
    
    final uri = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=258982adaa384351b9d306dc389ecb70');
    final response = await http.get(uri);
    
    print('2. API YANITI GELDİ - Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> articlesJson = jsonResponse['articles'];
      
      print('3. HABER SAYISI: ${articlesJson.length}. Model dönüşümü başlıyor...');

      final articles = articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
      
      print('4. DÖNÜŞÜM BAŞARILI! Toplam ${articles.length} haber modellendi.');
      return articles;
    } else {
      print('API HATA DÖNDÜRDÜ: ${response.body}');
      throw Exception('API isteği başarısız oldu: ${response.statusCode}');
    }
  }
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final http.Client client;
  
  ArticleRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArticleModel>> getNewsArticles() async {
    final uri = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=258982adaa384351b9d306dc389ecb70');
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