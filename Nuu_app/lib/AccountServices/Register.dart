import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//gender select
String? selectedGender = '其他';
List<String> genderOptions = ['男', '女', '其他'];
//className select
String? selectedDepartment;
String? selectedYear;
List<String> departments = ['臺灣語文與傳播學系', '華語文學系', '文化創意與數位行銷學系','文化觀光產業學系',
'工業設計學系','建築學系','經營管理學系','財務金融學系','資訊管理學系','電機工程學系','電子工程學系','光電工程學系',
'資訊工程學系','機械工程學系','土木與防災工程學系','化學工程學系'];
List<String> years = ['一年級','二年級','三年級','四年級','碩士生','博士生'];

void main() => runApp(const MaterialApp(home: RegisterPage()));

class RegisterPage extends StatefulWidget{
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Future<void> registerUser() async {
    final String username = usernameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String studentId = studentIdController.text;
    final String phoneNumber = phoneNumberController.text;

    Future<http.Response> createAlbum(String username, String email, String password, String studentId) {
      const String apiUrl = 'http://10.0.2.2:8800/api/users/register';

      final Map<String, dynamic> userData = {
        'username': username,
        'email': email,
        'password': password,
        'studentId': studentId,
        'Department': selectedDepartment,
        'Year': selectedYear,
        'gender': selectedGender,
        'phoneNumber': phoneNumber,
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
      final response = await createAlbum(username, email, password, studentId, );

      if (response.statusCode == 200) {
        // 註冊成功
        final jsonResponse = json.decode(response.body);
        print('註冊成功，用戶 ID: ${jsonResponse['_id']}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('註冊成功!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('回到登錄頁面'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); //回到登錄頁面
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('註冊失敗'),
              content: const Text('姓名、學號或電子信箱已被註冊過'),
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
        //print('註冊失敗: ${response.body}');
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
                    hintText: '姓名',
                    labelText: '姓名',
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
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    hintText: '行動電話',
                    labelText: '行動電話',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: studentIdController,
                  decoration: const InputDecoration(
                    hintText: '學號',
                    labelText: '學號',
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDepartment = newValue!;
                    });
                  },
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('選擇系所'), //默認
                    ),
                    ...departments.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  decoration: const InputDecoration(
                    hintText: '系所',
                    labelText: '系所',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('選擇年級'), //默認
                    ),
                    ...years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  decoration: const InputDecoration(
                    hintText: '年級',
                    labelText: '年級',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('選擇性別'), //默認
                    ),
                    ...genderOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ],
                  decoration: const InputDecoration(
                    hintText: '性別',
                    labelText: '性別',
                  ),
                ),
                const SizedBox(height: 16.0),
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