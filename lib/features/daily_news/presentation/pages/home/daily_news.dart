import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_clean_arch/core/resources/data_state.dart';
import 'package:news_app_clean_arch/features/daily_news/presentation/providers/article_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';


class DailyNews extends ConsumerWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesState = ref.watch(articleListProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Tasarımdaki çok açık mavi/gri arka plan
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Karşılama ve Profil Alanı
              _buildHeader(),
              const SizedBox(height: 24),
              
              // 2. Arama Çubuğu
              _buildSearchBar(),
              const SizedBox(height: 32),
              
              // 3. Öne Çıkanlar Başlığı
              _buildSectionTitle('Öne Çıkanlar', 'Tümünü Görüntüle'),
              const SizedBox(height: 16),
              
              // 4. Öne Çıkan Kartlar (Geçici Yer Tutucu)
        
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET METOTLARI ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Merhaba,Kullanıcı!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'Keşfet\nDünya Haberleri',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/previews/024/983/914/non_2x/simple-user-default-icon-free-png.png'), // Geçici profil resmi
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Arama yap...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          actionText,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

Widget _buildFeaturedNewsList(List<ArticleEntity> articles) {
return SizedBox(
  height: 250,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    itemCount: articles.length,
    itemBuilder: (context, index) {
      final article = articles[index];
      return _buildFeaturedNewsCard(article);
    },
  ),
);
}
Widget _buildFeaturedNewsCard(ArticleEntity article) { // <-- Artık Article parametresi alıyor
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          // API'den gelen gerçek resmi ekliyoruz. Eğer resim yoksa (null) varsayılan bir görsel koyuyoruz.
          image: NetworkImage(article.urlToImage ?? 'https://picsum.photos/400/500'), 
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient (Gölge) Katmanı
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          // Yazı Katmanı
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Etiket
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'News', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // GERÇEK HABER BAŞLIĞI BURADA!
                Text(
                  article.title ?? 'Başlık bulunamadı', // API'den gelen başlık
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
