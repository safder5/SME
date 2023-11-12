
class BOMmodel {
  final String productName;
  String? productCode;
  String? notes;
  final List<BOMItem> itemswithQuantities;
  BOMmodel(
      {required this.productName,
      this.productCode,
      this.notes,
      required this.itemswithQuantities});
}

class BOMItem {
  final String itemname;
  final double quantity;
  BOMItem({required this.itemname, required this.quantity});
}
