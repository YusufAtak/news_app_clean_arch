import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/data/data_sources/remote/article_remote_data_source.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/repository/article_repository.dart';

// 1. Domain katmanındaki sözleşmeyi (ArticleRepository) uyguluyoruz
class ArticleRepositoryImpl implements ArticleRepository {
  
  // 2. Kendi yazdığımız http veri kaynağını (RemoteDataSource) içeri alıyoruz
  final ArticleRemoteDataSource _remoteDataSource;

  ArticleRepositoryImpl(this._remoteDataSource);

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    try {
      // Veri kaynağından haberleri çekmeyi deniyoruz
      final articles = await _remoteDataSource.getNewsArticles();
      
      // Başarılı olursa DataSuccess içine sarıp gönderiyoruz
      return DataSuccess(articles, data: []);
      
    } catch (error) {
      // Eğer bir çökme, internet kopması veya hata olursa DataFailed ile yakalıyoruz
      return DataFailure(error: error.toString());
    }
  }
}
