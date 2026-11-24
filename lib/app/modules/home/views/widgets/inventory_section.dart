import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/item.dart';
import '../../controllers/home_controller.dart';
import 'empty_inventory.dart';
import 'item_card.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({
    super.key,
    required this.controller,
    required this.onEdit,
    required this.onDelete,
  });

  final HomeController controller;
  final ValueChanged<Item> onEdit;
  final ValueChanged<Item> onDelete;

  static const _purple = Color(0xFF8537FE);
  static const _ink = Color(0xFF211B2C);
  static const _muted = Color(0xFF898393);
  static const _line = Color(0xFFECE9F1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: controller.setSearchQuery,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Cari material',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _purple, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Persediaan',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  '${controller.items.length} material',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator(color: _purple)),
              );
            }

            final items = controller.visibleItems;
            if (items.isEmpty) {
              return EmptyInventory(
                hasSearch: controller.searchQuery.value.trim().isNotEmpty,
              );
            }

            return Column(
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ItemCard(
                      item: item,
                      onEdit: () => onEdit(item),
                      onDelete: () => onDelete(item),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
