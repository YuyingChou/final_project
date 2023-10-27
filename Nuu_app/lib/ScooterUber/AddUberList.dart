import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddUberList extends StatefulWidget {
  const AddUberList({super.key});
  @override
  _AddUberListState createState() => _AddUberListState();
}

class _AddUberListState extends State<AddUberList> {
  DateTime selectedDateTime = DateTime.now();
  bool wantToFindRide = false;
  bool wantToOfferRide = false;

  TextEditingController startingLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Future<void> addUberList() async {
    final String startingLocation = startingLocationController.text;
    final String destination = destinationController.text;

    Future<http.Response> createAlbum(String startingLocation, String destination, DateTime selectedDateTime,bool wantToFindRide,bool wantToOfferRide) {
      const String apiUrl = 'http://10.0.2.2:8800/api/uberList/addUberList';

      final Map<String, dynamic> listData = {
        'startingLocation': startingLocation,
        'destination': destination,
        'selectedDateTime': selectedDateTime.toIso8601String(), // 將日期時間轉為 ISO 8601 字串格式
        'wantToFindRide': wantToFindRide,
        'wantToOfferRide': wantToOfferRide,
      };

      return http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(listData),
      );
    }
    try {
      // 調用 createAlbum 函數發送 POST 請求
      final response = await createAlbum(startingLocation, destination,selectedDateTime,wantToFindRide,wantToOfferRide);

      if (response.statusCode == 200) {
        // 註冊成功
        final jsonResponse = json.decode(response.body);
        print('上傳成功，清單 ID: ${jsonResponse['_id']}');
      } else {
        print('上傳失敗: ${response.body}');
      }
    } catch (e) {
      // 發生錯誤
      print('上傳失敗: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增共乘需求'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              style: const TextStyle(fontSize: 20),
              controller: startingLocationController,
              decoration: const InputDecoration(
                hintText: '出發地',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: const TextStyle(fontSize: 20),
              controller: destinationController,
              decoration: const InputDecoration(
                hintText: '目的地'
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('出發時間:',style: TextStyle(fontSize: 20)),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime),
                      style: const TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectDateTime(context);
                  },
                  child: const Text('選擇日期和時間',style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                const Text('我要',style: TextStyle(fontSize: 20)),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wantToFindRide = true;
                      wantToOfferRide = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(wantToFindRide ? Colors.lightBlue[200] : Colors.grey[300]),
                  ),
                  child: const Text('找車搭',style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wantToFindRide = false;
                      wantToOfferRide = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(wantToOfferRide ? Colors.lightBlue[200] : Colors.grey[300]),
                  ),
                  child: const Text('提供座位',style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            addUberList();
          },
          child: const Text('確定',style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateTime) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}
