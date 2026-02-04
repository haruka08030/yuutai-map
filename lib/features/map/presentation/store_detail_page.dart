import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_stock/features/map/presentation/state/place.dart';
import 'package:flutter_stock/features/map/presentation/widgets/store_detail_benefits_section.dart';
import 'package:flutter_stock/features/map/presentation/widgets/store_detail_header.dart';

class StoreDetailPage extends ConsumerWidget {
  const StoreDetailPage({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('店舗詳細')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StoreDetailHeader(place: place),
            StoreDetailBenefitsSection(place: place),
          ],
        ),
      ),
    );
  }
}
