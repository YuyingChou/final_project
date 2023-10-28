import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(RentApp());
}

class RentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '租屋分享',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/home': (context) => HomePage(),
        '/roommate': (context) => RoommatePage(),
      },
    );
  }
}

class RentItem {
  final String roomType;
  final String title;
  final String location;
  final String price;
  final String landlordName;
  final String landlordContact;
  final String expectedEndDate;
  final double rating;
  final File? image;
  final List<String> facilities;

  RentItem({
    required this.roomType,
    required this.title,
    required this.location,
    required this.price,
    required this.landlordName,
    required this.landlordContact,
    required this.expectedEndDate,
    required this.rating,
    this.image,
    required this.facilities,
  });

  factory RentItem.fromJson(Map<String, dynamic> json) {
    List<int> bytes = base64Decode(json['image']);
    return RentItem(
      roomType: json['roomType'],
      title: json['title'],
      location: json['location'],
      price: json['price'],
      landlordName: json['landlordName'],
      landlordContact: json['landlordContact'],
      expectedEndDate: json['expectedEndDate'],
      rating: json['rating'].toDouble(),
      image:
      bytes.isNotEmpty ? File.fromRawPath(Uint8List.fromList(bytes)) : null,
      facilities: List<String>.from(json['facilities']),
    );
  }

  // 新增 toJson 方法以將 RentItem 轉換為 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'roomType': roomType,
      'title': title,
      'location': location,
      'price': price,
      'landlordName': landlordName,
      'landlordContact': landlordContact,
      'expectedEndDate': expectedEndDate,
      'rating': rating,
      'image': image != null ? base64Encode(image!.readAsBytesSync()) : null,
      'facilities': facilities,
    };
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主介面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '主介面',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Text('進入租屋分享'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/roommate');
              },
              child: Text('進入合租頁面'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RentItem> rentItems = [];
  List<RentItem> filteredRentItems = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  Future<void> _handleRefresh() async {
    // 模拟刷新操作
    await Future.delayed(Duration(seconds: 2));

    // 重新获取数据等
    await getRentItems();

    // 通知 Flutter 刷新页面
    setState(() {});
  }

  Future<void> getRentItems() async {
    final url = 'http://10.0.2.2:8800/api/Info/getRentItems'; // 替换成你的后端API的URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 请求成功，解析响应数据
      final List<dynamic> data = jsonDecode(response.body);
      final List<RentItem> rentItems =
      data.map((item) => RentItem.fromJson(item)).toList();

      setState(() {
        this.rentItems = rentItems;
        filteredRentItems = rentItems;
      });
    } else {
      // 请求失败，处理错误
      // 可以添加错误处理逻辑或显示错误消息
    }
  }

  final TextEditingController searchController = TextEditingController();
  String selectedRoomTypeFilter = '';
  List<String> selectedFacilities = [];

  final List<String> roomFacilityOptions = [
    '洗衣機',
    '陽台',
    '冷氣',
    '冰箱',
    '網路',
    '床',
    '衣櫃',
    '熱水器',
    '機車位',
    '汽車位',
  ];

  @override
  void initState() {
    super.initState();
    getRentItems();
  }

  void addRentItem(RentItem rentItem) {
    setState(() {
      rentItems.add(rentItem);
      filterRentItems(searchController.text);
      // 新增以下程式碼來將資料傳送至後端
      postRentItemToBackend(rentItem);
    });
  }

  void filterRentItems(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredRentItems = rentItems.where((rentItem) {
        final roomType = rentItem.roomType.toLowerCase();
        final title = rentItem.title.toLowerCase();
        final location = rentItem.location.toLowerCase();
        return (roomType.contains(selectedRoomTypeFilter.toLowerCase()) ||
            selectedRoomTypeFilter.isEmpty) &&
            (title.contains(lowerCaseQuery) ||
                location.contains(lowerCaseQuery)) &&
            selectedFacilities
                .every((facility) => rentItem.facilities.contains(facility));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('租屋分享'),
        actions: [
          DropdownButton<String>(
            value: selectedRoomTypeFilter,
            onChanged: (newValue) {
              setState(() {
                selectedRoomTypeFilter = newValue!;
                filterRentItems(searchController.text);
              });
            },
            items: <String>['', '套房', '雅房']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.isEmpty ? '所有房型' : value),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddRentItemPage(
                        addRentItem: addRentItem,
                        roomFacilityOptions: roomFacilityOptions,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: '搜尋租屋',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            filterRentItems('');
                          },
                        ),
                      ),
                      onChanged: (query) {
                        filterRentItems(query);
                      },
                    ),
                    SizedBox(height: 16.0),
                    MultiSelectChip(
                      facilityOptions: roomFacilityOptions,
                      selectedFacilities: selectedFacilities,
                      onSelectionChanged: (selectedFacilities) {
                        setState(() {
                          this.selectedFacilities = selectedFacilities;
                          filterRentItems(searchController.text);
                        });
                      },
                    ),
                    for (var rentItem in filteredRentItems)
                      RentItemCard(rentItem: rentItem),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 新增函數來將資料傳送至後端
Future<void> postRentItemToBackend(RentItem rentItem) async {
  final url = 'http://10.0.2.2:8800/api/Info/publishHouse'; // 替換成你的後端API的URL
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(rentItem.toJson()), // 將RentItem轉換為JSON格式
  );

  if (response.statusCode == 200) {
    // 資料已成功儲存到後端資料庫
    // 可以添加一些處理成功的邏輯或顯示成功消息
  } else {
    // 請求失敗，處理錯誤
    // 可以添加錯誤處理邏輯或顯示錯誤消息
  }
}

