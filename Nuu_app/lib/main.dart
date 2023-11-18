import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nuu_app/AccountServices/Login.dart';
import 'package:nuu_app/AccountServices/Home.dart';
import 'package:nuu_app/Providers/user_provider.dart';
import 'package:nuu_app/Providers/ListOwner_provider.dart';
import 'package:nuu_app/Providers/List_provider.dart';

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
        ChangeNotifierProvider(
          create: (context) => ListOwnerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ListProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary
          )
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