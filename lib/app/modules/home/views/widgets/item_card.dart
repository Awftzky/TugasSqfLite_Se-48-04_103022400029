import 'package:flutter/material.dart';

import '../../../../data/model/item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const _purple = Color(0xFF8537FE);
  static const _ink = Color(0xFF211B2C);
  static const _muted = Color(0xFF898393);
  static const _line = Color(0xFFECE9F1);

  @override
  Widget build(BuildContext context) {
    final inStock = item.quantity > 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080E0920),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 47,
                width: 47,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF2EAFE), Color(0xFFE9DAFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: _purple,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEdit,
                tooltip: 'Ubah ${item.name}',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit_outlined, size: 19),
                color: const Color(0xFF777080),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Hapus ${item.name}',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: const Color(0xFFD96C70),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Divider(height: 1, color: _line),
          ),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: _muted, size: 15),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: inStock
                      ? const Color(0xFFEAF7EB)
                      : const Color(0xFFFFF1E7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: inStock
                          ? const Color(0xFF39A34A)
                          : const Color(0xFFDF8A3A),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      inStock ? 'Tersedia' : 'Stok habis',
                      style: TextStyle(
                        color: inStock
                            ? const Color(0xFF348B42)
                            : const Color(0xFFB66B26),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 11),
              Text(
                '${_formatQuantity(item.quantity)} ${item.unit}',
                style: const TextStyle(
                  color: Color(0xFF278A38),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatQuantity(double quantity) =>
      quantity.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}
