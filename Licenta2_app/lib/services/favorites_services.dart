import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesServices {


  // FavoritesServices._instantiate();
  // static final FavoritesServices instance = FavoritesServices._instantiate();
  // CollectionReference _collectionReference = FirebaseFirestore.instance.collection('favorites');
  // Future addFavorites() async {
  //    List <Places> PlacesData = [];
  //     return _collectionReference
  //         .doc()
  //         .collection('favorites')
  //         .doc()
  //         .set({
  //       'id': id,
  //       'title': title,
  //       'image': image,
  //       'description': description
  //     }).then((value) => print('added to fav'));
  // }

  Future getFavorites() async {

    FirebaseFirestore.instance
        .collection('favorites')
        .get()
        .then((value) {

    });
}

}