

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepl_dart/deepl_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:licenta2_app/generated/l10n.dart';
import 'package:licenta2_app/l10n/l10n.dart';
import 'package:licenta2_app/models/places.dart';
import 'package:licenta2_app/screens/events_screen.dart';
import 'package:licenta2_app/screens/place_detail_screen.dart';
import 'package:licenta2_app/services/translation_services.dart';
import '../l10n/provider.dart';
import '../main.dart';
import '../models/theme_styles.dart';
import 'favorite_screen.dart';
import '../models/place_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_screen.dart';
import 'my_account_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/avatar_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/local_notification_service.dart';
import 'place_detail_screen.dart';


class MyHomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {

  int currentPageIndex = 0;
  final user = FirebaseAuth.instance.currentUser;
  final docId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoaded = false;
  String events = '';
  String avatarUrl = '';

  //final FCMNotificationService _fcmNotificationService = FCMNotificationService();

  @override
  void initState() {
    AvatarServices.instance.getAvatarUrl().whenComplete(() {
      setState(() {
        avatarUrl = AvatarServices.instance.avatarUrl;
        _isLoaded = true;
      });
    });
    firestoreDB = FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('favorites')
        .snapshots();
    super.initState();

  }

  // Future<void> onMessage() async {
  //   FirebaseMessaging.onMessage.listen((message) {
  //     PushNotification notification = PushNotification(
  //       message.notification!.title!,
  //       message.notification!.body!,
  //       message.data['title'],
  //       message.data['body'],
  //     );
  //     print('Got a message whilst in the foreground!');
  //     if(notification != null){
  //       print('title:   ${notification.dataTitle}');
  //     }
  //   });
  // }
  late Stream<QuerySnapshot<Map<String, dynamic>>> firestoreDB;

//
//  Future<void> load() async {
//
//   String? token = await _fcm.getToken();
//   assert(token != null);
//
//    DocumentReference docRef = _tokensDB.doc('tokens');
//    docRef.set({'token' : token});
//
//    DocumentSnapshot docSnap = await _tokensDB.doc().get();
//    _otherDeviceToken = docSnap['token'];
//  }


  @override
  Widget build(BuildContext context) {
    _title(String val) {
      switch (val) {
        case 'en':
          return Text(
            'English',
            style: TextStyle(fontSize: 16.0),
          );

        case 'ro':
          return Text(
            'Română',
            style: TextStyle(fontSize: 16.0),
          );

        default:
          return Text(
            'Română',
            style: TextStyle(fontSize: 16.0),
          );
      }
    }
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      var lang = provider.locale ?? Localizations.localeOf(context);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            PopupMenuButton(
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                      backgroundImage: _isLoaded & AvatarServices.instance.avatarUrl.isNotEmpty
                          ? NetworkImage(AvatarServices.instance.avatarUrl) as ImageProvider
                          : NetworkImage("https://firebasestorage.googleapis.com/v0/b/licenta2-34bf6.appspot.com/o/images%2Ftoken_image.jpg?alt=media&token=4fa569ec-df58-40da-a95e-bf9e3a1cc673")
                  ),
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'my-account',
                      child: Row(
                        children:  <Widget>[
                          Icon(Icons.person, color: Colors.black),
                          SizedBox(width: 8),
                         Text(AppLocalizations.of(context).my_account)
                          //Text('My Account'),
                        ],
                      ),
                    ),
                    // PopupMenuItem<String>(
                    //   value: 'settings',
                    //   child: Row(
                    //     children: <Widget>[
                    //       Icon(Icons.settings, color: Colors.black,),
                    //       SizedBox(width: 8),
                    //       Text(AppLocalizations.of(context).settings),
                    //     ],
                    //   ),
                    // ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.exit_to_app, color: Colors.black),
                          SizedBox(width: 8),
                          Text(AppLocalizations.of(context).logout),
                        ],
                      ),
                    ),
                  PopupMenuItem(child:  DropdownButton(
                      value: lang,
                      onChanged: (Locale? val) {
                        provider.setLocale(val!);
                      },
                      items: L10n.all
                          .map((e) =>
                          DropdownMenuItem(
                            value: e,
                            child: _title(e.languageCode),
                          ))
                          .toList()),)
                  ];
                },
                onSelected: (value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                  // if (value == 'settings') {
                  //   Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //           builder: (context) => SettingsScreen()));
                  // }
                  if (value == 'my-account') {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => MyAccountScreen()));
                  }
                }
            ),
          ],
          title: Text('Visit Caras-Severin',style: TextStyle(color: Styles.themeData(isDarkTheme, context).disabledColor),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations:  [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context).home,),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: AppLocalizations.of(context).favorite,

            ),
            NavigationDestination(
              icon: Icon(Icons.event),
              label: AppLocalizations.of(context).events,
            ),
          ],
        ),
        body: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('places')
                .snapshots(),
            builder: (context, snapshot) {
              List <Places> places = [];
              if (snapshot.hasData) {
                List _places = snapshot.data!.docs;
               // print(_places.length);
                _places.forEach((place) {
                 // print(place["title"]);
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
                return
                  StreamBuilder(
                      stream: firestoreDB,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return CircularProgressIndicator();
                        }
                        List _places = snapshot.data!.docs;
                        var placesIds = [];
                        _places.forEach((element) {
                          placesIds.add(element.id);
                        });
                        //print(_places.length);

                        return Container(padding: EdgeInsets.only(
                            left: 7, top: 7, right: 7),
                          // color: Colors.white,
                          alignment: Alignment.center,
                          child: GridView(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              childAspectRatio: 1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 10,
                            ),
                            children: places
                                .map((catData) {
                              bool isFavorite = false;
                              _places.forEach((element) {
                              //  print('favorites ${element.id}');
                              });
                            //  print("place ${catData.id} ");
                              isFavorite = placesIds.contains(catData.id);
                             // print(isFavorite);
                              return PlaceItem(
                                id: catData.id,
                                title: catData.title,
                                image: catData.image,
                                description: catData.description,
                                location: catData.location,
                                pictures: catData.pictures,
                                isFavorite: isFavorite,
                              );
                            }).toList(),
                          ),
                        );
                      }
                  );
              }
              else
                return const Text("Loading...");
            },
          ),
          // Container(
          //   padding: EdgeInsets.only(left: 7, top: 7, right: 7),
          //  // color: Colors.white,
          //   alignment: Alignment.center,
          //   child: GridView(
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //       maxCrossAxisExtent: 400,
          //       childAspectRatio: 1,
          //       crossAxisSpacing: 10,
          //       mainAxisSpacing: 20,),
          //     children: PlacesData
          //         .map((catData) => PlaceItem(
          //       id: catData.id,
          //       title: catData.title,
          //       image: catData.image,
          //       description: catData.description,
          //       location: catData.location,
          //       pictures: catData.pictures,
          //     )).toList(),
          //   ),
          // ),
          Container(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(),
              home: FavoritesScreen()
            ),
          ),
          Container(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Color.fromRGBO(86, 86, 86, 1.00),
              ),
              home: EventsScreen(
                title: '',
                eventImg: XFile(''),
                description: ""
              ),

            ),
          )

        ][currentPageIndex],
      );
    });
  }
}