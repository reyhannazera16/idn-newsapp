import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  // Ganti dengan API Key Anda dari newsapi.org
  static const String apiKey = '554e0c2d61484768b556cd9376f0c040';
  static const String baseUrl = 'https://newsapi.org/v2';

  // Method untuk mendapatkan top headlines
  static Future<List<Article>> getTopHeadlines({String country = 'us'}) async {
    try {
      // Menggunakan country='us' karena lebih stabil dan banyak artikel
      final response = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=$country&apiKey=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NewsApp/1.0',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if response has error
        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTopHeadlines: $e');
      throw Exception('Network error: $e');
    }
  }

  // Method untuk mendapatkan berita berdasarkan kategori
  static Future<List<Article>> getNewsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey',
        ),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NewsApp/1.0',
        },
      );

      print('Category Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception('Failed to load category news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getNewsByCategory: $e');
      throw Exception('Network error: $e');
    }
  }

  // Method untuk search berita dengan format yang benar
  static Future<List<Article>> searchNews(String query) async {
    try {
      // Format tanggal untuk from parameter (30 hari yang lalu)
      final DateTime thirtyDaysAgo = DateTime.now().subtract(
        Duration(days: 30),
      );
      final String fromDate =
          '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
          '$baseUrl/everything?q=${Uri.encodeComponent(query)}&from=$fromDate&sortBy=popularity&language=en&apiKey=$apiKey',
        ),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NewsApp/1.0',
        },
      );

      print('Search Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .take(20)
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in searchNews: $e');
      throw Exception('Network error: $e');
    }
  }

  // Method untuk mendapatkan berita Indonesia dengan endpoint everything
  static Future<List<Article>> getIndonesianNews() async {
    try {
      final DateTime thirtyDaysAgo = DateTime.now().subtract(
        Duration(days: 30),
      );
      final String fromDate =
          '${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
          '$baseUrl/everything?q=Indonesia&from=$fromDate&sortBy=popularity&language=en&apiKey=$apiKey',
        ),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NewsApp/1.0',
        },
      );

      print('Indonesian News Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'error') {
          throw Exception('API Error: ${data['message']}');
        }

        final List<dynamic> articles = data['articles'] ?? [];

        return articles
            .map((json) => Article.fromJson(json))
            .where(
              (article) =>
                  article.title != '[Removed]' &&
                  article.title.isNotEmpty &&
                  article.description.isNotEmpty,
            )
            .take(50)
            .toList();
      } else if (response.statusCode == 429) {
        throw Exception('API limit reached. Please try again later.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your API key.');
      } else {
        throw Exception(
          'Failed to load Indonesian news: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getIndonesianNews: $e');
      throw Exception('Network error: $e');
    }
  }
}
