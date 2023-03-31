import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';
import 'package:flutter_redelcom/services/notifications_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RedelcomService extends ChangeNotifier {
  Future pagoRedelcom({monto, total, userTransactionId, tipopago, dte}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    AndroidIntent intent = AndroidIntent(
      componentName: 'redelcom.cl.rdcpass.MainActivity',
      action: 'android.intent.action.SEND',
      type: 'message/rfc822',
      package: 'redelcom.cl.rdcpass',
      arguments: {
        'packageName': 'com.example.flutter_redelcom',
        'className': 'com.example.flutter_redelcom.MainActivity',
        'monto': monto.toStringAsFixed(0),
        'total': total.toStringAsFixed(0),
        'description': 'Pago Redelcom flutter',
        'userTransactionId': userTransactionId.toString(),
        'payment_type': tipopago,
        'rdcDTE': dte
      },
    );

    await intent.launch().catchError((PlatformException err) =>
        {NotificationsService.showSnackBar(err.code)});
  }

  Future imprimir(String texto) async {
    await FlutterPaxPrinterUtility.init;
    await FlutterPaxPrinterUtility.printStr(texto, null);
    var status = await FlutterPaxPrinterUtility.start();
    return status;
  }
}
