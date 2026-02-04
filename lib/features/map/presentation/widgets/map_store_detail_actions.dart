import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/core/utils/snackbar_utils.dart';
import 'package:flutter_stock/features/map/presentation/state/place.dart';

const Color _kShareButtonBg = Color(0xFFF1F5F9);

/// 店舗ボトムシートのアクション（使う・共有）
class MapStoreDetailActions extends StatelessWidget {
  const MapStoreDetailActions({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                context.push('/store/detail', extra: place);
              },
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              child: Container(
                height: 56,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '使う',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: _kShareButtonBg,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: InkWell(
            onTap: () {
              showSnackBarMessage(context, '共有機能は準備中です');
            },
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                Icons.share_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
