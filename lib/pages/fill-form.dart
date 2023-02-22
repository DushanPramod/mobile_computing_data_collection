import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_computing_data_collection/sqlite/data.mdl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uuid/uuid.dart';

import '../sqlite/database.dart';

class FillForm extends StatefulWidget {
  final String formId;

  const FillForm({Key? key, required this.formId}) : super(key: key);

  @override
  State<FillForm> createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  late DB db;

  String title = '';
  String description = '';
  bool isLoading = false;

  List<InputTypeMdl> formInputFields = [
    // InputTypeMdl(0, 'Name', 'text', ''),
    // InputTypeMdl(1, 'Age', 'number', ''),
    // InputTypeMdl(2, 'Birthday', 'date', ''),
    // InputTypeMdl(3, 'Time', 'time', ''),
    // InputTypeMdl(4, 'Image', 'image', ''),
    // InputTypeMdl(5, 'Video', 'video', ''),
    // InputTypeMdl(6, 'Audio', 'audio', ''),
  ];

  @override
  void initState() {
    super.initState();
    getFormData();

    db = DB();
  }

  void getFormData() async {
    setState(() => isLoading = true);

    CollectionReference form = FirebaseFirestore.instance.collection('forms_list');
    final snapshot = await form.doc(widget.formId).get();
    final data = snapshot.data() as Map<String, dynamic>;

    setState(() {
      formInputFields.clear();
      title = data['title'];
      description = data['description'];
      for(int i = 0; i < data['inputFields'].length; i++){
        formInputFields.add(InputTypeMdl(data['inputFields'][i]['inputNo'], data['inputFields'][i]['fieldName'], data['inputFields'][i]['dataType'], ''));
      }
      isLoading = false;
    });

  }

