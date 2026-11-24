import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/material_form_controller.dart';

const _purple = Color(0xFF8537FE);
const _ink = Color(0xFF211B2C);
const _muted = Color(0xFF898393);
const _line = Color(0xFFECE9F1);

class MaterialFormDialog extends GetView<MaterialFormController> {
  const MaterialFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.existing;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2EAFE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item == null
                            ? Icons.add_box_outlined
                            : Icons.edit_outlined,
                        color: _purple,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item == null ? 'Tambah material' : 'Ubah material',
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Lengkapi informasi material berikut.',
                            style: TextStyle(color: _muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => IconButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : controller.close,
                        icon: const Icon(Icons.close_rounded),
                        color: _muted,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _FormField(
                  controller: controller.nameController,
                  label: 'Nama material',
                  hint: 'Contoh: Semen OPC 43',
                  icon: Icons.inventory_2_outlined,
                  validator: _requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 13),
                _FormField(
                  controller: controller.categoryController,
                  label: 'Kategori',
                  hint: 'Contoh: Semen, Baja, Kelistrikan',
                  icon: Icons.category_outlined,
                  validator: _requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 13),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _FormField(
                        controller: controller.quantityController,
                        label: 'Jumlah',
                        hint: '0',
                        icon: Icons.numbers_rounded,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _quantityValidator,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      flex: 2,
                      child: _FormField(
                        controller: controller.unitController,
                        label: 'Satuan',
                        hint: 'Karung',
                        icon: Icons.straighten_rounded,
                        validator: _requiredValidator,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                _FormField(
                  controller: controller.locationController,
                  label: 'Lokasi penyimpanan',
                  hint: 'Contoh: Gudang Utama',
                  icon: Icons.location_on_outlined,
                  validator: _requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 23),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => OutlinedButton(
                          onPressed: controller.isSaving.value
                              ? null
                              : controller.close,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: _line),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Obx(
                        () => FilledButton(
                          onPressed: controller.isSaving.value
                              ? null
                              : controller.save,
                          style: FilledButton.styleFrom(
                            backgroundColor: _purple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          child: controller.isSaving.value
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  item == null
                                      ? 'Simpan material'
                                      : 'Simpan perubahan',
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? _requiredValidator(String? value) =>
    value == null || value.trim().isEmpty ? 'Wajib diisi' : null;

String? _quantityValidator(String? value) {
  final quantity = double.tryParse(value?.trim() ?? '');
  if (quantity == null || !quantity.isFinite || quantity < 0) {
    return 'Masukkan jumlah yang valid';
  }
  return null;
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 19),
        filled: true,
        fillColor: const Color(0xFFFAF9FC),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _purple, width: 1.5),
        ),
        errorMaxLines: 2,
      ),
    );
  }
}
