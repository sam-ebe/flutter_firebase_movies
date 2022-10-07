import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_movies/add_movie_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Movies',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase'),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const AddPage();
                  },
                  fullscreenDialog: true),
            );
          },
        ),
      ),
      body: MoviesInformation(),
    );
  }
}

// from FlutterFire #realtime changes
class MoviesInformation extends StatefulWidget {
  const MoviesInformation({Key? key}) : super(key: key);

  @override
  _MoviesInformationState createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('movies').snapshots();

  void addLike(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('movies').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print('data up to date'));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> movieData =
                document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Image.network(movieData['poster']),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieData['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Production'),
                        Text(movieData['year'].toString()),
                        Row(
                          children: [
                            for (final categorie in movieData['categories'])
                              Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Chip(
                                  label: Text(categorie),
                                ),
                              )
                          ],
                        ),
                        Row(children: [
                          IconButton(
                            icon: Icon(Icons.favorite),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(), // reduces paddings

                            onPressed: () {
                              addLike(document.id, movieData['likes']);
                            },
                          ),
                          SizedBox(width: 10),
                          Text(movieData['likes'].toString())
                        ])
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
