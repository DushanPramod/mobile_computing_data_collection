import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('submitted_form_list');
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: collection.where('userId', isEqualTo: userId).snapshots(),
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
              updatedDate: document.get('updatedDate')?.toDate()
          );
        }).toList();

        return Scaffold(
          body: ListView.builder(
            itemCount: myObjects.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {},
                  title: Text(myObjects[index].title),
                  subtitle: Text(DateFormat('yyyy-MM-dd-kk:mm').format(myObjects[index].updatedDate)),
                  leading: const Icon(Icons.upload_file, size: 50),
                ),
              );

            },
          ),

        );
      },
    );
  }
}



