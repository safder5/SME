import 'package:ashwani/constantWidgets/boxes.dart';
import 'package:ashwani/constants.dart';
import 'package:ashwani/Utils/items/addItems.dart';
import 'package:ashwani/Utils/items/item_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final _auth = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddItems()));
        },
        child: const Icon(LineIcons.plus),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(LineIcons.angleLeft)),
                    const SizedBox(width: 10),
                    const Text('Items'),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('UserData')
                          .doc('${_auth!.email}')
                          .collection('Items')
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final userItemsSnapshot = snapshot.data?.docs;
                        if (userItemsSnapshot!.isEmpty) {
                          return const Text('No Items, Add below');
                        }
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                            itemCount: userItemsSnapshot.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ItemScreen(
                                                itemname: userItemsSnapshot[index]
                                                    ["item_name"],
                                                sIh: userItemsSnapshot[index]
                                                    ["sIh"],
                                              )));
                                },
                                child: ItemsPageContainer(
                                    itemName: userItemsSnapshot[index]
                                        ["item_name"],
                                    sku: userItemsSnapshot[index]["sIh"]),
                              );
                            });
                      }),
                )
              ],
            ),
          )),
    );
  }
}
