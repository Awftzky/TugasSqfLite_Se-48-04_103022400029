import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/item.dart';
import '../controllers/home_controller.dart';
import 'widgets/delete_item_dialog.dart';
import 'widgets/home_header.dart';
import 'widgets/inventory_section.dart';
import 'widgets/material_form_dialog.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const _purple = Color(0xFF8537FE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx(
              () => HomeHeader(
                materialCount: controller.items.length,
                categoryCount: controller.categoryCount,
              ),
            ),
            InventorySection(
              controller: controller,
              onEdit: (item) => _showItemForm(context, item: item),
              onDelete: (item) => _confirmDelete(context, item),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemForm(context),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah material',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _showItemForm(BuildContext context, {Item? item}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) =>
          MaterialFormDialog(item: item, onSave: controller.saveItem),
    );
    if (saved == true) {
      _showMessage(
        item == null ? 'Material ditambahkan' : 'Perubahan disimpan',
        item == null
            ? 'Material sudah tercatat dalam persediaan.'
            : 'Informasi material berhasil diperbarui.',
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteItemDialog(item: item),
    );
    if (confirmed == true && await controller.removeItem(item)) {
      _showMessage(
        'Material dihapus',
        '${item.name} telah dihapus dari persediaan.',
      );
    }
  }

  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFF30243F),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
