import 'package:ashwani/src/Models/iq_list.dart';
import 'package:ashwani/src/Models/sales_order.dart';
import 'package:ashwani/src/Screens/newOrders/new_sales_order.dart';
import 'package:ashwani/src/Screens/sales/sales_order_page.dart';
import 'package:ashwani/src/constantWidgets/boxes.dart';
import 'package:ashwani/src/constants.dart';
import 'package:ashwani/src/Providers/new_sales_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';

import 'package:provider/provider.dart';

import '../../Providers/iq_list_provider.dart';
import 'package:intl/intl.dart';

class SalesOrders extends StatefulWidget {
  const SalesOrders({super.key});

  @override
  State<SalesOrders> createState() => _SalesOrdersState();
}

class _SalesOrdersState extends State<SalesOrders>
    with AutomaticKeepAliveClientMixin {
  List<SalesOrderModel> soList = [];

  bool _isDisposed = false;
  DateTime? _startDate;
  DateTime? _endDate;

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Declare selectedItems as a state variable
  List<Item> selectedItems = [];
  bool _usingDateFilter = false;
  bool _usingItemFilter = false;
  bool _openfilters = false;
  // Widget doubleArrow = SvgPicture.asset('lib/icons/mail.svg');

  @override
  void initState() {
    super.initState();
    soList = [];
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: _endDate ?? DateTime.now(),
      ),
    );

    if (picked != null && !_isDisposed) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _usingDateFilter = true;
      });
    }
  }

  List<SalesOrderModel> _filterSalesOrders(List<SalesOrderModel> orders) {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    return orders.where((order) {
      // Date filtering logic
      final DateTime orderDate = dateFormat.parse(order.orderDate);
      bool matchesDate = true;
      if (_startDate != null && _endDate != null) {
        matchesDate =
            orderDate.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                orderDate.isBefore(_endDate!.add(const Duration(days: 1)));
      }

      // Item filtering logic
      bool matchesItems = true;
      if (selectedItems.isNotEmpty) {
        matchesItems = selectedItems.any((itemK) =>
            order.items!.any((item) => item.itemName == itemK.itemName));
      }

      // Combine both conditions
      return matchesDate && matchesItems;
    }).toList();
  }

  void _showItemSelectionDialog(BuildContext context) {
    final pitems = Provider.of<ItemsProvider>(context, listen: false);
    final items = pitems.allItems;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Item> tempSelectedItems = List.from(selectedItems);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              surfaceTintColor: w,
              shadowColor: w,
              backgroundColor: w,
              title: const Text(
                'Filter by items',
                style: TextStyle(fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: items.map((item) {
                    return CheckboxListTile(
                      title: Text(item.itemName),
                      value: tempSelectedItems.contains(item),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            tempSelectedItems.add(item);
                          } else {
                            tempSelectedItems.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedItems = tempSelectedItems;
                      _usingItemFilter = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(color: blue),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        _filterSalesOrders(
            soList); // Re-apply the filter with the updated items
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final fieldWidth = MediaQuery.of(context).size.width;
    return Consumer<NSOrderProvider>(builder: (context, provider, _) {
      final salesOrders = provider.som
          .where((salesorder) =>
              salesorder.customerName.toLowerCase().contains(_searchQuery))
          .toList()
          .reversed
          .toList();
      final filteredSalesOrders = _filterSalesOrders(salesOrders);

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          tooltip: 'New Sales Order',
          backgroundColor: blue,
          child: const Center(
            child: Icon(
              LineIcons.plus,
              size: 30,
            ),
          ),
          onPressed: () {
            Provider.of<ItemsProvider>(context, listen: false).clearsoItems();
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const NewSalesOrder()));
          },
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: fieldWidth * 0.8,
                          child: TextField(
                            cursorColor: blue,
                            cursorHeight: 16,
                            cursorWidth: 0.8,
                            controller: _searchController,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(
                                  maxWidth: fieldWidth * 0.7,
                                  minWidth: fieldWidth * 0.2),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              hintText: " Search Orders... ",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: b32),
                              suffixIcon: Icon(
                                LineIcons.search,
                                color: b.withOpacity(0.1),
                              ),
                              fillColor: w,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: blue, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: b.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _openfilters = !_openfilters;
                            });
                          },
                          child: Container(
                            width: fieldWidth * 0.1,
                            height: 48,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: w,
                                border: Border.all(color: b.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(10)),
                            child: _usingDateFilter || _usingItemFilter
                                ? SvgPicture.asset(
                                    "lib/icons/filter_active.svg")
                                : SvgPicture.asset("lib/icons/filter_dead.svg"),
                          ),
                        )
                      ],
                    ),
                  ),
                  _openfilters
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _usingDateFilter || _usingItemFilter
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _startDate = null;
                                          _endDate = null;
                                          _searchQuery = '';
                                          selectedItems = [];
                                          _usingDateFilter = false;
                                          _usingItemFilter = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: _usingDateFilter ||
                                                    _usingItemFilter
                                                ? Border.all(
                                                    color: b, width: 0.5)
                                                : Border.all(color: t),
                                            color: w,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 14),
                                          child: Row(
                                            children: [
                                              _usingDateFilter ||
                                                      _usingItemFilter
                                                  ? SvgPicture.asset(
                                                      'lib/icons/remove_active.svg')
                                                  : SvgPicture.asset(
                                                      'lib/icons/remove_dead.svg'),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                'Remove Filter',
                                                style: TextStyle(
                                                    color: _usingDateFilter ||
                                                            _usingItemFilter
                                                        ? b
                                                        : grey,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () => _selectDateRange(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: _usingDateFilter
                                          ? Border.all(color: b, width: 0.5)
                                          : Border.all(color: t),
                                      color: w,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 14),
                                    child: Row(
                                      children: [
                                        _usingDateFilter
                                            ? SvgPicture.asset(
                                                'lib/icons/date_active.svg')
                                            : SvgPicture.asset(
                                                'lib/icons/date_inactive.svg'),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          // _startDate != null && _endDate != null
                                          //     ? 'From: ${DateFormat.yMMMd().format(_startDate!)} To: ${DateFormat.yMMMd().format(_endDate!)}'
                                          //     : 'Select Date Range',
                                          _startDate != null && _endDate != null
                                              ? 'Change Dates'
                                              : 'Select Date Range',
                                          style: TextStyle(
                                              color:
                                                  _usingDateFilter ? b : grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showItemSelectionDialog(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: _usingItemFilter
                                          ? Border.all(color: b, width: 0.5)
                                          : Border.all(color: t),
                                      color: w,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 14),
                                    child: Row(
                                      children: [
                                        _usingItemFilter
                                            ? SvgPicture.asset(
                                                'lib/icons/filter_active.svg')
                                            : SvgPicture.asset(
                                                'lib/icons/filter_dead.svg'),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'Filter by Items',
                                          style: TextStyle(
                                              color:
                                                  _usingItemFilter ? b : grey,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  _usingDateFilter
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                    maxWidth: 600, minWidth: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: w,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  child: Text(
                                    _startDate != null && _endDate != null
                                        ? ' ${DateFormat.yMMMd().format(_startDate!)} →  ${DateFormat.yMMMd().format(_endDate!)}'
                                        : '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSalesOrders.length,
                      itemBuilder: (context, index) {
                        final salesOrder = filteredSalesOrders[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context, rootNavigator: true)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => SalesOrderPage(
                                  orderId: salesOrder.orderID,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          child: ContainerSalesOrder(
                            orderID: salesOrder.orderID.toString(),
                            name: salesOrder.customerName,
                            date: salesOrder.orderDate,
                            status: salesOrder.status!,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
