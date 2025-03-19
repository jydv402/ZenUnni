import'package:firebase_messaging/firebase_messaging.dart';
import 'package:zen/main.dart';
class NotifServ {

  //instance of firebase messsaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  //function to intialize notifications
  Future<void> initNotifications() async {
   //request permission from user
   await _firebaseMessaging.requestPermission();
   //fetch the FCM token for device
   final fCMToken = await _firebaseMessaging.getToken();
   

    print('Token:$fCMToken');

    initPushNotifications();

  }

//function to handle recieved messages
  void handleMessage(RemoteMessage? message){
    if(message== null) return;
     //navigate to todo page
     navigatorKey.currentState?.pushNamed('/todo',arguments:message);
  }
  

  //function to initialize background settings
  Future initPushNotifications()async{
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}