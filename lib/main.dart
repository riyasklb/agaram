
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Loginpage.dart';
import 'Signuppage.dart';
import 'dashboard-demo.dart';
import 'dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

Future<void> checkLoggedIn(BuildContext context) async {
  final loggedIn = await isLoggedIn();
  if (loggedIn) {
    final String? authToken = await getAuthToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) =>HomeScreen(uid: authToken!)),
          (Route<dynamic> route) => false, // Prevents going back to the intro page
    );
  }
}


// Function to retrieve the stored session token
Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? Token = prefs.getString('auth_token');
  print("Your Token : $Token");
  return Token;
}

// Function to retrieve the stored session token
Future<String?> getAuthEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final String? Email = prefs.getString('auth_email');
  print("Your Email : $Email");
  return Email;
}


// Function to retrieve the stored session token
Future<String?> getAuthPass() async {
  final prefs = await SharedPreferences.getInstance();
  final String? password = prefs.getString('auth_password');
  print("Your Password : $password");
  return password;
}

// Function to check if user is logged in
Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('auth_token');
  final String? Token = prefs.getString('auth_token');
  print("Your Token : $Token");
  final String? Email = prefs.getString('auth_email');
  print("Your Email : $Email");
  final String? password = prefs.getString('auth_password');
  print("Your Password : $password");
  return authToken != null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(500, 800), // Moto G82 approximate dimensions
        builder: (context, child) =>GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroPage(),
      )  );
  }

}

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn(context); // Check if user is already logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 140, horizontal: 52),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 3,
                child: Image.asset(
                  'assets/images/logo1.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Let's get started",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Never a better time than now to start.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 38,
              ),
              Flexible(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Signuppage()),
                          (Route<dynamic> route) => false, // Prevents going back to the intro page
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Flexible(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) =>LoginPage()),
                          (Route<dynamic> route) => false, // Prevents going back to the intro page
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.lightGreen),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
