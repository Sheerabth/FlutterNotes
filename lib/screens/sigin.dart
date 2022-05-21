import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignIn',
      home: Scaffold(
        body: Center(
         child: Card(
             color: Theme.of(context).colorScheme.surfaceVariant,
             child: SizedBox(
               width: 300,
               height: 300,
               child: Center(
                 child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       const Image(image: AssetImage('assets/icon/icon.png'), width: 50, height: 50,),
                       const Padding(
                         padding: EdgeInsets.all(10),
                         child: Text(
                           "Flutter Notes",
                           style: TextStyle(
                               fontSize: 35,
                               fontWeight: FontWeight.bold,
                              fontFamily: 'ProductSans'
                           ),
                         ),
                       ),
                       const Padding(
                         padding: EdgeInsets.all(10),
                         child: Text(
                           "A notes app built in flutter",
                         ),
                       ),
                       const Divider(),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SignInButton(
                             Buttons.Google,
                             text: "Continue with Google",
                             onPressed: signInWithGoogle,
                           ),
                         ],
                       ),
                     ]
                 ),
               ),
             )
         ),
        )
      ),
    );
  }

}