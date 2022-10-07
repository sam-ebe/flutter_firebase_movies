import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multiselect/multiselect.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  final descriptionController = TextEditingController();
  List<String> categoriesList = ['Action', 'Drama', 'Fantasy'];
  List<String> categoriesSelected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.white30, width: 1.5)),
              title: Row(children: [
                Text('Name: '),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: nameController,
                  ),
                )
              ]),
            ),
            SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.white30, width: 1.5)),
              title: Row(children: [
                Text('Year: '),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: yearController,
                  ),
                )
              ]),
            ),
            SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.white30, width: 1.5)),
              title: Row(children: [
                Text('Poster: '),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: posterController,
                  ),
                )
              ]),
            ),
            SizedBox(height: 20),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  categoriesSelected = x;
                });
              },
              options: categoriesList,
              selectedValues: categoriesSelected,
              whenEmpty: 'Choose categories',
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('movies').add({
                  'name': nameController.value.text,
                  'year': yearController.value.text,
                  'poster': posterController.value.text,
                  'categories': categoriesSelected,
                  'likes': 0
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}
