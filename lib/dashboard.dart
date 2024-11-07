import 'package:agaram_dairy/data/details/subscription_detail_screendart';
import 'package:agaram_dairy/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calendar.dart';
import 'orders_calendar.dart';



class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String uid;

  const MyAppBar({required this.uid, Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agaram')
          .doc('user_delivery')
          .collection('users')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildAppBar(context, title: 'Loading...');
        } else if (snapshot.hasError) {
          return _buildAppBar(context, title: 'Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildAppBar(context, title: 'No data available');
        } else {
          DocumentSnapshot document = snapshot.data!;
          String username = document['username'];
          String address = document['address'];

          return AppBar(
            backgroundColor: Colors.lightGreen,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: InkWell(onTap: (){Get.to( SubscriptionDetailsScreen(uid: uid));},
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/person_icon.png'),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16.0,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          address,
                          style: const TextStyle(
                            fontSize: 8.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, {required String title}) {
    return AppBar(
      backgroundColor: Colors.lightGreen,
      automaticallyImplyLeading: false,
      title: Text(title),
    );
  }
}


class Products {
  String p_id;
  String p_imageUrl;
  String p_name;
  double p_price;
  bool p_sub;
  int p_quantity=1;

  Products({
    required this.p_quantity,
    required this.p_id,
    required this.p_name,
    required this.p_imageUrl,
    required this.p_price,
    required this.p_sub,
  });

  // Update the Product model to handle nested data inside "agaram_products"
  factory Products.fromMap(Map<String, dynamic> data) {
    return Products(
      p_quantity:1,
      p_id: data['p_id'].toString(), // Ensure ID is a string
      p_name: data['p_name'] ?? '',
      p_imageUrl: data['p_image'] ?? '', // Use p_image key for URL
      p_price: (data['p_price'] ?? 0).toDouble(),
      p_sub: (data['p_sub'] ?? false) as bool, // Ensure it defaults to `false` and cast to bool
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  final String uid;

  const HomeScreen({super.key, required this.uid});
}

class _HomeScreenState extends State<HomeScreen> {

  String? auth_token;

  // List to store Product objects
  List<Products> _products = [];
  bool isshowproduct=false;
  double totalprice = 0.0;
  int selecteditem=0;

  ////////




  // List<int>mybaglist=[];
  // List<Map>mybag=[];


  //final products

  List<Products>selectedProducts=[];

  @override
  void initState() {
    super.initState();
    checkLoggedIn(context);
    _fetchProducts(); // Fetch products on init
  }

  void _fetchProducts() async {
    print("Starting FetchProducts");

    // Fetching the collection from Firestore
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('agaram')  // Replace with your collection name
        .doc('user_delivery')
        .collection('products')
        .get();

    // Iterate through documents and extract agaram_products
    querySnapshot.docs.forEach((doc) {
      final data = doc['agaram_products'] as List<dynamic>; // Get the array of products
      // Map each product in the array to a Product object
      _products.addAll(data.map((productData) => Products.fromMap(productData)).toList());
    });

    // Update the state with fetched products
    setState(() {
      // Now _products contains all the products fetched
    });

    // Print the fetched products list
    print('Your Products: $_products');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    print("Your Token : $authToken");
    return authToken != null;
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    final loggedIn = await isLoggedIn();
    if (loggedIn) {
      auth_token = await getAuthToken();
    }
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    print("Your Token : $token");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true, splitScreenMode: true);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(uid: widget.uid),
      // appBar: AppBar(
      //   backgroundColor: Colors.blueAccent,
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         radius: 20.r,
      //         backgroundImage: NetworkImage("https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="), // Example profile image
      //       ),
      //       SizedBox(width: 10.w),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             "${auth_token ?? 'Guest'}",
      //             style: TextStyle(color: Colors.white, fontSize: 16.sp),
      //           ),
      //           Text(
      //             "example@mail.com",
      //             style: TextStyle(color: Colors.white, fontSize: 12.sp),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Agaram Product",
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: _products.isEmpty
                      ? Center(child: CircularProgressIndicator())  // Loading indicator
                      : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 0.7.r,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      // Retrieve product details from _products list
                      final product = _products[index];
                      return GestureDetector(
                        onTap: () {
                          print("onTap()");

                            setState(() {



                              // Check if the product is already in the selectedProducts list
                              int existingIndex = selectedProducts.indexWhere((
                                  p) => p.p_id == product.p_id);

                              if (existingIndex != -1) {
                                // If the product exists, increment its quantity
                                selectedProducts[existingIndex].p_quantity += 1;
                              } else {
                                // If it's a new product, add it to selectedProducts
                                selectedProducts.add(product);
                              }

                              // Update total price calculation based on quantity
                              totalprice += product.p_price;
                              isshowproduct = true;
                            });

                            selecteditem++;
                            print(
                                "Adding Products : ${product.p_name}, ${product
                                    .p_id} times ${product.p_quantity}");

                        },



                        onDoubleTap: () {
                          print("ontap()");


                          setState(() {


                            // Check if the item exists in the bag before removing it
                            if (selectedProducts.contains(product)) {
                              print("product appear");
                              // Remove the corresponding product from the bag
                              totalprice -= product.p_price;
                              // mybag.removeAt(mybaglist.indexOf(index));

                              // Remove the index from mybaglist as well
                              // mybaglist.remove(index);
                              selectedProducts.remove(product);

                              print("Removing Products : ${product.p_name}, ${product.p_id} times ${product.p_quantity}");

                            }
                            print("across");
                            if(selectedProducts.isEmpty) isshowproduct=false;
                            selecteditem--;


                            //


                          });
                        },

                        child: ProductCard(
                          productId: product.p_id,
                          imageUrl: product.p_imageUrl,
                          price: "\₹${product.p_price}",
                          name: product.p_name,
                          subcription: product.p_sub,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Conditional widget for displaying selected product info
          if (isshowproduct)
            Positioned(
              bottom: 0.h,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No Of Products : ${selecteditem}",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),


                        Text(
                          "Total Price: \₹$totalprice",
                          style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight:FontWeight.w600),
                        ),
                        SizedBox(width: 10,),

                        ElevatedButton(
                          onPressed: () {


                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrdersConfirm(
                                        products: selectedProducts, userid: widget.uid),
                              ),
                            );


                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Navigating To Payment Section")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child:
                          Center(
                            child: Text(
                              "Confirm Order",
                              style: TextStyle(color: Colors.black, fontSize: 15.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 2), // Spacing between buttons
                        //
                        //  ElevatedButton(
                        //   onPressed: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text("Subscription added!")),
                        //     );
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10.r),
                        //     ),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       "Subscription",
                        //       style: TextStyle(color: Colors.black, fontSize: 15.sp),
                        //     ),
                        //   ),
                        // )


                      ],
                    ),
                    SizedBox(height: 30,child: ElevatedButton.icon(onPressed: (){

                      setState(() {
                        selectedProducts.clear();
                        totalprice=0;
                        isshowproduct=false;
                        selecteditem=0;
                      });
                      print("Removing All");
                    }, label: Icon(Icons.cancel,color: Colors.red)))
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height*(0.09), // Adjust height here
        elevation: 20.0,
        notchMargin: 10.0,
        shape: CircularNotchedRectangle(),
        color: Colors.lightGreen,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double dynamicPadding = screenWidth * 0.01;


            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.subscriptions,
                  label: 'Subscription',
                  dynamicPadding: dynamicPadding,
                  screenWidth: screenWidth,
                  onTap: () {
                    // Subscription navigation logic
                  },
                ),
                _buildNavItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Calendar',
                  dynamicPadding: dynamicPadding * 2,
                  screenWidth: screenWidth,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // builder: (context) => CalendarPage(uid: widget.uid),
                          builder: (context) =>CalendarPage(uid:widget.uid)
                      ),
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.person_sharp,
                  label: 'Profile',
                  dynamicPadding: dynamicPadding,
                  screenWidth: screenWidth,
                  onTap: () {

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // builder: (context) => CalendarPage(uid: widget.uid),
                          builder: (context) =>FirebaseListPage(uid:widget.uid)
                      ),
                    );
                    //            FirebaseListPage(uid: widget.uid),
                    // Profile navigation logic
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required double dynamicPadding,
    required double screenWidth,
    required Function onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dynamicPadding),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.r),
              ),

              child: Icon(
                icon,
                color: Colors.white,
                size: screenWidth * 0.10,
              ),
            ),
            // Text(
            //   label,
            //   style: TextStyle(color: Colors.white,fontSize: 10),
            // )
          ],
        ),
      ),
    );
  }
}

