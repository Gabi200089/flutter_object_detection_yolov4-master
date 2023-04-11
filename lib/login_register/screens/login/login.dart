import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/screens/login/components/body.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  String email = '';
  String password = '';
  final auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //appBar: AppBar(title: Text('login'),),
      body: Body(),
    );
  }
}



// Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextFormField(
      //         keyboardType: TextInputType.emailAddress,
      //         decoration:  InputDecoration(
      //           icon: Icon(Icons.email),
      //           hintText: 'Email'
      //         ),
      //         onChanged: (value) {
      //           setState(() {
      //             email = value.trim();
      //           });
      //         }
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: TextFormField(
      //         obscureText: true,
      //         decoration:  InputDecoration(
      //           icon: Icon(Icons.password),
      //           hintText: 'Password'
      //         ),
      //         onChanged: (value) {
      //           setState(() {
      //             password = value.trim();
      //           });
      //         },
      //       ),
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             primary:Colors.blue,
      //           ),
      //           child: Text('sign in'),
      //           onPressed: (){
      //             auth.signInWithEmailAndPassword(email: email, password: password);
      //             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      //         }),
      //         ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             primary:Colors.blue,
      //           ),
      //           child: Text('sign up'),
      //           onPressed: (){
      //             auth.createUserWithEmailAndPassword(email: email, password: password);
      //         })
      //       ],
            
      //     )
      //   ],
      // ),

