import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import '../controllers/theme_controller.dart';
import '../widgets/news_card.dart';
import '../widgets/category_chips.dart';
import 'search_page.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita Terkini'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Get.to(() => SearchPage()),
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Get.to(() => FavoritesPage()),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                themeController.toggleTheme();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(
                      themeController.isDarkMode.value
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    SizedBox(width: 8),
                    Text(
                      themeController.isDarkMode.value
                          ? 'Mode Terang'
                          : 'Mode Gelap',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          CategoryChips(),
          // News list
          Expanded(
            child: Obx(() {
              if (newsController.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Memuat berita...'),
                    ],
                  ),
                );
              }

              if (newsController.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          newsController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => newsController.refreshNews(),
                          child: Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (newsController.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ada berita tersedia',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  newsController.refreshNews();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: newsController.articles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(article: newsController.articles[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
