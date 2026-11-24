import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/item.dart';

typedef SaveItemCallback =
    Future<bool> Function({Item? existing, required Item item});

class MaterialFormController extends GetxController {
  MaterialFormController({required SaveItemCallback onSave})
    : _onSave = onSave,
      nameController = TextEditingController(),
      categoryController = TextEditingController(),
      quantityController = TextEditingController(),
      unitController = TextEditingController(),
      locationController = TextEditingController();

  Item? existing;
  final SaveItemCallback _onSave;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isSaving = false.obs;
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController locationController;

  void prepare(Item? item) {
    existing = item;
    nameController.text = item?.name ?? '';
    categoryController.text = item?.category ?? '';
    quantityController.text = item == null
        ? ''
        : _formatQuantity(item.quantity);
    unitController.text = item?.unit ?? '';
    locationController.text = item?.location ?? '';
    formKey = GlobalKey<FormState>();
  }

  Future<void> save() async {
    if (isSaving.value || !(formKey.currentState?.validate() ?? false)) return;

    isSaving.value = true;
    late final bool saved;
    try {
      saved = await _onSave(
        existing: existing,
        item: Item(
          id: existing?.id,
          name: nameController.text.trim(),
          category: categoryController.text.trim(),
          quantity: double.parse(quantityController.text.trim()),
          unit: unitController.text.trim(),
          location: locationController.text.trim(),
        ),
      );
    } finally {
      isSaving.value = false;
    }
    if (saved) Get.back<bool>(result: true);
  }

  void close() => Get.back<bool>(result: false);

  @override
  void onClose() {
    nameController.dispose();
    categoryController.dispose();
    quantityController.dispose();
    unitController.dispose();
    locationController.dispose();
    super.onClose();
  }

  static String _formatQuantity(double quantity) =>
      quantity.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}
