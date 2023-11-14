import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuu_app/ScooterUber/AddUberList.dart';
import 'package:http/http.dart' as http;
import 'detail_dialog.dart';

void main() => runApp(const UberList());

class UberList extends StatefulWidget {
  const UberList({super.key});

  @override
  UberListState createState() => UberListState();
}

class UberListState extends State<UberList>{
  List<UberItem> uberList = [];

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> reloadList() async {
    List<UberItem> updatedList = await loadCards();
    //更新UI
    setState(() {
      uberList = updatedList;
    });
  }

  Future<List<UberItem>> loadCards() async {
    const String apiUrl= 'http://10.0.2.2:8800/api/uberList/getAllList';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'];

      uberList = data.map((json) {
        return UberItem.fromJson(json);
      }).toList();
      setState(() {
        uberList = uberList;
      });
      return uberList;
    } else {
      throw Exception('載入失敗');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('共乘系統'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUberList()),
              ).then((result) {
                if (result == true ){
                  reloadList();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: uberList.length,
        itemBuilder: (BuildContext context,int index){
          final item = uberList[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.directions_car),
              title: Text('從 ${item.startingLocation} 到 ${item.destination}'),
              subtitle: Text('${DateFormat('yyyy-MM-dd HH:mm').format(item.selectedDateTime)} 出發'),
              trailing: Text(
                item.wantToFindRide ? '找車搭乘' : '提供搭乘',
                style: TextStyle(
                color: item.wantToFindRide ? Colors.green[900] : Colors.lightBlue[900],
                fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (){
                showDetailsDialog(context, item);
              },
            ),
          );
        }
      )
    );
  }
}

class UberItem {
  final String userId;
  final String anotherUserId;
  final bool reserved;
  final String startingLocation;
  final String destination;
  final DateTime selectedDateTime;
  final bool wantToFindRide;
  final bool wantToOfferRide;

  UberItem({
    required this.userId,
    required this.anotherUserId,
    required this.reserved,
    required this.startingLocation,
    required this.destination,
    required this.selectedDateTime,
    required this.wantToFindRide,
    required this.wantToOfferRide,
  });
  factory UberItem.fromJson(Map<String, dynamic> json) {
    return UberItem(
      userId: json['userId'],
      anotherUserId: json['anotherUserId'],
      reserved: json['reserved'],
      startingLocation: json['startingLocation'],
      destination: json['destination'],
      selectedDateTime: DateTime.parse(json['selectedDateTime']),
      wantToFindRide: json['wantToFindRide'],
      wantToOfferRide: json['wantToOfferRide'],
    );
  }

}
