import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuth_milk {

  late String email;
  late String password;
  late int mobile;
  late final String address;

late String userid;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpWithEmailAndPassword(String email,int mobile, String address, String password) async {

    this.address = address;
    this.mobile = mobile;
    this.email  = email;
    this.password = password;

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      print('User created in: ${credential.user!.uid}');
      userid = credential.user!.uid;
      print("Successfully Signup:");
      return insertData();


    } catch (e) {
      print("Error occurred during sign up: $e");
      return false;
    }
  }



Future<bool> insertData() async {

  //extract username in email
  List<String> extractUsername = this.email.split('@');
  String username = extractUsername[0];

  try {

//subscription issue
//
//
//     FirebaseFirestore.instance
//         .collection('agaram')
//         .doc('user_delivery')
//         .collection('users')
//         .doc(userid)
//         .collection("booking")
//         .doc('subscriptions_details')
//         .set({
//     'subscriptions_details':[],
//     'issued':false});



  //
    // Add a new document with the incremented ID
    await FirebaseFirestore.instance
        .collection('agaram')
        .doc('user_delivery')
        .collection('users')
        .doc(userid)
        .set({
    'username': username,
    'email': this.email,
    'mobile': this.mobile,
    'password': this.password,
    'address': this.address,});

    List transaction = [];

    FirebaseFirestore.instance.collection('agaram').doc('user_delivery').collection('users').doc(userid).collection("booking").doc('wallets').set({
      "money": 100,
      "referred": 0,
      'subscription':[],
      'vacation':[],
      'transactions': transaction
    });


    FirebaseFirestore.instance
        .collection('agaram')
        .doc('user_delivery')
        .collection('users')
        .doc(userid)
        .collection("credentials")
        .doc("registration")
    .set({
      "join_data":DateTime.now(),
    });


    print("Data Inserted Successfully");
    return true;
  } catch (error) {
    print("Data Insertion Failed: $error");
    return false;
  }
}




  Future<bool> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User logged in: ${credential.user!.uid}');
      userid = credential.user!.uid;
      return login_insertdata();
    } catch (e) {
      print("Error occurred during sign in: $e");
      return false;
    }


  }

  Future<bool>login_insertdata() async
  {
    try{
      FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(userid)
          .collection("credentials")
          .doc("logined")
          .set({
        "last_login":DateTime.now(),
      });

      print("Successfully Stored Login");
      return true;
    }
    catch(e)
    {
      print("Something went wrong in login storage $e");
      return false;
    }
  }



}

