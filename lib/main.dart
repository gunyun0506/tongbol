import 'package:flutter/material.dart';
import 'package:tongbokapp/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tongbokapp/login_page.dart';
import 'package:intl/date_symbol_data_local.dart'; // intl 패키지의 date_symbol_data_local impor

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('ko_KR', null); // 한국 로케일의 데이터 초기화
  initalizeSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TongBokApp',
      locale: Locale('ko', 'KR'), // 로케일을 한국어로 설정
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'KR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
