import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ex/trading_website/data.dart';
String selectedCategory = '';

class additem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<additem> {

  final ValueNotifier<XFile?> _imageFile = ValueNotifier(null);
  final ImagePicker _imagePicker = ImagePicker();
  late String name1;
  late int number1;
  late int price1;
  late String time1;
  late String place1;
  late String other1;
  late File image1;

  List<DateTime> selectedDateTimes = [];

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDateTimes.add(selectedDateTime);
          time1 = selectedDateTime.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 建立AppBar
    final appBar = AppBar(
      title: const Text('上架交易品資訊'),
      backgroundColor: Colors.blue,
    );

    final btnD=_Dropdownwidge();
    final nameController = TextEditingController();
    final name= TextField(
        controller: nameController,
        decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0, // 设置边框宽度
          ),
        ),
      labelText: '交易品名稱',
      labelStyle: TextStyle(fontSize: 20),
    ),
    );

    var text1=const Text('類別:',style: TextStyle(fontSize: 20),);
    final numController = TextEditingController();
    final number= TextField(
      controller: numController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0, // 设置边框宽度
          ),
        ),
        labelText: '數量',
        labelStyle: TextStyle(fontSize: 20),
      ),
    );

    final priceController = TextEditingController();
    final price= TextField(
      controller: priceController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0, // 设置边框宽度
          ),
        ),
        labelText: '單價',
        labelStyle: TextStyle(fontSize: 20),
      ),
    );

    final placeController = TextEditingController();
    final place= TextField(
      controller: placeController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0, // 设置边框宽度
          ),
        ),
        labelText: '交易地點',
        labelStyle: TextStyle(fontSize: 20),
      ),
    );

    final timeController = TextEditingController();
    final time= TextField(
      controller: timeController,
      decoration: const InputDecoration(
        labelText: '可交易時間:',
        labelStyle: TextStyle(fontSize: 20),
      ),
    );

    final otherController = TextEditingController();
    final other= TextField(
      controller: otherController,
      maxLines: null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0, // 设置边框宽度
          ),
        ),
        labelText: '輸入交易品敘述',
        labelStyle: TextStyle(fontSize: 20),
      ),
    );

    File? imagePath=null;
    Future<void> _getImage(ImageSource imageSource) async {
      XFile? imgFile = await _imagePicker.pickImage(source: imageSource);
      if (imgFile!=null){
        _imageFile.value = imgFile;
        imagePath=File(imgFile.path);
      }
      else {
        imagePath = null;
      }
    }

    final btnCameraImage = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        '相機拍照',
        style: TextStyle( color: Colors.white,),
      ),
      onPressed: () => _getImage(ImageSource.camera),
    );

    final btnGalleryImage = ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        '挑選相簿照片',
        style: TextStyle( color: Colors.white,),
      ),
      onPressed: () => _getImage(ImageSource.gallery),
    );

    var text=const Text('圖片:');
    final btn = ElevatedButton(
      child: const Text('確定'),
      onPressed: () {
        Navigator.pop(context);
        name1=nameController.text;
        number1=int.parse(numController.text);
        price1=int.parse(priceController.text);
        time1=timeController.text;
        place1=placeController.text;
        other1=otherController.text;
        image1= imagePath ?? File('default_image_path.jpg');
        addproduct(name1, selectedCategory, number1, price1,time1,place1,other1,image1 );
      }
    );

    final btn1 = ElevatedButton(
      child: const Text('取消'),
      onPressed: () => Navigator.pop(context),
    );

    final btnt = ElevatedButton(
      child: const Text('+'),
      onPressed: _pickDateTime,
    );

    Widget _imageBuilder(BuildContext context, XFile? imageFile, Widget? child) {
      final wid = imageFile == null ?
      const Text('沒有照片')://style: TextStyle(fontSize: 20),) :
      Image.file(File(imageFile.path), fit: BoxFit.contain,);
      return wid;
    }
   // 建立App的操作畫面
    final widget =Container(
      height:1000,
      child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: name,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: text1,
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: btnD,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.all(5),
                              child: time,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.all(5),
                              child: price,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: time,
                            ),
                          Expanded(
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.all(5),
                              child: price,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: place,width: 400,margin: const EdgeInsets.all(10),
                    ),
                    Container(
                      child: other,width: 600,padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    )
                  ],
                ),
              ),
              Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: text,width: 60,margin: const EdgeInsets.all(5),
                        ),
                      ),
                      Container(
                          child: Column(
                            children: [Container(
                              child: btnCameraImage,
                              margin: const EdgeInsets.all(5),
                            ),
                              Container(
                                child: btnGalleryImage,
                                margin: const EdgeInsets.all(5),
                              ),
                            ],
                          )
                      ),
                      Expanded(
                        child: ValueListenableBuilder<XFile?>(
                          builder: _imageBuilder,
                          valueListenable: _imageFile,
                        ),
                      )
                    ],
                  )
              ),
              Container(
                  child: Row(
                    children: [
                      Container(
                        child: btn1,margin: const EdgeInsets.all(8),
                      ),
                      Expanded(
                        child:Container(
                            child: btn,alignment: Alignment.bottomRight,margin: const EdgeInsets.all(8),
                          )
                      )
                    ],
                  )
              ),
              //Container(
              //  child: btnt,margin: const EdgeInsets.all(8),
              //),
              //Expanded(
              //  child: selectedDateTimes.isEmpty
              //  ? Center(
              //  child: Text('没有可显示的日期时间。'),
              //  )
              //    : ListView.builder(
              //    shrinkWrap: true,
              //    itemCount: selectedDateTimes.length,
              //    itemBuilder: (context, index) {
               //     return ListTile(
               //       title: Text(selectedDateTimes[index].toString()),
                //    );
                  //},
                //),
              //),
            ],
          )
      )
    );

    //final wid
    // 結合AppBar和App操作畫面
    final page = Scaffold(
      appBar: appBar,
      body: widget,
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
    );

    return page;
  }
}

class _Dropdownwidge extends StatefulWidget{
  @override
  _Dropdownwidgestate createState() => _Dropdownwidgestate();
}
class _Dropdownwidgestate extends State<_Dropdownwidge> {

  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    final btn = DropdownButton(
      items: const <DropdownMenuItem> [
        DropdownMenuItem(
          child:  Text('書籍', style: TextStyle(fontSize: 20),),
          value: 1,
        ),
        DropdownMenuItem(
          child:  Text('生活用品', style: TextStyle(fontSize: 20),),
          value: 2,
        ),
        DropdownMenuItem(
          child:  Text('電子產品', style: TextStyle(fontSize: 20),),
          value: 3,
        ),
        DropdownMenuItem(
          child:  Text('其他', style: TextStyle(fontSize: 20),),
          value: 4,
        )
      ],
      onChanged: (dynamic value) {
        setState(() {
          selectedValue = value as int;
          selectedCategory = getCategory(value);
        });
      },

      hint: const Text('請選擇', style: TextStyle(fontSize: 20),),
      value: selectedValue,
    );

    return btn;
  }
  String getCategory(value) {
    if (value == 1) {
      return '書籍';
    } else if (value == 2) {
      return '生活用品';
    } else if (value == 3) {
      return '電子產品';
    } else {
      return '其他';
    }
  }
}