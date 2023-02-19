import 'package:flutter/material.dart';
import 'package:mobile_computing_data_collection/pages/my-forms.dart';
import 'package:mobile_computing_data_collection/pages/submitted-forms.dart';
import 'package:mobile_computing_data_collection/pages/forms.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Forms', icon: Icon(Icons.my_library_books)),
              Tab(text: 'Submitted', icon: Icon(Icons.upload_file)),
              Tab(text: 'Forms', icon: Icon(Icons.book))
            ],
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      setState(() {
                        counter = 0;
                      });
                    }),
                counter != 0 ? Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text('$counter',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : Container()
              ],
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            MyForms(),
            SubmittedForms(),
            Forms()
          ],
        ),
      ),
      );
  }
}
