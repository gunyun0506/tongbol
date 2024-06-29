import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:tongbokapp/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_page.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 137, top: 300),
              // child: const Text(
              //   'Login',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 25,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
            _user != null ? _userInfo() : _googleSignInButton(),
          ],
        ),
      ),
    );
  }

  // 구글 로그인 버튼
  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 60,
        child: SignInButton(
          Buttons.google,
          text: "Sign up with Google",
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }

  // 유저 정보 입력되면 HomePage로 이동
  Widget _userInfo() {
    return const HomePage();
  }

  void _handleGoogleSignIn() async {
    try {
      final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print('Error signing in with Google: $error');
      // 예외 처리 추가 (예: 사용자에게 오류 메시지를 표시)
    }
  }
}
