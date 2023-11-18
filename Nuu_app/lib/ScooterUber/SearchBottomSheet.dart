import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'UberList.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key? key, this.onItemSearch}) : super(key: key);

  final VoidCallback? onItemSearch;

  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();

}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  DateTime selectedDateTime = DateTime.now();
  bool wantToFindRide = false;
  bool wantToOfferRide = false;

  TextEditingController startingLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  bool wantToFindRideChecked = false;
  bool wantToOfferRideChecked = false;

  @override
  void initState() {
    super.initState();
    startingLocationController = TextEditingController();
    destinationController = TextEditingController();
  }

  Future<void> search() async {
    final String startingLocation = startingLocationController.text;
    final String destination = destinationController.text;

    Future<http.Response> searchList(
        String startingLocation,
        String destination,
        DateTime selectedDateTime,
        bool wantToFindRideChecked,
        bool wantToOfferRideChecked) {
      // 使用函數參數中的搜尋條件
      String apiUrl = 'http://10.0.2.2:8800/api/uberList/searchList?'
          'startingLocation=$startingLocation&'
          'destination=$destination&'
          'selectedDateTime=${selectedDateTime.toIso8601String()}&'
          'wantToFindRide=$wantToFindRideChecked&'
          'wantToOfferRide=$wantToOfferRideChecked';

      return http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }

    try {
      // 調用 searchList 函數發送 GET 請求
      final response = await searchList(startingLocation, destination,
          selectedDateTime, wantToFindRideChecked, wantToOfferRideChecked);


      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        print(data);

        UberListState? uberListState = UberList.uberListKey.currentState;
        if (uberListState != null) {
          uberListState?.updateSearchResults(
            data.map((json) {
              return UberItem.fromJson(json);
            }).toList(),
          );
        }
        widget.onItemSearch?.call();
      } else {
        print('搜尋失敗: ${response.body}');
      }
    } catch (e) {
      // 發生錯誤
      print('異常: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: startingLocationController,
                  decoration: const InputDecoration(
                    hintText: '出發地關鍵字',
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: destinationController,
                  decoration: const InputDecoration(
                    hintText: '目的地關鍵字',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text('出發時間:', style: TextStyle(fontSize: 20)),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _selectDateTime(context);
                  },
                  child: const Text('選擇日期和時間', style: TextStyle(fontSize: 20)),
                ),
              ),
              const Text("之後"),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              CheckboxForRide(
                onChanged: (value) {
                  setState(() {
                    wantToFindRideChecked = value!;
                    wantToOfferRideChecked = false;
                  });
                },
              ),
              const SizedBox(width: 16.0),
              const Text('我要找車搭乘', style: TextStyle(fontSize: 20)),
              CheckboxForRide(
                onChanged: (value) {
                  setState(() {
                    wantToOfferRideChecked = value!;
                    wantToFindRideChecked = false;
                  });
                },
              ),
              const SizedBox(width: 16.0),
              const Text('我要提供座位', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              search();
            },
            child: const Text('開始搜尋', style: TextStyle(fontSize: 20)),
          ),
        ],
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

class CheckboxForRide extends StatefulWidget {
  final ValueChanged<bool?> onChanged;

  const CheckboxForRide({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<CheckboxForRide> createState() => _CheckboxForRideState();
}

class _CheckboxForRideState extends State<CheckboxForRide> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
        widget.onChanged(value);
      },
    );
  }
}
