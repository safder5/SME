import 'package:ashwani/src/Providers/bom_providers.dart';
import 'package:ashwani/src/Providers/inventory_summary_provider.dart';
import 'package:ashwani/src/Providers/iq_list_provider.dart';
import 'package:ashwani/src/Providers/new_purchase_order_provider.dart';
import 'package:ashwani/src/Providers/production.dart';
import 'package:ashwani/src/Providers/purchase_returns_provider.dart';
import 'package:ashwani/src/Providers/sales_returns_provider.dart';
import 'package:ashwani/src/Providers/user_provider.dart';
import 'package:ashwani/src/Providers/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/Providers/customer_provider.dart';
import 'src/Providers/new_sales_order_provider.dart';

class LoadData {
  Future<bool> loadData(BuildContext context) async {
    final customerP = Provider.of<CustomerProvider>(context, listen: false);
    final vendorP = Provider.of<VendorProvider>(context, listen: false);
    final itemsP = Provider.of<ItemsProvider>(context, listen: false);
    final invSummP =
        Provider.of<InventorySummaryProvider>(context, listen: false);
    final salesOP = Provider.of<NSOrderProvider>(context, listen: false);
    final salesRP = Provider.of<SalesReturnsProvider>(context, listen: false);
    final purchaseOP = Provider.of<NPOrderProvider>(context, listen: false);
    final purchaseRP =
        Provider.of<PurchaseReturnsProvider>(context, listen: false);
    final bomP = Provider.of<BOMProvider>(context, listen: false);
    final prodP = Provider.of<ProductionProvider>(context, listen: false);
    final userP = Provider.of<UserProvider>(context, listen: false);
    try {
      await userP.getUserDetails();
      await customerP.fetchAllCustomers();
      await vendorP.fetchAllVendors();
      await itemsP.getItems();
      await invSummP.totalInHand();
      await salesOP.fetchSalesOrders();
      await salesOP.fetchActivity();
      await salesRP.fetchSalesReturns();
      await purchaseOP.fetchPurchaseOrders();
      await purchaseOP.fetchPurchaseActivity();
      await purchaseRP.fetchPurchaseReturns();
      await bomP.fetchBOMS();
      await prodP.fetchProductions();
      // await invSummP.totalTobeRecieved();
      return true;
    } catch (e) {
      return false;
      // try recurring the loading for this function
    }
  }
}
