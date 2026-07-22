import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app_clean_arch/features/daily_news/presentation/providers/article_providers.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';

class AllNewsScreen extends ConsumerWidget {
  const AllNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider'dan haberleri tekrar dinliyoruz
    final articlesState = ref.watch(articleListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Tüm Haberler',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // Geri butonu rengi
      ),
      body: articlesState.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('Gösterilecek haber bulunamadı.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _buildVerticalNewsCard(context, article);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }

  // Dikey Liste İçin Tasarlanmış Haber Kartı
  Widget _buildVerticalNewsCard(BuildContext context, ArticleEntity article) {
    return GestureDetector(
      onTap: () async {
        final url = article.url;
        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          try {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Haber linki açılamadı!')),
              );
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sol Taraftaki Haber Resmi
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.network(
                article.urlToImage != null && article.urlToImage!.isNotEmpty
                    ? article.urlToImage!
                    : 'https://picsum.photos/200/200',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            // Sağ Taraftaki Yazı Alanı
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? 'Başlık bulunamadı',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.author ?? 'Bilinmeyen Yazar',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}