  Widget _buildTextInput(InputTypeMdl data) {
    return TextFormField(
      initialValue: data.data,
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
      initialValue: data.data,
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
            enabled: true,
              helperText: 'yyyy-mm-dd',
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
                  enabled: true,
                  helperText: 'HH:mm',
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

  // XFile? imageFile;
  // XFile? videoFile;
  void _openGallery(BuildContext context, InputTypeMdl data) async {
    dynamic file;
    if(data.dataType == 'image'){
      file = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    else{
      file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    }

    setState(() {
      for (int i = 0; i < formInputFields.length; i++) {
        if (formInputFields[i].inputNo == data.inputNo) {
          formInputFields[i].data = file;
        }
      }
    });

    if (context.mounted) Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context, InputTypeMdl data) async {
    dynamic file;
    if(data.dataType == 'image'){
      file = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    else{
      file = await ImagePicker().pickVideo(source: ImageSource.camera);
    }

    setState(() {
      for (int i = 0; i < formInputFields.length; i++) {
        if (formInputFields[i].inputNo == data.inputNo) {
          formInputFields[i].data = file;
        }
      }
    });

    if (context.mounted) Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  Widget _buildImageInput(InputTypeMdl data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.fieldName, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
            ElevatedButton(onPressed: () {
              _showChoiceDialog(context, data);
            }, child: const Text('Select Image'))
          ],
        ),
        (data.data == null || data.data == '') ? const Text('No Image Selected') : Image.file(File(data.data!.path), width: 200, height: 200),
        const SizedBox(height: 5)
      ],
    );
  }

  Widget _buildVideoInput(InputTypeMdl data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(data.fieldName, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
            ElevatedButton(onPressed: () {
              _showChoiceDialog(context, data);
            }, child: const Text('Select Video'))
          ],
        ),


        (data.data == null || data.data == '')?const Text('No Image Selected') : Container(
          color: Colors.brown,
          height: MediaQuery.of(context).size.height * (100/100),
          width: MediaQuery.of(context).size.width *  (100/100),
          child: (data.data == null || data.data == '')?const Center(
            child: Icon(Icons.videocam, color: Colors.red, size: 50.0),
          ):FittedBox(
            fit: BoxFit.contain,
            child: mounted?Chewie(
              controller: ChewieController(
                  videoPlayerController: VideoPlayerController.file(File(data.data!.path)),
                  aspectRatio: 0.7,
                  autoPlay: false,
                  looping: false
              ),
            ):Container(),
          ),
        ),
      ],
    );
  }

  Future<void> _showChoiceDialog(context, InputTypeMdl data) {
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Choose'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: const Text('Gallery'),
                onTap: (){
                  _openGallery(context,data);
                },
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: const Text('Camera'),
                onTap: (){
                  _openCamera(context,data);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAudioInput(InputTypeMdl data) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(6.0),
            side: const BorderSide(
              color: Colors.red,
              width: 4.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            primary: Colors.white,
            elevation: 9.0,
          ),
          onPressed: () {},
          icon: Icon(Icons.mic, color: Colors.red, size: 38.0),
          label: Text(''),
        ),

        SizedBox(width: 30),

        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(6.0),
            side: const BorderSide(
              color: Colors.red,
              width: 4.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            primary: Colors.white,
            elevation: 9.0,
          ),
          onPressed: () {},
          icon: Icon(Icons.stop, color: Colors.red, size: 38.0),
          label: Text(''),
        )
      ],
    );
  }

  Future uploadFile(InputTypeMdl data) async {
    if(data.data == null) return;
    if(data.dataType != 'image' && data.dataType != 'video') return;

    FirebaseStorage storage = FirebaseStorage.instance;
    String fileRefStr = '${data.dataType}/${const Uuid().v4()}';
    Reference ref = storage.ref().child(fileRefStr);
    await ref.putFile(File(data.data!.path));

    return fileRefStr;
  }

  Future uploadFile2(File data) async {

    FirebaseStorage storage = FirebaseStorage.instance;
    String fileRefStr = const Uuid().v4();
    Reference ref = storage.ref().child(fileRefStr);
    await ref.putFile(data);
    return fileRefStr;
  }

  void submit () async {
    if((await InternetConnectionChecker().hasConnection) == true) {
      print('YAY! Free cute dog pics!');

      for(int i = 0; i < formInputFields.length; i++){
        if(formInputFields[i].dataType == 'image' || formInputFields[i].dataType == 'video'){
          String refString = await uploadFile(formInputFields[i]);
          formInputFields[i].data = refString;
        }
      }

      Map<String, String> data = {};
      for(int i = 0; i < formInputFields.length; i++){
        data.addAll({formInputFields[i].fieldName:formInputFields[i].data});
      }

      String userId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection('submitted_form_list')
          .add({
        'title': title,
        'data': data,
        'formId': widget.formId,
        'userId': userId,
        'createdDate': FieldValue.serverTimestamp(),
        'updatedDate': FieldValue.serverTimestamp()
      }).then((value) {
        print('Data added successfully');
        Navigator.pop(context);
      }).catchError((error) => print('Failed to add data: $error'));
    } else {
      print('No internet :( Reason:');

      List<DbFormMdl> localFormList = await db.getForms();
      int maxId = localFormList.isEmpty? 0 : localFormList.map((e) => e.id).toList().reduce(max);
      await db.insertForm(DbFormMdl(
          id:maxId+1 ,
          formId: widget.formId,
          title: title,
          userId: FirebaseAuth.instance.currentUser!.uid,
          createdDate: FieldValue.serverTimestamp().toString(),
          updatedDate: FieldValue.serverTimestamp().toString()
      ));

      for(int i = 0; i< formInputFields.length; i++){
          if(formInputFields[i].dataType == 'image' || formInputFields[i].dataType == 'video'){
            final String duplicateFilePath =  (await getApplicationDocumentsDirectory()).path;
            String fileNameRef = '$duplicateFilePath/${const Uuid().v4()}';
            await File(formInputFields[0].data!.path).copy(fileNameRef);
            formInputFields[i].data = fileNameRef;
          }
          await db.insertFormData(DbFormDataMdl(submitFormId:maxId+1 , fieldName: formInputFields[i].fieldName, data: formInputFields[i].data));
      }

      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(title: const Text('Form'), centerTitle: true),
        body: isLoading == true ? const Center(child: CircularProgressIndicator()):Container(
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
                      } else if (e.dataType == 'image') {
                        return _buildImageInput(e);
                      } else if (e.dataType == 'video') {
                        return _buildVideoInput(e);
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
                      submit();
                    }
                    _formKey.currentState!.save();
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
                )
              ],
            ))));
  }
}

class InputTypeMdl {
  int inputNo;
  String fieldName;
  String dataType;
  dynamic data;

  InputTypeMdl(this.inputNo, this.fieldName, this.dataType, this.data);
}
