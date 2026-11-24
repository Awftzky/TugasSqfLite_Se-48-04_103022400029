import 'package:flutter/material.dart';

class EmptyInventory extends StatelessWidget {
  const EmptyInventory({super.key, required this.hasSearch});

  final bool hasSearch;

  static const _purple = Color(0xFF8537FE);
  static const _ink = Color(0xFF211B2C);
  static const _muted = Color(0xFF898393);
  static const _line = Color(0xFFECE9F1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF2EAFE), Color(0xFFE8D8FF)],
              ),
            ),
            child: Icon(
              hasSearch ? Icons.search_off_rounded : Icons.inventory_2_outlined,
              color: _purple,
              size: 29,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            hasSearch ? 'Material tidak ditemukan' : 'Belum ada material',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Coba nama, kategori, atau lokasi lain.'
                : 'Tambahkan material pertama untuk mulai memantau stok.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
