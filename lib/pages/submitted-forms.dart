import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_computing_data_collection/models/submitted-forms.mdl.dart';

class SubmittedForms extends StatefulWidget {
  const SubmittedForms({Key? key}) : super(key: key);

  @override
  State<SubmittedForms> createState() => _SubmittedFormsState();
}

class _SubmittedFormsState extends State<SubmittedForms> {
  List<SubmittedFormModel> submittedForms = [
    SubmittedFormModel(
        id: '1',
        title: 'test 1',
        researcher: 'name 1',
        submittedDate: DateTime.parse('2023-02-18 13:00:04Z')),
    SubmittedFormModel(
        id: '1',
        title: 'test 2',
        researcher: 'name 1',
        submittedDate: DateTime.parse('2023-02-18 13:01:04Z')),
    SubmittedFormModel(
        id: '1',
        title: 'test 3',
        researcher: 'name 1',
        submittedDate: DateTime.parse('2023-02-18 13:02:04Z')),
    SubmittedFormModel(
        id: '1',
        title: 'test 4',
        researcher: 'name 1',
        submittedDate: DateTime.parse('2023-02-18 13:03:04Z'))
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children: submittedForms.map((e) {
          return Card(
              child: ListTile(
            onTap: () {},
            title: Text(e.title),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.researcher),
                Text(DateFormat('yyyy-MM-dd-kk:mm').format(e.submittedDate)),
              ],
            ),
            leading: const Icon(Icons.upload_file, size: 50),
            // trailing: Text(e.numOfRecords)
          ));
        }).toList());
  }
}
