import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/data/data_sources/remote/article_remote_data_source.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource _remoteDataSource;

  ArticleRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    try {
      final articles = await _remoteDataSource.getNewsArticles();
      
      return DataSuccess(articles, data: articles);
      
    } catch (error) {
    
      return DataFailure(error: error.toString());
    }
  }
}