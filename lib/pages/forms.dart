import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_computing_data_collection/models/forms.mdl.dart';

class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  List<FormsModel> formsList = [
    FormsModel(
        id: '1',
        title: 'test 1',
        researcher: 'name 1',
        createdDate: DateTime.parse('2023-02-18 13:00:04Z')),
    FormsModel(
        id: '1',
        title: 'test 2',
        researcher: 'name 1',
        createdDate: DateTime.parse('2023-02-18 13:01:04Z')),
    FormsModel(
        id: '1',
        title: 'test 3',
        researcher: 'name 1',
        createdDate: DateTime.parse('2023-02-18 13:02:04Z')),
    FormsModel(
        id: '1',
        title: 'test 4',
        researcher: 'name 1',
        createdDate: DateTime.parse('2023-02-18 13:03:04Z'))
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children: formsList.map((e) {
          return Card(
              child: ListTile(
                onTap: () {},
                title: Text(e.title),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.researcher),
                    Text(DateFormat('yyyy-MM-dd-kk:mm').format(e.createdDate)),
                  ],
                ),
                leading: const Icon(Icons.book, size: 50),
                // trailing: Text(e.numOfRecords)
              ));
        }).toList());
  }
}
