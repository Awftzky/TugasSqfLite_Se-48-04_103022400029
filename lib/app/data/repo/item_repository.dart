import '../dao/item_dao.dart';
import '../model/item.dart';

class ItemRepository {
  ItemRepository({ItemDao? itemDao}) : _itemDao = itemDao ?? ItemDao();

  final ItemDao _itemDao;

  Future<List<Item>> getItems() => _itemDao.getAll();

  Future<int> addItem(Item item) => _itemDao.insert(item);

  Future<int> updateItem(Item item) => _itemDao.update(item);

  Future<int> deleteItem(int id) => _itemDao.delete(id);
}
