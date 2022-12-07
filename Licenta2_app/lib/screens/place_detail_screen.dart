
import 'package:deepl_dart/deepl_dart.dart';
import 'package:flutter/material.dart';
import 'package:licenta2_app/dark_theme_preference.dart';
import 'package:licenta2_app/models/theme_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models/places.dart';
import '../services/translation_services.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const routeName = '/place_detail_screen';
  final String placeId;
  final String placeImage;
  final String placeTitle;
  final String placeDescription;
  final String placeLocation;
  final String placePictures;

  const PlaceDetailScreen({
    required this.placeId,
    required this.placeImage,
    required this.placeTitle,
    required this.placeDescription,
    required this.placeLocation,
    required this.placePictures,
  });

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}



class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
 //final Uri _url = Uri.parse('');
  Translator translator = Translator(authKey: '20280596-6d93-f325-8a20-bfe919e57bfe:fx');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Styles.themeData(isDarkTheme, context).scaffoldBackgroundColor,
     appBar: AppBar(
       backgroundColor: Styles.themeData(isDarkTheme, context).scaffoldBackgroundColor,
      title:Text(widget.placeTitle, style:TextStyle(color: Styles.themeData(isDarkTheme, context).disabledColor),
     ),),
      body: SingleChildScrollView(
        child: Column(
        children: [
          //Container(child: Text(widget.placeTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),),
          Container(
            padding: const EdgeInsets.all(8),
            child: Image(
                image: NetworkImage(widget.placeImage)
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(descriptionTranslated, style: TextStyle(color: Styles.themeData(isDarkTheme, context).disabledColor),)
          ),
          Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            width: 400,
            decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                widget.placePictures
              )
            )
          ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal)),
              label:  Text('location',),
              icon: const Icon(Icons.location_on),
              onPressed: () {
                  _launchUrl(widget.placeLocation);
              },
            ),),
          Container(
            child: TextButton(
              onPressed: () {
                translate();
                },
              child: Text('English', style: TextStyle(color: Styles.themeData(isDarkTheme, context).primaryColor),),
            ),
          ),

        ],
      )),
    );
  }

  Future<void> _launchUrl(String url) async {
     Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
   var descriptionTranslated;
  void translate() async {
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
    await translator.translateTextSingular(widget.placeDescription, 'en-GB');
    print(result);
    setState(() {
      descriptionTranslated = result.text;
    });
  }

  void initState() {
   descriptionTranslated = widget.placeDescription;
    super.initState();

  }
}