import 'package:flutter/material.dart';

class SubmittedForms extends StatefulWidget {
  const SubmittedForms({Key? key}) : super(key: key);

  @override
  State<SubmittedForms> createState() => _SubmittedFormsState();
}

class _SubmittedFormsState extends State<SubmittedForms> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Text('submitted forms')
    );
  }
}
