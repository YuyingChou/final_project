import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../RentHouse/RentHouse.dart';
import '../ScooterUber/ScooterUber.dart';
import '../main.dart';
import '../trading_website/trading_website.dart';
import 'Login.dart';
import 'menu.dart';
import 'package:nuu_app/Providers/user_provider.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('主頁面'),
        ),
        drawer: Menu(key: scaffoldKey),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '歡迎使用這個App!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     context.read<UserProvider>().setUserLoggedOut();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => LoginPage()),
              //     );
              //   },
              //   child: const Text('登出'),
              // ),
              ElevatedButton(
                onPressed: () {
                  // 在按下按鈕時導航到註冊頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UberList()),
                  );
                },
                child: const Text('共乘系統'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 在按下按鈕時導航到註冊頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const trading_website()),
                  );
                },
                child: const Text('二手物交易&代訂教科書平台'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 在按下按鈕時導航到註冊頁面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RentApp()),
                  );
                },
                child: const Text('租屋平台'),
              ),
            ],
          ),
        ),
      );
    }
    else{
      return LoginPage();
    }
  }
}