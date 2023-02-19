import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_computing_data_collection/models/my-form.mdl.dart';

class MyForms extends StatefulWidget {
  const MyForms({Key? key}) : super(key: key);

  @override
  State<MyForms> createState() => _MyFormsState();
}

class _MyFormsState extends State<MyForms> {
  List<MyFormModel> myForms = [
    MyFormModel(
        id: '1',
        title: 'test 1',
        createdDate: DateTime.parse('2023-02-18 13:00:04Z'),
        numOfRecords: 5.toString()),
    MyFormModel(
        id: '1',
        title: 'test 2',
        createdDate: DateTime.parse('2023-02-18 13:01:04Z'),
        numOfRecords: 10.toString()),
    MyFormModel(
        id: '1',
        title: 'test 3',
        createdDate: DateTime.parse('2023-02-18 13:02:04Z'),
        numOfRecords: 20.toString()),
    MyFormModel(
        id: '1',
        title: 'test 4',
        createdDate: DateTime.parse('2023-02-18 13:03:04Z'),
        numOfRecords: 30.toString())
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children: myForms.map((e) {
          return Card(
              child: ListTile(
                  onTap: () {},
                  title: Text(e.title),
                  subtitle: Text(
                      DateFormat('yyyy-MM-dd-kk:mm').format(e.createdDate)),
                  leading: const Icon(Icons.my_library_books_rounded, size: 50),
                  trailing: Text(e.numOfRecords)));
        }).toList());
  }
}
