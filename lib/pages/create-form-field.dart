import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> inputTypes = <String>[
  'text',
  'number',
  'date',
  'time',
  // 'location',
  'image',
  // 'audio',
  'video'
];

class InputTypeMdl {
  int number;
  String fieldName;
  String dataType;

  InputTypeMdl(this.number, this.fieldName, this.dataType);
}

class CreateFormField extends StatefulWidget {
  final String title;
  final String description;
  final int numberOfInputFields;

  CreateFormField(
      {Key? key,
      required this.title,
      required this.description,
      required this.numberOfInputFields})
      : super(key: key);

  @override
  State<CreateFormField> createState() => _CreateFormFieldState();
}

class _CreateFormFieldState extends State<CreateFormField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<InputTypeMdl> inputFieldData = [];

  Widget _buildInputField(InputTypeMdl e) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: 'Input ${e.number + 1}'),
          maxLength: 150,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Name for Input ${e.number + 1} is Required';
            }
          },
          onSaved: (value) {
            for (int i = 0; i < inputFieldData.length; i++) {
              if (inputFieldData[i].number == e.number) {
                inputFieldData[i].fieldName = value!;
              }
            }
          },
          onChanged: (value) {
            for (int i = 0; i < inputFieldData.length; i++) {
              if (inputFieldData[i].number == e.number) {
                inputFieldData[i].fieldName = value!;
              }
            }
          },
        ),

        DropdownButton<String>(
            value: e.dataType,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            // style: const TextStyle(color: Colors.deepPurple),
            // underline: Container(height: 2, width: double.infinity),
            onChanged: (String? value) {
              setState(() {
                for (int i = 0; i < inputFieldData.length; i++) {
                  if (inputFieldData[i].number == e.number) {
                    inputFieldData[i].dataType = value!;
                  }
                }
              });
            },
            items: inputTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList()),

        const SizedBox(height: 10)
      ],
    );
  }

  
  void submit (){
    String userId = FirebaseAuth.instance.currentUser!.uid;
     String title = widget.title;
     String description = widget.description;
     // int numberOfInputFields = widget.numberOfInputFields;
     FirebaseFirestore.instance
         .collection('forms_list')
         .add({
       'title': title,
       'description': description,
       'inputFields': inputFieldData.map((e) => {'dataType': e.dataType, 'fieldName': e.fieldName, 'inputNo': e.number}),
       'userId': userId,
       'createdDate': FieldValue.serverTimestamp(),
       'updatedDate': FieldValue.serverTimestamp()
     })
         .then((value) => print('Data added successfully'))
         .catchError((error) => print('Failed to add data: $error'));


     Navigator.pop(context);
     Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    if (inputFieldData.isEmpty) {
      for (int i = 0; i < widget.numberOfInputFields; i++) {
        inputFieldData.add(InputTypeMdl(i, '', 'text'));
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Form'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          child : SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: inputFieldData.map((e) => _buildInputField(e)).toList(),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submit();
                      }
                      _formKey.currentState!.save();
                    },
                    child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              )
          )
        ));
  }
}
