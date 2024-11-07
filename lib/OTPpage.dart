import 'package:agaram_dairy/Loginpage.dart';
import 'package:flutter/material.dart';

import 'Firebase_activity.dart';
import 'dashboard.dart';

class Otp extends StatefulWidget {
  final int otp;
  final String email;
  final String username;
  final String password;
  final int mobile;
  final String address;
  const Otp({required Key key, required this.otp, required this.email,required this.username, required this.password,required this.mobile ,required this.address}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    // Initialize _controllers list
    _controllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose controllers
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool loading= false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightGreen.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/illustration-3.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                                (index) => Expanded(
                              child: _textFieldOTP(
                                first: index == 0,
                                last: index == 3,
                                controller: _controllers[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      const SizedBox(height: 20),
                      Text('Your OTP IS : ${widget.otp}'),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {

                            setState(() {
                              loading =  true;
                            });
                            // Extract the entered OTP from the text controllers
                            String enteredOTP = _controllers.map((controller) => controller.text).join();

                            // Check if the entered OTP matches the OTP generated during signup
                            if (enteredOTP == widget.otp.toString()) {

                              const snackBar = SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('OTP verified successfully!'),
                                  ],
                                ),
                                backgroundColor: Colors.lightGreen,
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              FirebaseAuth_milk firebaseactivity= FirebaseAuth_milk();

                              var result =  await firebaseactivity.signUpWithEmailAndPassword(widget.email,widget.mobile,widget.address,widget.password);

                              if(result)
                                {
                                  setState(() {
                                    loading = false;
                                  });
                                  const snackBar = SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('Account Was Created'),
                                      ],
                                    ),
                                    backgroundColor: Colors.lightGreen,
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                        (Route<dynamic> route) => false, // Prevents going back to the intro page
                                  );

                                }
                              else
                                {


                                  setState(() {
                                    loading = false;
                                  });
                                  const snackBar = SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.close, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Account Was Failed To Create'),
                                      ],
                                    ),
                                    backgroundColor: Colors.lightGreen,
                                    duration: Duration(seconds: 3),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                }








                            } else {

                              setState(() {
                                loading = false;
                              });
                              const snackBar = SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.close, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('OTP verification Failed!'),
                                  ],
                                ),
                                backgroundColor: Colors.lightGreen,
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
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
                              'Verify',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (loading)
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              const Text(
                "Resend New Code",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, required bool last, required TextEditingController controller}) {
    return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: first,
          onChanged: (value) {
            if (value.length == 1 && !last) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && !first) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.lightGreen),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
