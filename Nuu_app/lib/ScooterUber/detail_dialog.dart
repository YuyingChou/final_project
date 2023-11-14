import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:nuu_app/Providers/uberList_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'ScooterUber.dart';

Future<void> showDetailsDialog(BuildContext context, UberItem item) async {
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
  final userInfoResponse = await getUserInfo(item.userId);
  //取得信息成功
  if (userInfoResponse.statusCode == 200) {
    print("成功");
    final userInfo = json.decode(userInfoResponse.body);
    context.read<UberListProvider>().setList(
      userInfo['username'],
      item.userId,
      userInfo['email'],
      userInfo['studentId'],
      userInfo['Department'],
      userInfo['Year'],
      userInfo['gender'],
      userInfo['phoneNumber'],
    );
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '建立者: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: context.watch<UberListProvider>().username,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '地點: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '從 ${item.startingLocation} 到 ${item.destination}',
                    ),
                  ],
                ),
              ),
              Text('出發時間: ${DateFormat('yyyy-MM-dd HH:mm').format(item.selectedDateTime)}'),


              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('關閉'),
              ),
            ],
          ),
        ),
      );
    },
  );
}