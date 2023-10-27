import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nuu_app/MainSystem/Login.dart';
import 'package:nuu_app/ScooterUber/ScooterUber.dart';


void main() async {
  //確認登入狀態
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MaterialApp(
      home: isLoggedIn ? const HomePage() : LoginPage()
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the App!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('登出'),
            ),
            ElevatedButton(
              onPressed: () {
                // 在按下按鈕時導航到註冊頁面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>UberList()),
                );
              },
              child: const Text('共乘系統'),
            ),
          ],
        ),
      ),
    );
  }
}
