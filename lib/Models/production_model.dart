import 'package:ashwani/Models/bom_model.dart';
import 'package:ashwani/Models/iq_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductionModel {
  final String productionID;
  final Timestamp dateTime;
  final int quantityofBOMProduced;
  final String nameofBOM;
  ProductionModel(
      {required this.productionID,
      required this.dateTime,
      required this.quantityofBOMProduced,
      required this.nameofBOM});
}

class CombinedItem {
  final String itemName;
  final int? itemQuantity;
  final int bomQuantity;

  CombinedItem({
    required this.itemName,
    this.itemQuantity,
    required this.bomQuantity,
  });
}

List<CombinedItem> combineData(List<Item> items, List<BOMItem> bomItems) {
  final Map<String, int> bomItemsMap = {
    for (final bomItem in bomItems) bomItem.itemname: bomItem.quantity
  };

  final List<CombinedItem> combinedList = [];

  for (final item in items) {
    if (bomItemsMap.containsKey(item.itemName)) {
      final int bomQuantity = bomItemsMap[item.itemName] ?? 0;
      final combinedItem = CombinedItem(
        itemName: item.itemName,
        itemQuantity: item.itemQuantity,
        bomQuantity: bomQuantity,
      );
      combinedList.add(combinedItem);
    }
  }

  return combinedList;
}
