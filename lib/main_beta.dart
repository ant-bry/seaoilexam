import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seaoil/app.dart';
import 'package:seaoil/config/env.dart';

import 'flutterfire/firebase_options_beta.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'flutterboilerplate-beta',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlavorConfig(
      flavor: Flavor.BETA,
      color: Colors.deepPurpleAccent,
      values: FlavorValues(
        baseUrl: 'https://staging.api.locq.com',
      ));
  runApp(MyApp());
}
