import 'package:flutter/material.dart';
import 'package:nuu_app/ScooterUber/UberListPage/MyUberList.dart';
import 'allUberList.dart';

void main() {
  runApp(const UberList());
}

class UberList extends StatefulWidget {
  const UberList({super.key});

  @override
  _UberListState createState() => _UberListState();
}

class _UberListState extends State<UberList> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('共乘系統'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('所有清單'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('我的清單'),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                Container(
                  child: AllUberList(),
                ),
                // Use the updated AllUberList widget
                Container(
                  child: MyUberList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
