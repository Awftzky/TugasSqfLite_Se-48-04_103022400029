import 'package:flutter/material.dart';

import '../../../../data/model/item.dart';

class DeleteItemDialog extends StatelessWidget {
  const DeleteItemDialog({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: Color(0xFFE05252),
        size: 28,
      ),
      title: const Text('Hapus material?'),
      content: Text(
        'Hapus “${item.name}” dari persediaan? Tindakan ini tidak dapat dibatalkan.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE05252),
            foregroundColor: Colors.white,
          ),
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
