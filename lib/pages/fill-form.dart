import 'package:flutter/material.dart';

class FillForm extends StatefulWidget {
  final String formId;
  const FillForm({Key? key, required this.formId}) : super(key: key);

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  String title = 'test title 1';
  String description = 'test description 1';

  List<InputTypeMdl> formInputFields = [
    InputTypeMdl(0, 'Name', 'text', ''),
    InputTypeMdl(1, 'Age', 'number', ''),
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
        centerTitle: true
      ),
        // body: Container(
        //   margin: const EdgeInsets.all(24),
        //   child: Form(
        //     key: _formKey,
        //     child: SingleChildScrollView(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: <Widget>[
        //           _buildTitle(),
        //           _buildDescription(),
        //           _buildNumberOfInputFields(),
        //           const SizedBox(height: 50),
        //           FilledButton(
        //             onPressed: () {
        //               if (_formKey.currentState!.validate()) {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (context) => CreateFormField(
        //                           title: _title,
        //                           description: _description,
        //                           numberOfInputFields: _numberOfInputFields
        //                       ),
        //                     ));
        //               }
        //
        //               _formKey.currentState!.save();
        //             },
        //             child: const Text(
        //               'Next',
        //               style: TextStyle(color: Colors.white, fontSize: 16),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // )
    );
  }
}

class InputTypeMdl {
  int inputNo;
  String fieldName;
  String dataType;
  String data;

  InputTypeMdl(this.inputNo, this.fieldName, this.dataType, this.data);
}