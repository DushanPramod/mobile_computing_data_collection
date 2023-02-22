import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/submitted-forms.mdl.dart';
import '../sqlite/data.mdl.dart';
import '../sqlite/database.dart';

class MyCustomObject {
  final String title;
  late DateTime updatedDate;

  MyCustomObject({required this.title, required this.updatedDate});
}

class SubmittedForms extends StatefulWidget {
  const SubmittedForms({Key? key}) : super(key: key);


  @override
  State<SubmittedForms> createState() => _SubmittedFormsState();
}

class _SubmittedFormsState extends State<SubmittedForms> {
  bool isLoading = false;
  late DB db;
  List<SubmittedFormModel> submittedForms = [];

  @override
  void initState() {
    super.initState();
    getFormData();

    db = DB();
  }

  void getFormData() async {
    setState(() => isLoading = true);
    dynamic submittedFormCollection = FirebaseFirestore.instance.collection('submitted_form_list').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await submittedFormCollection.get();
    final data = snapshot.docs;

    submittedForms.clear();
    List<DbFormMdl> localSavedForms = await db.getForms();
    for(int i=0;i<localSavedForms.length; i++){
      submittedForms.add(SubmittedFormModel(
          id: '',
        title: localSavedForms[i].title,
        researcher: '',
        formId: localSavedForms[i].formId,
        submittedDate: DateTime((localSavedForms[i].updatedDate ~/(1000 * 1000))),
        uploaded: false
      ));
      // print(localSavedForms[i].updatedDate);
    }

    setState(() {
      for(int i = 0; i < data.length; i++){
        submittedForms.add(SubmittedFormModel(
            id:data[i].id,
            formId:data[i].data()['formId'],
            researcher: '',
            title: data[i].data()['title'],
            submittedDate:data[i].data()['updatedDate'].toDate(),
          uploaded: true
        ));
      }
      submittedForms.sort((a, b) => b.submittedDate.compareTo(a.submittedDate));
      isLoading = false;
    });
  }

  void submit() async {

  }


  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('submitted_form_list');
    String userId = FirebaseAuth.instance.currentUser!.uid;


    return isLoading == true ? const Center(child: CircularProgressIndicator()): ListView(
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
                    // Text(e.researcher),
                    Text(DateFormat('yyyy-MM-dd-kk:mm').format(e.submittedDate)),
                  ],
                ),
                leading: const Icon(Icons.upload_file, size: 50),
                trailing: IconButton(
                  iconSize: 25,
                  icon: e.uploaded == true ? const Icon(Icons.check_circle_outline_rounded, color: Colors.green)
                      :const Icon(Icons.upload, color: Colors.red),
                  onPressed: () {

                  },
                )
              ));
        }).toList());
  }
}



