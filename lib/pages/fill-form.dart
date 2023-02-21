import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:chewie/chewie.dart';

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
    InputTypeMdl(4, 'Image', 'image', ''),
    InputTypeMdl(5, 'Video', 'video', ''),
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

  XFile? imageFile;
  XFile? videoFile;
  void _openGallery(BuildContext context, String dataType) async {
    if(dataType == 'image'){
      var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        imageFile = picture;
      });
    }
    else{
      var video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      setState(() {
        videoFile = video;
      });
    }

    if (context.mounted) Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context, String dataType) async {
    if(dataType == 'image'){
      var picture = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        imageFile = picture;
      });
    }
    else{
      var video = await ImagePicker().pickVideo(source: ImageSource.camera);
      setState(() {
        videoFile = video;
      });
    }
    if (context.mounted) Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  Widget _buildImageInput(InputTypeMdl data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(data.fieldName, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
        imageFile == null?const Text('No Image Selected'): Image.file(File(imageFile!.path), width: 200, height: 200),
        // const Text('No image selected'),
        ElevatedButton(onPressed: () {
          _showChoiceDialog(context, data);
        }, child: const Text('Select Image'))
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
        Container(
          color: Colors.brown,
          height: MediaQuery.of(context).size.height * (30/100),
          width: MediaQuery.of(context).size.width *  (100/100),
          child: videoFile == null?const Center(
            child: Icon(Icons.videocam, color: Colors.red, size: 50.0),
          ):FittedBox(
            fit: BoxFit.contain,
            child: mounted?Chewie(
              controller: ChewieController(
                  videoPlayerController: VideoPlayerController.file(File(videoFile!.path)),
                  aspectRatio: 3/2,
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
                  _openGallery(context,data.dataType);
                },
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: const Text('Camera'),
                onTap: (){
                  _openCamera(context,data.dataType);
                },
              )
            ],
          ),
        ),
      );
    });
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
  dynamic data;

  InputTypeMdl(this.inputNo, this.fieldName, this.dataType, this.data);
}
