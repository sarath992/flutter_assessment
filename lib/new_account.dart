import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_application/login_or_signup.dart';
import 'package:shopping_application/product_list.dart';

class New_Account extends StatefulWidget {
  const New_Account({super.key});

  @override
  State<New_Account> createState() => _New_AccountState();
}

class _New_AccountState extends State<New_Account> {
  final _username = TextEditingController();

  final _password = TextEditingController();

  final _confirmPassword = TextEditingController();

  bool _passwordMatch = true;

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Silver Shop-Create Account'),
        backgroundColor: Colors.greenAccent,
        automaticallyImplyLeading: false,
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
                    hintText: 'New Password',
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
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: true,
                   decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm Password',
                    errorText: !_passwordMatch? 'Please enter new password and confirm password as same':null,
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
                    else if(_password.text != value){
                      _passwordMatch = false;
                      return 'Please enter new password and confirm password as same';
                    }
                    else
                    {
                      _passwordMatch = true;
                      return null;
                    }
                  },
                ),
                  ElevatedButton.icon(onPressed: (){
                      signUp(context);
              
                  }, icon: Icon(Icons.check), label:Text('SignUP')),
                  SizedBox(height: 20,),
                  ElevatedButton.icon(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return Login();
                      }));
              
                  }, icon: Icon(Icons.question_mark), label:Text('Already Have an account'))
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


  void signUp(BuildContext context) async {
  if (_formkey.currentState!.validate()) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String existingUsername = prefs.getString('username') ?? '';
    final String existingPassword = prefs.getString('password') ?? '';

    if (_username.text == existingUsername && _password.text == existingPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account already exists'),
        ),
      );
    } else {
     
      prefs.setString('username', _username.text);
      prefs.setString('password', _password.text);


      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => ProductListPage()),
      );
    }
  }
}

}