import 'package:flutter/material.dart';
import 'package:project/students/Dashboard/restaurants.dart';
import 'package:project/students/Order%20status/verified.dart';

import '../../animation.dart';
import '../../models/meals.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class OrderConfirmationPage extends StatefulWidget {
  final List<Order> cartItems;

  const OrderConfirmationPage({required this.cartItems});

  @override
  // ignore: library_private_types_in_public_api
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String _status = 'Not Ordered';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Define the _showNotification method
  Future<void> _showNotification() async {
   // print('Showing notification');
    var androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
    //  'channelDescription',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'test',
    );
  //  var iOSDetails = IOSNotificationDetails();
    var platformDetails =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Order Confirmed', 'Your food has been ordered', platformDetails,
        payload: 'test');
     //   print('Notification shown');

     showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:Color.fromRGBO(50, 41, 57, 1) ,
        title: Text('Order Confirmed', style: TextStyle(color: Color.fromRGBO(201, 199, 126, 1),),),
        content: Text('Your food has been ordered', style: TextStyle(color: Colors.white),),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBB902D)),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
  }

  @override
  void initState() {
    super.initState();

    // Initialize the local notification plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Configure the initialization settings for Android and iOS
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
  //  var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    // Initialize the plugin with the initialization settings
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      ),
      backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      body: ListView.builder(
        itemCount: widget.cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.cartItems[index];
          return ListTile(
            tileColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            leading: Image.network(imageurls[index]),
            title: Text(
              item.menuItemName,
              style: TextStyle(
                fontSize: 16.0,
                color: Color.fromRGBO(201, 199, 126, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '\RWF ${item.menuItemPrice.toStringAsFixed(2)} x ${item.quantity}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status: $_status',
              style: TextStyle(
                fontSize: 16.0,
                color: Color.fromRGBO(201, 199, 126, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
           style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBB902D)),
              onPressed: () {
                Navigator.push(context,
                        CustomPageRoute(child:const VerifiedOrder()));
                setState(() {
                  _status = 'Ordered';
                  _showNotification();
                });
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}


