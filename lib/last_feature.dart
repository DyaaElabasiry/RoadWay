import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

class LastFeature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Items(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Last Feature'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<Items>(
              builder: (context,items,child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          items.addItem('Item 1');
                          print(items.items.length);
                        },
                        child: Text('Add Item')),
                    ...items.items.map((item) => Text(item)).toList(),
                  ],
                );
              }
            ),
            Consumer<Items>(
                builder: (context,items,child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            items.addItem('Item 1');
                            print(items.items.length);
                          },
                          child: Text('Add Item')),
                      ...items.items.map((item) => Text(item)).toList(),
                    ],
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}

class Items extends ChangeNotifier {
  List<String> items = [];

  void addItem(String item) {
    items.add(item);
    notifyListeners();
  }
}