// Product Card Widget to display each product
class ProductCard extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String price;
  final String name;
  final bool subcription;

  const ProductCard({
    Key? key,
    required this.productId,
    required this.subcription,
    required this.imageUrl,
    required this.price,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  price,
                  style: TextStyle(color: Colors.green, fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                if (subcription) // Check if subscription is true
                  Text(
                    'Subscription available',
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'calendar.dart';
// import 'products.dart';
// import 'profile.dart';
//
// class Dashboard extends StatefulWidget {
//   final String uid;
//
//   const Dashboard({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentIndex = 0;
//   int _backButtonPressCount = 0; // Default index
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (_backButtonPressCount < 2) {
//           setState(() {
//             _backButtonPressCount++;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Press back again to exit'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//           return false;
//         } else {
//           return true;
//         }
//       },
//       child: Scaffold(
//         appBar: MyAppBar(uid: widget.uid),
//         body: PageView(
//           controller: _pageController,
//           children: <Widget>[
//             ProductsPage(uid: widget.uid),
//             CalendarPage(uid: widget.uid),
//             FirebaseListPage(uid: widget.uid),
//           ],
//         ),
//         extendBody: true,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                 builder: (context) => Dashboard(uid: widget.uid),
//               ),
//                   (Route<dynamic> route) => false,
//             );
//           },
//           child: Icon(Icons.storefront_outlined),
//           backgroundColor: Colors.lightGreen,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: CircleBorder(),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           elevation: 20.0,
//           notchMargin: 10.0,
//           shape: CircularNotchedRectangle(),
//           color: Colors.lightGreen,
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               double dynamicPadding = screenWidth * 0.05;
//
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNavItem(
//                     icon: Icons.subscriptions,
//                     label: 'Subscription',
//                     dynamicPadding: dynamicPadding,
//                     screenWidth: screenWidth,
//                     onTap: () {
//                       // Subscription navigation logic
//                     },
//                   ),
//                   _buildNavItem(
//                     icon: Icons.calendar_month_outlined,
//                     label: 'Calendar',
//                     dynamicPadding: dynamicPadding * 2,
//                     screenWidth: screenWidth,
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => CalendarPage(uid: widget.uid),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildNavItem(
//                     icon: Icons.person_sharp,
//                     label: 'Profile',
//                     dynamicPadding: dynamicPadding,
//                     screenWidth: screenWidth,
//                     onTap: () {
//                       // Profile navigation logic
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem({
//     required IconData icon,
//     required String label,
//     required double dynamicPadding,
//     required double screenWidth,
//     required Function onTap,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: dynamicPadding),
//       child: GestureDetector(
//         onTap: () => onTap(),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: Colors.white,
//               size: screenWidth * 0.06,
//             ),
//             Text(
//               label,
//               style: TextStyle(color: Colors.white),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String uid;
//
//   const MyAppBar({required this.uid, Key? key}) : super(key: key);
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('agaram')
//           .doc('user_delivery')
//           .collection('users')
//           .doc(uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildAppBar(context, title: 'Loading...');
//         } else if (snapshot.hasError) {
//           return _buildAppBar(context, title: 'Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || !snapshot.data!.exists) {
//           return _buildAppBar(context, title: 'No data available');
//         } else {
//           DocumentSnapshot document = snapshot.data!;
//           String username = document['username'];
//           String address = document['address'];
//
//           return AppBar(
//             backgroundColor: Colors.lightGreen,
//             automaticallyImplyLeading: false,
//             title: Row(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(right: 10.0),
//                   child: const CircleAvatar(
//                     backgroundImage: AssetImage('assets/icons/person_icon.png'),
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       username,
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           size: 16.0,
//                           color: Colors.red,
//                         ),
//                         const SizedBox(width: 5.0),
//                         Text(
//                           address,
//                           style: const TextStyle(
//                             fontSize: 8.5,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context, {required String title}) {
//     return AppBar(
//       backgroundColor: Colors.lightGreen,
//       automaticallyImplyLeading: false,
//       title: Text(title),
//     );
//   }
// }
