import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/Providers/bs_address_provider.dart';
import 'package:ashwani/src/Providers/customer_provider.dart';
import 'package:ashwani/src/Providers/inventory_summary_provider.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/src/Providers/new_sales_order_provider.dart';
import 'package:ashwani/src/Providers/production.dart';
import 'package:ashwani/src/Providers/purchase_returns_provider.dart';
import 'package:ashwani/src/Providers/sales_returns_provider.dart';
import 'package:ashwani/src/Providers/vendor_provider.dart';

class ProviderManager {
  static final ProviderManager _instance = ProviderManager._internal();

  factory ProviderManager() {
    return _instance;
  }

  ProviderManager._internal();
  BOMProvider bomProvider = BOMProvider();
  BSAddressProvider bsAddressProvider = BSAddressProvider();
  CustomerProvider customerProvider = CustomerProvider();
  VendorProvider vendorProvider = VendorProvider();
  InventorySummaryProvider inventorySummaryProvider =
      InventorySummaryProvider();
  ItemsProvider itemsProvider = ItemsProvider();
  NPOrderProvider npOrderProvider = NPOrderProvider();
  NSOrderProvider nsOrderProvider = NSOrderProvider();
  ProductionProvider productionProvider = ProductionProvider();
  PurchaseReturnsProvider purchaseReturnsProvider = PurchaseReturnsProvider();
  SalesReturnsProvider salesReturnsProvider = SalesReturnsProvider();

  void resetAll() {
    try {
      bomProvider.reset();
      bsAddressProvider.reset();
      customerProvider.reset();
      vendorProvider.reset();
      inventorySummaryProvider.reset();
      itemsProvider.reset();
      npOrderProvider.reset();
      nsOrderProvider.reset();
      productionProvider.reset();
      purchaseReturnsProvider.reset();
      salesReturnsProvider.reset();
    } catch (e) {
      print('err $e');
    }
    print('RESET');
  }
}
