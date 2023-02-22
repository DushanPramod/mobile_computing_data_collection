import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCustomObject {
  final String title;
  late DateTime createdDate;

  MyCustomObject({required this.title, required this.createdDate});
}

class MyForms extends StatefulWidget {
  const MyForms({Key? key}) : super(key: key);


  @override
  State<MyForms> createState() => _MyFormsState();
}

class _MyFormsState extends State<MyForms> {
  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('forms_list');
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

        List<MyCustomObject> myObjects = snapshot.data!.docs.map((DocumentSnapshot document){
          return MyCustomObject(
              title: document.get('title'),
              createdDate: document.get('createdDate') == null ? DateTime.now() : document.get('createdDate')?.toDate()
          );
        }).toList();

        myObjects.sort((a, b) => b.createdDate.compareTo(a.createdDate));

        return Scaffold(
          body: ListView.builder(
            itemCount: myObjects.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyForms(formId: myObjects[index].formId)));
                  },
                  title: Text(myObjects[index].title),
                  subtitle: Text(DateFormat('yyyy-MM-dd-kk:mm').format(myObjects[index].createdDate)),
                  leading: const Icon(Icons.my_library_books_rounded, size: 50),
                  // trailing: Text(myObjects[index].filledCount.toString()),
                ),
              );

            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create-form');
            },
            tooltip: 'Add new form',
            child: const Icon(Icons.add),
          ),

        );
      },
    );
  }
}



