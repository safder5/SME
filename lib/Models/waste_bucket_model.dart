class WasteBucketItem {
  int orderId;
  String? date;
  String itemname;
  int quantityWasted;
  String? referenceNo;
  String? type;

  WasteBucketItem(
      {required this.itemname,
      required this.quantityWasted,
      this.date,
      required this.orderId,
      this.referenceNo,this.type});
}
