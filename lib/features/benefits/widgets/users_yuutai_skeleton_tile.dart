import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

class UsersYuutaiSkeletonTile extends StatelessWidget {
  const UsersYuutaiSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox placeholder
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColors>()!.skeletonBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          // Content placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title placeholder (company name)
                Container(
                  width: double.infinity,
                  height: 17,
                  color: Theme.of(context).extension<AppColors>()!.skeletonBase,
                ),
                const SizedBox(height: 5),
                // Expiry date placeholder
                Container(
                  width: 100,
                  height: 14,
                  color: Theme.of(context).extension<AppColors>()!.skeletonBase,
                ),
                const SizedBox(height: 5),
                // Subtitle placeholder (benefit detail)
                Container(
                  width: 150,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Theme.of(context).extension<AppColors>()!.skeletonBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
