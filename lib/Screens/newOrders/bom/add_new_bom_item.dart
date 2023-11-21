import 'package:ashwani/Models/bom_model.dart';
import 'package:ashwani/Providers/bom_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../Services/helper.dart';
import '../../../constantWidgets/boxes.dart';
import '../../../constants.dart';

class AddNewBOMItems extends StatefulWidget {
  const AddNewBOMItems({super.key, required this.items});
  final List<String> items;

  @override
  State<AddNewBOMItems> createState() => _AddNewBOMItemsState();
}

class _AddNewBOMItemsState extends State<AddNewBOMItems> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _itemnameController = TextEditingController();
  final TextEditingController _quantityCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool? validateForm() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  final auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final bomItemsP = Provider.of<BOMProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
          color: w,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Add items & quantity'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              CircleAvatar(
                backgroundColor: t,
                maxRadius: 22,
                child: const Image(
                  width: 44,
                  height: 44,
                  image: AssetImage('lib/images/itemimage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldSearch(
                minStringLength: 1,
                label: 'Search Item',
                controller: _itemnameController,
                decoration:
                    getInputDecoration(hint: 'Search Item', errorColor: r)
                        .copyWith(
                  suffix: GestureDetector(
                    onTap: () {
                      // add a unique item to items list
                      // Navigator.of(context, rootNavigator: true).push(
                      //     MaterialPageRoute(
                      //         builder: (context) => const AddItems()));
                    },
                    child: Icon(
                      LineIcons.plus,
                      size: 18,
                      color: blue,
                    ),
                  ),
                ),
                initialList: widget.items,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _quantityCtrl,
                // validator: validateSOIQ,
                cursorColor: blue,
                cursorWidth: 1,
                textInputAction: TextInputAction.next,
                decoration: getInputDecoration(
                        hint: 'Units per BOM', errorColor: Colors.red)
                    .copyWith(),
                // onChanged: (value) {
                //   // try {
                //   //   quantitySales = int.parse(value);
                //   // } catch (e) {
                //   //   quantitySales = int.parse('0');
                //   // }
                // },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'lib/icons/info.svg',
                    width: 12,
                    height: 12,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Units needed for production of one Product',
                    style: TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 12, color: b32),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),
              Consumer<BOMProvider>(builder: (_, bom, __) {
                return Expanded(
                  child: ListView.builder(
                      itemCount: bom.items.length,
                      itemBuilder: (context, index) {
                        final item = bom.items[index];
                        return NewBomOrderItemTile(
                          index: index,
                          name: item.itemname,
                          quantity: item.quantity.toString(),
                        );
                      }),
                );
              }),
              const Spacer(),
              // const SizedBox(height: 24,),
              GestureDetector(
                onTap: () async {
                  try {
                    if (validateForm() == true) {
                      bomItemsP.addItem(BOMItem(
                          itemname: _itemnameController.text.trim(),
                          quantity: int.parse(_quantityCtrl.text)));
                      Navigator.pop(context);
                    } else {
                      print('error');
                    }
                  } catch (e) {
                    //snackbar to show item not added
                    print(e);
                  }
                  // add items and pass the item and quantity to the list in sales order
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: blue,
                  ),
                  width: double.infinity,
                  height: 48,
                  child: Center(
                      child: Text(
                    'Add Item',
                    style: TextStyle(
                      color: w,
                    ),
                    textScaleFactor: 1.2,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
