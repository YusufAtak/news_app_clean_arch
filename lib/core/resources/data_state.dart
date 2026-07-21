import 'package:news_app_clean_arch/features/daily_news/data/models/article.dart';

abstract class DataState<T> {
  final T? data;
  final String? error;

  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(List<ArticleModel> articles, {required T data}) : super(data: data);
}

class DataFailure<T> extends DataState<T> {
  const DataFailure({required String error}) : super(error: error);
}
