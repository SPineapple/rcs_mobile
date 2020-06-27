import 'package:flutter/material.dart';
import 'package:rcs_mobile/screens/dashboard_screen.dart';
import 'package:rcs_mobile/common/sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF70b57c).withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return RaisedButton(
      splashColor: Color(0xFFbbedc4),
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      highlightElevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
