import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: RegisterPage()));

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  Future<void> registerUser() async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    Future<http.Response> createAlbum(String username, String email, String password) {
      const String apiUrl = 'http://10.0.2.2:8800/api/users/register';

      final Map<String, dynamic> userData = {
        'username': username,
        'email': email,
        'password': password,
      };

      return http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );
    }
    try {
      // 調用 createAlbum 函數發送 POST 請求
      final response = await createAlbum(username, email, password);

      if (response.statusCode == 200) {
        // 註冊成功
        final jsonResponse = json.decode(response.body);
        print('註冊成功，用戶 ID: ${jsonResponse['_id']}');
      } else {
        print('註冊失敗: ${response.body}');
      }
    } catch (e) {
      // 發生錯誤
      print('註冊失敗: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('註冊'),
      ),
      body: Center(
        child:SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: '使用者名稱',
                    labelText: '使用者名稱',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: '電子郵件',
                    labelText: '電子郵件',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '密碼',
                    labelText: '密碼',
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    registerUser(); // 呼叫註冊功能
                  },
                  child: const Text('註冊'),
                ),
              ],
            ),
          ),
        )

      )
    );
  }
}