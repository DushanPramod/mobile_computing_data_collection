import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'create-form-field.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({Key? key}) : super(key: key);

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  String _title = '';
  String _description = '';
  int _numberOfInputFields = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitle() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Title'),
      maxLength: 150,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
      },
      onSaved: (value) {
        _title = value!;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Description'),
      maxLength: 500,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Description is Required';
        }
      },
      onSaved: (value) {
        _description = value!;
      },
    );
  }

  Widget _buildNumberOfInputFields() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Number of Input Fields'),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return 'Number of Input Fields is Required';
        }
        else if(int.parse(value)<1){
          return 'Number of Input Fields should be greater than 1';
        }
      },
      onSaved: (value) {
        if (!value!.isEmpty) {
          _numberOfInputFields = int.parse(value);
        }

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Form'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildTitle(),
                  _buildDescription(),
                  _buildNumberOfInputFields(),
                  const SizedBox(height: 50),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateFormField(
                                title: _title,
                                description: _description,
                                numberOfInputFields: _numberOfInputFields
                              ),
                            ));
                      }

                      _formKey.currentState!.save();
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
