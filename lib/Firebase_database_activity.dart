// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'Firebase_activity.dart';
//
// class FirebaseDatabase {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CollectionReference _agaramCollection = FirebaseFirestore.instance.collection('agaram').doc('user_delivery').collection('users');
//
//
//   final String email;
//   final String password;
//   final int mobile;
//   final String address;
//   late String username;
//
//   FirebaseDatabase(this.email, this.password, this.mobile, this.address);
//
//   Future<bool> insertData() async {
//
//     //extract username in email
//     List<String> extractUsername = this.email.split('@');
//     String username = extractUsername[0];
//
//     try {
//       // // Get the last document ID
//        L// final QuerySnapshot datas = await FirebaseFirestore.instance
// //       //     .collection('agaram')
// //       //     .doc('user_delivery')
// //       //     .collection('users')
// //       //     .orderBy(FieldPath.documentId, descending: true) // Order by document ID in descending order
// //       //     .limit(1) //imit to only one document
//       //     .get();
//       //
//       // String lastDocumentId = 'AMG00001'; // Default value if collection is empty
//       // if (datas.docs.isNotEmpty) {
//       //   final lastDocument = datas.docs.first;
//       //   lastDocumentId = lastDocument.id;
//       // }
//       //
//       // // Increment the last document ID
//       // final nextId = int.parse(lastDocumentId.substring(3)) + 1;
//       // final usernameIncrement = 'AMG${nextId.toString().padLeft(5, '0')}';
//
//       FirebaseAuth_milk auth = FirebaseAuth_milk();
//       final usernameIncrement = auth.userid;
//       // Add a new document with the incremented ID
//       await FirebaseFirestore.instance
//           .collection('agaram')
//           .doc('user_delivery')
//           .collection('users')
//           .doc(usernameIncrement)
//
//           .set({
//         'username': username,
//         'email': this.email,
//         'mobile': this.mobile,
//         'password': this.password,
//         'address': this.address,
//         'referred': 0,
//         'wallet': 100,
//       });
//
//       print("Data Inserted Successfully");
//       return true;
//     } catch (error) {
//       print("Data Insertion Failed: $error");
//       return false;
//     }
//   }
//
//
//
//
// }
