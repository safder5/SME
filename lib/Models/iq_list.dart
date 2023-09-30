import 'package:ashwani/Models/item_tracking_model.dart';

class Item {
  final String? itemName;
  int? itemQuantity;
  int? quantityPurchase;
  int? quantitySales;
  List<ItemTrackingModel>? itemTracks;
  String? imageURL;

  Item({
    required this.itemName,
    this.itemQuantity,
    this.quantityPurchase,
    this.quantitySales,
    this.itemTracks,
    this.imageURL,
  });
}
