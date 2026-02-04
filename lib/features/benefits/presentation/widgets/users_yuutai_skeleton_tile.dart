import 'package:flutter/material.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';

class UsersYuutaiSkeletonTile extends StatelessWidget {
  const UsersYuutaiSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    final skeletonBase =
        Theme.of(context).extension<AppColors>()?.skeletonBase ??
            Colors.grey[200]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Checkbox placeholder
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: skeletonBase,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              // Content placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title placeholder
                    Container(
                      width: 140,
                      height: 18,
                      decoration: BoxDecoration(
                        color: skeletonBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Expiry info placeholder
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: skeletonBase,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
