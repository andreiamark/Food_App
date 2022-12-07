// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:licenta2_app/dark_theme_provider.dart';
// import 'package:provider/provider.dart';
//
// class SettingsScreen extends StatefulWidget {
//
//   static const keyDarkMode = 'key-dark-mode';
//
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool isDarkMode = false;
//
//
//
//
//
//
//
//   // static const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   //   'high_importance_channel', // id
//   //   'High Importance Notifications', // title// description
//   //   importance: Importance.max,
//   // );
//   //
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   // FlutterLocalNotificationsPlugin();
//   //
//   // Future pushNotification() async {
//   //   await flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //       AndroidFlutterLocalNotificationsPlugin>()
//   //       ?.createNotificationChannel(channel);
//   // }
//   bool value = false;
//   //bool onNotification = false;
//
//   @override
//   Widget build(BuildContext context) {
//
//     final themeChange = Provider.of<DarkThemeProvider>(context);
//
//      return Scaffold(
//        appBar: AppBar(
//          title: const Text('Settings',)
//        ),
//        body: Column(
//          children: [
//           //  Row(children: [
//           //    const Padding(padding: EdgeInsets.all(10)),
//           //    const SizedBox(
//           //      width: 100,
//           //      child: Text('Notifications', style: TextStyle(fontSize: 17),),),
//           //    const SizedBox(
//           //      height: 60,
//           //    width: 200,),
//           //    IconButton(
//           //        icon: onNotification
//           //         ? const Icon(Icons.notifications_active)
//           //         : const Icon(Icons.notifications_off),
//           //        onPressed: () {
//           //          setState(() {
//           //            onNotification = !onNotification;
//           //          });
//           //          !onNotification ?  Icons.notifications_active : Icons.notifications_off;
//           //        }),
//           //
//           // ] ),
//            const Divider(
//              color: Colors.black,
//            ),
//            Row(children: [
//              const Padding(padding: EdgeInsets.all(10)),
//              const SizedBox(
//                width: 100,
//                child: Text('Dark Mode',
//                  style: TextStyle(fontSize: 17),),),
//              const SizedBox(
//                height: 60,
//                width: 200,),
//              IconButton(
//                  icon: !value
//                      ?  const Icon(Icons.dark_mode)
//                     :  const Icon(Icons.dark_mode_outlined),
//                  onPressed: () {
//                    setState(() {
//                      value = !value;
//                      themeChange.darkTheme = value;
//                    });
//                  }),
//                  //  Checkbox(
//                  //  value: themeChange.darkTheme,
//                  //  onChanged: (bool? value) {
//                  //  themeChange.darkTheme = value!;
//                  // })
//            ] ),
//            const Divider(color: Colors.black,)
//            // Row(
//            //   children: [
//            //     DropdownButton(
//            //         value: lang,
//            //         onChanged: (Locale? val) {
//            //           provider.setLocale(val!);
//            //         },
//            //         items: L10n.all
//            //             .map((e) => DropdownMenuItem(
//            //           value: e,
//            //           child: _title(e.languageCode),
//            //         ))
//            //             .toList())
//            //  ],
//          //  )
//          ],
//        ),
//      );
//
//   }
// }
