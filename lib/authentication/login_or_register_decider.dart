import 'package:flutter/cupertino.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class Decider extends StatefulWidget {
  const Decider({super.key});

  @override
  State<Decider> createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {

  //Initially show the login page
  bool showLoginPage = true;

  //Decide whether to show login or register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {

    if(showLoginPage){
      return LoginPage(onTap: togglePages,);
    }else{
      return Register(onTap: togglePages,);
    }
  }
}
