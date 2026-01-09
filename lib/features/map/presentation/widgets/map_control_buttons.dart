import 'package:flutter/material.dart';

class MapControlButtons extends StatelessWidget {
  final bool showAllStores;
  final Function(int) onTogglePressed;
  final VoidCallback onFilterPressed;

  const MapControlButtons({
    super.key,
    required this.showAllStores,
    required this.onTogglePressed,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ToggleButtons(
            isSelected: [!showAllStores, showAllStores],
            onPressed: onTogglePressed,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            borderColor: Colors.transparent,
            selectedBorderColor: Colors.transparent,
            fillColor: Theme.of(context).primaryColor.withAlpha(25),
            selectedColor: Theme.of(context).primaryColor,
            color: Colors.grey.shade600,
            constraints: const BoxConstraints(minHeight: 40),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('優待あり'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('全店舗'),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: onFilterPressed,
            tooltip: 'Filter',
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
