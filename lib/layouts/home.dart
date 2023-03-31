import 'package:flutter/material.dart';
import 'package:flutter_redelcom/services/redelcom.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final redelcomService = Provider.of<RedelcomService>(context);
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Redelcom - Flutter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    redelcomService.pagoRedelcom(
                        monto: 1000,
                        total: 1000,
                        userTransactionId: 'X001',
                        tipopago: 'EFECTIVO',
                        dte: false);
                  },
                  child: const Text('Pagar EFECTIVO \$1.000.-')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    redelcomService.pagoRedelcom(
                        monto: 1000,
                        total: 1000,
                        userTransactionId: 'X001',
                        tipopago: 'TARJETA',
                        dte: false);
                  },
                  child: const Text('Pagar TARJETA \$1.000.-')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    redelcomService
                        .imprimir('Hola mundo \n\nredelcom\n_____________\n\n');
                  },
                  child: const Text('IMPRIMR TEXTO'))
            ],
          ),
        ));
  }
}
