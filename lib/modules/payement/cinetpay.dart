// ignore_for_file: avoid_print, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:math';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future main() async {
  runApp(const CinetPay());
}

class CinetPay extends StatefulWidget {
  const CinetPay({super.key});

  @override
  _CinetPayState createState() => _CinetPayState();
}

class _CinetPayState extends State<CinetPay> {
  TextEditingController amountController = TextEditingController();
  Map<String, dynamic>? response;
  Color? color;
  IconData? icon;
  String? message;
  bool show = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'CinetPay Demo';
    return GetMaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
            centerTitle: true,
          ),
          body: SafeArea(
              child: Center(
                  child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  show ? Icon(icon, color: color, size: 150) : Container(),
                  show ? Text(message!) : Container(),
                  show ? const SizedBox(height: 50.0) : Container(),
                  const Text(
                    "Example integration Package for Flutter",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50.0),
                  Text(
                    "Cart informations.",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 50.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    margin: const EdgeInsets.symmetric(horizontal: 50.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.green),
                    ),
                    child: TextField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        hintText: "Amount",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    child: const Text("Pay with CinetPay"),
                    onPressed: () async {
                      String amount = amountController.text;
                      if (amount.isEmpty) {
                        // Mettre une alerte
                        return;
                      }
                      double _amount;
                      try {
                        _amount = double.parse(amount);

                        if (_amount < 100) {
                          // Mettre une alerte
                          return;
                        }

                        if (_amount > 1500000) {
                          // Mettre une alerte
                          return;
                        }
                      } catch (exception) {
                        return;
                      }

                      amountController.clear();

                      final String transactionId = Random()
                          .nextInt(100000000)
                          .toString(); // Mettre en place un endpoint à contacter côté serveur pour générer des ID unique dans votre BD

                      await Get.to(CinetPayCheckout(
                        title: 'Payment Checkout',
                        titleStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        titleBackgroundColor: Colors.green,
                        configData: <String, dynamic>{
                          'apikey': '66623283664389d2a61b6a6.75178443',
                          'site_id': int.parse("312650"),
                          'notify_url': 'YOUR_NOTIFY_URL'
                        },
                        paymentData: <String, dynamic>{
                          'transaction_id': transactionId,
                          'amount': _amount,
                          'currency': 'XOF',
                          'channels': 'ALL',
                          'description': 'Payment test',
                        },
                        waitResponse: (data) {
                          if (mounted) {
                            setState(() {
                              response = data;
                              print(response);
                              icon = data['status'] == 'ACCEPTED'
                                  ? Icons.check_circle
                                  : Icons.mood_bad_rounded;
                              color = data['status'] == 'ACCEPTED'
                                  ? Colors.green
                                  : Colors.redAccent;
                              show = true;
                              Get.back();
                            });
                          }
                        },
                        onError: (data) {
                          if (mounted) {
                            setState(() {
                              response = data;
                              message = response!['description'];
                              print(response);
                              icon = Icons.warning_rounded;
                              color = Colors.yellowAccent;
                              show = true;
                              Get.back();
                            });
                          }
                        },
                      ));
                    },
                  )
                ],
              ),
            ],
          )))),
    );
  }
}