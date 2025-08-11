import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';

class CategoryChips extends StatelessWidget {
  final NewsController controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected =
                controller.selectedCategory.value == category.name;

            return Padding(
              padding: EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      category.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onSelected: (selected) {
                  if (selected) {
                    controller.fetchNewsByCategory(category.name);
                  }
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.blue[600],
                checkmarkColor: Colors.white,
                elevation: isSelected ? 3 : 1,
                pressElevation: 2,
              ),
            );
          },
        ),
      ),
    );
  }
}
