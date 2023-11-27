import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nuu_app/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddUberList extends StatefulWidget {
  final VoidCallback? onItemAdded;

  const AddUberList({Key? key, this.onItemAdded}) : super(key: key);
  @override
  _AddUberListState createState() => _AddUberListState();
}

class _AddUberListState extends State<AddUberList> {
  DateTime selectedDateTime = DateTime.now();
  bool wantToFindRide = false;
  bool wantToOfferRide = false;

  TextEditingController startingLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  Future<void> addUberList() async {
    final String startingLocation = startingLocationController.text;
    final String destination = destinationController.text;
    final String notes = notesController.text;

    Future<http.Response> postList(String startingLocation, String destination, DateTime selectedDateTime,bool wantToFindRide,bool wantToOfferRide, String notes) {
      const String apiUrl = 'http://10.0.2.2:8800/api/uberList/addUberList';

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final Map<String, dynamic> listData = {
        'userId': userProvider.userId,
        'anotherUserId':'',
        'reserved':false,
        'startingLocation': startingLocation,
        'destination': destination,
        'selectedDateTime': selectedDateTime.toIso8601String(),
        'wantToFindRide': wantToFindRide,
        'wantToOfferRide': wantToOfferRide,
        'notes': notes,
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
      // 調用 postList 函數發送 POST 請求
      final response = await postList(startingLocation, destination, selectedDateTime, wantToFindRide, wantToOfferRide,notes);

      if (response.statusCode == 200) {
        // 上傳成功
        final jsonResponse = json.decode(response.body);
        print('上傳成功，清單 ID: ${jsonResponse['_id']}');
        if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                  '上傳成功!',
                  textAlign: TextAlign.center,
                  style: TextStyle( fontSize: 24),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      '回到介面',
                      textAlign: TextAlign.center,
                      style: TextStyle( fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true); //回到清單頁面
                    },
                  ),
                ],
              );
            },
          );

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
        child: SingleChildScrollView(
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
                      backgroundColor: MaterialStateProperty.all(wantToFindRide ? Colors.orangeAccent[200] : Colors.grey[300]),
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
                      backgroundColor: MaterialStateProperty.all(wantToOfferRide ? Colors.orangeAccent[200] : Colors.grey[300]),
                    ),
                    child: const Text('提供座位',style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                '備註:',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 100.0,
                child: Align(
                  alignment: Alignment.center,
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    controller: notesController,
                    decoration: const InputDecoration(
                      hintText: '請填入至多100字的備註，可能包括安全帽需求、行車習慣等',
                      hintMaxLines: 2,
                    ),
                    maxLines: null,
                  ),
                )
              ),
            ],
          ),
        )
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
    if (!context.mounted) return;
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
