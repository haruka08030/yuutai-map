import 'package:flutter/material.dart';

class AddEditModal extends StatelessWidget {
  const AddEditModal({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add / Edit'),
      content: const Text('Placeholder form'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
