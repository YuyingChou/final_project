import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:nuu_app/Providers/user_provider.dart';
import 'package:nuu_app/Providers/List_provider.dart';
import 'package:nuu_app/Providers/ListOwner_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'UberList.dart';
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
        'userId' : context.read<ListProvider>().userId,
        'anotherUserId': context.read<ListProvider>().anotherUserId,
        'reserved' : context.read<ListProvider>().reserved,
        'startingLocation': context.read<ListProvider>().startingLocation,
        'destination': context.read<ListProvider>().destination,
        'selectedDateTime': context.read<ListProvider>().selectedDateTime.toIso8601String(),
        'wantToFindRide': context.read<ListProvider>().wantToFindRide,
        'wantToOfferRide': context.read<ListProvider>().wantToOfferRide
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
      context.read<ListProvider>().setList(
        item.listId,
        item.userId,
        item.anotherUserId,
        item.reserved,
        item.startingLocation,
        item.destination,
        item.selectedDateTime,
        item.wantToFindRide,
        item.wantToOfferRide,
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
                const Text('建立者資訊: '),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
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
                        style: DefaultTextStyle.of(context).style,
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
                    style: DefaultTextStyle.of(context).style,
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
                    style: DefaultTextStyle.of(context).style,
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
                    children: [
                      const TextSpan(
                        text: '地點: ',
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                      TextSpan(
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        text: '從 ${item.startingLocation} 到 ${item.destination}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('出發時間: ${DateFormat('yyyy-MM-dd HH:mm').format(item.selectedDateTime)}'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<ListProvider>().setReserved(context.read<UserProvider>().userId, true);
                        editList(listId: item.listId);
                        Navigator.of(context).pop(true);
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

// class DetailsDialog extends StatefulWidget {
//   final UberItem item;
//   final VoidCallback? onItemAdded;
//
//   const DetailsDialog({Key? key, required this.item, this.onItemAdded}) : super(key: key);
//
//   @override
//   _DetailsDialogState createState() => _DetailsDialogState();
// }
//
// class _DetailsDialogState extends State<DetailsDialog> {
//
//   late ListProvider listProvider;
//   late ListOwnerProvider listOwnerProvider;
//   late UserProvider userProvider;
//
//
//   @override
//   void initState() {
//     super.initState();
//     listProvider = context.read<ListProvider>();
//     listOwnerProvider = context.read<ListOwnerProvider>();
//     userProvider = context.read<UserProvider>();
//     loadOwnerInfo();
//   }
//   Future<void> loadOwnerInfo() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://10.0.2.2:8800/api/users/user/${widget.item.userId}'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final ownerInfo = json.decode(response.body);
//         if (mounted) {
//           listOwnerProvider.setListOwnerInfo(
//             ownerInfo['username'],
//             widget.item.userId,
//             ownerInfo['email'],
//             ownerInfo['studentId'],
//             ownerInfo['Department'],
//             ownerInfo['Year'],
//             ownerInfo['gender'],
//             ownerInfo['phoneNumber'],
//           );
//         }
//       }
//     } catch (e) {
//       print('異常: $e');
//     }
//   }
//   Future<void> editList() async {
//     try {
//       final response = await http.put(
//         Uri.parse('http://10.0.2.2:8800/api/uberList/updatedList/${widget.item.listId}'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode({
//           'userId': listProvider.userId,
//           'anotherUserId': listProvider.anotherUserId,
//           'reserved': listProvider.reserved,
//           'startingLocation': listProvider.startingLocation,
//           'destination': listProvider.destination,
//           'selectedDateTime': listProvider.selectedDateTime.toIso8601String(),
//           'wantToFindRide': listProvider.wantToFindRide,
//           'wantToOfferRide': listProvider.wantToOfferRide,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final updatedUserData = jsonDecode(response.body);
//         print('預約成功: $updatedUserData');
//         Fluttertoast.showToast(
//           msg: "預約成功",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.blue,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       } else {
//         print('用户信息更新失败: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('異常: $e');
//     }
//   }
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('詳細資訊'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: SingleChildScrollView(
//             child:Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('詳細資訊', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),textAlign: TextAlign.center),
//             const SizedBox(height: 12),
//             const Text('建立者資訊: '),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     style: const TextStyle(
//                         color: Colors.black
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: '建立者: ',
//                       ),
//                       TextSpan(
//                         text: context.watch<ListOwnerProvider>().username,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 30),
//                 RichText(
//                   text: TextSpan(
//                     style: const TextStyle(
//                         color: Colors.black
//                     ),
//                     children: [
//                       const TextSpan(
//                         text: '性別: ',
//                       ),
//                       TextSpan(
//                         text: context.watch<ListOwnerProvider>().gender,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             RichText(
//               text: TextSpan(
//                 style: const TextStyle(
//                     color: Colors.black
//                 ),
//                 children: [
//                   const TextSpan(
//                     text: '學號: ',
//                   ),
//                   TextSpan(
//                     text: context.watch<ListOwnerProvider>().studentId,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             RichText(
//               text: TextSpan(
//                 style: const TextStyle(
//                     color: Colors.black
//                 ),
//                 children: [
//                   const TextSpan(
//                     text: '系所: ',
//                   ),
//                   TextSpan(
//                     text: context.watch<ListOwnerProvider>().department + context.watch<ListOwnerProvider>().year,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   const TextSpan(
//                     text: '地點: ',
//                     style: TextStyle(
//                         color: Colors.black
//                     ),
//                   ),
//                   TextSpan(
//                     style: const TextStyle(
//                         color: Colors.black
//                     ),
//                     text: '從 ${widget.item.startingLocation} 到 ${widget.item.destination}',
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text('出發時間: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.item.selectedDateTime)}'),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     listProvider.setReserved(userProvider.userId, true);
//                     editList();
//                     Navigator.of(context).pop(true);
//                   },
//                   child: const Text('預約搭乘'),
//                 ),
//                 const SizedBox(width: 30),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                   child: const Text('關閉'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         ),
//
//       ),
//
//     );
//   }
// }