import 'package:flutter/material.dart';
import 'package:chatit/CreateAccount.dart';
import 'package:chatit/Methods.dart';
import 'package:chatit/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  String signInMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                signInMessage,
                style: TextStyle(
                  color: Colors.red, // Change color as per your requirement
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildTextField("Email", Icons.account_box, _email),
                    SizedBox(height: 20),
                    _buildTextField("Password", Icons.lock, _password,
                        obscureText: true),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _handleLogin(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CreateAccount(),
                  ));
                },
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hintText, IconData icon, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      logIn(_email.text, _password.text).then((user) {
        if (user != null) {
          setState(() {
            signInMessage = "Login Successful"; // Display success message
          });
          print("Login Successful");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          setState(() {
            signInMessage = "Login Failed"; // Display error message
          });
          print("Login Failed");
        }
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        signInMessage =
            "Please fill the form correctly"; // Display error message
      });
      print("Please fill the form correctly");
    }
  }
}
