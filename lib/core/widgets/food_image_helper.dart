import 'package:flutter/material.dart';

class FoodImageHelper {
  FoodImageHelper._();

  static String getRealisticFoodUrl(String name, String category, {String? explicitUrl}) {
    if (explicitUrl != null && explicitUrl.trim().isNotEmpty && explicitUrl.startsWith('http')) {
      return explicitUrl;
    }

    final lowerName = name.toLowerCase();
    final lowerCat = category.toLowerCase();

    if (lowerName.contains('phở') || lowerName.contains('pho')) {
      return 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=500&auto=format&fit=crop&q=80';
    } else if (lowerName.contains('bún chả') || lowerName.contains('bun cha') || lowerName.contains('bún')) {
      return 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=80';
    } else if (lowerName.contains('bánh mì') || lowerName.contains('banh mi') || lowerName.contains('pate')) {
      return 'https://images.unsplash.com/photo-1626804475297-41608ea09aeb?w=500&auto=format&fit=crop&q=80';
    } else if (lowerName.contains('cơm') || lowerName.contains('sườn') || lowerName.contains('com')) {
      return 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500&auto=format&fit=crop&q=80';
    } else if (lowerName.contains('burger') || lowerName.contains('bò') || lowerCat.contains('fast')) {
      return 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80';
    } else if (lowerName.contains('trà sữa') || lowerName.contains('tea') || lowerCat.contains('drink') || lowerName.contains('cafe')) {
      return 'https://images.unsplash.com/photo-1558857563-b37cf05d8a58?w=500&auto=format&fit=crop&q=80';
    } else if (lowerName.contains('pizza')) {
      return 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&auto=format&fit=crop&q=80';
    } else if (lowerCat.contains('noodle') || lowerName.contains('mỳ') || lowerName.contains('mi')) {
      return 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500&auto=format&fit=crop&q=80';
    } else if (lowerCat.contains('dessert') || lowerName.contains('kem') || lowerName.contains('chè')) {
      return 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop&q=80';
    }

    return 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500&auto=format&fit=crop&q=80';
  }

  static Widget buildFoodImage({
    required String name,
    required String category,
    String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final url = getRealisticFoodUrl(name, category, explicitUrl: imageUrl);

    Widget imageWidget = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallback(name, width, height),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFE8DF), Color(0xFFFFD4C4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFFF5428),
              ),
            ),
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  static Widget _buildFallback(String name, double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8A65), Color(0xFFFF5428)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant, color: Colors.white, size: 36),
            const SizedBox(height: 4),
            Text(
              name.isNotEmpty ? name.split(' ').first : 'Món ngon',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

