import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //user input controllers
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmPassWordController = TextEditingController();

  //registering new users

  void signUp()async{
    //showing the loading animation
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ));

    //checking if password and confirm password match

    if(passWordController.text != confirmPassWordController.text){
      //eliminate loading animation
      Navigator.pop(context);
      //display error
      displayMessage("Password does not match");
      return;
    }

    try{

      //create new user
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passWordController.text.trim());

      //Create list of users (Add new user if already created)
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set(
        {
          'username' : emailController.text.split('@')[0],//Default user name
          'bio' : '...empty...'
        }
      );

      //eliminating loading animation
      Navigator.pop(context);
    }on FirebaseAuthException
    catch(e){
      //eliminating loading animation
      Navigator.pop(context);
      //display error
      displayMessage(e.code);
    }

  }

  //print sign up error to user
  void displayMessage(String message){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  //logo
                  const SizedBox(
                    width: 250,
                    height: 250,
                    child: Image(image: AssetImage('assets/Design.png'),
                    ),
                  ),

                  const SizedBox(height: 17.5,),

                  //welcome text
                  const Text("Welcome to the whispher, lets get you started!"),

                  const SizedBox(height: 17.5,),
                  //email
                  MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscure: false),

                  const SizedBox(height: 10,),
                  //password
                  MyTextField(
                      controller: passWordController,
                      hintText: "Password",
                      obscure: true),

                  const SizedBox(height: 10,),

                  //confirm password
                  MyTextField(
                      controller: confirmPassWordController,
                      hintText: "Confirm password",
                      obscure: true),

                  const SizedBox(height: 30,),

                  //sign in button
                  MyButton(
                    ontap: signUp,
                    text: "Sign Up",
                  ),

                  const SizedBox(height: 10,),

                  //redirect to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Return to login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
