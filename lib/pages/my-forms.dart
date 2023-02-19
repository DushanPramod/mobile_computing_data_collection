import 'package:flutter/material.dart';

class MyForms extends StatefulWidget {
  const MyForms({Key? key}) : super(key: key);

  @override
  State<MyForms> createState() => _MyFormsState();
}

class _MyFormsState extends State<MyForms> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('my forms')
    );
  }
}
