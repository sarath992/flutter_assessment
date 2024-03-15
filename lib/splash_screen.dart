import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_application/login_or_signup.dart';
import 'package:shopping_application/main.dart';
import 'package:shopping_application/product_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    checkuserLoggedIn();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/splash_screen/splash.png',
          fit: BoxFit.cover,),
        ],

      )
    );
  }

void dispose(){
super.dispose();
}
  Future<void> gotoLogin()async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)
    {
      return Login();
    }));
  }

   Future<void> checkuserLoggedIn() async{
    final _sharedpref = await SharedPreferences.getInstance();
    final _logged =  _sharedpref.getBool(SAVE_KEY_NAME);    
    if(_logged == null || _logged == false)
    {
      gotoLogin();
    }
    else
    {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx1)=>ProductListPage()));
    }
  }
}