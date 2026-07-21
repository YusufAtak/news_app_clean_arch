import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/core/usecases/usecase.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/repository/article_repository.dart';

class GetArticleUseCase implements UseCase<DataState<List<Article>>, void> {
  final ArticleRepository _articleRepository;

  // Hatanın çözümü bu satırdadır. Dışarıdan repository'yi tam olarak böyle almalı:
  GetArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<Article>>> call(void params) {
    return _articleRepository.getNewsArticles();
  }
}