class RentItemCard extends StatelessWidget {
  final RentItem rentItem;

  RentItemCard({Key? key, required this.rentItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(rentItem.title),
        subtitle: Text(rentItem.location),
        trailing: Text('\$${rentItem.price}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RentItemDetailsPage(rentItem: rentItem),
            ),
          );
        },
        leading: rentItem.image != null ? Image.file(rentItem.image!) : null,
      ),
    );
  }
}

class RentItemDetailsPage extends StatelessWidget {
  final RentItem rentItem;

  RentItemDetailsPage({required this.rentItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('租屋詳細資訊'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '房型：${rentItem.roomType}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('地址：${rentItem.location}'),
            SizedBox(height: 8.0),
            Text('價格(月)：${rentItem.price}'),
            SizedBox(height: 8.0),
            Text('房東姓名：${rentItem.landlordName}'),
            SizedBox(height: 8.0),
            Text('房東連絡電話：${rentItem.landlordContact}'),
            SizedBox(height: 8.0),
            Text('預計退租日期：${rentItem.expectedEndDate}'),
            SizedBox(height: 8.0),
            Text('評分：${rentItem.rating.toStringAsFixed(1)}'),
            SizedBox(height: 16.0),
            if (rentItem.image != null) Image.file(rentItem.image!),
          ],
        ),
      ),
    );
  }
}

class AddRentItemPage extends StatefulWidget {
  final Function(RentItem) addRentItem;
  final List<String> roomFacilityOptions;

  AddRentItemPage({
    required this.addRentItem,
    required this.roomFacilityOptions,
  });

  @override
  _AddRentItemPageState createState() => _AddRentItemPageState();
}

class _AddRentItemPageState extends State<AddRentItemPage> {
  String selectedRoomType = '套房';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController landlordNameController = TextEditingController();
  final TextEditingController landlordContactController =
  TextEditingController();
  final TextEditingController expectedEndDateController =
  TextEditingController();
  double rating = 0.0;
  File? selectedImage;
  List<String> selectedFacilities = [];

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分享自己的租屋處'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedRoomType,
                onChanged: (newValue) {
                  setState(() {
                    selectedRoomType = newValue!;
                  });
                },
                items: <String>['套房', '雅房']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '標題'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: '地址'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: '價格(月)'),
              ),
              TextField(
                controller: landlordNameController,
                decoration: InputDecoration(labelText: '房東姓名'),
              ),
              TextField(
                controller: landlordContactController,
                decoration: InputDecoration(labelText: '房東連絡電話'),
              ),
              TextField(
                controller: expectedEndDateController,
                decoration: InputDecoration(labelText: '預計退租日期 (YYYY/MM/DD)'),
              ),
              SizedBox(height: 16.0),
              Text(
                '評分： ${rating.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 16.0),
              ),
              Slider(
                value: rating,
                onChanged: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
                min: 0.0,
                max: 5.0,
                divisions: 10,
                label: rating.toStringAsFixed(1),
              ),
              SizedBox(height: 16.0),
              MultiSelectChip(
                facilityOptions: widget.roomFacilityOptions,
                selectedFacilities: selectedFacilities,
                onSelectionChanged: (selectedFacilities) {
                  setState(() {
                    this.selectedFacilities = selectedFacilities;
                  });
                },
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: selectedImage != null
                      ? Image.file(selectedImage!, fit: BoxFit.cover)
                      : Icon(Icons.add_a_photo, color: Colors.grey),
                ),
              ),
              ElevatedButton(
                child: Text('發布'),
                onPressed: () {
                  if (_areFieldsValid()) {
                    final rentItem = RentItem(
                      roomType: selectedRoomType,
                      title: titleController.text,
                      location: locationController.text,
                      price: priceController.text,
                      landlordName: landlordNameController.text,
                      landlordContact: landlordContactController.text,
                      expectedEndDate: expectedEndDateController.text,
                      rating: rating,
                      image: selectedImage,
                      facilities: selectedFacilities,
                    );

                    widget.addRentItem(rentItem);

                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('錯誤'),
                          content: Text('請填寫所有必填項目。'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('確定'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _areFieldsValid() {
    return titleController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        landlordNameController.text.isNotEmpty &&
        landlordContactController.text.isNotEmpty &&
        expectedEndDateController.text.isNotEmpty;
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> facilityOptions;
  final Function(List<String>) onSelectionChanged;
  final List<String> selectedFacilities;

  MultiSelectChip({
    required this.facilityOptions,
    required this.onSelectionChanged,
    required this.selectedFacilities,
  });

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var facility in widget.facilityOptions)
          ChoiceChip(
            label: Text(facility),
            selected: widget.selectedFacilities.contains(facility),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  widget.selectedFacilities.add(facility);
                } else {
                  widget.selectedFacilities.remove(facility);
                }
                widget.onSelectionChanged(widget.selectedFacilities);
              });
            },
          ),
      ],
    );
  }
}

class RoommatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('合租頁面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '合租頁面',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('返回主頁'),
            ),
          ],
        ),
      ),
    );
  }
}
