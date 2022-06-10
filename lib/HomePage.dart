import 'package:begreatful/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  var id="";
  var name ="";
  var email = "";

  HomePage({this.id, this.name, this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var name="";
  var password="";
  getdata() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("Name");
     password = prefs.getString("Password");
    }
    );
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // Text("Id : "+widget.id.toString(),),
              // Text("Name : "+widget.name.toString(),),
              // Text("Email : "+widget.email.toString(),),
              SizedBox(height: 50,),
              Text("Name : "+name, style: TextStyle(fontSize: 20),),
              SizedBox(height: 50,),
              Text("Password : "+password, style: TextStyle(fontSize: 20),),

              SizedBox(height: 50,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove("islogin");

                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage())
                    );
                  },

                  child: Text("LogOut", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
