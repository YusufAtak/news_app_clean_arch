import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/presentation/providers/article_providers.dart';

class DailyNews extends ConsumerWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    final articleState = ref.watch(articleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News'),
      ),
      body: articleState.when(
        data: (dataState) {

          if (dataState is DataFailure) {
            return Center(child: Text('API Hatası: ${dataState.error}'));
          }

          if (dataState is DataSuccess && dataState.data != null) {
            final articles = dataState.data!; 
            
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.title ?? 'Başlık Yok'),
                  subtitle: Text(article.author ?? 'Yazar Yok'),
                );
              },
            );
          }
          
          return const Center(child: Text('Gösterilecek haber bulunamadı.'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
  
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}