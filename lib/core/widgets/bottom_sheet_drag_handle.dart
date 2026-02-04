import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/app_theme.dart';

/// モーダルボトムシート上部のドラッグ用インジケーター。
/// 再利用可能な共通コンポーネント。
class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppTheme.dividerColor(context),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
