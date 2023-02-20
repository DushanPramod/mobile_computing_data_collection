import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FillForm extends StatefulWidget {
  final String formId;

  const FillForm({Key? key, required this.formId}) : super(key: key);

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  String title = 'test title 1';
  String description =
      'Explicitly passing type arguments is an effective way to help identify type errors. For example, if you change the code to specify List as a type argument, the analyzer can detect the type mismatch in the constructor argument. Fix the error by providing a constructor argument of the appropriate type, such as a list literal:';

  List<InputTypeMdl> formInputFields = [
    InputTypeMdl(0, 'Name', 'text', ''),
    InputTypeMdl(1, 'Age', 'number', ''),
    InputTypeMdl(2, 'Birthday', 'date', ''),
    InputTypeMdl(3, 'Time', 'time', ''),
  ];

  Widget _buildTextInput(InputTypeMdl data) {
    return TextFormField(
      decoration: InputDecoration(labelText: data.fieldName),
      // maxLength: 150,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
      },
      onSaved: (value) {
        for (int i = 0; i < formInputFields.length; i++) {
          if (formInputFields[i].inputNo == data.inputNo) {
            formInputFields[i].data = value!;
          }
        }
      },
      onChanged: (value) {
        for (int i = 0; i < formInputFields.length; i++) {
          if (formInputFields[i].inputNo == data.inputNo) {
            formInputFields[i].data = value!;
          }
        }
      },
    );
  }

  Widget _buildNumberInput(InputTypeMdl data) {
    return TextFormField(
      decoration: InputDecoration(labelText: data.fieldName),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        }
      },
      onSaved: (value) {
        for (int i = 0; i < formInputFields.length; i++) {
          if (formInputFields[i].inputNo == data.inputNo) {
            formInputFields[i].data = value!;
          }
        }
      },
      onChanged: (value) {
        for (int i = 0; i < formInputFields.length; i++) {
          if (formInputFields[i].inputNo == data.inputNo) {
            formInputFields[i].data = value!;
          }
        }
      },
    );
  }

  Widget _buildDateInput(InputTypeMdl data) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFormField(
          initialValue: data.data != ''
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(data.data))
              : '',
          decoration: InputDecoration(
              labelText: data.fieldName,
              suffixIcon: Container(
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size(120, 40),
                    ),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: data.data != ''
                              ? DateTime.parse(data.data)
                              : DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (newDate == null) return;
                      setState(() => {
                        for (int i = 0; i < formInputFields.length; i++){
                          if (formInputFields[i].inputNo == data.inputNo){
                            formInputFields[i].data = newDate.toString()
                          }
                        }
                      });
                    },
                    child: const Text('Select Date')),
              )),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Required';
            }
          },
        ),
      ],
    ));
  }


  Widget _buildTimeInput(InputTypeMdl data) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              initialValue: data.data,
              decoration: InputDecoration(
                  labelText: data.fieldName,
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(120, 40),
                        ),
                        onPressed: () async {
                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: data.data != '' ?
                              TimeOfDay(hour: int.parse(data.data.split(':')[0]), minute: int.parse(data.data.split(':')[1]))
                                  :TimeOfDay.fromDateTime(DateTime.now()),
                          );
                          if (newTime == null) return;
                          setState(() => {
                            for (int i = 0; i < formInputFields.length; i++){
                              if (formInputFields[i].inputNo == data.inputNo){
                                formInputFields[i].data = '${newTime.hour}:${newTime.minute}'
                              }
                            }
                          });
                        },
                        child: const Text('Select Time')),
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required';
                }
              },
            ),
          ],
        ));
  }



  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(title: const Text('Form'), centerTitle: true),
        body: Container(
            margin: const EdgeInsets.all(24),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Text(description),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: formInputFields.map((e) {
                      if (e.dataType == 'text') {
                        return _buildTextInput(e);
                      } else if (e.dataType == 'number') {
                        return _buildNumberInput(e);
                      } else if (e.dataType == 'date') {
                        return _buildDateInput(e);
                      } else if (e.dataType == 'time') {
                        return _buildTimeInput(e);
                      } else {
                        return _buildTextInput(e);
                      }
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // submit();
                    }
                    _formKey.currentState!.save();
                  },
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                )
              ],
            ))));
  }
}

class InputTypeMdl {
  int inputNo;
  String fieldName;
  String dataType;
  String data;

  InputTypeMdl(this.inputNo, this.fieldName, this.dataType, this.data);
}
