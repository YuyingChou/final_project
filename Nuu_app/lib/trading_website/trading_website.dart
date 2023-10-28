import 'dart:io';
import 'package:nuu_app/trading_website/additem.dart';
import 'package:nuu_app/trading_website/data.dart';
import 'package:nuu_app/trading_website/p1.dart';
import 'package:nuu_app/trading_website/p2.dart';
import 'package:nuu_app/trading_website/p3.dart';
import 'package:nuu_app/trading_website/buy.dart';
import 'package:flutter/material.dart';
import 'dart:async';

StreamController<List<product>> dataStreamController = StreamController<List<product>>.broadcast();

void main() {
  Timer.periodic(const Duration(seconds: 1), (Timer timer) {

    dataStreamController.sink.add(newproduct);
  });

  runApp(const trading_website());
}

class trading_website extends StatelessWidget {
  const trading_website({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var MyApp = MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) =>MyHomePage(),
        '/additem' :(context) => additem(),
        '/p1' :(context) => p1(),
        '/p2' :(context) => p2(),
        '/p3' :(context) => p3(),
        '/buy' :(context) => buy(),
      },
    );
    return MyApp;
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final ValueNotifier<String> _msg = ValueNotifier('');  // 要顯示的訊息

  _showdialog(context, index, dataList){
    int t = index;
    var dlg=AlertDialog(
      title:Text(dataList[index].name),
      content: Column(
        children: [
          Image.file(dataList[index].image,height: 100,width: 80,),
          Text("數量: ${dataList[index].number}\n類別: ${dataList[index].category}\n單價: ${dataList[index].price}\n可交易時間: ${dataList[index].time}\n交易地點: ${dataList[index].place}\n交易品敘述: ${dataList[index].other}"
          ),
        ],
      ),
      actions: [
        TextButton(
           onPressed: () {
             Navigator.pop(context); // Close the dialog
           },
           child: Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);// Close the dialog
            Navigator.pushNamed(context, '/buy', arguments: index);
          },
          child: Text('交易'),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (context) => dlg,
    );
  }

  Widget _data(context, index, dataList) {
    return Container(
       decoration: BoxDecoration(
        border:
        Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),

      child: Column(
        children: <Widget>[
          Image.file(dataList[index].image,height: 100,width: 80,),
          Text(
           "\n${dataList[index].name}\n類別: ${dataList[index].category}\n數量: ${dataList[index].number}  單價: ${dataList[index].price}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
          )
        ],
      )
    );
  }

  Widget _data1(context, index, dataList) {
    return Container(
        decoration: BoxDecoration(
            border:
            Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),

        child: Column(
          children: <Widget>[
            Image.file(dataList[index].image,height: 100,width: 80,),
            Text(
              "\n${dataList[index].name}\n數量: ${dataList[index].number}  單價: ${dataList[index].price}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawer = Drawer(
      child: ListView(
        children: <Widget> [
          const DrawerHeader(
            child: Text('個人專區', style: TextStyle(fontSize: 20),),
            decoration: BoxDecoration(
              color: Colors.blue,

            ),
          ),
          ListTile(
              title: const Text('個人資料', style: TextStyle(fontSize: 20),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/p1',);
              }
          ),
          ListTile(
              title: const Text('我的空間', style: TextStyle(fontSize: 20),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/p2',);
              }
          ),
          ListTile(
              title: const Text('通知', style: TextStyle(fontSize: 20),),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/p3',);
              }
          ),
        ],
      ),
    );

    final btn= ElevatedButton(
        child: const Text('上架', style: TextStyle(fontSize: 20, color: Colors.white),),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          elevation: 8,
        ),
        onPressed: () =>
            Navigator.pushNamed(context, '/additem',),
    );

    final btn1= ElevatedButton(
      child: const Text('+', style: TextStyle(fontSize: 20, color: Colors.white),),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        elevation: 8,
      ),
      onPressed: () =>
          Navigator.pushNamed(context, '/additem',),
    );

    // 建立AppBar
    final appBar = AppBar(
      title: const Text('二手物交易&代訂教科書平台'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
          child: Container(
            height: 48.0,alignment: Alignment.center,child: TabPageSelector(controller: _tabController),
          ),
        ),
      ),
    );


    final tabPag1=
        Container(
          child: Column(
            children: [
          StreamBuilder<List<product>>(
          stream: dataStreamController.stream,
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    padding:const EdgeInsets.all(8.0),
                    itemCount: snapshot.data?.length,
                    physics:const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder:(context,index) {
                      return GestureDetector(
                        onTap: () {
                          _showdialog(context, index, snapshot.data);
                        },
                        child: _data(context, index, snapshot.data),
                      );
                    },
                  );
                }
                else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
          ),
              Container(child: btn,alignment: Alignment.bottomRight,)],
          ),
        );


    final tabPag2=Container(child: btn1,alignment: Alignment.bottomRight,);

    final tabBarView= TabBarView(
        children: [tabPag1,tabPag2],physics: const BouncingScrollPhysics(),
        controller: _tabController,
    );
    
    final appHomePage = DefaultTabController(length: tabBarView.children.length, child: Scaffold(
      appBar: appBar,
      body: tabBarView,
      drawer: drawer,
      ),
    );

    return appHomePage;
  }

  Widget _showMsg(BuildContext context, String msg, Widget? child) {
    final widget = Text(msg,
        style: const TextStyle(fontSize: 20));
    return widget;
  }
}
