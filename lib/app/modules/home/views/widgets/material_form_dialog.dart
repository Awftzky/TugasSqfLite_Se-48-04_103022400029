import 'package:flutter/material.dart';

import '../../../../data/model/item.dart';

const _purple = Color(0xFF8537FE);
const _ink = Color(0xFF211B2C);
const _muted = Color(0xFF898393);
const _line = Color(0xFFECE9F1);

typedef SaveItemCallback =
    Future<bool> Function({Item? existing, required Item item});

class MaterialFormDialog extends StatefulWidget {
  const MaterialFormDialog({super.key, this.item, required this.onSave});

  final Item? item;
  final SaveItemCallback onSave;

  @override
  State<MaterialFormDialog> createState() => _MaterialFormDialogState();
}

class _MaterialFormDialogState extends State<MaterialFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.item?.name ?? '',
  );
  late final _categoryController = TextEditingController(
    text: widget.item?.category ?? '',
  );
  late final _quantityController = TextEditingController(
    text: widget.item == null ? '' : _formatQuantity(widget.item!.quantity),
  );
  late final _unitController = TextEditingController(
    text: widget.item?.unit ?? '',
  );
  late final _locationController = TextEditingController(
    text: widget.item?.location ?? '',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          child: Form(
            key: _formKey,
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
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close_rounded),
                      color: _muted,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _FormField(
                  controller: _nameController,
                  label: 'Nama material',
                  hint: 'Contoh: Semen OPC 43',
                  icon: Icons.inventory_2_outlined,
                  validator: _requiredValidator,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 13),
                _FormField(
                  controller: _categoryController,
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
                        controller: _quantityController,
                        label: 'Jumlah',
                        hint: '0',
                        icon: Icons.numbers_rounded,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          final quantity = double.tryParse(value?.trim() ?? '');
                          if (quantity == null ||
                              !quantity.isFinite ||
                              quantity < 0) {
                            return 'Masukkan jumlah yang valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      flex: 2,
                      child: _FormField(
                        controller: _unitController,
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
                  controller: _locationController,
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
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: _purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Text(
                          item == null ? 'Simpan material' : 'Simpan perubahan',
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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final saved = await widget.onSave(
      existing: widget.item,
      item: Item(
        id: widget.item?.id,
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        quantity: double.parse(_quantityController.text.trim()),
        unit: _unitController.text.trim(),
        location: _locationController.text.trim(),
      ),
    );
    if (saved && mounted) Navigator.of(context).pop(true);
  }

  String? _requiredValidator(String? value) =>
      value == null || value.trim().isEmpty ? 'Wajib diisi' : null;

  String _formatQuantity(double quantity) =>
      quantity.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
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
