import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_computing_data_collection/pages/fill-form.dart';

class MyCustomObject {
  final String title;
  late DateTime createdDate;
  final String formId;

  MyCustomObject({required this.title, required this.createdDate, required this.formId});
}

class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);


  @override
  State<Forms> createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('forms_list');
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: collection.where('userId', isNotEqualTo: userId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<MyCustomObject> myObjects = snapshot.data!.docs.map((DocumentSnapshot document) {
          return MyCustomObject(
              title: document.get('title'),
              createdDate: document.get('createdDate')?.toDate(),
              formId: document.id
          );
        }).toList();

        return Scaffold(
          body: ListView.builder(
            itemCount: myObjects.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FillForm(formId: myObjects[index].formId)));
                  },
                  title: Text(myObjects[index].title),
                  subtitle: Text(DateFormat('yyyy-MM-dd-kk:mm').format(myObjects[index].createdDate)),
                  leading: const Icon(Icons.book, size: 50),
                ),
              );

            },
          ),
        );
      },
    );
  }
}



