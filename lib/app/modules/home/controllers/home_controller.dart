import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/item.dart';
import '../../../data/repo/item_repository.dart';

class HomeController extends GetxController {
  HomeController({ItemRepository? repository})
    : _repository = repository ?? ItemRepository();

  final ItemRepository _repository;
  final items = <Item>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  Future<void>? _initialLoad;

  List<Item> get visibleItems {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query);
    }).toList();
  }

  int get categoryCount =>
      items.map((item) => item.category.toLowerCase()).toSet().length;

  @override
  void onInit() {
    super.onInit();
    _initialLoad = loadItems();
  }

  Future<void> loadItems() async {
    isLoading.value = true;
    try {
      items.assignAll(await _repository.getItems());
    } catch (error) {
      _showError('Material gagal dimuat. Silakan coba lagi.');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String value) => searchQuery.value = value;

  Future<bool> saveItem({Item? existing, required Item item}) async {
    try {
      await _initialLoad;
      if (existing == null) {
        final id = await _repository.addItem(item);
        items.add(item.copyWith(id: id));
      } else {
        final updated = item.copyWith(id: existing.id);
        await _repository.updateItem(updated);
        final index = items.indexWhere((entry) => entry.id == existing.id);
        if (index != -1) items[index] = updated;
      }
      items.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      return true;
    } catch (error) {
      _showError('Material gagal disimpan. Silakan coba lagi.');
      return false;
    }
  }

  Future<bool> removeItem(Item item) async {
    final id = item.id;
    if (id == null) return false;
    try {
      await _initialLoad;
      await _repository.deleteItem(id);
      items.removeWhere((entry) => entry.id == id);
      return true;
    } catch (error) {
      _showError('Material gagal dihapus. Silakan coba lagi.');
      return false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Terjadi kesalahan',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: const Color(0xFF30243F),
      colorText: Colors.white,
    );
  }
}
