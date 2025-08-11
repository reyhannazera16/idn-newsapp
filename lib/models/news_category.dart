import 'package:flutter/material.dart';

class NewsCategory {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;

  NewsCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
  });

  static List<NewsCategory> getAllCategories() {
    return [
      NewsCategory(
        id: 'general',
        name: 'general',
        displayName: 'Umum',
        icon: Icons.public,
      ),
      NewsCategory(
        id: 'business',
        name: 'business',
        displayName: 'Bisnis',
        icon: Icons.business,
      ),
      NewsCategory(
        id: 'entertainment',
        name: 'entertainment',
        displayName: 'Hiburan',
        icon: Icons.movie,
      ),
      NewsCategory(
        id: 'health',
        name: 'health',
        displayName: 'Kesehatan',
        icon: Icons.health_and_safety,
      ),
      NewsCategory(
        id: 'science',
        name: 'science',
        displayName: 'Sains',
        icon: Icons.science,
      ),
      NewsCategory(
        id: 'sports',
        name: 'sports',
        displayName: 'Olahraga',
        icon: Icons.sports_soccer,
      ),
      NewsCategory(
        id: 'technology',
        name: 'technology',
        displayName: 'Teknologi',
        icon: Icons.computer,
      ),
    ];
  }
}
