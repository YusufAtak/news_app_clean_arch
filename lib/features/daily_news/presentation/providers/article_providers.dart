import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/data/data_sources/remote/article_remote_data_source.dart';
import 'package:news_app_clean_arch/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/usecases/get_article.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final articleRemoteDataSourceProvider = Provider<ArticleRemoteDataSource>((ref) {
  // read yerine watch kullanıyoruz
  final client = ref.watch(httpClientProvider); 
  return ArticleRemoteDataSourceImpl(client: client);
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  // read yerine watch kullanıyoruz
  final dataSource = ref.watch(articleRemoteDataSourceProvider); 
  return ArticleRepositoryImpl(dataSource);
});

final getArticleUseCaseProvider = Provider<GetArticleUseCase>((ref) {
  // read yerine watch kullanıyoruz
  final repository = ref.watch(articleRepositoryProvider); 
  return GetArticleUseCase(repository);
});

// Doğrudan List<ArticleEntity> döndürüyoruz, DataState hatasını veya verisini burada açıyoruz
final articleListProvider = FutureProvider<List<ArticleEntity>>((ref) async {
  final useCase = ref.watch(getArticleUseCaseProvider);
  
  // UseCase'den DataState paketini alıyoruz
  final dataState = await useCase();

  // Paket Başarılı ise içindeki List<ArticleEntity>'yi çıkarıp döndürüyoruz
  if (dataState is DataSuccess && dataState.data != null) {
    return dataState.data!;
  } 
  // Hatalı ise Riverpod'un error durumuna düşmesi için Exception fırlatıyoruz
  else {
    throw Exception(dataState.error ?? 'Haberler yüklenirken bir hata oluştu.');
  }
});