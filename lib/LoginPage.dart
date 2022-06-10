import 'dart:convert';

import 'package:begreatful/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  checklogin()async{
    SharedPreferences Prefs = await SharedPreferences.getInstance();

    if(Prefs.containsKey("islogin"))
      {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage()));
      }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Enter your Name",
                    errorStyle: TextStyle(
                      color: Colors.red,
                      wordSpacing: 5.0,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    hintText: "Enter your Password",
                    errorStyle: TextStyle(
                      color: Colors.red,
                      wordSpacing: 5.0,
                    ),
                  ),
                  validator: (value) {
                    // add your custom validation here.
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    } else if (value.length < 6) {
                      return 'Must be more than 5 charater';
                    }
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var name = _name.text.toString();
                        var pw = _password.text.toString();

                        Uri url =
                            Uri.parse("https://begratefulapp.ca/api/login");
                        Map<String, String> params = {
                          "name": name,
                          "password": pw,
                          "device_token": "123432",
                          "device_os": "android",
                        };

                        Map<String, String> headers = {
                          "Content-Type": "application/json",
                        };

                        var response = await http.post(url,
                            body: jsonEncode(params), headers: headers);
                        if (response.statusCode == 200) {
                          var body = response.body.toString();
                          var json = jsonDecode(body);
                          var message = json["message"].toString();
                          if (json["result"] == "success") {
                            Fluttertoast.showToast(
                              msg: message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 18,
                            );

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("Name", name);
                            prefs.setString("Password", pw);
                            prefs.setString("islogin", "yes");

                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          } else {
                            Fluttertoast.showToast(
                              msg: message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 18,
                            );
                          }

                          _name.text = "";
                          _password.text = "";
                        }
                      }
                    },
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
