import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nuu_app/AccountServices/Login.dart';
import 'package:nuu_app/AccountServices/Home.dart';
import 'package:nuu_app/Providers/user_provider.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(

        ),
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => const MainPage(),
        },
        initialRoute: '/home', // 應用程序的初始路由
      ),
    );
  }
}
