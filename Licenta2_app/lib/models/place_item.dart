import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:licenta2_app/models/places.dart';
import 'package:licenta2_app/screens/place_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepl_dart/deepl_dart.dart';
import 'dart:io';




class PlaceItem extends StatefulWidget {
  final String id;
  final String title;
  final String image;
  final String description;
  final String location;
  final String pictures;
  final bool isFavorite;

  PlaceItem(
      {required this.id,
      required this.title,
      required this.image,
      required this.description,
      required this.location,
      required this.pictures,
      required this.isFavorite});

  @override
  State<PlaceItem> createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {
  void selectPlace(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) =>
          PlaceDetailScreen(
              placeId: widget.id,
              placeImage: widget.image,
              placeTitle: widget.title,
              placeDescription: widget.description,
              placeLocation: widget.location,
              placePictures: widget.pictures),
    ));
  }


var descriptionTranslated;
   translate() async {
    // Construct Translator
    Translator translator = Translator(authKey: '20280596-6d93-f325-8a20-bfe919e57bfe:fx');
    Translator(
      authKey: '20280596-6d93-f325-8a20-bfe919e57bfe:fx',
      headers: {'my header key': 'my header value'},
      serverUrl: 'https://api-free.deepl.com',
      maxRetries: 42,
    );

    // Translate multiple texts
    TextResult result =
    await translator.translateTextSingular(widget.description, 'en-GB');
    print(result);
    setState(() {
      descriptionTranslated = result.text;
    });
    return descriptionTranslated;
    // T

  }

  Future addToFavorites(Places place) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('favorites');
    return collectionRef.doc(uid).collection('favorites').doc(place.id).set({
      'id': place.id,
      'title': place.title,
      'image': place.image,
      'description': place.description,
      'pictures': place.pictures,
      "location":place.location
    }).then((value) => print(place.id));
  }

  Future deleteFavorites(Places place) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    final id = place.id;

    FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favorites')
        .doc(id)
        .delete()
        .then(
          (doc) => print('deleted doc'),
      onError: (e) => print("Error updating document $e"),
    );
  }


  @override
  Widget build(BuildContext context) {
    bool isFavorite = widget.isFavorite;

    Places place = Places(
      id: widget.id,
      title: widget.title,
      image: widget.image,
      description: widget.description,
      location: widget.location,
      pictures: widget.pictures,
      events: [],
    );
    return Stack(
      children: [
        AnimatedContainer(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.image), fit: BoxFit.fill),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          duration: const Duration(seconds: 10),
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.39,

                ),
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  duration: const Duration(seconds: 0),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.15,
                  // color: Colors.white.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.alegreya(
                        textStyle: const TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              selectPlace(context);
            },
          ),
        ),
        IconButton(
          onPressed: () =>
          isFavorite ? deleteFavorites(place) : addToFavorites(place),
          icon: !isFavorite
              ? const Icon(Icons.favorite_border_outlined, color: Colors.teal)
              : const Icon(
            Icons.favorite,
            color: Colors.teal,
          ),
          padding: const EdgeInsets.only(left: 330),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: MediaQuery
                .of(context)
                .size
                .height * 0.35,
          ),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            duration: const Duration(seconds: 0),
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.15,
            // color: Colors.white.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text(widget.description, style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold,),
                // style: const TextStyle(
                //     color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )],
    );
  }


}
