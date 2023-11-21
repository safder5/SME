class BOMmodel {
  final String productName;
  String? productCode;
  String? notes;
  final List<BOMItem> itemswithQuantities;
  List<String>? productionIDs;
  BOMmodel(
      {required this.productName,
      this.productCode,
      this.notes,
      this.productionIDs,
      required this.itemswithQuantities});
}

class BOMItem {
  final String itemname;
  final int quantity;
  BOMItem({required this.itemname, required this.quantity});
}
