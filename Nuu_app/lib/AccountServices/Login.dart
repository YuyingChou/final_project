import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:nuu_app/Providers/user_provider.dart';
import 'dart:convert';
import 'package:nuu_app/AccountServices/Register.dart';
import 'Home.dart';

void main() => runApp(MaterialApp(home: LoginPage()));

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BuildContext currentContext = context;
    return MaterialApp(
      title: '登入介面',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'TW'),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('登入'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: '輸入使用者名稱',
                      labelText: '使用者名稱',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '輸入密碼',
                      labelText: '密碼',
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    key: const Key('loginButton'),
                    onPressed: () async {
                      String username = usernameController.text;
                      String password = passwordController.text;

                      Future<http.Response> postUserInfo(String username,String password) {
                        const String apiUrl = 'http://10.0.2.2:8800/api/users/login';

                        final Map<String, dynamic> userData = {
                          'username': username,
                          'password': password
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
                        //傳送帳號密碼
                        final response = await postUserInfo(username,password);
                        //登入成功
                        if (response.statusCode == 200) {
                          final jsonResponse = json.decode(response.body);
                          final userId = jsonResponse['_id'];

                          Future<http.Response> getUserInfo(String userId) async {
                            String apiUrl = 'http://10.0.2.2:8800/api/users/user/$userId';

                            final response = await http.get(
                              Uri.parse(apiUrl),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                            );
                            return response;
                          }
                          //取得使用者信息
                          final userInfoResponse = await getUserInfo(userId);
                          //取得信息成功
                          if (userInfoResponse.statusCode == 200) {
                            final userInfo = json.decode(userInfoResponse.body);
                            //更新狀態
                            context.read<UserProvider>().setUser(
                              userInfo['username'],
                              userId,
                              userInfo['email'],
                              userInfo['studentId'],
                              userInfo['Department'],
                              userInfo['Year'],
                              userInfo['gender'],
                              userInfo['phoneNumber'],
                            );

                            // Navigator.push(
                            //   currentContext,
                            //   MaterialPageRoute(builder: (context) => const MainPage()),
                            // );
                          }
                          Provider.of<UserProvider>(context, listen: false).setUserLoggedIn();

                          Navigator.push(
                            currentContext,
                            MaterialPageRoute(builder: (context) => const MainPage()),
                          );

                        } else {  //登入失敗
                          showDialog(
                            context: currentContext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('登入失敗'),
                                content: const Text('請確認你的使用者名稱與密碼是否輸入正確'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } catch (e) {
                        // 發生錯誤
                        print('登入失敗: $e');
                      }
                    },
                    child: const Text('登入'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 在按下按鈕時導航到註冊頁面
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text('註冊'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}