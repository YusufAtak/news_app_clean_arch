# news_app_clean_arch

Daily News - Flutter Clean Architecture Uygulaması
Modern Flutter geliştirme standartlarına uygun olarak tasarlanmış, Clean Architecture prensipleri ve Riverpod durum yönetimi kullanılarak geliştirilmiş modern bir haber uygulaması.

🚀 Proje Hakkında
Bu proje; güncel haberleri NewsAPI üzerinden dinamik olarak çeken, katmanlı mimari yaklaşımıyla yazılmış ve kullanıcı dostu arayüze sahip profesyonel bir mobil/masaüstü istemcisidir.

✨ Temel Özellikler
Clean Architecture (Temiz Mimari): Veri (Data), İş Mantığı (Domain) ve Arayüz (Presentation) katmanlarının birbirinden tamamen ayrıldığı modüler yapı.

State Management (Durum Yönetimi): Reaktif ve hatasız bir veri akışı için modern Riverpod entegrasyonu.

Harici API Entegrasyonu: NewsAPI üzerinden anlık başlıkların ve görsellerin çekilmesi.

Güvenli Dış Bağlantı (url_launcher): Kullanıcıların haber kartlarına tıklayarak ilgili haberi doğrudan tarayıcılarda orijinal kaynağında görüntüleyebilmesi.

Hata Yönetimi (Error Handling): Görsel yüklenme hatalarında veya eksik veri durumlarında uygulamanın çökmesini önleyen kullanıcı dostu yedek (fallback) mekanizmaları.

🛠️ Kullanılan Teknolojiler ve Paketler
Flutter & Dart

flutter_riverpod - Reaktif durum yönetimi

http - Ağ istekleri ve REST API iletişimi

url_launcher - Web linklerini harici tarayıcıda açma

equatable - Nesne karşılaştırmalarında performans optimizasyonu

📂 Mimari Yapı (Clean Architecture)
Proje klasör hiyerarşisi sorumluluklarına göre şu şekilde ayrılmıştır:
lib/
│
├── core/                  # Sabitler, genel kaynaklar ve veri durum yönetimi (DataState)
├── features/
│   └── daily_news/
│       ├── data/          # Modeller, Remote Data Source ve Repository implementasyonları
│       ├── domain/        # Entity'ler, Repository sözleşmeleri (interfaces) ve UseCase'ler
│       └── presentation/  # Ekranlar (Screens), Widget'lar ve Provider sağlayıcıları
│
└── main.dart              # Uygulama başlangıç noktası

