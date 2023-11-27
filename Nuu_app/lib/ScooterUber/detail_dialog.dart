import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:nuu_app/Providers/user_provider.dart';
import 'package:nuu_app/Providers/UberList_provider.dart';
import 'package:nuu_app/Providers/ListItem_provider.dart';
import 'package:nuu_app/Providers/ListOwner_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'UberListPage/allUberList.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  //取得擁有者信息
  final userInfoResponse = await getUserInfo(item.userId);
  //取得信息成功
  if (userInfoResponse.statusCode == 200) {
    final ownerInfo = json.decode(userInfoResponse.body);
    if (!context.mounted) return;
    context.read<ListOwnerProvider>().setListOwnerInfo(
      ownerInfo['username'],
      item.userId,
      ownerInfo['email'],
      ownerInfo['studentId'],
      ownerInfo['Department'],
      ownerInfo['Year'],
      ownerInfo['gender'],
      ownerInfo['phoneNumber'],
    );
  }

  //更新list
  Future<void> editList({
    required String listId,
  }) async {
    Future<http.Response> editList() {
      final String apiUrl = 'http://10.0.2.2:8800/api/uberList/updatedList/$listId';

      final Map<String, dynamic> listData = {
        'userId' : context.read<ListItemProvider>().userId,
        'anotherUserId': context.read<ListItemProvider>().anotherUserId,
        'reserved' : context.read<ListItemProvider>().reserved,
        'startingLocation': context.read<ListItemProvider>().startingLocation,
        'destination': context.read<ListItemProvider>().destination,
        'selectedDateTime': context.read<ListItemProvider>().selectedDateTime.toIso8601String(),
        'wantToFindRide': context.read<ListItemProvider>().wantToFindRide,
        'wantToOfferRide': context.read<ListItemProvider>().wantToOfferRide
      };

      return http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(listData),
      );
    }
    try {
      // 調用 editList 函數發送 PUT 請求
      final response = await editList();

      if (response.statusCode == 200) {
        final updatedUserData = jsonDecode(response.body);
        print('預約成功: $updatedUserData');
        Fluttertoast.showToast(
          msg: "預約成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0, //文本大小
        );
      } else {
        print('用户信息更新失败: ${response.statusCode}');
      }
    } catch (e) {
      // 發生錯誤
      print('異常: $e');
    }
  }
  if (!context.mounted) return;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      context.read<ListItemProvider>().setList(
        item.listId,
        item.userId,
        item.anotherUserId,
        item.reserved,
        item.startingLocation,
        item.destination,
        item.selectedDateTime,
        item.wantToFindRide,
        item.wantToOfferRide,
        item.notes
    );
      return Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('詳細資訊', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18.0,color: Colors.black),
                        children: [
                          const TextSpan(
                            text: '建立者: ',
                          ),
                          TextSpan(
                            text: context.watch<ListOwnerProvider>().username,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18.0,color: Colors.black),
                        children: [
                          const TextSpan(
                            text: '性別: ',
                          ),
                          TextSpan(
                            text: context.watch<ListOwnerProvider>().gender,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18.0,color: Colors.black),
                    children: [
                      const TextSpan(
                        text: '學號: ',
                      ),
                      TextSpan(
                        text: context.watch<ListOwnerProvider>().studentId,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18.0,color: Colors.black),
                    children: [
                      const TextSpan(
                        text: '系所: ',
                      ),
                      TextSpan(
                        text: context.watch<ListOwnerProvider>().department + context.watch<ListOwnerProvider>().year,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18.0,color: Colors.black),
                    children: [
                      const TextSpan(
                        text: '地點: ',
                      ),
                      TextSpan(
                        style: const TextStyle(color: Colors.black),
                        text: '從 ${item.startingLocation} 到 ${item.destination}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18.0,color: Colors.black),
                    children: [
                      const TextSpan(
                        text: '出發時間: ',
                      ),
                      TextSpan(
                        style: const TextStyle(color: Colors.black),
                        text: DateFormat('yyyy-MM-dd HH:mm').format(item.selectedDateTime),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                    "備註: ",
                  style: TextStyle(fontSize: 18.0,color: Colors.black),
                ),
                SizedBox(
                  width: 200.0,
                  height: 100.0,
                  child: SingleChildScrollView(
                    child: Text(
                      item.notes,
                      style: const TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if(context.read<UserProvider>().userId == context.read<ListItemProvider>().userId){
                          Fluttertoast.showToast(
                            msg: "你已經是清單的建立者，不能預約",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blue,
                            textColor: Colors.white,
                            fontSize: 16.0, //文本大小
                          );
                        } else{
                          context.read<ListItemProvider>().setReserved(context.read<UserProvider>().userId, true);
                          editList(listId: item.listId);
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: const Text('預約搭乘'),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('關閉'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}