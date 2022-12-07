import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:licenta2_app/main.dart';
import 'package:licenta2_app/models/events.dart';
import 'package:licenta2_app/models/places.dart';
import 'package:licenta2_app/screens/place_detail_screen.dart';
import '../models/place_item.dart';
import '../models/theme_styles.dart';

class FavoritesScreen extends StatefulWidget {
   static const routeName = '/favorite-screen';
 //  final String id;
 //  final String title;
 //  final String image;
 //  final String description;
 //  final String location;
 //  final String pictures;
 //  final bool isFavorite;
 //
 // FavoritesScreen(
 //      {required this.id,
 //        required this.title,
 //        required this.image,
 //        required this.description,
 //        required this.location,
 //        required this.pictures,
 //        required this.isFavorite});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  var firestoreDB = FirebaseFirestore
      .instance
      .collection('favorites')
      .snapshots();

  String subscription = '';

  String snapshot = '';

  @override
  Widget build(BuildContext context) {
    // void selectPlace(BuildContext ctx) {
    //   Navigator.of(ctx).push(MaterialPageRoute(
    //     builder: (_) =>
    //         PlaceDetailScreen(
    //             placeId: widget.id,
    //             placeImage: widget.image,
    //             placeTitle: widget.title,
    //             placeDescription: widget.description,
    //             placeLocation: widget.location,
    //             placePictures: widget.pictures),
    //   ));
    //}

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;


    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .doc(user!.uid)
          .collection('favorites')
          .snapshots(),
      builder: (context, snapshot) {
        List <Places> places = [];
        //List <Event> events = [];
        if (snapshot.hasData){
          List _places = snapshot.data!.docs;
         // print(_places.length);
          _places.forEach((place) {
            //print(place["title"]);
            Places _place = Places(
                id: place['id'],
                title: place['title'],
                image: place['image'],
                description: place['description'],
                location: place['location'],
                pictures: place['pictures'],
                events: []);
            places.add(_place);
          });
          return Column(children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: places.length,
                itemBuilder: (context, index) {
                  //return buildListItem(context, snapshot.data.documents[index]);
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: <Widget>[
                      GestureDetector(
                        child:  ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                places[index].image),
                          ),
                          title: Text(places[index].title,
                              style: TextStyle(color: Colors.grey)),
                        ),
                        onTap:  () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PlaceDetailScreen(
                                placeTitle: places[index].title,
                                placeLocation: places[index].location,
                                placeImage: places[index].image,
                                placeDescription: places[index].description,
                                placePictures: places[index].pictures,
                                placeId: places[index].id,),
                              settings: RouteSettings(
                                  arguments: places[index]
                              )
                          ),
                          );
                        },
                      )
                    ],
                  );
                }),

          ]);
        }
        else
          return const CircularProgressIndicator(
            color: Colors.teal,
          );


      },
    );

  }
}