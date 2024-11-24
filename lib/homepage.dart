import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notifaction.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  NotifactionServices notifactionServices=NotifactionServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifactionServices.requestMessageingPermission();
    notifactionServices.setupInterMessage(context);
    notifactionServices.firbaseInit(context);
    notifactionServices.getDeviceToken();


  }



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
