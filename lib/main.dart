import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter/services.dart';
import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';
import 'package:flutter_redelcom/layouts/home.dart';
import 'package:flutter_redelcom/services/notifications_service.dart';
import 'package:flutter_redelcom/services/redelcom.dart';
import 'package:provider/provider.dart';
import 'package:receive_intent/receive_intent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RedelcomService()),
      ],
      child: const RedelcomApp(),
    );
  }
}

class RedelcomApp extends StatefulWidget {
  const RedelcomApp({
    super.key,
  });

  @override
  State<RedelcomApp> createState() => _RedelcomAppState();
}

class _RedelcomAppState extends State<RedelcomApp> {
  late Intent _initialIntent;
  String _platformVersion = 'Unknown';
  String statusPrinter = '0';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      String platformVersion;
      // Platform messages may fail, so we use a try/catch PlatformException.
      // We also handle the message potentially returning null.
      try {
        platformVersion = await FlutterPaxPrinterUtility.platformVersion ??
            'Unknown platform version';
      } on PlatformException {
        platformVersion = 'Failed to get platform version.';
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        _platformVersion = platformVersion;
      });
    }
  }

  getPrinterStatus() async {
    if (Platform.isAndroid) {
      await FlutterPaxPrinterUtility.init;
      PrinterStatus status = await FlutterPaxPrinterUtility.getStatus;

      setState(() {
        if (status == PrinterStatus.SUCCESS) {
          statusPrinter = "1";
        } else {
          statusPrinter = "0";
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    if (Platform.isAndroid) {
      final receivedIntent = await ReceiveIntent.getInitialIntent();

      if (!mounted) return;

      setState(() {
        receivedIntent?.extra?.forEach((key, value) {
          if (key == 'android.intent.extra.TEXT') {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              NotificationsService.showSnackBar(jsonEncode(value));
            });
          }
        });
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Redelcom',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
