import 'package:flutter/material.dart';
import 'package:wordpress_app/models/sidemenu.dart';

import '../models/category.dart';
import '../pages/category_based_articles.dart';
import '../pages/sub_categories.dart';
import '../utils/cached_image_with_dark.dart';
import '../utils/next_screen.dart';

class SelectiveCategoryCard extends StatelessWidget {
  final Sidebar category;
  final List<Sidebar> allCategories;
  final bool? isTitleCenter;
  final double? titleFontSize;

  const SelectiveCategoryCard(
      {super.key,
      required this.category,
      required this.allCategories,
      this.isTitleCenter,
      this.titleFontSize});

  @override
  Widget build(BuildContext context) {
    final String heroTag = UniqueKey().toString();
    return InkWell(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Hero(
              tag: heroTag,
              child: const CustomCacheImageWithDarkFilterBottom(
                imageUrl:
                    "https://arynews.tv/wp-content/uploads/2025/02/placeholder_bg-1.jpg",
                radius: 5,
              ),
            ),
          ),
          Align(
            alignment: isTitleCenter != null && isTitleCenter == true
                ? Alignment.center
                : Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 20),
              child: Text(
                category.title.toString().toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: titleFontSize ?? 18,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
      onTap: () {
        nextScreeniOS(
            context,
            CategoryBasedArticles(
                category: Category(
                    categoryThumbnail: "",
                    count: 0,
                    id: 0,
                    name: "",
                    parent: 0),
                heroTag: heroTag,
                isManual: true,
                sidebar: category));
      },
    );
  }
}
