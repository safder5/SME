// import 'package:ashwani/main.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:line_icons/line_icons.dart';

// import '../constants.dart';
// import 'helper.dart';

// class DBCreatingPage extends StatefulWidget {
//   const DBCreatingPage(
//       {super.key,
//       required this.email,
//       required this.name,
//       required this.companyName,
//       required this.country});
//   final String email;
//   final String name;
//   final String companyName;
//   final String country;

//   @override
//   State<DBCreatingPage> createState() => _DBCreatingPageState();
// }

// class _DBCreatingPageState extends State<DBCreatingPage> {
//   DateTime cdate = DateTime.now();
//   final _fs = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance.currentUser;
  
//   @override
//   void initState() {
//     super.initState();
//     createDatabase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Let’s setup your organization!',
//                   style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 20,
//                       color: b.withOpacity(.82)),
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     // show a menu
//                     try {
//                       FirebaseAuth.instance.signOut();
//                     } catch (e) {
//                       print('error logging out');
//                     }
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                         '/loginPage', (route) => false);
//                   },
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 32,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
               
//                 const SizedBox(
//                   height: 20,
//                 ),
               
               
//                 const SizedBox(
//                   height: 20,
//                 ),
               
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //       color:
//                 //           _inventoryDate.text.isEmpty ? b.withOpacity(0.02) : t,
//                 //       borderRadius: BorderRadius.circular(5)),
//                 //   child: TextField(
//                 //     readOnly: true,
//                 //     controller: _inventoryDate,
//                 //     keyboardType: TextInputType.emailAddress,
//                 //     decoration: logInputDecoration(
//                 //             hint: 'Inventory Start Date', errorColor: r)
//                 //         .copyWith(
//                 //             suffixIcon: IconButton(
//                 //                 onPressed: () async {
//                 //                   DateTime? pickedDate = await showDatePicker(
//                 //                       context: context,
//                 //                       initialEntryMode:
//                 //                           DatePickerEntryMode.calendarOnly,
//                 //                       initialDate: cdate,
//                 //                       firstDate: DateTime.utc(1965, 1, 1),
//                 //                       lastDate: DateTime(cdate.year + 1));
//                 //                   if (pickedDate != null) {
//                 //                     //get the picked date in the format => 2022-07-04 00:00:00.000
//                 //                     String formattedDate =
//                 //                         DateFormat('dd-MM-yyyy').format(
//                 //                             pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
//                 //                     //formatted date output using intl package =>  2022-07-04
//                 //                     setState(() {
//                 //                       _inventoryDate.text =
//                 //                           formattedDate; //set foratted date to TextField value.
//                 //                     });
//                 //                   }
//                 //                 },
//                 //                 icon: Icon(
//                 //                   LineIcons.calendarWithDayFocus,
//                 //                   color: b25,
//                 //                 ))),
//                 //     onChanged: (value) {
//                 //       colorOfTextField();
//                 //     },
//                 //   ),
//                 // ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     try {
//                       await createDatabase();
//                       // await _auth.createUserWithEmailAndPassword(
//                       //     email: email, password: password);
//                       if (!context.mounted) return;
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const LoadInventory()));
//                     } catch (e) {
//                       print(e);
//                     }
//                   },
//                   child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           color: blue, borderRadius: BorderRadius.circular(5)),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 16.0),
//                         child: Center(
//                           child: Text(
//                             'Finish Setup',
//                             style: TextStyle(color: w, fontSize: 14),
//                           ),
//                         ),
//                       )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
