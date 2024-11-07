import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'Firebase_database_activity.dart';
import 'OTPpage.dart';
import 'main.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  State<Signuppage> createState() => SignuppageState();
}

class SignuppageState extends State<Signuppage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController address_reg;

  final TextEditingController username_reg = TextEditingController();
  final TextEditingController email_reg = TextEditingController();
  final TextEditingController password_reg = TextEditingController();
  final TextEditingController mobile_reg = TextEditingController();
  final TextEditingController pincodeController = TextEditingController(); // Added pincode controller
  bool loading = false;
  String? district;
  String? state;
  String? addressError;
  String? name;

  late final String fulladdress;

  @override
  void initState() {
    super.initState();
    address_reg = TextEditingController();
    pincodeController.addListener(getDistrictAndState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/illustration-2.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const SizedBox(height: 10),
                Column(
                  children: [
                    TextFormField(
                      controller: username_reg,
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your username';
                      //   }
                      //   // Username validation: Minimum characters with a number
                      //   if (!RegExp(r'^(?=.*[0-9])[a-zA-Z0-9]+$').hasMatch(
                      //       value)) {
                      //     return 'Username must contain at least one number';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: email_reg,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your email';
                      //   }
                      //   // Email validation: Must end with "@gmail.com"
                      //   if (!value.endsWith('@gmail.com')) {
                      //     return 'Email must end with "@gmail.com"';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: password_reg,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                      ),
                      obscureText: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter a password';
                      //   }
                      //   // Password validation: Medium level of validation
                      //   if (value.length < 8) {
                      //     return 'Password must be at least 8 characters long';
                      //   }
                      //   if (!RegExp(
                      //       r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$')
                      //       .hasMatch(value)) {
                      //     return 'Password must contain both letters and numbers';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: mobile_reg,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.7),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        // Phone number validation: Indian phone number format
                        if (!RegExp(r'^\+91[1-9]\d{9}$').hasMatch(value)) {
                          return 'Please enter a valid Indian phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      // Automatically add "+91" prefix to the beginning of the mobile number input
                      onChanged: (value) {
                        if (!value.startsWith('+91')) {
                          mobile_reg.text = '+91$value';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: pincodeController,
                            // Use pincode controller
                            decoration: InputDecoration(
                              labelText: 'Pincode',
                              // Changed label to Pincode
                              prefixIcon: const Icon(Icons.location_pin),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                              errorText: district == null
                                  ? 'Please enter a valid pincode'
                                  : null,
                            ),
                            keyboardType: TextInputType.number,
                            // Allow only numeric input for pincode
                            validator: (value) {
                              if (value == null || value.isEmpty ||
                                  value.length != 6) {
                                return 'Please enter a valid 6-digit pincode';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        // IconButton(
                        //   icon: const Icon(Icons.location_pin),
                        //   onPressed: () async {
                        //     setState(() {
                        //       loading = true;
                        //     });
                        //     loc.LocationData? locationData = await getLocation();
                        //     if (locationData != null) {
                        //       String address = await getAddressFromLocation(locationData);
                        //       setState(() {
                        //         address_reg.text = address;
                        //         loading = false;
                        //         addressError = null;
                        //       });
                        //     } else {
                        //       setState(() {
                        //         loading = false;
                        //         addressError = 'Error getting address';
                        //       });
                        //     }
                        //   },
                        // ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [

                          Icon(Icons.location_city, color: Colors.white),
                          SizedBox(width: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: 5),
                              Text(
                                name ?? 'Pls Wait',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 4),
                              // Text(
                              //   block ?? 'N/A',
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 14,
                              //   ),
                              // ),
                              Text(
                                district ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                state ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 4),


                            ],
                          ),
                        ],
                      ),
                    )
                    ,
                    const SizedBox(height: 20),
                    if (loading) const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, proceed with signup
                          signUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),

                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 20),
                // const Text(
                //   'Or sign up with',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ElevatedButton.icon(
                //       onPressed: () {
                //         // Handle Google login action
                //       },
                //       icon: const Icon(Icons.account_circle_outlined),
                //       label: const Text('Google Account'),
                //       style: ElevatedButton.styleFrom(
                //         foregroundColor: Colors.white,
                //         backgroundColor: Colors.redAccent,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 20),
                //     ElevatedButton.icon(
                //       onPressed: () {
                //         // Handle phone login action
                //       },
                //       icon: const Icon(Icons.phone),
                //       label: const Text('Login With Phone'),
                //       style: ElevatedButton.styleFrom(
                //         foregroundColor: Colors.white,
                //         backgroundColor: Colors.blue,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    // setState(() {
    //   loading = true;
    // });

    // FirebaseDatabase database = FirebaseDatabase(
    //   email_reg.text.trim(),
    //   password_reg.text.trim(),
    //   int.parse(mobile_reg.text.trim()),
    //   address_reg.text.trim(),
    // );
    // var result = await database.insertData();
    // if (result) {
    const snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Your Account Was Created'),
        ],
      ),

      backgroundColor: Colors.lightGreen,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print("result : done");

    setState(() {
      loading = false;
    });

    final int verify = generateFourDigitRandomNumber();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Otp(key: const Key('Your OTP IS'),
            otp: verify,
            email: email_reg.text.trim(),
            username: username_reg.text.trim(),
            mobile: int.parse(mobile_reg.text.trim()),
            password: password_reg.text.trim(),
            address: "$name,$district,$state",)),
    );

    //   } else {
    //     const snackBar = SnackBar(
    //       content: Row(
    //         children: [
    //           Icon(Icons.close, color: Colors.green),
    //           SizedBox(width: 8),
    //           Text('Your Account Failed To Create'),
    //         ],
    //       ),
    //       backgroundColor: Colors.purple,
    //       duration: Duration(seconds: 3),
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //     print("result : false");
    //     setState(() {
    //       loading = false;
    //     });
    //   }
  }

  // Function to generate a four-digit random number
  int generateFourDigitRandomNumber() {
    Random random = Random();

    int otp = random.nextInt(9000) +
        1000; // Generates a random number between 1000 and 9999
    print("YOUR OTP IS : $otp");
    return otp;
  }

  void getDistrictAndState() async {
    finpincode();
    setState(() {
      loading = true;
      district = null;
      state = null;
      name = null;

    });


    String? pincode = pincodeController.text;
    if (pincode.length == 6) {
      String apiUrl = 'https://api.postalpincode.in/pincode/$pincode';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          var postOffice = responseData[0]['PostOffice'][0];
          setState(() {
            district = postOffice['District'];
            state = postOffice['State'];
            name = postOffice['Name'];


            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }


  Future<void> finpincode() async {
    print('im working on');
    String? pincode = pincodeController.text;
    if (pincode.length == 6) {
      String apiUrl = 'https://api.postalpincode.in/pincode/$pincode';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          var postOffice = responseData[0]['PostOffice'][0];
          setState(() {
            district = postOffice['District'];
            state = postOffice['State'];
            name = postOffice['Name'];
            fulladdress = "$name, $district, $state";
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }
}
  //
  // Future<loc.LocationData?> getLocation() async {
  //   loc.Location location = loc.Location();
  //   try {
  //     return await location.getLocation();
  //   } catch (e) {
  //     print('Could not get location: $e');
  //     return null;
  //   }
  // }
  //
  // Future<String> getAddressFromLocation(loc.LocationData locationData) async {
  //   try {
  //     List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
  //       locationData.latitude!,
  //       locationData.longitude!,
  //     );
  //
  //     if (placemarks.isNotEmpty) {
  //       String address = '';
  //       if (placemarks[0].name != null && placemarks[0].name != '') {
  //         address += '${placemarks[0].name!}, ';
  //       }
  //       if (placemarks[0].thoroughfare != null && placemarks[0].thoroughfare != '') {
  //         address += '${placemarks[0].thoroughfare!}, ';
  //       }
  //       if (placemarks[0].subThoroughfare != null && placemarks[0].subThoroughfare != '') {
  //         address += '${placemarks[0].subThoroughfare!}, ';
  //       }
  //       if (placemarks[0].locality != null && placemarks[0].locality != '') {
  //         address += '${placemarks[0].locality!}, ';
  //       }
  //       if (placemarks[0].subLocality != null && placemarks[0].subLocality != '') {
  //         address += '${placemarks[0].subLocality!}, ';
  //       }
  //       if (placemarks[0].administrativeArea != null && placemarks[0].administrativeArea != '') {
  //         address += '${placemarks[0].administrativeArea!}, ';
  //       }
  //       if (placemarks[0].subAdministrativeArea != null && placemarks[0].subAdministrativeArea != '') {
  //         address += '${placemarks[0].subAdministrativeArea!}, ';
  //       }
  //       if (placemarks[0].country != null && placemarks[0].country != '') {
  //         address += placemarks[0].country!;
  //       }
  //       return address;
  //     } else {
  //       return "Address not found";
  //     }
  //   } catch (e) {
  //     print('Error fetching address: $e');
  //     return "Error fetching address";
  //   }
  // }

