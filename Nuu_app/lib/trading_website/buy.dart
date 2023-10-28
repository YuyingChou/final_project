import 'package:flutter/material.dart';
import 'package:nuu_app/trading_website/data.dart';

final ValueNotifier<String> _msg = ValueNotifier('');
int a=0,b=0;
class buy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dynamic id = ModalRoute.of(context)!.settings.arguments;
    final appBar = AppBar(
      title: const Text('確認交易內容'),
      backgroundColor: Colors.blue,
    );
    b=newproduct[id].price;

    var text=const Text('選擇交易數量:',style: TextStyle(fontSize: 20),);
    final btnD=_Dropdownwidge(newproduct[id].number);
    var text1=const Text('單價: ',style: TextStyle(fontSize: 20),);
    var text2= Text("$b",style: TextStyle(fontSize: 20),);
    var text3=const Text('總金額: ',style: TextStyle(fontSize: 20),);
    final btn = ElevatedButton(
      child: const Text('確定'),
      onPressed: () => Navigator.pop(context),
    );

    final btn1 = ElevatedButton(
      child: const Text('取消'),
      onPressed: () => Navigator.pop(context),
    );

    final widget =
    Container(
      child: Column(
        children: [text,btnD,text1,text2,text3,_showMsg(context, _msg.value, null),
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
        )
      ])
    );

    final page = Scaffold(
      appBar: appBar,
      body: widget,
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
    );

    return page;
  }
}

class _Dropdownwidge extends StatefulWidget{
  final int id;
  _Dropdownwidge(this.id);

  @override
  State<StatefulWidget> createState() {
    return _Dropdownwidgestate();
  }
}
class _Dropdownwidgestate extends State<_Dropdownwidge> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> items = List.generate(widget.id, (index) {
      return DropdownMenuItem<int>(
        value: index + 1,
        child: Text((index + 1).toString(), style: TextStyle(fontSize: 20)),
      );
    });
    _msg.value='';

    return
        DropdownButton<int>(
          items: items,
          value: selectedValue,
          onChanged: (int? value) {
            setState(() {
              selectedValue = value;
              a=value!;
              _msg.value = (a*b).toString();
            });
          },
          hint: const Text('請選擇', style: TextStyle(fontSize: 20)),
        );
  }
}
Widget _showMsg(BuildContext context, String msg,Widget? child) {
  final widget = Text(msg,
      style: const TextStyle(fontSize: 20));
  return widget;
}