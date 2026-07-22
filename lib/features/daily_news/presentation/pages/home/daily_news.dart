import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_clean_arch/features/daily_news/presentation/providers/article_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app_clean_arch/features/daily_news/domain/entitites/article.dart';
import 'package:news_app_clean_arch/features/daily_news/presentation/pages/home/all_news_screen.dart';

class DailyNews extends ConsumerWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesState = ref.watch(articleListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSectionTitle(context, 'Öne Çıkanlar', 'Tümünü Görüntüle'),
              const SizedBox(height: 12),

              // ESNEK YAPI (Expanded kullanarak ekranın geri kalanına göre esremesini sağlıyoruz)
              Expanded(
                child: articlesState.when(
                  data: (articles) {
                    if (articles.isEmpty) {
                      return const Center(child: Text('Gösterilecek haber bulunamadı.'));
                    }
                    return _buildFeaturedNewsList(articles);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Hata oluştu: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET METOTLARI ---

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Merhaba, Kullanıcı!',
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
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              'https://static.vecteezy.com/system/resources/previews/024/983/914/non_2x/simple-user-default-icon-free-png.png'),
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

  Widget _buildSectionTitle(BuildContext context, String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // Tıklandığında yeni sayfaya geçiş yapıyoruz!
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllNewsScreen(), // Yeni oluşturduğumuz sayfa
              ),
            );
          },
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14, 
              color: Colors.blueAccent, // Tıklanabilir olduğunu belli etmek için mavi yaptık
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedNewsList(List<ArticleEntity> articles) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: articles.length,
      itemBuilder: (context, index) { //context konum bilgisini verir.
        final article = articles[index];
        return _buildFeaturedNewsCard(context, article);
      },
    );
  }

  Widget _buildFeaturedNewsCard(BuildContext context, ArticleEntity article) {
    return GestureDetector(
      // Karta Tıklanma Özelliği (Haberi Tarayıcıda Açma)
      onTap: () async {
        final url = article.url;
        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          try{
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Haber açılırken bir hata oluştu.')),
              );
            }
            }
        }
      },
      child: Container(
        width: 200,
        height: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(article.urlToImage != null && article.urlToImage!.isNotEmpty 
                ? article.urlToImage! 
                : 'https://picsum.photos/400/500'), // Boş gelirse varsayılan resim
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient (Gölge) Katmanı (Yazının okunabilirliğini artırır)
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Gerçek Haber Başlığı
                  Expanded(
                    child: Text(
                    article.title ?? 'Başlık bulunamadı',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis, // Sığmazsa 3 nokta koyar
                  ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}