import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_application/main.dart';
import 'package:shopping_application/new_account.dart';
import 'package:shopping_application/product_list.dart';

class Login extends StatefulWidget {
   Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _username = TextEditingController();

  final _password = TextEditingController();

  final _formkey = GlobalKey<FormState>();// Key for form validation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Silver-Shop')),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key:_formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _username,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'E-mail'
                  ),
                  validator: (value){
                     if(value == null||value.isEmpty)
                    {
                      return '!Required';
                    }
                    else if(!_isValidEmail(value))
                    {
                      return 'Please enter a valid email address';
                    }
                    else
                    {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                   decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password'
                  ),
                   validator: (value){
                   
                    if(value == null||value.isEmpty)
                    {
                      return '!Required';
                    }
                    else if(!_isValidPassword(value))
                    {
                      return 'Password must contain at least 8 characters including uppercase, lowercase, and a number';
                    }
                    else
                    {
                      return null;
                    }
                  },
                ),
                
                SizedBox(height: 20,),
                  ElevatedButton.icon(onPressed: (){
                      checklogin(context);
              
                  }, icon: Icon(Icons.check), label:Text('Login')),
                  SizedBox(height: 20,),
                  ElevatedButton.icon(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return New_Account();
                      }));
              
                  }, icon: Icon(Icons.question_mark), label:Text('New Here,Then Please Create An Account'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
  final RegExp regex = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  return regex.hasMatch(email);
}

  bool _isValidPassword(String password) {
  final RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
  return regex.hasMatch(password);
}

  void checklogin(BuildContext ctx) async
  {

     if (_formkey.currentState!.validate()) {
    final _sharedPreference = await SharedPreferences.getInstance();
    await _sharedPreference.setBool(SAVE_KEY_NAME, true);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return ProductListPage();
    }));
  }
  }
}