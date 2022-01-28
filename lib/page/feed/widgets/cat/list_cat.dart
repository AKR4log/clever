// ignore_for_file: unused_local_variable

import 'package:clever/utils/mdls/app/cat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategories extends StatefulWidget {
  const ListCategories({Key key}) : super(key: key);

  @override
  _ListCategoriesState createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<ListCategories> {
  String category_status = '';

  @override
  Widget build(BuildContext context) {
    final cat = Provider.of<List<Cat>>(context);
    List cats = [];
    cat.forEach((element) {
      setState(() {
        cats.add(element);
      });
    });
    return cat.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : DropdownButtonFormField(
            value: category_status,
            onChanged: (value) {
              print(value);
              setState(() {
                category_status = value;
              });
            },
            items: cats.map((e) => DropdownMenuItem(
                  value: e.uid,
                  child: Text(e.name[0].toString()),
                )),
          );
  }
}
