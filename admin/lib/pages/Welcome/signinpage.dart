// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero/controllers/login_controller.dart';
import 'package:zero/pages/Admin/fetch_data.dart';

import 'package:zero/pages/Welcome/forgottenpassword.dart';
import 'package:zero/styles/squareTile.dart';

import 'package:zero/styles/textfield.dart';
import 'package:zero/styles/button.dart';
import 'package:zero/styles/color.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final controller = Get.put(LoginController());
  // Define a list of roles for the dropdown
  List<String> roles = ['Admin']; // Add your roles here

  // Define a variable to hold the selected role
  String? selectedRole;

  void login() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Dismiss loading circle
      Navigator.pop(context);

      User? user = userCredential.user;
      String userEmail = user!.email ?? 'User';
      String userName = userEmail.split('@').first;

      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(user.email)
          .get();

      if (userData.exists) {
        String? assignedRole = userData['Selected Role'];

        if (selectedRole == assignedRole) {
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Welcome, $userName!'),
                content: Text('You have successfully signed in!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Get.offAll(() => FetchData());                     
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else {
          // Show error message for incorrect role
          showErrorMessage(
              'Invalid role selected. Please choose the correct role.');
        }
      }
    } on FirebaseAuthException catch (e) {
      // Dismiss loading circle
      Navigator.pop(context);
      // Show error message
      showErrorMessage(e.code);
    }
  }

  //error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[400],
          title: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'FjallaOne',
              ),
            )
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const SizedBox(width: 88),
                    const Text(
                      'ZERO',
                      style: TextStyle(
                        fontFamily: 'FjallaOne',
                        fontSize: 70,
                        color: Color(0xff414141)
                      )
                    ),
                    Image.asset(
                      'assets/zero_logo.png',
                      height: 101, 
                      width: 123
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Eating Mindfully, Wasting Less
                const Text(
                  'Eating Mindfully, Wasting Less',
                  style: TextStyle(
                    fontFamily: 'FjallaOne',
                    fontSize: 16,
                    color: Color(0xff414141)
                  )
                ),

                // Enter your Email textfield
                const SizedBox(height: 100),
                MyTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  isPassword: false,
                ),

                const SizedBox(height: 20),

                // Enter your Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  isPassword: true,
                ),

                const SizedBox(height: 10),

                //Role
                Container(
                  width: 350,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                      // Dropdown button for role
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        },
                        items: roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                        ),
                      ),
                    ),
                  ),

                  // const SizedBox(height: 10),

                  // Forgotten password?
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>ForgottenPassword()
                        )
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 44.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgotten Password?',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'PathwayGothicOne',
                              color: Color(0xff414141)
                            )
                          ),
                        ]
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign in button
                  ElevatedButton(
                    style: buttonPrimary,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PathwayGothicOne',
                        color: Color(0xff414141)
                      )
                    ),
                    onPressed: () {
                      login();
                    },
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
