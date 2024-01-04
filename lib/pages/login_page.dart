import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passWordController = TextEditingController();

  //user sign in
  void signIn() async{
    //loading animation
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ));

    //signing in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passWordController.text);

      //terminating loading animation
      if(context.mounted){
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  //print login error to user
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
                  const SizedBox(height: 50,),
                  //logo
                  const SizedBox(
                    width: 250,
                    height: 250,
                    child: Image(
                      image: AssetImage(
                          'assets/Design.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40,),

                  //welcome text
                  const Text("Welcome back! your presence have been missed"),

                  const SizedBox(height: 40,),
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

                  const SizedBox(height: 30,),

                  //sign in button
                  MyButton(
                    ontap: signIn,
                    text: "Sign in",
                  ),

                  const SizedBox(height: 10,),

                  //redirect to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member? "),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                            "Register now",
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
