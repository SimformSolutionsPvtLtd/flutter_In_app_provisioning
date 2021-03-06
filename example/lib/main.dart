import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_provisioning/in_app_provisioning.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements InAppProvisioningInterface {
  late InAppProvisioning _provisioning;

  late Future<bool> _canAccessPasskit;

  @override
  void initiateEnrollment(String? nonce, String? nonceSignature, String? certificate) {

  }

  @override
  void initState() {
    super.initState();
    _provisioning = InAppProvisioning(this);
    _canAccessPasskit = _checkForPassKit();
  }

  Future<bool> _checkForPassKit() async {
    return await _provisioning.isPassKitAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FutureBuilder(
            future: _canAccessPasskit,
            builder: (_, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                bool _havePassKitAccess = snapshot.data as bool;
                if(_havePassKitAccess) {
                  return MaterialButton(
                    child: const Text('Initiate'),
                    onPressed: () {
                      _provisioning.initiateEnrollment(CardData(
                        panTokenSuffix: "2314",
                        holderName: "Simform"
                      ));
                    },
                  );
                } else {
                  return const Text('Cannot access passkit');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
