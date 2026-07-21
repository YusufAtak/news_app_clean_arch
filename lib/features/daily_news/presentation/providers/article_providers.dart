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
  final client = ref.read(httpClientProvider);
  return ArticleRemoteDataSourceImpl(client: client);
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  final dataSource = ref.read(articleRemoteDataSourceProvider);
  return ArticleRepositoryImpl(dataSource);
});

final getArticleUseCaseProvider = Provider<GetArticleUseCase>((ref) {
  final repository = ref.read(articleRepositoryProvider);
  return GetArticleUseCase(repository);
});

final articleListProvider = FutureProvider<DataState<List<ArticleEntity>>>((ref) async {
  final useCase = ref.read(getArticleUseCaseProvider);
  return await useCase(); // call() metodu otomatik tetiklenir
});