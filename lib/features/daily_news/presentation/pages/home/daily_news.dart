import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/presentation/providers/article_providers.dart';
import 'package:url_launcher/url_launcher.dart';

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
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.urlToImage!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50),
                ),
              )
            : Container(width: 80, height: 80, color: Colors.grey),
        // Haber başlığı
        title: Text(
          article.title ?? 'Başlık Yok',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        // Yazar bilgisi
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            article.author ?? 'Bilinmeyen Yazar',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        // 2. Adım: Habere Tıklayınca Detay Sayfasına Gitme
        onTap: () async {
  if (article.url != null) {
    final Uri url = Uri.parse(article.url!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Haber URL adresi açılamadı: $url');
    }
  }
},
        
      ),
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