import 'package:flutter/material.dart';
import 'package:chatit/Methods.dart';
import 'package:chatit/HomeScreen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[900], // Set background color to dark theme
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: size.width / 0.5,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Text(
                "Create Your Account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              _buildInputField("Name", Icons.person, _name),
              _buildInputField("Email", Icons.email, _email),
              _buildInputField("Password", Icons.lock, _password,
                  obscureText: true),
              SizedBox(
                height: size.height / 20,
              ),
              _buildSignUpButton(size),
              SizedBox(
                height: size.height / 30,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String hintText, IconData icon, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
              print("Account Created Successfully");
            } else {
              print("Account Creation Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please enter all fields");
        }
      },
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
