import 'dart:io';


import 'package:deepl_dart/deepl_dart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:licenta2_app/models/theme_styles.dart';
import 'package:licenta2_app/services/translation_services.dart';
import '../main.dart';
import 'events_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/event_services.dart';
import '../models/events.dart';


class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  static const routeName = '/add-event-screen';
  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}
class _AddEventScreenState extends State<AddEventScreen> {
  final myController = TextEditingController();
  final myDescription = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDateTime = false;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  String collectionName = 'events';
  XFile? imagePath;
  String imageName = '';
  var eventImg = '';
  final ImagePicker _picker = ImagePicker();
  bool _isLoaded = false;
  var title = '';


  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  // select date time picker

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDate() {
    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  String getDateTime() {

    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd HH: ss a').format(dateTime);
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();

    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myDescription.dispose();
    super.dispose();
  }



  uploadFile(String docId) async {
    String uploadFileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference reference =
    storageRef.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(
        File(imagePath!.path));

    uploadTask.snapshotEvents.listen((event) {
      print(event.totalBytes.toString());
    });

    await uploadTask.whenComplete(() async {

      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

      if (uploadPath.isNotEmpty) {
        firestoreRef.collection('places')
            .doc(docId)
          .update({
          'events': FieldValue.arrayUnion([
            {
              'eventImg': uploadPath,
              'title': myController.text,
              'date': dateTime,
              "description": myDescription.text
            }
          ]),
        });
            // .get()
            // .then((value) {
            //   value.docs.forEach((element) {
            //     element.reference.update({
            //       'events': FieldValue.arrayUnion([
            //         {
            //           'eventImg': uploadPath,
            //           'title': myController.text,
            //           'date': dateTime,
            //         }
            //       ]),
            //     });
            // });
            // }).then((value) => _showMessage('image uploaded'));
      } else {
        _showMessage('something while upload image');
      }
      // setState(() {
      //   _isLoaded = true;
      // });
    });
  }
  final user = FirebaseAuth.instance.currentUser;

  // Future addTitleandTime() async {
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //   DocumentReference doc_ref = FirebaseFirestore.instance
  //       .collection("events")
  //       .doc(user!.uid)
  //       .collection("events")
  //       .doc();
  //
  //   DocumentSnapshot docSnap = await doc_ref.get();
  //   var doc_id = docSnap.reference.id;
  //   CollectionReference _collectionRef = FirebaseFirestore.instance.collection('events');
  //   return _collectionRef
  //       .doc(user!.uid)
  //       .collection('events')
  //       .doc(doc_id)
  //       .set({
  //       'title' : myController.text,
  //       'date' : dateTime,
  //
  //   }).then((value) => print('title added'));
  // }

  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
        //addTitleandTime();
      });
    }
  }

  _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 3),));
  }


  // @override
  // void initState() {
  //   EventServices.instance.getEventImgUrl().whenComplete(() {
  //     setState(() {
  //       eventImg = EventServices.instance.eventImg;
  //       _isLoaded = true;
  //     });
  //   });
  //   super.initState();
  // }
  var items = [
    'Trei Ape',
    'Valiug',
    'Cheile Nerei',
    'Calea ferată Oravița-Anina',
    'Teatrul vechi - Mihai Eminescu',
    'Stațiunea Băile-Herculane',
    'Muzeul în aer liber de locomotive - Reșița',
    'Peșterea Comarnic',
    'Monumentul Turismului',
    'Cheile Carașului',
    'Parcul Național Semenic',
    'Hidrocentrala Grebla',
    'Cascada Moceriș',
    'Parcul Național Domogled',
    'Porțile de Fier'

  ];

  String dropdownvalue = 'Trei Ape';
  String docId = 'TreiApe';

  //
  // String done = 'Realizat';
  // String save = 'Salvați';
  // String ChooseLoc = 'Alege locația: ';
  // String AddImage = 'Adaugă poză';
  // String AddTitle = 'Adaugă titlul evenimentului';
  // String DateAndTime = 'Selectează data și ora';
  //
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
    TextResult result1 =
    await translator.translateTextSingular(done , 'en-US');
    TextResult result2 =
    await translator.translateTextSingular(save , 'en-GB');
    TextResult result3 =
    await translator.translateTextSingular(ChooseLoc , 'en-GB');
    TextResult result4 =
    await translator.translateTextSingular(AddImage ,'en-GB');
    TextResult result5 =
    await translator.translateTextSingular(AddTitle ,'en-GB');
    TextResult result6 =
    await translator.translateTextSingular(DateAndTime ,'en-GB');
    TextResult result7 =
    await translator.translateTextSingular(AddDescription ,'en-GB');
    setState(() {
      done = result1.text;
      save = result2.text;
      ChooseLoc = result3.text;
      AddImage = result4.text;
      AddTitle = result5.text;
      DateAndTime = result6.text;
      AddDescription = result7.text;
    });
    print(result1);

    // T
  }
  //
  String done = 'Afișează';
  String save = 'Salvează';
  String ChooseLoc = 'Selectează locația: ';
  String AddImage = 'Adaugă poză';
  String AddTitle = 'Denumirea locației pe care ați selectat-o';
  String DateAndTime = 'Selectează data și ora';
  String AddDescription = 'Adaugă descrierea evenimentului';
  @override
  void initState() {
    //TranslateText.instance.translate().whenComplete(() {
      setState(() {
       //  done = TranslateText.instance.done;
       //  save = TranslateText.instance.save;
       //  ChooseLoc = TranslateText.instance.ChooseLoc;
       //  AddImage = TranslateText.instance.AddImage;
       //  AddTitle = TranslateText.instance.AddTitle;
       // DateAndTime = TranslateText.instance.DateAndTime;
       // AddDescription = TranslateText.instance.AddDescription;
         done = done;
         save = save;
         ChooseLoc = ChooseLoc;
         AddImage = AddImage;
         AddTitle = AddTitle;
         DateAndTime = DateAndTime;
         AddDescription = AddDescription;
      });
    //  });
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                  translate();
                    }, child: Text('English', style: TextStyle(color: Colors.grey),)),
              Container(child: Text(ChooseLoc,
                  style: TextStyle(color: Colors.grey),
                    //fontWeight: FontWeight.bold, fontSize: 20, decoration: TextDecoration.none,
                  ),),
              DropdownButton(
                value: dropdownvalue,
                onChanged: (place) {
                  setState(() {
                    dropdownvalue = place!;
                    switch (place) {
                      case 'Trei Ape':
                        docId = 'TreiApe';
                        break;
                      case 'Valiug':
                        docId = 'valiug';
                        break;
                      case 'Cheile Nerei':
                        docId = 'CheileNerei';
                        break;
                      case 'Calea ferată Oravița-Anina':
                        docId = 'CaleaFerataOravitaAnina';
                        break;
                      case 'Teatrul vechi - Mihai Eminescu':
                        docId = 'MihaiEminescu';
                        break;
                      case 'Stațiunea Băile-Herculane':
                        docId = 'BaileHerculane';
                        break;
                        case 'Muzeul în aer liber de locomotive - Reșița':
                      docId = 'MuzeulAerLiber';
                      break;
                      case 'Peșterea Comarnic':
                        docId = 'PestereaComarnic';
                        break;
                      case 'Monumentul Turismului':
                        docId = 'MonumentulTurismului';
                        break;
                      case 'Cheile Carașului':
                        docId = 'CheileCarasului';
                        break;
                      case 'Parcul Național Semenic':
                        docId = 'ParculNationalSemenic';
                        break;
                      case 'Hidrocentrala Grebla':
                        docId = 'HidrocentralaGrebla';
                        break;
                      case 'Cascada Moceriș':
                        docId = 'CascadaMoceris';
                        break;
                      case 'Parcul Național Domogled':
                        docId = 'ParculNationalDomogled';
                        break;
                      case 'Porțile de Fier':
                        docId = 'PortileDeFier';
                        break;

                    }
                  });
                },
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items, style: TextStyle( color: Colors.grey, fontSize: 20, decoration: TextDecoration.none),),
                  );
                }).toList(),
              ),
            Card(
              child: Container(
                child: TextField(
                  controller: myController,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: AddTitle,
                  ),
                ),
              ),
            ),
              Card(
                child: Container(
                  child: TextField(
                    controller: myDescription,
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: AddDescription,
                    ),
                  ),
                ),
              ),
            Card(
                shape: Border.all(color: Colors.black),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        child: Column(
                                  children: [
                                    imagePath != null ? Image.file(File(imagePath!.path))  : GestureDetector(
                                      child: Text(AddImage),
                                      onTap: () {
                                        imagePicker();
                                      },
                                    )
                                  ],

                                )
                    )
                )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.teal)
                    ),
                    onPressed: () {
                      _selectDateTime(context);
                      showDateTime = true;
                    },
                    child: Text(DateAndTime),
                  ),
                ),
                showDateTime
                    ? Center(
                    child: Text(getDateTime()))
                    : const SizedBox(),
                // Container(
                //   padding: EdgeInsets.only( left: 280),
                //   child: TextButton(
                //       onPressed: () {
                //         //addTitleandTime();
                //       },
                //       child: Text('Save',
                //         style: TextStyle(
                //             color: Colors.teal,
                //             fontSize: 17),)
                //   ),),
               Container(
                 child: Padding(
                   padding: const EdgeInsets.only(left: 315,),
                   child: TextButton(
                       onPressed: () {
                         uploadFile(docId);
                       },
                       child:  Text(save, style: TextStyle(color: Colors.teal),)
                   ),
                 ),
               ),

                Stack(
                 children: [
                   Container(
                     padding: const EdgeInsets.only(right: 370, top:380),
                     alignment: Alignment.bottomRight,
                     child: IconButton(
                       icon: const Icon(Icons.arrow_back, color: Colors.teal,),
                       onPressed: () {
                         Navigator.pop(context);

                       },
                     ),),
                   Container(
                    padding: const EdgeInsets.only( left: 40, top: 380 ),
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        child:  Text(done,
                          style: TextStyle(color: Colors.teal, fontSize: 17),),
                    onPressed: () {
                          if(imagePath == null){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Need to upload Image'),
                              duration: Duration(seconds: 3),)
                            );
                            return;
                          }
                      Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) =>  EventsScreen(
                            title: myController.text,
                            eventImg: imagePath!,
                            description: myDescription.text,
                            //dateAndTime: dateTime as String,
                          ))
                      );

                    },
                  ),),
                 ]),
              ],
            ),
        ],)
        ));

      }

  }
