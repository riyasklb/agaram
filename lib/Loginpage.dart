import 'package:agaram_dairy/main.dart';
import 'package:agaram_dairy/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Firebase_activity.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool loading = false;
  bool showpass = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyApp()));

          },
        ),
      ),
      resizeToAvoidBottomInset: true, // Allow resizing when keyboard appears
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Container(
                  height: 200, // Specify a fixed height
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/illustration-3.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your credentials to login",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Container(
                  height : MediaQuery.of(context).size.height, // Specify a fixed height
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !showpass? true : false,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          suffixIcon: IconButton(
                            icon: Icon(showpass ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                showpass = !showpass;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (loading)
                        Container(
                          color: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      const SizedBox(height: 10),
TextButton(onPressed: (){

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>
        RestPassword()),
  );
  // RestPassword
}, child: Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text('Forgot Password?'),
    Icon(Icons.lock)
  ],
)),
                      // const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          // onPressed: ()
                          // {
                          //     FirebaseAuth_milk firebaseActivity = FirebaseAuth_milk();

                          // },
                          onPressed: () async {

                            setState(() {
                              loading=true;
                            });
                            FirebaseAuth_milk firebaseActivity = FirebaseAuth_milk();
                            var result = await firebaseActivity.signInWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());


                            if(result)
                            {
                              setState(() {
                                loading=false;
                              });
                              const snackBar = SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Login Successful'),
                                  ],
                                ),
                                backgroundColor: Colors.lightGreen,
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              print(" Your USER ID IS : ------- > ${firebaseActivity.userid}");
                              // Save session information
                              await saveSession(emailController.text.trim(), firebaseActivity.userid,passwordController.text.trim());

                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>  HomeScreen(uid: firebaseActivity.userid)));
                            }
                            else
                            {
                              setState(() {
                                loading=false;
                              });
                              const snackBar = SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.close, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Incorrect Email Or Password'),
                                  ],
                                ),
                                backgroundColor: Colors.lightGreen,
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to save session information
  Future<void> saveSession(String email, String token, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email);
    await prefs.setString('auth_token', token);
    await prefs.setString('auth_password', pass);
  }

}
